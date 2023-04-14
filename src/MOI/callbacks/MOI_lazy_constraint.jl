function moi_lazy_constraint_xprs_optnode_wrapper(func::Function, model::Optimizer, callback_data::CD) where {CD<:CallbackData}
    push_callback_state!(model, CS_MOI_LAZY_CONSTRAINT)

    get_callback_solution!(model, callback_data.node_model)

    # Add previous cuts if any to gurantee that the user is dealing with
    # an optimal solution feasibile for existing cuts
    if isempty(model.callback_cut_data.cut_ptrs) || !apply_cuts!(model, callback_data.node_model)
        func(callback_data)
    end

    pop_callback_state!(model)


    return nothing
end

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, ::Nothing)
    info = model.callback_table.moi_lazy_constraint

    if !isnothing(info)
        xprs_optnode_info, = info

        remove_xprs_optnode_callback!(model, xprs_optnode_info)

        model.callback_table.moi_lazy_constraint = nothing
    end

    return nothing
end

function MOI.set(model::Optimizer, attr::MOI.LazyConstraintCallback, func::Function)
    MOI.set(model, attr, nothing)

    xprs_optnode_info = add_xprs_optnode_callback!(
        model.inner,
        (callback_data::OptNodeCallbackData) -> moi_lazy_constraint_xprs_optnode_wrapper(
            func,
            model,
            callback_data,
        )
    )::CallbackInfo{OptNodeCallbackData}

    model.callback_table.moi_lazy_constraint = (xprs_optnode_info,)

    return nothing
end

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true
MOI.supports(::Optimizer, ::MOI.LazyConstraint{CD}) where {CD<:CallbackData} = true

function MOI.submit(
    model::Optimizer,
    submittable::MOI.LazyConstraint{CD},
    f::F,
    s::S
) where {CD<:CallbackData,T,F<:MOI.ScalarAffineFunction{T},S<:Union{MOI.LessThan{T},MOI.GreaterThan{T},MOI.EqualTo{T}}}
    # It is assumed that every '<:CallbackData' has a 'node_model' field
    node_model = submittable.callback_data.node_model::Xpress.XpressProblem

    check_callback_state(model, node_model, submittable, CS_MOI_LAZY_CONSTRAINT)

    # Check if b is 0 in a'x + b <= c?
    # f(x) = a'x + b
    # S = {<= c}
    if !iszero(f.constant)
        cache_exception(
            model,
            MOI.ScalarFunctionConstantNotZero{T,F,S}(f.constant)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    end

    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Ref{Cint}(1) # Cut type
    mstart = Cint[0, length(indices)]
    mindex = Array{Xpress.Lib.XPRScut}(undef, 1)
    ncuts = Cint(1)
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    sensetype = Ref{UInt8}(sense) # Julia assumes Cchar to be signed, but Xpress likes it unsigned
    drhs = Ref{Cdouble}(rhs)
    indices .-= 1 # Xpress follows C's 0-index convention
    mcols = Cint.(indices)
    interp = Cint(-1) # Load all cuts

    Xpress.Lib.XPRSstorecuts(
        node_model,
        ncuts,
        nodupl,
        mtype,
        sensetype,
        drhs,
        mstart,
        mindex,
        mcols,
        coefficients,
    )

    Xpress.Lib.XPRSloadcuts(
        node_model,
        mtype[],
        interp,
        ncuts,
        mindex,
    )

    push!(model.callback_cut_data.cut_ptrs, mindex[])

    model.callback_cut_data.submitted = true

    return nothing
end

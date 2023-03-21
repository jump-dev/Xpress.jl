function moi_lazy_constraint_wrapper(model::Optimizer, callback_data::CallbackData)
    info = get(model.callback_info, CT_MOI_LAZY_CONSTRAINT, nothing)

    if !isnothing(info)
        model.callback_state = CS_MOI_LAZY_CONSTRAINT # TODO: push

        # Add previous cuts if any to gurantee that the user is dealing with
        # an optimal solution feasibile for existing cuts
        if isempty(model.callback_cut_data.cut_ptrs) || !apply_cuts!(model, callback_data.node_model)
            info.data_wrapper.func(callback_data)
        end

        model.callback_state = CS_NONE # TODO: pop
    end

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, ::Nothing)
    model.callback_info[CT_MOI_LAZY_CONSTRAINT] = nothing

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, func::Function)
    model.callback_info[CT_MOI_LAZY_CONSTRAINT] = CallbackInfo{GenericCallbackData}(
        C_NULL,
        CallbackDataWrapper(model.inner, func),
    )

    model.callback_info[CT_MOI_GENERIC] = set_moi_generic_callback!(model)

    return nothing
end

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true
MOI.supports(::Optimizer, ::MOI.LazyConstraint{CD}) where {CD<:CallbackData} = true

function MOI.submit(
    model::Optimizer,
    submittable::MOI.LazyConstraint{CD},
    f::MOI.ScalarAffineFunction{T},
    s::Union{MOI.LessThan{T},MOI.GreaterThan{T},MOI.EqualTo{T}}
) where {T,CD<:CallbackData}
    # It is assumed that every '<:CallbackData' has a 'node_model' field
    node_model = submittable.callback_data.node_model::Xpress.XpressProblem

    # TODO: Should we mark as submitted in the beginning of the function?
    model.callback_cut_data.submitted = true

    # Check callback state
    let state = callback_state(model)
        if state !== CS_MOI_LAZY_CONSTRAINT
            cache_callback_exception!(
                model,
                MOI.InvalidCallbackUsage(
                    state_callback(state),
                    submittable,
                )
            )

            Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

            return nothing
        end
    end

    # Check if b is 0 in a'x + b <= c?
    # f(x) = a'x + b
    # S = {<= c}
    if !iszero(f.constant)
        cache_exception(
            model,
            MOI.ScalarFunctionConstantNotZero{T,typeof(f),typeof(s)}(f.constant)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    end

    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Cint[1] # Cut type
    mstart = Cint[0, length(indices)]
    mindex = Array{Xpress.Lib.XPRScut}(undef, 1)
    ncuts = Cint(1)
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    sensetype = Cchar[Char(sense)]
    drhs = Cdouble[rhs]
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

    return nothing
end

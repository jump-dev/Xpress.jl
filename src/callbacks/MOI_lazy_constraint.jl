function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, ::Nothing)
    model.lazy_callback = callback

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, callback::Function)
    model.lazy_callback = callback

    return nothing
end

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true
MOI.supports(::Optimizer, ::MOI.LazyConstraint{CD}) where {CD<:CallbackData} = true

function MOI.submit(
    model::Optimizer,
    moi_callback::MOI.LazyConstraint{CD},
    f::MOI.ScalarAffineFunction{T},
    s::Union{MOI.LessThan{T},MOI.GreaterThan{T},MOI.EqualTo{T}}
) where {T,CD<:CallbackData}
    node_model = moi_callback.callback_data.node_model
    model.callback_cut_data.submitted = true

    if model.callback_state == CS_MOI_HEURISTIC
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.HeuristicCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif model.callback_state == CS_MOI_LAZY_CONSTRAINT && CB <: MOI.UserCut{CallbackData}
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif model.callback_state == CS_MOI_USER_CUT && CB <: MOI.LazyConstraint{CallbackData}
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.UserCutCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif !iszero(f.constant)
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

    Lib.XPRSstorecuts(node_model, ncuts, nodupl, mtype, sensetype, drhs, mstart, mindex, mcols, coefficients)
    Lib.XPRSloadcuts(node_model, mtype[], interp, ncuts, mindex)

    push!(model.callback_cut_data.cut_ptrs, mindex[1])

    model.callback_cut_data.cut_ptrs

    return nothing
end

function moi_lazy_callback_wrapper()

end

function default_moi_lazy_callback(callback_data::GenericCallbackData)
    model.callback_state = CS_MOI_LAZY_CONSTRAINT

    # Add previous cuts if any to gurantee that the user is dealing with
    # an optimal solution feasibile for exisitng cuts
    if !isempty(model.callback_cut_data.cut_ptrs)
        added = apply_cuts!(model, callback_data.node_model)

        if added
            return nothing
        end
    end

    model.lazy_callback(callback_data)

    return nothing
end

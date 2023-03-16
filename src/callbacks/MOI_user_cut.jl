function MOI.set(model::Optimizer, ::MOI.UserCutCallback, ::Nothing)
    remove_moi_user_cut_callback!(model)

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, func::Function)
    set_moi_user_cut_callback!(model, func)

    return nothing
end

MOI.supports(::Optimizer, ::MOI.UserCutCallback) = true
MOI.supports(::Optimizer, ::MOI.UserCut{CD}) where {CD <: CallbackData} = true

function MOI.submit(
    model::Optimizer,
    moi_callback::CB,
    f::MOI.ScalarAffineFunction{T},
    s::Union{MOI.LessThan{T}, MOI.GreaterThan{T}, MOI.EqualTo{T}}
) where {T, CB <: Union{MOI.UserCut{CallbackData},MOI.LazyConstraint{CallbackData}}}

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
            MOI.ScalarFunctionConstantNotZero{T, typeof(f), typeof(s)}(f.constant)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)
        
        return nothing
    end
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Cint[1] # Cut type
    mstart = Cint[0, length(indices)]
    mindex  = Array{Xpress.Lib.XPRScut}(undef,1)
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

function default_moi_user_cut_callback!(model::Optimizer, callback_data::CallbackData)
    model.callback_state = CS_MOI_USER_CUT

    # Apply stored cuts if any
    if !isempty(model.callback_cut_data.cut_ptrs)
        added = apply_cuts!(model, callback_data.node_model)

        if added
            return nothing
        end
    end
    
    # Allow only one user cut solution per LP optimal node limiting
    # two calls to guarantee th user has a chance to add a cut.
    # If the user cut is loose the problem will be resolved anyway.
    if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 2
        return nothing
    end

    model.user_cut_callback(callback_data)

    return nothing
end

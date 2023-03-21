function moi_user_cut_wrapper(model::Optimizer, callback_data::CallbackData)
    info = get(model.callback_info, CT_MOI_USER_CUT, nothing)

    if !isnothing(info)
        model.callback_state = CS_MOI_USER_CUT # TODO: push

        # Apply stored cuts if any
        if isempty(model.callback_cut_data.cut_ptrs) || !apply_cuts!(model, callback_data.node_model)
            # Allow only one user cut solution per LP optimal node limiting
            # two calls to guarantee th user has a chance to add a cut.
            # If the user cut is loose the problem will be resolved anyway.
            if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) <= 2
                info.data_wrapper.func(callback_data)
            end
        end

        model.callback_state = CS_NONE # TODO: pop
    end

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, ::Nothing)
    model.callback_info[CT_MOI_USER_CUT] = nothing

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, func::Function)
    model.callback_info[CT_MOI_USER_CUT] = CallbackInfo{GenericCallbackData}(
        C_NULL,
        CallbackDataWrapper(model.inner, func),
    )

    model.callback_info[CT_MOI_GENERIC] = set_moi_generic_callback!(model)

    return nothing
end

MOI.supports(::Optimizer, ::MOI.UserCutCallback) = true
MOI.supports(::Optimizer, ::MOI.UserCut{CD}) where {CD<:CallbackData} = true

function MOI.submit(
    model::Optimizer,
    submittable::MOI.UserCut{CD},
    f::MOI.ScalarAffineFunction{T},
    s::Union{MOI.LessThan{T},MOI.GreaterThan{T},MOI.EqualTo{T}}
) where {T,CD<:CallbackData}
    # It is assumed that every '<:CallbackData' has a 'node_model' field
    node_model = submittable.callback_data.node_model::Xpress.XpressProblem

    # TODO: Should we mark as submitted in the beginning of the function?
    model.callback_cut_data.submitted = true

    # Check callback state
    let state = callback_state(model)
        if state !== CS_MOI_USER_CUT
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

    mtype = Ref{Cint}(1) # Cut type
    mstart = Cint[0, length(indices)]
    mindex = Array{Xpress.Lib.XPRScut}(undef, 1)
    ncuts = Cint(1)
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    qrtype = Cchar[sense]
    drhs = Ref{Cdouble}(rhs)
    indices .-= 1 # Xpress follows C's 0-index convention
    mcols = Cint.(indices)
    interp = Cint(-1) # Load all cuts
    dmatval = Cdouble.(coefficients)

    Xpress.Lib.XPRSstorecuts(
        node_model,
        ncuts,
        nodupl,
        mtype,
        qrtype,
        drhs,
        mstart,
        mindex,
        mcols,
        dmatval,
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

function moi_heuristic_wrapper(model::Optimizer, callback_data::CallbackData)
    info = get(model.callback_info, CT_MOI_HEURISTIC, nothing)

    if !isnothing(info)
        push_callback_state!(model, CS_MOI_HEURISTIC)

        # Allow at most one heuristic solution per LP optimal node
        if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) <= 1
            info.data_wrapper.func(callback_data)
        end

        pop_callback_state!(model)
    end

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, ::Nothing)
    model.callback_info[CT_MOI_HEURISTIC] = nothing

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, func::Function)
    model.callback_info[CT_MOI_HEURISTIC] = CallbackInfo{GenericCallbackData}(
        C_NULL,
        CallbackDataWrapper(model.inner, func),
    )

    model.callback_info[CT_MOI_GENERIC] = set_moi_generic_callback!(model)

    return nothing
end

MOI.supports(::Optimizer, ::MOI.HeuristicCallback) = true
MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CD}) where {CD<:CallbackData} = true

function MOI.submit(
    model::Optimizer,
    submittable::MOI.HeuristicSolution{CD},
    variables::Vector{MOI.VariableIndex},
    values::Vector{T}
) where {T, CD <: CallbackData}
    # It is assumed that every '<:CallbackData' has a 'node_model' field
    node_model = submittable.callback_data.node_model::Xpress.XpressProblem

    # Check callback state
    let state = callback_state(model)
        if state !== CS_MOI_HEURISTIC
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

    # Specific submit tasks
    ilength   = length(variables)
    mipsolval = Vector{Cint}(undef, ilength)
    mipsolcol = fill!(Vector{Cfloat}(undef, ilength), NaN)

    for (count, (var, value)) in enumerate(zip(variables, values))
        mipsolcol[count] = _info(model, var).column - 1 # 0-indexing
        mipsolval[count] = value
    end

    if ilength == MOI.get(model, MOI.NumberOfVariables())
        mipsolcol = C_NULL
    end

    Lib.XPRSaddmipsol(
        node_model,
        Cint(ilength),
        mipsolval,
        mipsolcol,
        C_NULL,
    )

    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end

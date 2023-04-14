function moi_heuristic_xprs_optnode_wrapper(func::Function, model::Optimizer, callback_data::CD) where {CD<:CallbackData}
    push_callback_state!(model, CS_MOI_HEURISTIC)

    get_callback_solution!(model, callback_data.node_model)

    # Allow at most one heuristic solution per LP optimal node
    if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) <= 1
        func(callback_data)
    end

    pop_callback_state!(model)

    return nothing
end

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, ::Nothing)
    info = model.callback_table.moi_heuristic

    if !isnothing(info)
        xprs_optnode_info, = info

        remove_xprs_optnode_callback!(model.inner, xprs_optnode_info)

        model.callback_table.moi_heuristic = nothing
    end

    return nothing
end

function MOI.set(model::Optimizer, attr::MOI.HeuristicCallback, func::Function)
    MOI.set(model, attr, nothing)

    xprs_optnode_info = add_xprs_optnode_callback!(
        model.inner,
        (callback_data::OptNodeCallbackData) -> moi_heuristic_xprs_optnode_wrapper(
            func,
            model,
            callback_data,
        )
    )::CallbackInfo{OptNodeCallbackData}

    model.callback_table.moi_heuristic = (xprs_optnode_info,)

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

    check_callback_state(model, node_model, submittable, CS_MOI_HEURISTIC)

    # Specific submit tasks
    ilength = length(variables)
    solval = fill!(Vector{Cdouble}(undef, ilength), NaN)
    colind = Vector{Cint}(undef, ilength)

    for (count, (var, value)) in enumerate(zip(variables, values))
        solval[count] = value
        colind[count] = _info(model, var).column - 1 # 0-indexing
    end

    if ilength == MOI.get(model, MOI.NumberOfVariables())
        colind = C_NULL
    end

    Lib.XPRSaddmipsol(
        node_model,
        Cint(ilength),
        solval,
        colind,
        C_NULL,
    )

    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end

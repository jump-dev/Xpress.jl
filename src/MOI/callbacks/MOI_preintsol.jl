@doc raw"""
    PreIntSolCallback
""" struct PreIntSolCallback <: XpressCallback end

function xprs_preintsol_wrapper(func::Function, model::Xpress.Optimizer, callback_data::PreIntSolCallbackData)
    info = model.callback_table.xprs_preintsol::Union{CallbackInfo{PreIntSolCallbackData},Nothing}

    if !isnothing(info)
        push_callback_state!(model, CS_XPRS_PREINTSOL)

        get_callback_solution!(model, callback_data.node_model)

        # Allow at most one heuristic solution per LP optimal node
        if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) <= 1
            func(callback_data)
        end

        pop_callback_state!(model)
    end

    return nothing
end

function MOI.set(model::Optimizer, ::PreIntSolCallback, ::Nothing)
    xprs_preintsol_info = model.callback_table.xprs_preintsol::Union{CallbackInfo{PreIntSolCallbackData},Nothing}

    if !isnothing(xprs_preintsol_info)
        remove_xprs_preintsol_callback!(model.inner, xprs_preintsol_info)
    end

    model.callback_table.xprs_preintsol = nothing

    return nothing
end

function MOI.set(model::Optimizer, attr::PreIntSolCallback, func::Function)
    # remove any previous callback definitions
    MOI.set(model, attr, nothing)

    model.callback_table.xprs_preintsol = add_xprs_preintsol_callback!(
        model.inner,
        (callback_data::PreIntSolCallbackData) -> xprs_preintsol_wrapper(func, model, callback_data)
    )

    return nothing
end
@doc raw"""
    OptNodeCallback
""" struct OptNodeCallback <: XpressCallback end

function xprs_optnode_wrapper(func::Function, model::Xpress.Optimizer, callback_data::OptNodeCallbackData)
    info = model.callback_table.xprs_optnode::Union{CallbackInfo{OptNodeCallbackData},Nothing}

    if !isnothing(info)
        push_callback_state!(model, CS_MOI_HEURISTIC)

        get_callback_solution!(model, info.data_wrapper.data)

        # Allow at most one heuristic solution per LP optimal node
        if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) <= 1
            func(callback_data)
        end

        pop_callback_state!(model)
    end

    return nothing
end

function MOI.set(model::Xpress.Optimizer, ::OptNodeCallback, ::Nothing)
    xprs_optnode_info = model.callback_table.xprs_optnode::Union{CallbackInfo{OptNodeCallbackData},Nothing}

    if !isnothing(xprs_optnode_info)
        remove_xprs_optnode_callback!(model.inner, xprs_optnode_info)
    end

    model.callback_table.xprs_optnode = nothing

    return nothing
end

function MOI.set(model::Optimizer, attr::OptNodeCallback, func::Function)
    # remove any previous callback definitions
    MOI.set(model, attr, nothing)

    model.callback_table.xprs_optnode = add_xprs_optnode_callback!(
        model,
        (callback_data::OptNodeCallbackData) -> xprs_optnode_wrapper(func, model, callback_data),
    )

    return nothing
end
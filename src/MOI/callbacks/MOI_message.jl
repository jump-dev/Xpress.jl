@doc raw"""
    MessageCallback
""" struct MessageCallback <: XpressCallback end

function xprs_message_wrapper(func::Function, model::Optimizer, callback_data::CD) where {CD<:CallbackData}
    xprs_message_info = model.callback_table.xprs_message::Union{CallbackInfo{CD},Nothing}

    if !isnothing(xprs_message_info)
        push_callback_state!(model, CS_XPRS_MESSAGE)

        func(callback_data)

        pop_callback_state!(model)
    end


    return nothing
end

function MOI.set(model::Optimizer, ::MessageCallback, ::Nothing)
    xprs_message_info = model.callback_table.xprs_message::Union{CallbackInfo{MessageCallbackData},Nothing}

    if !isnothing(xprs_message_info)
        remove_xprs_message_callback!(model.inner, xprs_message_info)
    end

    model.callback_table.xprs_message = nothing

    return nothing
end

function MOI.set(model::Optimizer, attr::MessageCallback, func::Function)
    # remove any existing callback definitions
    MOI.set(model, attr, nothing)

    model.callback_table.xprs_message = add_xprs_message_callback!(
        model.inner,
        (callback_data::MessageCallbackData) -> xprs_message_wrapper(func, model, callback_data)
    )::CallbackInfo{MessageCallbackData}

    return nothing
end

@doc raw"""
    default_xprs_message_func(callback_data::MessageCallbackData)
"""
function default_xprs_message_func(callback_data::MessageCallbackData)
    show_warning = callback_data.data::Bool
    msg = callback_data.msg
    msgtype = callback_data.msgtype

    if msgtype == 1 # Information
        println(unsafe_string(msg))
        return zero(Cint)
    elseif msgtype == 2 # Not used
        return zero(Cint)
    elseif msgtype == 3 # Warning
        if show_warning
            println(unsafe_string(msg))
        end
        return zero(Cint)
    elseif msgtype == 4 # Error
        return zero(Cint)
    else # Exiting - buffers need flushing
        flush(stdout)
        return zero(Cint)
    end

    return nothing
end

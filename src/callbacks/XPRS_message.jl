struct MessageCallback <: XpressCallback end

mutable struct MessageCallbackData <: CallbackData
    # models
    root_model::XpressProblem
    node_model::Union{XpressProblem, Nothing}

    # data
    data::Any

    # args
    cbprob::Union{Xpress.Lib.XPRSprob, Nothing}
    cbdata::Union{Ptr{Cvoid}, Nothing}
    msg::Union{Ptr{Cchar}, Nothing}
    msglen::Union{Cint, Nothing}
    msgtype::Union{Cint, Nothing}

    function MessageCallbackData(root_model::XpressProblem, data::Any = nothing)
        return new(
            root_model,
            nothing, # node_model
            data,
            nothing, # cbprob
            nothing, # cbdata
            nothing, # msg
            nothing, # msglen
            nothing, # msgtype
        )
    end
end

@doc raw"""
    default_xprs_message(callback_data::MessageCallbackData)
"""
function default_xprs_message(callback_data::MessageCallbackData)
    show_warning = callback_data.data::Bool
    msg          = callback_data.msg
    msgtype      = callback_data.msgtype

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

@doc raw"""
    xprs_message_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, msg::Ptr{Cchar}, len::Cint, msgtype::Cint)
"""
function xprs_message_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, msg::Ptr{Cchar}, msglen::Cint, msgtype::Cint)
    data_wrapper = unsafe_pointer_to_objref(cbdata)::CallbackDataWrapper{MessageCallbackData}    
    
    # Update callback data
    data_wrapper.data.node_model = XpressProblem(cbprob; finalize_env = false)

    # Update function args
    data_wrapper.data.cbprob = cbprob
    data_wrapper.data.msg = msg
    data_wrapper.data.msglen = msglen
    data_wrapper.data.msgtype = msgtype

    # Call user-defined function
    data_wrapper.func(data_wrapper.data)
    
    return zero(Cint)
end

@doc raw"""
    set_callback_message!(model::XpressProblem, show_warning::Bool)

From ...

# `XPRSaddcbmessage`

## Purpose
  
Declares an output callback function, called every time a text line relating to the given XPRSprob is output by the Optimizer.
This callback function will be called in addition to any callbacks already added by `XPRSaddcbmessage`.
Note that Optimizer messages passed to the callback do not end with a newline character; the user callback is expected to append such required newline characters itself.

## Synopsis

```c
int XPRS_CC XPRSaddcbmessage(
    XPRSprob prob,
    void (XPRS_CC *message)(XPRSprob cbprob, void *cbdata, const char *msg, int msglen, int msgtype),
    void *data,
    int priority
);
```

## Arguments
    
- `prob` The current problem.
- `message` The callback function which takes five arguments, cbprob, cbdata, msg, msglen and
- `msgtype`, and has no return value. Use a NULL value to cancel a callback function.
- `cbprob` The problem passed to the callback function.
- `cbdata` The user-defined data passed as data when setting up the callback with XPRSaddcbmessage.
- `msg` A null terminated character array (string) containing the message, which may simply be a new line.
- `msglen` The length of the message string, excluding the null terminator.
- `msgtype` Indicates the type of output message:
    - `1` information messages;
    - `2` (not used);
    - `3` warning messages;
    - `4` error messages.
    A negative value indicates that the Optimizer is about to finish and the buffers should be flushed at this time if the output is being redirected to a file.
- `data` A user-defined data to be passed to the callback function.
- `priority` An integer that determines the order in which callbacks of this type will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

## Related controls

Integer `OUTPUTLOG` All messages are disabled if set to zero.

## Example

The following example simply sends all output to the screen (stdout):

```c
XPRSaddcbmessage(prob,Message,NULL,0);
```

The callback function might resemble:

```c
void XPRS_CC Message(XPRSprob cbprob, void* data, const char *msg, int msglen, int msgtype)
{
    switch(msgtype) {
        case 4: /* error */
        case 3: /* warning */
        case 2: /* not used */
        case 1: /* information */
            printf("%s\n", msg);
            break;
        default: /* exiting - buffers need flushing */
            fflush(stdout);
            break;
    }
}
```

## Further information
    1. Screen output is automatically created by the Optimizer Console only. To produce output when using the Optimizer library, it is necessary to define this callback function and use it to print the messages to the screen (stdout).
    2. This function offers one method of handling the messages which describe any warnings and errors that may occur during execution. Other methods are to check the return values of functions and then get the error code using the ERRORCODE attribute, obtain the last error message directly using XPRSgetlasterror, or send messages direct to a log file using XPRSsetlogfile.
    3. Visual Basic users must use the alternative function XPRSaddcbmessageVB to define the callback; this is required because of the different way VB handles strings.
"""
function set_xprs_message_callback!(model::Xpress.Optimizer, func::Function, data::Any = nothing, priority::Integer = 0)
    callback_ptr = @cfunction(xprs_message_wrapper, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cchar}, Cint, Cint))
    data_wrapper = CallbackDataWrapper{MessageCallbackData}(model.inner, func, data)

    Lib.XPRSaddcbmessage(
        model.inner.ptr, # XPRSprob prob
        callback_ptr,    # void (XPRS_CC *message)(XPRSprob cbprob, void *cbdata, const char *msg, int msglen, int msgtype)
        data_wrapper,    # void *data
        Cint(priority)   # int priority
    )

    # Keep a reference to the callback function to avoid garbage collection
    # TODO: Handle reference-tracking properly
    model.callback_info[:xprs_message] = CallbackInfo{MessageCallbackData}(callback_ptr, data_wrapper)

    return nothing
end

function set_xprs_message_callback!(model::Xpress.Optimizer, show_warning::Bool = true, priority::Integer = 0)
    set_xprs_message_callback!(
        model,
        default_xprs_message, # func::Function
        show_warning,         # data::Any
        priority,
    )

    return nothing
end

@doc raw"""
    remove_message_callback!(model::XpressProblem)

From ...

# `XPRSremovecbmessage`

## Purpose
Removes a message callback function previously added by XPRSaddcbmessage.
The specified callback function will no longer be called after it has been removed.

## Synopsis
```c
int XPRS_CC XPRSremovecbmessage(
    XPRSprob prob,
    void (XPRS_CC *message)(XPRSprob prob, void* vContext, const char* msg, int len, int msgtype),
    void* data
);
```

## Arguments
- `prob` The current problem.
- `message` The callback function to remove. If NULL then all message callback functions added with the given user-defined data value will be removed.
- `data` The data value that the callback was added with. If NULL, then the data value will not be checked and all message callbacks with the function pointer message will be removed.

"""
function remove_message_callback!(model::Optimizer)
    Xpress.Lib.XPRSremovecbmessage(model.inner, C_NULL, C_NULL)

    model.callback_info[:xprs_message] = nothing

    return nothing
end

function MOI.set(model::Optimizer, ::MessageCallback, ::Nothing)
    if !isnothing(model.callback_info[:xprs_message])
        remove_message_callback!(model)
    end

    return nothing
end

function MOI.set(model::Optimizer, attr::MessageCallback, func::Function)
    # remove any existing callback definitions
    MOI.set(model, attr, nothing)

    set_xprs_message_callback!(model, func)

    return nothing
end

MOI.supports(::Optimizer, ::MessageCallback) = true

function reset_message_callback!(model::Optimizer)
    callback_info = model.callback_info[:xprs_message]::Union{CallbackInfo{MessageCallbackData},Nothing}

    if !isnothing(callback_info)
        # remove all message callbacks
        remove_message_callback!(model)
    end

    #  no file -> screen            && has log
    if isempty(model.inner.logfile) && !iszero(model.log_level)
        set_xprs_message_callback!(
            model,
            model.show_warning,
        )
    end

    return nothing
end

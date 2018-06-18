# Xpress callbacks

mutable struct CallbackData
    model_root::Model # should not use operations here
    data::Any # data for user
    model::Model# local model # ptr_model::Ptr{Void}
end

mutable struct MessageData
    data::Any # data for user
    msg::Cstring
    len::Cint
    msgtype::Cint
end

function setcbintsol_wrapper(ptr_model::Ptr{Void}, my_object::Ptr{Void})
    callback, model, data = unsafe_pointer_to_objref(my_object)
    callback(CallbackData(model, data, Model(ptr_model;finalize_env = false)))
    return convert(Cint,0)
end

set_callback_intsol!(model::Model, callback::Function) = set_callback_intsol!(model, callback, nothing)
function set_callback_intsol!(model::Model, callback::Function, data::Any)
    xprscallback = cfunction(setcbintsol_wrapper, Cint, (Ptr{Void}, Ptr{Void}))
    usrdata = (callback, model, data)
    ret = @xprs_ccall(addcbintsol, Cint, (Ptr{Void}, Ptr{Void}, Any), model.ptr_model, xprscallback, usrdata)
    if ret != 0
        throw(XpressError(model))
    end
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    return nothing
end

function addcbpreintsol_wrapper(ptr_model::Ptr{Void}, my_object::Ptr{Void})
    callback, model, data = unsafe_pointer_to_objref(my_object)#::(Function,Model,Any)
    callback(CallbackData(model, data, Model(ptr_model;finalize_env = false)))
    return convert(Cint,0)
end

set_callback_preintsol!(model::Model, callback::Function) = set_callback_preintsol!(model, callback, nothing)
function set_callback_preintsol!(model::Model, callback::Function, data::Any)

    xprscallback = cfunction(addcbpreintsol_wrapper, Cint, (Ptr{Void}, Ptr{Void}))
    usrdata = (callback, model, data)
    ret = @xprs_ccall(addcbpreintsol, Cint, (Ptr{Void}, Ptr{Void}, Any), model.ptr_model, xprscallback, usrdata)
    if ret != 0
        throw(XpressError(model))
    end

    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    return nothing
end

function addmessage_wrapper(ptr_model::Ptr{Void}, my_object::Ptr{Void}, msg::Cstring, len::Cint, msgtype::Cint)
    callback, data = unsafe_pointer_to_objref(my_object)#::(Function,Model,Any)
    callback(MessageData(data, msg, len, msgtype))
    return convert(Cint,0)
end

set_callback_message!(model::Model, callback::Function) = set_callback_message!(model, callback, nothing)
function set_callback_message!(model::Model, callback::Function, data::Any)
    xprscallback = cfunction(addmessage_wrapper, Cint, (Ptr{Void}, Ptr{Void}, Cstring, Cint, Cint))
    usrdata = (callback, data)
    ret = @xprs_ccall(addcbmessage, Cint, (Ptr{Void}, Ptr{Void}, Any), model.ptr_model, xprscallback, usrdata)
    if ret != 0
        throw(XpressError(model))
    end
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    return nothing
end

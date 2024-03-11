# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

mutable struct CallbackData
    model_root::XpressProblem # should not use operations here
    data::Any # data for user
    model::XpressProblem # local model # ptr_model::Ptr{Nothing}
end
Base.broadcastable(x::CallbackData) = Ref(x)

# must be mutable
mutable struct _CallbackUserData
    callback::Function
    model::XpressProblem
    data::Any
end
Base.cconvert(::Type{Ptr{Cvoid}}, x::_CallbackUserData) = x
function Base.unsafe_convert(::Type{Ptr{Cvoid}}, x::_CallbackUserData)
    return pointer_from_objref(x)::Ptr{Cvoid}
end

export CallbackData

function setcboptnode_wrapper(
    ptr_model::Lib.XPRSprob,
    my_object::Ptr{Cvoid},
    feas::Ptr{Cint},
)
    usrdata = unsafe_pointer_to_objref(my_object)::_CallbackUserData
    callback, model, data = usrdata.callback, usrdata.model, usrdata.data
    model_inner = XpressProblem(ptr_model; finalize_env = false)
    callback(CallbackData(model, data, model_inner))
    return zero(Cint)
end

function set_callback_optnode!(
    model::XpressProblem,
    callback::Function,
    data::Any = nothing,
)
    callback_ptr = @cfunction(
        setcboptnode_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint})
    )
    usrdata = _CallbackUserData(callback, model, data)
    Lib.XPRSaddcboptnode(model.ptr, callback_ptr, usrdata, 0)
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    return callback_ptr, usrdata
end

function setcbpreintsol_wrapper(
    ptr_model::Lib.XPRSprob,
    my_object::Ptr{Cvoid},
    soltype::Ptr{Cint},
    ifreject::Ptr{Cint},
    cutoff::Ptr{Cdouble},
)
    usrdata = unsafe_pointer_to_objref(my_object)::_CallbackUserData
    callback, model, data = usrdata.callback, usrdata.model, usrdata.data
    model_inner = XpressProblem(ptr_model; finalize_env = false)
    callback(CallbackData(model, data, model_inner))
    return zero(Cint)
end

function set_callback_preintsol!(
    model::XpressProblem,
    callback::Function,
    data::Any = nothing,
)
    callback_ptr = @cfunction(
        setcbpreintsol_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble})
    )
    usrdata = _CallbackUserData(callback, model, data)
    Lib.XPRSaddcbpreintsol(model.ptr, callback_ptr, usrdata, 0)
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    return callback_ptr, usrdata
end

function addcboutput2screen_wrapper(
    ptr_model::Lib.XPRSprob,
    my_object::Ptr{Cvoid},
    msg::Ptr{Cchar},
    len::Cint,
    msgtype::Cint,
)
    usrdata = unsafe_pointer_to_objref(my_object)::_CallbackUserData
    show_warning = usrdata.data::Bool

    if msgtype == 4
        #= Error =#
        return zero(Cint)
    elseif msgtype == 3 && show_warning
        #= Warning =#
        msg_str = unsafe_string(msg)
        println(msg_str)
        return zero(Cint)
    elseif msgtype == 2
        #= Not used =#
        return zero(Cint)
    elseif msgtype == 1
        #= Information =#
        msg_str = unsafe_string(msg)
        println(msg_str)
        return zero(Cint)
    else
        #= Exiting - buffers need flushing  =#
        flush(stdout)
        return zero(Cint)
    end
end

function setoutputcb!(model::XpressProblem, show_warning::Bool)
    callback_ptr = @cfunction(
        addcboutput2screen_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cchar}, Cint, Cint)
    )
    usrdata = _CallbackUserData(_null, model, show_warning)
    Lib.XPRSaddcbmessage(model.ptr, callback_ptr, usrdata, 0)
    return callback_ptr, usrdata
end

function _null()
    return
end

# Xpress callbacks

mutable struct CallbackData
    #cbdata::Ptr{Void} # data for solver
    model_root::Model # should not use operations here
    data::Any # data for user
    model::Model# local model # ptr_model::Ptr{Void}
end

function setcbintsol_wrapper(ptr_model::Ptr{Void}, my_object::Ptr{Void})
    callback, model, data = unsafe_pointer_to_objref(my_object)#::(Function,Model,Any)
    callback(CallbackData(model, data, Model(ptr_model)))
    return convert(Cint,0)
end

set_callback_intsol!(model::Model, callback::Function) = set_callback_intsol!(model, callback, nothing)
function set_callback_intsol!(model::Model, callback::Function, data::Any)
    
    xprscallback = cfunction(setcbintsol_wrapper, Cint, (Ptr{Void}, Ptr{Void}))
    usrdata = (callback, model, data)
    ret = @xprs_ccall(setcbintsol, Cint, (Ptr{Void}, Ptr{Void}, Any), model.ptr_model, xprscallback, usrdata)
    if ret != 0
        throw(XpressError(model))
    end

    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    model.callback = usrdata
    nothing
end
    

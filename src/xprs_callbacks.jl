function XPRSaddcboptnode_object(prob, f_optnode, p, priority)
    ccall((:XPRSaddcboptnode, Xpress.libxprs), Cint, (Xpress.Lib.XPRSprob, Ptr{Cvoid}, Any, Cint), prob, f_optnode, p, priority)
end

function XPRSaddcbpreintsol_object(prob, f_preintsol, p, priority)
    ccall((:XPRSaddcbpreintsol, Xpress.libxprs), Cint, (Xpress.Lib.XPRSprob, Ptr{Cvoid}, Any, Cint), prob, f_preintsol, p, priority)
end

function addcboptnode_object(prob::XpressProblem, f_optnode, p, priority)
    XPRSaddcboptnode_object(prob, f_optnode, p, priority)
end

function addcbpreintsol_object(prob::XpressProblem, f_preintsol, p, priority)
    XPRSaddcbpreintsol_object(prob, f_preintsol, p, priority)
end


mutable struct CallbackData
    model_root::XpressProblem # should not use operations here
    data::Any # data for user
    model::XpressProblem # local model # ptr_model::Ptr{Nothing}
end

export CallbackData

function setcboptnode_wrapper(ptr_model::Lib.XPRSprob, my_object::Ptr{Cvoid}, feas::Ptr{Cint})
    usrdata = unsafe_pointer_to_objref(my_object)
    (callback, model, data) = usrdata
    callback(CallbackData(model, data, XpressProblem(ptr_model)))
    nothing
end

set_callback_optnode!(model::XpressProblem, callback::Function) = set_callback_optnode!(model, callback, nothing)

function set_callback_optnode!(model::XpressProblem, callback::Function, data::Any)
    xprscallback = @cfunction(setcboptnode_wrapper, Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}))
    usrdata = (callback, model, data)
    addcboptnode_object(model, xprscallback, usrdata,0)
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    nothing
end

function setcbpreintsol_wrapper(ptr_model::Lib.XPRSprob, my_object::Ptr{Cvoid}, soltype::Ptr{Cint}, ifreject::Ptr{Cint}, cutoff::Ptr{Cdouble})
    usrdata = unsafe_pointer_to_objref(my_object)
    (callback, model, data) = usrdata
    callback(CallbackData(model, data, XpressProblem(ptr_model)))
    nothing
end

set_callback_preintsol!(model::XpressProblem, callback::Function) = set_callback_preintsol!(model, callback, nothing)

function set_callback_preintsol!(model::XpressProblem, callback::Function, data::Any)
    xprscallback = @cfunction(setcbpreintsol_wrapper, Cvoid, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}))
    usrdata = (callback, model, data)
    addcbpreintsol_object(model, xprscallback, usrdata,0)
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    nothing
end
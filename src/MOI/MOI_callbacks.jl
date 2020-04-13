"""
    CallbackFunction()

Set a generic Xpress callback function.
"""

struct CallbackFunction <: MOI.AbstractCallback end

mutable struct CallbackData
    model_root::XpressProblem # should not use operations here
    data::Any # data for user
    model::XpressProblem # local model # ptr_model::Ptr{Nothing}
end

function setcboptnode_wrapper(ptr_model::Ptr{Nothing}, my_object::Ptr{Nothing})
    usrdata = unsafe_pointer_to_objref(my_object)
    callback, model, data = usrdata[1],usrdata[2],usrdata[3]
    callback(CallbackData(model, data, XpressProblem(ptr_model)))
    return convert(Cint,0)
end

set_callback_optnode!(model::XpressProblem, callback::Function) = set_callback_optnode!(model, callback, nothing)

function set_callback_optnode!(model::XpressProblem, callback::Function, data::Any)
    xprscallback = @cfunction(setcboptnode_wrapper, Cint, (Ptr{Nothing}, Ptr{Nothing}))
    usrdata = [callback, model, data]
    addcboptnode(model, xprscallback, usrdata,0)
    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    push!(model.callback,usrdata)
    return nothing
end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    model.has_generic_callback = true
    # Starting with this callback to test
    set_callback_optnode!(model.inner, f)
    return
end
MOI.supports(::Optimizer, ::CallbackFunction) = true

function default_moi_callback(model::Optimizer)
    return (cb_data) -> begin
        if model.lazy_callback !== nothing
            model.callback_state = CB_LAZY
            model.lazy_callback(cb_data)
        end
        if model.user_cut_callback !== nothing
            model.callback_state = CB_USER_CUT
            model.user_cut_callback(cb_data)
        end
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            model.heuristic_callback(cb_data)
        end
    end
    model.callback_state = CB_NONE
end

# ==============================================================================
#    MOI.HeuristicCallback
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, cb::Function)
    model.heuristic_callback = cb
    return
end
MOI.supports(::Optimizer, ::MOI.HeuristicCallback) = true

function MOI.submit(
    model::Optimizer,
    cb::MOI.HeuristicSolution{CallbackData},
    variables::Vector{MOI.VariableIndex},
    values::MOI.Vector{Float64}
)
    #if model.callback_state == CB_LAZY
    #    throw(MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), cb))
    #elseif model.callback_state == CB_USER_CUT
    #    throw(MOI.InvalidCallbackUsage(MOI.UserCutCallback(), cb))
    #end
    ilength = length(variables)
    mipsolval = fill(NaN, ilength)
    mipsolcol = fill(NaN, ilength)
    count = 1
    for (var, value) in zip(variables, values)
        mipsolcol[count] = _info(model, var).column
        mipsolval[count] = value
        count += 1
    end
    if ilength == MOI.get(model, MOI.get(model, MOI.NumberOfVariables()))
        mipsolcol = C_NULL
    end
    addmipsol(model.inner, ilength, mipsolval, mipsolcol, C_NULL)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end
MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true

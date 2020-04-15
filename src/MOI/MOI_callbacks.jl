"""
    CallbackFunction()

Set a generic Xpress callback function.
"""

struct CallbackFunction <: MOI.AbstractCallback end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    model.has_generic_callback = true
    # Starting with this callback to test
    set_callback_optnode!(model.inner, (cb_data) -> begin
        model.callback_state = CB_GENERIC
        f(cb_data)
        model.callback_state = CB_NONE
    end)
    return
end
MOI.supports(::Optimizer, ::CallbackFunction) = true

function get_cb_solution(model::Optimizer)
    reset_callback_cached_solution(model)
    Xpress.Lib.XPRSgetlpsol(model.inner,
            model.callback_cached_solution.variable_primal,
            model.callback_cached_solution.linear_primal,
            model.callback_cached_solution.linear_dual,
            model.callback_cached_solution.variable_dual)
    model.callback_variable_primal = model.callback_cached_solution.variable_primal
    return
end

# TODO: Add User Cut and Lazy Callbacks 
#=
function default_moi_callback(model::Optimizer)
    return (cb_data, cb_where) -> begin
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
=#

function default_moi_callback(model::Optimizer)
    return (cb_data) -> begin
        get_cb_solution(model)
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            model.heuristic_callback(cb_data)
        end
    end
end

function MOI.get(
    model::Optimizer,
    ::MOI.CallbackVariablePrimal{CallbackData},
    x::MOI.VariableIndex
)
    return model.callback_variable_primal[_info(model, x).column]
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
    if model.callback_state == CB_LAZY
        throw(MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), cb))
    elseif model.callback_state == CB_USER_CUT
        throw(MOI.InvalidCallbackUsage(MOI.UserCutCallback(), cb))
    end
    ilength = length(variables)
    mipsolval = fill(NaN,ilength)
    mipsolcol = Array{Cint}(undef,ilength) 
    count = 1
    for (var, value) in zip(variables, values)
        mipsolcol[count] = convert(Cint,_info(model, var).column - 1)
        mipsolval[count] = value
        count += 1
    end
    if ilength == MOI.get(model, MOI.NumberOfVariables())
        mipsolcol = C_NULL
    end
    addmipsol(model.inner, ilength, mipsolval, mipsolcol, C_NULL)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end
MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true
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

function applycuts(model::Optimizer)
    itype = Cint(1)
    interp = Cint(-1) # Get all cuts
    delta = Xpress.Lib.XPRS_MINUSINFINITY
    ncuts = Array{Cint}(undef,1)
    size = length(model.cb_cut_data.cutptrs)
    mcutptr = Array{Xpress.Lib.XPRScut}(undef,size)
    dviol = Array{Cfloat}(undef,size)
    getcpcutlist(model.inner, itype, interp, delta, ncuts, size, mcutptr, dviol)
    loadcuts(model.inner, itype, interp, ncuts[1], mcutptr)
end

# ==============================================================================
#    MOI callbacks
# ==============================================================================

# TODO: Add Lazy Callbacks 
function default_moi_callback(model::Optimizer)
    return (cb_data) -> begin
        if Xpress.getintattrib(model.inner,Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 2
            return 
        end
        get_cb_solution(model)
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            model.heuristic_callback(cb_data)
        end
        if model.user_cut_callback !== nothing
            model.callback_state = CB_USER_CUT
            model.user_cut_callback(cb_data)
            if !model.cb_cut_data.submitted && length(model.cb_cut_data.cutptrs) > 0
                applycuts(model)
            end
        end
        if model.lazy_callback !== nothing
            model.callback_state = CB_LAZY
            model.lazy_callback(cb_data)
            if !model.cb_cut_data.submitted && length(model.cb_cut_data.cutptrs) > 0
                applycuts(model)
            end
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
#    MOI.UserCutCallback  & MOI.LazyConstraint 
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, cb::Function)
    model.user_cut_callback = cb
    return
end

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, cb::Function)
    model.lazy_callback = cb
    return
end

MOI.supports(::Optimizer, ::MOI.UserCutCallback) = true
MOI.supports(::Optimizer, ::MOI.UserCut{CallbackData}) = true

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true
MOI.supports(::Optimizer, ::MOI.LazyConstraint{CallbackData}) = true

function MOI.submit(
    model::Optimizer,
    cb::Union{MOI.UserCut{CallbackData},MOI.LazyConstraint{CallbackData}},
    f::MOI.ScalarAffineFunction{Float64},
    s::Union{MOI.LessThan{Float64}, MOI.GreaterThan{Float64}, MOI.EqualTo{Float64}}
)
    model.cb_cut_data.submitted = true
    if model.callback_state == CB_HEURISTIC
        throw(MOI.InvalidCallbackUsage(MOI.HeuristicCallback(), cb))
    elseif !iszero(f.constant)
        throw(MOI.ScalarFunctionConstantNotZero{Float64, typeof(f), typeof(s)}(f.constant))
    end
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Int32[1] # Cut type
    mstart = Int32[0,1]
    mindex  = Array{Xpress.Lib.XPRScut}(undef,1)
    ncuts = Cint(1)
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    sensetype = Cchar[Char(sense)]
    drhs = Float64[rhs]
    indices .-= 1
    mcols = Int32.(indices)
    interp = Cint(-1) # Load all cuts

    storecuts(model.inner, ncuts, nodupl, mtype, sensetype, drhs, mstart, mindex, mcols, coefficients)
    loadcuts(model.inner, mtype[1], interp, ncuts, mindex)
    push!(model.cb_cut_data.cutptrs, mindex[1])
    return
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
    mipsolcol = fill(NaN,ilength)
    count = 1
    for (var, value) in zip(variables, values)
        mipsolcol[count] = convert(Cint,_info(model, var).column - 1)
        mipsolval[count] = value
        count += 1
    end
    mipsolcol = Cint.(mipsolcol)
    mipsolval = Cfloat.(mipsolval)
    if ilength == MOI.get(model, MOI.NumberOfVariables())
        mipsolcol = C_NULL
    end
    addmipsol(model.inner, ilength, mipsolval, mipsolcol, C_NULL)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end
MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true
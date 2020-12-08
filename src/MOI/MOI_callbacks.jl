"""
    CallbackFunction()

Set a generic Xpress callback function.
"""

struct CallbackFunction <: MOI.AbstractCallback end

function MOI.set(model::Optimizer, ::CallbackFunction, ::Nothing)
    if model.callback_data !== nothing
        removecboptnode(model.inner, C_NULL, C_NULL)
        model.callback_data = nothing
    end
    model.has_generic_callback = false
    return
end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    if model.callback_data !== nothing
        Xpress.removecboptnode(model.inner, C_NULL, C_NULL)
        model.callback_data = nothing
    end
    model.has_generic_callback = true
    # Starting with this callback to test
    model.callback_data = set_callback_optnode!(model.inner, (cb_data) -> begin
        model.callback_state = CB_GENERIC
        f(cb_data)
        model.callback_state = CB_NONE
    end)
    return
end
MOI.supports(::Optimizer, ::CallbackFunction) = true

function get_cb_solution(model::Optimizer, model_inner::XpressProblem)
    reset_callback_cached_solution(model)
    Xpress.Lib.XPRSgetlpsol(model_inner,
            model.callback_cached_solution.variable_primal,
            model.callback_cached_solution.linear_primal,
            model.callback_cached_solution.linear_dual,
            model.callback_cached_solution.variable_dual)
    return
end

function applycuts(opt::Optimizer, model::XpressProblem)
    itype = Cint(1)
    interp = Cint(-1) # Get all cuts
    delta = 0.0#Xpress.Lib.XPRS_MINUSINFINITY
    ncuts = Array{Cint}(undef,1)
    size = Cint(length(opt.cb_cut_data.cutptrs))
    mcutptr = Array{Xpress.Lib.XPRScut}(undef,size)
    dviol = Array{Cdouble}(undef,size)
    getcpcutlist(model, itype, interp, delta, ncuts, size, mcutptr, dviol) # requires an availabel solution
    loadcuts(model, itype, interp, ncuts[1], mcutptr)
    return ncuts[1] > 0
end

# ==============================================================================
#    MOI callbacks
# ==============================================================================

function default_moi_callback(model::Optimizer)
    return (cb_data) -> begin
        get_cb_solution(model, cb_data.model)
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            # only allow one heuristic solution per LP optimal node
            if Xpress.getintattrib(cb_data.model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 1
                return
            end
            model.heuristic_callback(cb_data)
        end
        if model.user_cut_callback !== nothing
            model.callback_state = CB_USER_CUT
            # apply stored cuts if any
            if length(model.cb_cut_data.cutptrs) > 0
                added = applycuts(model, cb_data.model)
                if added
                    return
                end
            end
            # only allow one user cut solution per LP optimal node
            # limiting two calls to guarantee th user has a chance to add
            # a cut. if the user cut is loose the problem will be resolved anyway.
            if Xpress.getintattrib(cb_data.model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 2
                return
            end
            model.user_cut_callback(cb_data)
        end
        if model.lazy_callback !== nothing
            model.callback_state = CB_LAZY
            # add previous cuts if any
            # to gurantee the user is dealing with a optimal solution
            # feasibile for exisitng cuts
            if length(model.cb_cut_data.cutptrs) > 0
                added = applycuts(model, cb_data.model)
                if added
                    return
                end
            end
            model.lazy_callback(cb_data)
        end
    end
    return
end

function MOI.get(::Optimizer, attr::MOI.CallbackNodeStatus{CallbackData})
    if Xpress.getintattrib(attr.callback_data.model,Xpress.Lib.XPRS_MIPINFEAS) == 0
        return MOI.CALLBACK_NODE_STATUS_INTEGER
    elseif Xpress.getintattrib(attr.callback_data.model,Xpress.Lib.XPRS_MIPINFEAS) > 0
        return MOI.CALLBACK_NODE_STATUS_FRACTIONAL
    end
    return MOI.CALLBACK_NODE_STATUS_UNKNOWN
end

function MOI.get(
    model::Optimizer,
    ::MOI.CallbackVariablePrimal{CallbackData},
    x::MOI.VariableIndex
)
    return model.callback_cached_solution.variable_primal[_info(model, x).column]
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
    cb::CB,
    f::MOI.ScalarAffineFunction{Float64},
    s::Union{MOI.LessThan{Float64}, MOI.GreaterThan{Float64}, MOI.EqualTo{Float64}}
) where CB <: Union{MOI.UserCut{CallbackData},MOI.LazyConstraint{CallbackData}}

    model_cb = cb.callback_data.model
    model.cb_cut_data.submitted = true
    if model.callback_state == CB_HEURISTIC
        cache_exception(model,
            MOI.InvalidCallbackUsage(MOI.HeuristicCallback(), cb))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
    elseif model.callback_state == CB_LAZY && CB <: MOI.UserCut{CallbackData}
        cache_exception(model,
            MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), cb))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
    elseif model.callback_state == CB_USER_CUT && CB <: MOI.LazyConstraint{CallbackData}
        cache_exception(model,
            MOI.InvalidCallbackUsage(MOI.UserCutCallback(), cb))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
    elseif !iszero(f.constant)
        cache_exception(model,
            MOI.ScalarFunctionConstantNotZero{Float64, typeof(f), typeof(s)}(f.constant))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
    end
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Int32[1] # Cut type
    mstart = Int32[0, length(indices)]
    mindex  = Array{Xpress.Lib.XPRScut}(undef,1)
    ncuts = Cint(1)
    ncuts_ptr = Cint[0]
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    sensetype = Cchar[Char(sense)]
    drhs = Float64[rhs]
    indices .-= 1
    mcols = Cint.(indices)
    interp = Cint(-1) # Load all cuts

    ret = Xpress.storecuts(model_cb, ncuts, nodupl, mtype, sensetype, drhs, mstart, mindex, mcols, coefficients)
    Xpress.loadcuts(model_cb, mtype[], interp, ncuts, mindex)
    push!(model.cb_cut_data.cutptrs, mindex[1])
    model.cb_cut_data.cutptrs
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
    model_cb = cb.callback_data.model::Xpress.XpressProblem
    model_cb2 = cb.callback_data.model_root::Xpress.XpressProblem
    if model.callback_state == CB_LAZY
        cache_exception(model,
            MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), cb))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
    elseif model.callback_state == CB_USER_CUT
        cache_exception(model,
            MOI.InvalidCallbackUsage(MOI.UserCutCallback(), cb))
        Xpress.interrupt(model_cb, Xpress.Lib.XPRS_STOP_USER)
        return
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
    addmipsol(model_cb, ilength, mipsolval, mipsolcol, C_NULL)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end
MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true

function cache_exception(model::Optimizer, e::Exception)
    model.cb_exception = e
    return
end
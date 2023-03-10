@doc raw"""
    CallbackFunction()

Set a generic Xpress callback function.
"""
struct CallbackFunction <: MOI.AbstractCallback end

function MOI.set(model::Optimizer, ::CallbackFunction, ::Nothing)
    if !isnothing(model.callback_data)
        remove_callback_optnode!(model.inner)

        model.callback_data = nothing
    end

    model.has_generic_callback = false

    return nothing
end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    if model.callback_data !== nothing
        Xpress.removecboptnode(model.inner, C_NULL, C_NULL)
        model.callback_data = nothing
    end

    model.has_generic_callback = true

    # Starting with this callback to test
    model.callback_data = set_callback_optnode!(
        model.inner,
        (cb_data) -> begin
            model.callback_state = CB_GENERIC
            f(cb_data)
            model.callback_state = CB_NONE
        end,
    )

    return
end

MOI.supports(::Optimizer, ::CallbackFunction) = true

function get_cb_solution(model::Optimizer, model_inner::XpressProblem)
    reset_callback_cached_solution(model)

    Xpress.Lib.XPRSgetlpsol(
        model_inner,
        model.callback_cached_solution.variable_primal,
        model.callback_cached_solution.linear_primal,
        model.callback_cached_solution.linear_dual,
        model.callback_cached_solution.variable_dual,
    )
 
    return
end

function apply_cuts!(opt::Optimizer, model::XpressProblem)
    itype = Cint(1)
    interp = Cint(-1) # Get all cuts
    delta = zero(Cdouble) # Xpress.Lib.XPRS_MINUSINFINITY
    ncuts = Array{Cint}(undef,1)
    size = Cint(length(opt.cb_cut_data.cutptrs))
    mcutptr = Array{Xpress.Lib.XPRScut}(undef,size)
    dviol = Array{Cdouble}(undef,size)

    getcpcutlist( # requires an available solution
        model,
        itype,
        interp,
        delta,
        ncuts,
        size,
        mcutptr,
        dviol,
    ) 

    loadcuts(model, itype, interp, ncuts[1], mcutptr)

    return (ncuts[1] > 0)
end

# ==============================================================================
#    MOI callbacks
# ==============================================================================
function default_moi_callback(model::Optimizer)
    return (callback_data::CallbackData) -> begin
        get_cb_solution(model, callback_data.node_model)

        if !isnothing(model.heuristic_callback)
            default_moi_heuristic_callback!(model, callback_data)
        end

        if !isnothing(model.user_cut_callback)
            default_moi_user_cut_callback!(model, callback_data)
        end

        if !isnothing(model.lazy_callback)
            default_moi_lazy_callback!(model, callback_data)
        end
    end
end

function default_moi_heuristic_callback!(model::Optimizer, callback_data::CallbackData)
    model.callback_state = CB_HEURISTIC

    # Allow at most one heuristic solution per LP optimal node
    if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 1
        return nothing
    end

    model.heuristic_callback(callback_data)

    return nothing
end

function default_moi_user_cut_callback!(model::Optimizer, callback_data::CallbackData)
    model.callback_state = CB_USER_CUT

    # Apply stored cuts if any
    if !isempty(model.cb_cut_data.cutptrs)
        added = apply_cuts!(model, callback_data.node_model)

        if added
            return nothing
        end
    end
    
    # Allow only one user cut solution per LP optimal node limiting
    # two calls to guarantee th user has a chance to add a cut.
    # If the user cut is loose the problem will be resolved anyway.
    if Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 2
        return nothing
    end

    model.user_cut_callback(callback_data)

    return nothing
end

function default_moi_lazy_callback!(model::Optimizer, callback_data::CallbackData)
    model.callback_state = CB_LAZY

    # Add previous cuts if any to gurantee that the user is dealing with
    # an optimal solution feasibile for exisitng cuts
    if !isempty(model.cb_cut_data.cutptrs)
        added = apply_cuts!(model, callback_data.node_model)

        if added
            return nothing
        end
    end

    model.lazy_callback(callback_data)

    return nothing
end

function MOI.get(model::Optimizer, attr::MOI.CallbackNodeStatus{CallbackData})
    if check_moi_callback_validity(model)
        mip_infeas = Xpress.getintattrib(attr.callback_data.node_model, Xpress.Lib.XPRS_MIPINFEAS)
        if mip_infeas == 0
            return MOI.CALLBACK_NODE_STATUS_INTEGER
        elseif mip_infeas > 0
            return MOI.CALLBACK_NODE_STATUS_FRACTIONAL
        end
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

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, callback::Function)
    model.user_cut_callback = callback

    return nothing
end

MOI.supports(::Optimizer, ::MOI.UserCutCallback) = true
MOI.supports(::Optimizer, ::MOI.UserCut{CallbackData}) = true

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, callback::Function)
    model.lazy_callback = callback

    return nothing
end

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true
MOI.supports(::Optimizer, ::MOI.LazyConstraint{CallbackData}) = true

function MOI.submit(
    model::Optimizer,
    moi_callback::CB,
    f::MOI.ScalarAffineFunction{T},
    s::Union{MOI.LessThan{T}, MOI.GreaterThan{T}, MOI.EqualTo{T}}
) where {T, CB <: Union{MOI.UserCut{CallbackData},MOI.LazyConstraint{CallbackData}}}

    node_model = moi_callback.callback_data.node_model
    model.cb_cut_data.submitted = true

    if model.callback_state == CB_HEURISTIC
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.HeuristicCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif model.callback_state == CB_LAZY && CB <: MOI.UserCut{CallbackData}
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif model.callback_state == CB_USER_CUT && CB <: MOI.LazyConstraint{CallbackData}
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.UserCutCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    elseif !iszero(f.constant)
        cache_exception(
            model,
            MOI.ScalarFunctionConstantNotZero{T, typeof(f), typeof(s)}(f.constant)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)
        
        return nothing
    end
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)

    mtype = Cint[1] # Cut type
    mstart = Cint[0, length(indices)]
    mindex  = Array{Xpress.Lib.XPRScut}(undef,1)
    ncuts = Cint(1)
    nodupl = Cint(2) # Duplicates are excluded from the cut pool, ignoring cut type
    sensetype = Cchar[Char(sense)]
    drhs = Cdouble[rhs]
    indices .-= 1 # Xpress follows C's 0-index convention
    mcols = Cint.(indices)
    interp = Cint(-1) # Load all cuts

    Lib.XPRSstorecuts(node_model, ncuts, nodupl, mtype, sensetype, drhs, mstart, mindex, mcols, coefficients)
    Lib.XPRSloadcuts(node_model, mtype[], interp, ncuts, mindex)

    push!(model.cb_cut_data.cutptrs, mindex[1])

    model.cb_cut_data.cutptrs

    return nothing
end

# ==============================================================================
#    MOI.HeuristicCallback
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, callback::Function)
    model.heuristic_callback = callback

    return nothing
end

MOI.supports(::Optimizer, ::MOI.HeuristicCallback) = true

function MOI.submit(
    model::Optimizer,
    moi_callback::MOI.HeuristicSolution{CallbackData},
    variables::Vector{MOI.VariableIndex},
    values::MOI.Vector{Float64}
)
    node_model = moi_callback.callback_data.node_model::Xpress.XpressProblem

    if model.callback_state == CB_LAZY
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.LazyConstraintCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)
            
        return nothing
    elseif model.callback_state == CB_USER_CUT
        cache_exception(
            model,
            MOI.InvalidCallbackUsage(MOI.UserCutCallback(), moi_callback)
        )
        Xpress.interrupt(node_model, Xpress.Lib.XPRS_STOP_USER)

        return nothing
    end

    ilength = length(variables)
    mipsolval = fill(NaN, ilength)
    mipsolcol = fill(NaN, ilength)

    for (count, (var, value)) in enumerate(zip(variables, values))
        mipsolcol[count] = convert(Cint, _info(model, var).column - 1)
        mipsolval[count] = value
    end

    mipsolcol = Cint.(mipsolcol)
    mipsolval = Cfloat.(mipsolval)

    if ilength == MOI.get(model, MOI.NumberOfVariables())
        mipsolcol = C_NULL
    end

    Lib.XPRSaddmipsol(node_model, ilength, mipsolval, mipsolcol, C_NULL)

    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end

MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true

function cache_exception(model::Optimizer, e::Exception)
    model.cb_exception = e

    return nothing
end
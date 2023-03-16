function callback_state(model::Optimizer)
    return model.callback_state
end

function state_callback(state::CallbackState)
    if state === CS_MOI_HEURISTIC
        return MOI.HeuristicCallback()
    elseif state === CS_MOI_LAZY_CONSTRAINT
        return MOI.LazyConstraintCallback()
    elseif state === CS_MOI_USER_CUT
        return MOI.UserCutCallback()
    elseif state === CS_XPRS_MESSAGE
        return MessageCallback()
    elseif state === CS_XPRS_OPTNODE
        return OptNodeCallback()
        # elseif state === CS_XPRS_PREINTSOL
        #     return PreIntSolCallback()
    else
        return nothing
    end
end

function push_callback_state!(model::Optimizer, state)
    # TODO: proper implementation
    model.callback_state = state

    return nothing
end

function pop_callback_state!(model::Optimizer)
    # TODO: proper implementation
    model.callback_state = CS_NONE

    return nothing
end

function cache_callback_exception!(model::Optimizer, e::Union{Exception,Nothing})
    model.callback_exception = e

    return nothing
end

function reset_callback_cached_solution!(model::Optimizer)
    num_variables = length(model.variable_info)
    num_affine = length(model.affine_constraint_info)

    if model.callback_cached_solution === nothing
        model.callback_cached_solution = CachedSolution(
            fill(NaN, num_variables),
            fill(NaN, num_variables),
            fill(NaN, num_affine),
            fill(NaN, num_affine),
            false,
            false,
            false,
            NaN
        )
    else
        resize!(model.callback_cached_solution.variable_primal, num_variables)
        resize!(model.callback_cached_solution.variable_dual, num_variables)
        resize!(model.callback_cached_solution.linear_primal, num_affine)
        resize!(model.callback_cached_solution.linear_dual, num_affine)

        model.callback_cached_solution.has_primal_certificate = false
        model.callback_cached_solution.has_dual_certificate = false
        model.callback_cached_solution.has_feasible_point = false
        model.callback_cached_solution.solve_time = NaN
    end

    return model.callback_cached_solution
end

const _MOI_CALLBACK_KEYS = Set{Symbol}([
    :moi_heuristic,
    :moi_lazy_constraint,
    :moi_user_cut,
])

function _has_callback(model::Optimizer, key::Symbol)
    return !isnothing(get(model.callback_info, key, nothing))
end

function _has_moi_callback(model::Optimizer)
    # Check if any MOI callback is registered
    return any((k) -> _has_callback(model, k), _MOI_CALLBACK_KEYS)
end

function _has_generic_callback(model::Optimizer)
    # Look if any registered callback is actually an MOI one
    return !any(in(_MOI_CALLBACK_KEYS), keys(model.callback_info))
end

function check_moi_callback_validity(model::Optimizer)
    if _has_moi_callback(model)
        if _has_generic_callback(model)
            error("Cannot use Xpress's and MOI's callbacks simultaneously")
        else
            return true
        end
    else
        return false
    end
end

function initialize_callback_interface!(model::Xpress.Optimizer)
    if check_moi_callback_validity(model)
        if Xpress.getcontrol(model.inner, Xpress.Lib.XPRS_HEURSTRATEGY) != 0
            if model.moi_warnings
                @warn "Callbacks in XPRESS might not work correctly with HEURSTRATEGY != 0"
            end
        end
    end
end

function get_callback_solution!(model::Optimizer, node_model::XpressProblem)
    reset_callback_cached_solution!(model)

    Xpress.Lib.XPRSgetlpsol(
        node_model,
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
    size = Cint(length(opt.callback_cut_data.cut_ptrs))
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

function default_moi_user_cut_callback!(model::Optimizer, callback_data::CallbackData)
    model.callback_state = CS_MOI_USER_CUT

    # Apply stored cuts if any
    if !isempty(model.callback_cut_data.cut_ptrs)
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
    model.callback_state = CS_MOI_LAZY_CONSTRAINT

    # Add previous cuts if any to gurantee that the user is dealing with
    # an optimal solution feasibile for exisitng cuts
    if !isempty(model.callback_cut_data.cut_ptrs)
        added = apply_cuts!(model, callback_data.node_model)

        if added
            return nothing
        end
    end

    model.lazy_callback(callback_data)

    return nothing
end

function MOI.get(model::Optimizer, attr::MOI.CallbackNodeStatus{CD}) where {CD<:CallbackData}
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
    ::MOI.CallbackVariablePrimal{CD},
    x::MOI.VariableIndex
) where {CD<:CallbackData}
    return model.callback_cached_solution.variable_primal[_info(model, x).column]
end

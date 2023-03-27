function callback_state(model::Optimizer)
    if isempty(model.callback_state)
        return CS_NONE
    else
        return model.callback_state[end]
    end
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
    elseif state === CS_XPRS_PREINTSOL
        return PreIntSolCallback()
    else
        return nothing
    end
end

function push_callback_state!(model::Optimizer, state::CallbackState)
    push!(model.callback_state, state)

    return nothing
end

function pop_callback_state!(model::Optimizer)
    if isempty(model.callback_state)
        error("Can't pop from empty state stack")
    else
        pop!(model.callback_state)
    end

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

function reset_message_callback!(model::Optimizer)
    if isempty(model.inner.logfile) && !iszero(model.log_level)
        MOI.set(model, MessageCallback(), default_xprs_message_func)
    else
        MOI.set(model, MessageCallback(), nothing)
    end

    return nothing
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
    delta = Ref{Cdouble}(0.0) # Xpress.Lib.XPRS_MINUSINFINITY
    ncuts = Ref{Cint}(0)
    size = Cint(length(opt.callback_cut_data.cut_ptrs))
    mcutptr = Array{Xpress.Lib.XPRScut}(undef, size)
    dviol = Array{Cdouble}(undef, size)

    Xpress.Lib.XPRSgetcpcutlist( # requires an available solution
        model,
        itype,
        interp,
        delta[],
        ncuts,
        size,
        mcutptr,
        dviol,
    )

    Xpress.Lib.XPRSloadcuts(
        model,
        itype,
        interp,
        ncuts[],
        mcutptr
    )

    return (ncuts[] > 0)
end

function MOI.get(model::Optimizer, attr::MOI.CallbackNodeStatus{CD}) where {CD<:CallbackData}
    mip_infeas = Xpress.getintattrib(attr.callback_data.node_model, Xpress.Lib.XPRS_MIPINFEAS)

    if mip_infeas == 0
        return MOI.CALLBACK_NODE_STATUS_INTEGER
    elseif mip_infeas > 0
        return MOI.CALLBACK_NODE_STATUS_FRACTIONAL
    else
        return MOI.CALLBACK_NODE_STATUS_UNKNOWN
    end
end

function MOI.get(
    model::Optimizer,
    ::MOI.CallbackVariablePrimal{CD},
    x::MOI.VariableIndex
) where {CD<:CallbackData}
    return model.callback_cached_solution.variable_primal[_info(model, x).column]
end

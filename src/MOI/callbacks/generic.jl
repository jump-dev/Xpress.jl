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
    info = model.callback_table.xprs_message

    # if !isnothing(message_info)
    #     # remove all message callbacks
    #     remove_message_callback!(model)
    # end

    # #  no file -> screen            && has log
    # if isempty(model.inner.logfile) && !iszero(model.log_level)
    #     model.callback_info[CT_XPRS_MESSAGE] = add_xprs_message_callback!(
    #         model,
    #         model.show_warning,
    #     )
    # else
    #     model.callback_info[CT_XPRS_MESSAGE] = nothing
    # end

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

function default_moi_user_cut_callback!(model::Optimizer, callback_data::CallbackData)
    push_callback_state!(model, CS_MOI_USER_CUT)

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

    pop_callback_state!(model)

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

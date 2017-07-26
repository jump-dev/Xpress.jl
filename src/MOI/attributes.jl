## Solver attributes

# struct SupportsDuals <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsDuals) = false

# struct SupportsAddConstraintAfterSolve <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsAddConstraintAfterSolve) = true

# struct SupportsDeleteConstraint <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsDeleteConstraint) = false

# struct SupportsDeleteVariable <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsDeleteVariable) = false

# struct SupportsAddVariableAfterSolve <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsAddVariableAfterSolve) = true

# struct SupportsConicThroughQuadratic <: AbstractSolverAttribute end
MOI.getattribute(m::XpressSolver, ::MOI.SupportsConicThroughQuadratic) = true

## Solver instance attributes

# struct ObjectiveValue <: AbstractSolverInstanceAttribute
function MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.ObjectiveValue)
    # TODO
    # if solved
    if obj.resultindex == 1
        return true
    end
    return false
end
MOI.getattribute(m::XpressSolverInstance, obj::MOI.ObjectiveValue) = get_objval(m.inner)

# struct ObjectiveBound <: AbstractSolverInstanceAttribute end
function MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.ObjectiveBound)
    # TODO
    # if solved
end
MOI.getattribute(m::XpressSolverInstance, obj::MOI.ObjectiveBound) = get_bestbound(m.inner)

# struct RelativeGap <: AbstractSolverInstanceAttribute  end
function MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.RelativeGap)
    # TODO
    # if solved
end
MOI.getattribute(m::XpressSolverInstance, obj::MOI.RelativeGap) = abs(get_bestbound(m.inner)-get_objval(m.inner))/abs(get_objval)

# struct SolveTime <: AbstractSolverInstanceAttribute end
function MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.SolveTime)
    # TODO
    # if solved
end
MOI.getattribute(m::XpressSolverInstance, obj::MOI.SolveTime) = m.inner.time

# struct Sense <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.Sense) = true
function MOI.getattribute(m::XpressSolverInstance, obj::MOI.Sense)
    # TODO Feasibility
    if model_sense(m.inner) == :maximize
        return MOI.MaxSense
    else
        return MOI.MinSense
    end
end

# struct SimplexIterations <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.SimplexIterations) = true
MOI.getattribute(m::XpressSolverInstance, obj::MOI.SimplexIterations) = get_int_param(m.inner, XPRS_SIMPLEXITER)

# struct BarrierIterations <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.BarrierIterations) = true
MOI.getattribute(m::XpressSolverInstance, obj::MOI.BarrierIterations) = get_int_param(m.inner, XPRS_BARITER)

# struct NodeCount <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.NodeCount) = true
MOI.getattribute(m::XpressSolverInstance, obj::MOI.NodeCount) = get_int_param(m.inner, XPRS_NODES)

# struct RawSolver <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.RawSolver) = true
MOI.getattribute(m::XpressSolverInstance, obj::MOI.RawSolver) = m.inner

# struct ResultCount <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, obj::MOI.ResultCount) = true
function MOI.getattribute(m::XpressSolverInstance, obj::MOI.ResultCount)
    # TODO
    # if solved
    # else
    # return 0
    if is_mip(m.inner)
        return get_int_param(m.inner, XPRS_MIPSOLS)
    else
        return 1
    end
end

# struct NumberOfVariables <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, ::MOI.NumberOfVariables) = true
MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfVariables) = num_vars(m.inner)


# struct NumberOfConstraints{F,S} <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{F, S}) where {F,S} = true
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{F, S}) where {F<:MOI.ScalarAffineFunction{Float64}, S}
    length(constraint_storage(m, F, S))
end
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{MOI.SingleVariable, MOI.LessThan{Float64}})
    c = 0
    for i in m.variable_bound
        if i == Upper || i == LowerAndUpper
            c += 1
        end
    end
    return c 
end
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{MOI.SingleVariable, MOI.GreaterThan{Float64}})
    c = 0
    for i in m.variable_bound
        if i == Lower || i == LowerAndUpper
            c += 1
        end
    end
    return c 
end
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{MOI.SingleVariable, MOI.EqualTo{Float64}})
    c = 0
    for i in m.variable_bound
        if i == Fixed
            c += 1
        end
    end
    return c 
end
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{MOI.SingleVariable, MOI.Interval{Float64}})
    c = 0
    for i in m.variable_bound
        if i == Interval
            c += 1
        end
    end
    return c 
end


# struct ListOfConstraints <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, ::MOI.ListOfConstraints) = true
function MOI.getattribute(m::XpressSolverInstance, ::MOI.ListOfConstraints)
    out = Tuple{DataType,DataType}[]

    if length(constraint_storage(m, MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64})) > 0
        push!(out, (MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64}))
    end
    if length(constraint_storage(m, MOI.ScalarAffineFunction{Float64}, MOI.GreaterThan{Float64})) > 0
        push!(out, (MOI.ScalarAffineFunction{Float64}, MOI.GreaterThan{Float64}))
    end
    if length(constraint_storage(m, MOI.ScalarAffineFunction{Float64}, MOI.EqualTo{Float64})) > 0
        push!(out, (MOI.ScalarAffineFunction{Float64}, MOI.EqualTo{Float64}))
    end

    # TODO variablewise

    return out
end

# """
#     ObjectiveFunction()
# An `AbstractFunction` instance which represents the objective function.
# It is guaranteed to be equivalent but not necessarily identical to the function provided by the user.
# """
# struct ObjectiveFunction <: AbstractSolverInstanceAttribute end


## Termination status
# """
#     TerminationStatus()
# A `TerminationStatusCode` explaining why the solver stopped.
# """
# struct TerminationStatus <: AbstractSolverInstanceAttribute end
MOI.cangetattribute(m::XpressSolverInstance, ::MOI.TerminationStatus) = true
function MOI.getattribute(m::XpressSolverInstance, ::MOI.TerminationStatus)
    if !is_mip(m.inner)
        return terminationcode_lp[get_lp_status(m.inner)]
    else
        return terminationcode_mip[get_mip_status(m.inner)]
    end
end

# see STOPSTATUS
const terminationcode_lp = Dict(
    :unstarted        => MOI.OtherError, # TODO
    :optimal          => MOI.Success,
    :infeasible       => MOI.InfeasibleNoResult, # TODO improve
    :cutoff           => MOI.OtherError, # TODO
    :unfinished       => MOI.OtherError, # TODO
    :unbounded        => MOI.UnboundedNoResult, # TODO improve
    :cutoff_in_dual   => MOI.OtherError, # TODO
    :unsolved         => MOI.OtherError, # TODO
    :nonconvex        => MOI.InvalidSolverInstance # TODO
)
const terminationcode_mip = Dict(
    :mip_not_loaded     => MOI.OtherError, # TODO
    :mip_lp_not_optimal => MOI.OtherError, # TODO improve
    :mip_lp_optimal     => MOI.OtherError, # TODO improve
    :mip_no_sol_found   => MOI.InfeasibleNoResult, # TODO improve
    :mip_suboptimal     => MOI.AlmostSuccess, #TODO
    :mip_infeasible     => MOI.InfeasibleNoResult, # TODO improve
    :mip_optimal        => MOI.Success,
    :mip_unbounded      => MOI.UnboundedNoResult # TODO improve
)



## Result status

# struct PrimalStatus <: AbstractSolverInstanceAttribute
function MOI.cangetattribute(m::XpressSolverInstance, primal::MOI.PrimalStatus)
    if primal.N != 1
        return false
    end
    return true
end
function MOI.getattribute(m::XpressSolverInstance, primal::MOI.PrimalStatus)
    if !is_mip(m.inner)
        return MOI.FeasiblePoint
    else
        return MOI.FeasiblePoint
    end
end

function MOI.cangetattribute(m::XpressSolverInstance, primal::MOI.DualStatus)
    if primal.N != 1
        return false
    end
    return true
end
function MOI.getattribute(m::XpressSolverInstance, primal::MOI.DualStatus)
    if !is_mip(m.inner)
        return MOI.FeasiblePoint
    else
        return MOI.FeasiblePoint
    end
end
## Solver attributes

# struct SupportsDuals <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsDuals) = false

# struct SupportsAddConstraintAfterSolve <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsAddConstraintAfterSolve) = true

# struct SupportsDeleteConstraint <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsDeleteConstraint) = false

# struct SupportsDeleteVariable <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsDeleteVariable) = false

# struct SupportsAddVariableAfterSolve <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsAddVariableAfterSolve) = true

# struct SupportsConicThroughQuadratic <: AbstractSolverAttribute end
getattribute(m::XpressSolver, ::MOI.SupportsConicThroughQuadratic) = true

## Solver instance attributes

# struct ObjectiveValue <: AbstractSolverInstanceAttribute
function cangetattribute(m::XpressSolverInstance, obj::MOI.ObjectiveValue)
    # TODO
    # if solved
    if obj.resultindex == 1
        return true
    end
    return false
end
getattribute(m::XpressSolverInstance, obj::MOI.ObjectiveValue) = get_objval(m.inner)

# struct ObjectiveBound <: AbstractSolverInstanceAttribute end
function cangetattribute(m::XpressSolverInstance, obj::MOI.ObjectiveBound)
    # TODO
    # if solved
end
getattribute(m::XpressSolverInstance, obj::MOI.ObjectiveBound) = get_bestbound(m.inner)

# struct RelativeGap <: AbstractSolverInstanceAttribute  end
function cangetattribute(m::XpressSolverInstance, obj::MOI.RelativeGap)
    # TODO
    # if solved
end
getattribute(m::XpressSolverInstance, obj::MOI.RelativeGap) = abs(get_bestbound(m.inner)-get_objval(m.inner))/abs(get_objval)

# struct SolveTime <: AbstractSolverInstanceAttribute end
function cangetattribute(m::XpressSolverInstance, obj::MOI.SolveTime)
    # TODO
    # if solved
end
getattribute(m::XpressSolverInstance, obj::MOI.SolveTime) = m.inner.time

# struct Sense <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.Sense) = true
function getattribute(m::XpressSolverInstance, obj::MOI.Sense)
    # TODO Feasibility
    if model_sense(m.inner) == :maximize
        return MOI.MaxSense
    else
        return MOI.MinSense
    end
end

# struct SimplexIterations <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.SimplexIterations) = true
getattribute(m::XpressSolverInstance, obj::MOI.SimplexIterations) = get_int_param(m.inner, XPRS_SIMPLEXITER)

# struct BarrierIterations <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.BarrierIterations) = true
getattribute(m::XpressSolverInstance, obj::MOI.BarrierIterations) = get_int_param(m.inner, XPRS_BARITER)

# struct NodeCount <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.NodeCount) = true
getattribute(m::XpressSolverInstance, obj::MOI.NodeCount) = get_int_param(m.inner, XPRS_NODES)

# struct RawSolver <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.RawSolver) = true
getattribute(m::XpressSolverInstance, obj::MOI.RawSolver) = m.inner

# struct ResultCount <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, obj::MOI.ResultCount) = true
function getattribute(m::XpressSolverInstance, obj::MOI.ResultCount)
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
cangetattribute(m::XpressSolverInstance, ::MOI.NumberOfVariables) = true
getattribute(m::XpressSolverInstance, ::MOI.NumberOfVariables) = num_vars(m.inner)


# struct NumberOfConstraints{F,S} <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{F, S}) where {F,S} = true
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{F, S}) where {F<:MOI.ScalarAffineFunction{Float64}, S}
    length(constraint_storage(m, F, S))
end

# struct ListOfConstraints <: AbstractSolverInstanceAttribute end
cangetattribute(m::XpressSolverInstance, ::MOI.ListOfConstraints) = true
function MOI.getattribute(m::XpressSolverInstance, ::MOI.NumberOfConstraints{F, S}) where {F<:MOI.ScalarAffineFunction{Float64}, S}
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
cangetattribute(m::XpressSolverInstance, obj::MOI.TerminationStatus) = true
function getattribute(m::XpressSolverInstance, obj::MOI.TerminationStatus)

    if !is_mip(m.inner)
        return terminationcode_lp[get_lp_status(model)]
    else
        return terminationcode_mip[get_mip_status(model)]
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

# """
#     ResultStatusCode
# An Enum of possible values for the `PrimalStatus` and `DualStatus` attributes.
# The values indicate how to interpret the result vector.
# * `FeasiblePoint`
# * `InfeasiblePoint`
# * `InfeasibilityCertificate`
# * `UnknownResultStatus`
# * `OtherResultStatus`
# """
# @enum ResultStatusCode FeasiblePoint NearlyFeasiblePoint InfeasiblePoint InfeasibilityCertificate NearlyInfeasibilityCertificate ReductionCertificate NearlyReductionCertificate UnknownResultStatus OtherResultStatus

# """
#     PrimalStatus(N)
#     PrimalStatus()
# The `ResultStatusCode` of the primal result `N`.
# If `N` is omitted, it defaults to 1.
# """
# struct PrimalStatus <: AbstractSolverInstanceAttribute
#     N::Int
# end
# PrimalStatus() = PrimalStatus(1)

# """
#     DualStatus(N)
#     DualStatus()
# The `ResultStatusCode` of the dual result `N`.
# If `N` is omitted, it defaults to 1.
# """
# struct DualStatus <: MOI.AbstractSolverInstanceAttribute
#     N::Int
# end
# DualStatus() = DualStatus(1)
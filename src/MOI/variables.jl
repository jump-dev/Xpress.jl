# initial very simple interface

function MOI.VariableReference(m::XpressSolverInstance)
    m.last_variable_reference += 1
    refs = MOI.VariableReference(m.last_variable_reference)
    m.variable_mapping[m.last_variable_reference] = ref
    return ref
end
function MOI.VariableReference(m::XpressSolverInstance, n::Int)
    refs = MOI.VariableReference[]
    sizehint!(refs, n)
    for i in 1:n
        push!(refs, MOI.VariableReference(m))
    end
    return refs
end

# Variables

# TODO: lazy add?
function addvariables!(m::XpressSolverInstance, n::Int) 
    add_cvars!(m.inner, zeros(n))
    return VariableReference(m, n)
end
function addvariable!(m::XpressSolverInstance)
    add_cvar!(m.inner, 0.0)
    return VariableReference(m)
end


## Variable attributes

# """
#     VariablePrimalStart()
# An initial assignment of the variables that the solver may use to warm-start the solve.
# """
# struct VariablePrimalStart <: AbstractVariableAttribute end

"""
    VariablePrimal(N)
    VariablePrimal()
The assignment to the primal variables in result `N`.
If `N` is omitted, it is 1 by default.
"""
struct VariablePrimal <: AbstractVariableAttribute
    N::Int
end
VariablePrimal() = VariablePrimal(1)

# """
#     VariableBasisStatus()
# Returns the `BasisStatusCode` of a given variable, with respect to an available optimal solution basis.
# """
# struct VariableBasisStatus <: AbstractVariableAttribute end

# """
#     BasisStatusCode
# An Enum of possible values for the `VariableBasisStatus` and `ConstraintBasisStatus` attribute.
# This explains the status of a given element with respect to an optimal solution basis.
# Possible values are:
# * `Basic`: element is in the basis
# * `Nonbasic`: element is not in the basis
# * `NonbasicAtLower`: element is not in the basis and is at its lower bound
# * `NonbasicAtUpper`: element is not in the basis and is at its upper bound
# * `SuperBasic`: element is not in the basis but is also not at one of its bounds
# """
# @enum BasisStatusCode Basic Nonbasic NonbasicAtLower NonbasicAtUpper SuperBasic

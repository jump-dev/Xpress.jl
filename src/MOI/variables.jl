# initial very simple interface

# Variables

function addvariables!(m::XpressSolverInstance, n::Int) 
    add_cvars!(m.inner, zeros(n))
    m.last_variable_reference += n
    return VariableReference.(collect((m.last_variable_reference-n+1):m.last_variable_reference))
end

function addvariable!(m::XpressSolverInstance) 
    add_cvar!(m.inner, 0.0)
    m.last_variable_reference += 1
    return VariableReference(m.last_variable_reference)
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

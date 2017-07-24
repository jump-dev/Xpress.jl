# Constraints


# addconstraint!(m::AbstractSolverInstance, func::F, set::S)::ConstraintReference{F,S}
function addconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.EqualsTo{Float64}) 
    rejectnonzeroconstant(func)
    v = refs2inds(m, func.variables)
    add_constr!(m.inner, v, func.coefficients, '=', set.value)
    m.last_constraint_reference += 1
    return MOI.ConstraintReference{MOI.ScalarAffineFunction{Float64}, MOI.EqualsTo{Float64}}(m.last_constraint_reference)
end
function addconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.GreaterThan{Float64}) 
    rejectnonzeroconstant(func)
    v = refs2inds(m, func.variables)
    add_constr!(m.inner, v, func.coefficients, '>', set.value)
    m.last_constraint_reference += 1
    return MOI.ConstraintReference{MOI.ScalarAffineFunction{Float64}, MOI.GreaterThan{Float64}}(m.last_constraint_reference)
end
function addconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.LessThan{Float64}) 
    rejectnonzeroconstant(func)
    v = refs2inds(m, func.variables)
    add_constr!(m.inner, v, func.coefficients, '<', set.value)
    m.last_constraint_reference += 1
    return MOI.ConstraintReference{MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64}}(m.last_constraint_reference)
end

# function modifyconstraint! end

## Constraint attributes

# """
#     ConstraintPrimalStart()
# An initial assignment of the constraint primal values that the solver may use to warm-start the solve.
# """
# struct ConstraintPrimalStart <: AbstractConstraintAttribute end

# """
#     ConstraintDualStart()
# An initial assignment of the constraint duals that the solver may use to warm-start the solve.
# """
# struct ConstraintDualStart <: AbstractConstraintAttribute end

# """
#     ConstraintPrimal(N)
#     ConstraintPrimal()
# The assignment to the constraint primal values in result `N`.
# If `N` is omitted, it is 1 by default.
# """
# struct ConstraintPrimal <: AbstractConstraintAttribute
#     N::Int
# end
# ConstraintPrimal() = ConstraintPrimal(1)

"""
    ConstraintDual(N)
    ConstraintDual()
The assignment to the constraint dual values in result `N`.
If `N` is omitted, it is 1 by default.
"""
struct ConstraintDual <: AbstractConstraintAttribute
    N::Int
end
ConstraintDual() = ConstraintDual(1)

# """
#     ConstraintBasisStatus()
# Returns the `BasisStatusCode` of a given constraint, with respect to an available optimal solution basis.
# """
# struct ConstraintBasisStatus <: AbstractConstraintAttribute end

# """
#     ConstraintFunction()
# Return the `AbstractFunction` object used to define the constraint.
# It is guaranteed to be equivalent but not necessarily identical to the function provided by the user.
# """
# struct ConstraintFunction <: AbstractConstraintAttribute end

# """
#     ConstraintSet()
# Return the `AbstractSet` object used to define the constraint.
# """
# struct ConstraintSet <: AbstractConstraintAttribute end

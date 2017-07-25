# Constraints

function MOI.ConstraintReference(m::XpressSolverInstance, func::F, set::S) where {F<:MOI.ScalarAffineFunction{Float64}, S}
    m.last_constraint_reference += 1
    ref = MOI.ConstraintReference{F, S}(m.last_constraint_reference)
    constraint_storage(m,F,S)[ref] = length(m.constraint_mapping)+1
    return ref
end

function MOI.addconstraint!(m::XpressSolverInstance, func::Linear, set::T) where T
    rejectnonzeroconstant(func)
    addlinearconstraint!(m, func, set)
    return MOI.ConstraintReference(m, func, set)
end
function addlinearconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.EqualsTo{Float64}) 
    add_constr!(m.inner, getcols(func.variables), func.coefficients, '=', set.value)
end
function addlinearconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.GreaterThan{Float64}) 
    add_constr!(m.inner, getcols(func.variables), func.coefficients, '>', set.value)
end
function addlinearconstraint!(m::XpressSolverInstance, func::MOI.ScalarAffineFunction{Float64}, set::MOI.LessThan{Float64}) 
    add_constr!(m.inner, getcols(func.variables), func.coefficients, '<', set.value)
end

# TODO
# getters

# TODO
# function addconstraints! end

# TODO
# function modifyconstraint! end


# Variable bounds

function MOI.ConstraintReference(m::XpressSolverInstance, v::F, set::S) where {F<:MOI.SingleVariable, S}
    # bound ref number is the variable number
    ref = MOI.ConstraintReference{F, S}(v.variable.value)
    savevariablebound!(m, v, set)
    addboundconstraint!(m, v, set)
    return ref
end

function MOI.addconstraint!(m::XpressSolverInstance, v::MOI.SingleVariable, set)
    setvariablebound!(m, v, set)
    m.last_constraint_reference += 1
    ref = MOI.ConstraintReference{MOI.SingleVariable, typeof(set)}(m.last_constraint_reference)
    dict = constraint_storage(m, v, set)
    dict[ref] = v.variable
    ref
end

function savevariablebound!(m::XpressSolverInstance, v::MOI.SingleVariable, ::GreaterThan{Float64})
    var = m.variable_mapping[v.value]
    if m.variable_bound[var] == Upper
        m.variable_bound[var] = LowerAndUpper
    else
        m.variable_bound[var] = Lower
    end
end
function savevariablebound!(m::XpressSolverInstance, v::MOI.SingleVariable, ::LessThan{Float64})
    var = m.variable_mapping[v.value]
    if m.variable_bound[var] == Lower
        m.variable_bound[var] = LowerAndUpper
    else
        m.variable_bound[var] = Upper
    end
end
function savevariablebound!(m::XpressSolverInstance, v::MOI.SingleVariable, ::Interval{Float64})
    m.variable_bound[m.variable_mapping[v.value]] = Interval
end
function savevariablebound!(m::XpressSolverInstance, v::MOI.SingleVariable, ::EqualTo{Float64})
    m.variable_bound[m.variable_mapping[v.value]] = Fixed
end

addboundconstraint!(m::XpressSolverInstance, v::MOI.SingleVariable, set::GreaterThan{Float64}) = set_lb!(m.inner, Int32[getcol(v)], Float64[set.value])
addboundconstraint!(m::XpressSolverInstance, v::MOI.SingleVariable, set::LessThan{Float64}) = set_ub!(m.inner, Int32[getcol(v)], Float64[set.value])
function addboundconstraint!(m::XpressSolverInstance, v::MOI.SingleVariable, set::EqualTo{Float64}) 
    set_lb!(m.inner, Int32[getcol(v)], Float64[set.value])
    set_ub!(m.inner, Int32[getcol(v)], Float64[set.value])
end
function addboundconstraint!(m::XpressSolverInstance, v::MOI.SingleVariable, set::Interval{Float64}) 
    set_lb!(m.inner, Int32[getcol(v)], Float64[set.lower])
    set_ub!(m.inner, Int32[getcol(v)], Float64[set.upper])
end

# struct ConstraintFunction <: AbstractConstraintAttribute end
cangetattribute(m::XpressSolverInstance, ::MOI.ConstraintFunction) = true
function getattribute(m::XpressSolverInstance, ::MOI.ConstraintFunction, c::ConstraintReference{MOI.SingleVariable,S}) where S
    MOI.SingleVariable(MOI.VariableReference(c.value))
end

# struct ConstraintSet <: AbstractConstraintAttribute end
cangetattribute(m::XpressSolverInstance, ::MOI.ConstraintSet) = true
getattribute(m::XpressSolverInstance, ::MOI.ConstraintSet, c::ConstraintReference{MOI.SingleVariable,MOI.GreaterThan{Float64}}) = m.variable_lb[getcol(c)]
getattribute(m::XpressSolverInstance, ::MOI.ConstraintSet, c::ConstraintReference{MOI.SingleVariable,MOI.LessThan{Float64}}) = m.variable_ub[getcol(c)]
getattribute(m::XpressSolverInstance, ::MOI.ConstraintSet, c::ConstraintReference{MOI.SingleVariable,MOI.Interval{Float64}}) = m.variable_ub[getcol(c)]
getattribute(m::XpressSolverInstance, ::MOI.ConstraintSet, c::ConstraintReference{MOI.SingleVariable,MOI.EqualTo{Float64}}) = m.variable_ub[getcol(c)]

# TODO
# function addconstraints! end

# TODO
# function modifyconstraint! end


# TODO
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

# """
#     ConstraintDual(N)
#     ConstraintDual()
# The assignment to the constraint dual values in result `N`.
# If `N` is omitted, it is 1 by default.
# """
# struct ConstraintDual <: AbstractConstraintAttribute
#     N::Int
# end
# ConstraintDual() = ConstraintDual(1)

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

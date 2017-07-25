# helper functions

addsizehint!(v::Vector, n::Integer) = sizehint!(v, length(v)+n)

"""
    Get a vector of column indices given a vector of variable references
"""
function getcol(m::XpressSolverInstance, ref::MOI.VariableReference)
    m.variable_mapping[ref]
end
getcol(m::XpressSolverInstance, v::MOI.SingleVariable) = getcol(m, v.variable)
getcols(m::XpressSolverInstance, ref::Vector{MOI.VariableReference}) = getcol.(m, ref)

function getcol(m::XpressSolverInstance, v::MOI.ConstraintReference{MOI.SingleVariable,S}) where S
    m.variable_mapping[VariableReference(v.value)]
end

function rejectnonzeroconstant(f::MOI.AbstractScalarFunction)
    if abs(func.constant) > eps(Float64)
        return error("nope")
    end
end

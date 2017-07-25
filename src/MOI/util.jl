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


function key_from_value(map::Dict{A,B}, val::B)::A where A where B
    for (key, value) in map
        if value == val
            return key
        end
    end
    # return A(0)
end
# function keys_from_values(map::Dict{REF,B}, vals::Vector{B})::Vector{REF}
#     n = length(vals)
#     out = [REF(0) for i in 1:length()]
#     for (key, value) in map
#         if value == val
#             return key
#         end
#     end
#     return out
# end
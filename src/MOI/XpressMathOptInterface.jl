# XpressMathOptInterface
# Standardized MILP interface


const Linear = MOI.ScalarAffineFunction{Float64}
const LE = MOI.LessThan{Float64}
const GE = MOI.GreaterThan{Float64}
const EQ = MOI.EqualTo{Float64}
const LinConstrRef{T} = MOI.ConstraintReference{Linear, T}
const SVConstrRef{T} = MOI.ConstraintReference{MOI.SingleVariable, T}

const ConvexScalarSet = Union{MOI.LessThan{Float64}, MOI.GreaterThan{Float64}, MOI.EqualTo{Float64}}

export XpressSolver
struct XpressSolver <: MOI.AbstractSolver
    options
end
function XpressSolver(;kwargs...)
    return XpressSolver(kwargs)
end
@enum VariableBound None Lower Upper LowerAndUpper Interval Fixed
@enum VariableType IntVar BinVar ConVar

struct ConstraintMapping
    # LINEAR rows in constraint matrix
    less_than::Dict{LinConstrRef{LE}, Int}
    greater_than::Dict{LinConstrRef{GE}, Int}
    equal_to::Dict{LinConstrRef{EQ}, Int}

    # QUADRATIC
end
function ConstraintMapping()
    ConstraintMapping(Dict{LinConstrRef{LE}, Int}(),
                      Dict{LinConstrRef{GE}, Int}(),
                      Dict{LinConstrRef{EQ}, Int}(),
    )
end
Base.length(map::ConstraintMapping) = length(map.less_than)+length(map.greater_than)+length(map.equal_to)

mutable struct XpressSolverInstance <: MOI.AbstractSolverInstance
    inner::Model

    loaded::Bool

    # Variables

    # variable referencing
    last_variable_reference::UInt64
    # variable mapping
    variable_mapping::Dict{MOI.VariableReference, Int} # TODO UInt64
    variable_bound::Vector{VariableBound}
    variable_type::Vector{VariableType}

    # variable replicate data
    #variable_count::UInt64
    variable_lb::Vector{Float64}
    variable_ub::Vector{Float64}

    variable_solution::Vector{Float64}
    variable_redcost::Vector{Float64}


    # Constraints

    last_constraint_reference::UInt64
    constraint_mapping::ConstraintMapping

    #constraint_count::UInt64
    constraint_rhs::Vector{Float64}

    constraint_slack::Vector{Float64}
    constraint_dual::Vector{Float64}

    # Callbacks

    # lazycb
    # cutcb
    # heuristiccb
    # infocb

    # Options
    options
end
function XpressSolverInstance(s::XpressSolver)
   m = XpressSolverInstance(
       Model(), 
       false,
       0, 
       Dict{MOI.VariableReference, Int}(),
       VariableBound[],
       VariableType[],
       Float64[],
       Float64[],
       Float64[],
       Float64[],
       0, 
       ConstraintMapping(),
       Float64[],
       Float64[],
       Float64[],
       s.options
       )

   for (name,value) in s.options
       setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
   end
   return m
end

# MOI.SolverInstance(s::XpressSolver) = XpressSolverInstance(s.options)
function MOI.SolverInstance(s::XpressSolver) 
    XpressSolverInstance(s)
end

constraint_storage(m::XpressSolverInstance, func::MOI.AbstractScalarFunction, set::MOI.AbstractSet) = constraint_storage(m, typeof(func), typeof(set))

constraint_storage(m::XpressSolverInstance, ::Type{Linear}, ::Type{LE}) = m.constraint_mapping.less_than
constraint_storage(m::XpressSolverInstance, ::Type{Linear}, ::Type{GE}) = m.constraint_mapping.greater_than
constraint_storage(m::XpressSolverInstance, ::Type{Linear}, ::Type{EQ}) = m.constraint_mapping.equal_to

# constraint_storage(m::XpressSolverInstance, ::Type{MOI.SingleVariable}, ::Type{LE}) = m.constraint_mapping.variable_upper_bound
# constraint_storage(m::XpressSolverInstance, ::Type{MOI.SingleVariable}, ::Type{GE}) = m.constraint_mapping.variable_lower_bound
# constraint_storage(m::XpressSolverInstance, ::Type{MOI.SingleVariable}, ::Type{EQ}) = m.constraint_mapping.fixed_variables
# constraint_storage(m::XpressSolverInstance, ::Type{MOI.SingleVariable}, ::Type{MOI.Interval{Float64}}) = m.constraint_mapping.interval_variables


# Supported problems
const SUPPORTED_OBJECTIVES = [
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64}
    ]
const SUPPORTED_CONSTRAINTS = [
    (MOI.ScalarAffineFunction{Float64}, MOI.EqualTo{Float64}),
    (MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64}),
    (MOI.ScalarAffineFunction{Float64}, MOI.GreaterThan{Float64}),

    # (MOI.ScalarQuadraticFunction{Float64}, MOI.EqualsTo{Float64}),
    # (MOI.ScalarQuadraticFunction{Float64}, MOI.LessThan{Float64}),
    # (MOI.ScalarQuadraticFunction{Float64}, MOI.GreaterThan{Float64}),

    (MOI.SingleVariable, MOI.EqualTo{Float64}),
    (MOI.SingleVariable, MOI.LessThan{Float64}),
    (MOI.SingleVariable, MOI.GreaterThan{Float64}),
    (MOI.SingleVariable, MOI.Interval{Float64}),

    (MOI.SingleVariable, MOI.Integer),
    (MOI.SingleVariable, MOI.ZeroOne),
    # (MOI.SingleVariable, MOI.SemiContinous{Float64}),
    # (MOI.SingleVariable, MOI.SemiInteger{Float64}),

    # (MOI.VectorOfVariables, MOI.SOS1{Float64}),
    # (MOI.VectorOfVariables, MOI.SOS2{Float64}),
    ]
function MOI.supportsproblem(s::XpressSolver, objective_type, constraint_types)
    if !(objective_type in SUPPORTED_OBJECTIVES)
        return false
    end
    for c in constraint_types
        if !(c in SUPPORTED_CONSTRAINTS)
            return false
        end
    end
    return true
end


function load!(m::XpressSolverInstance) 
    # Variables

    # a)delete
    # verify vars to remove
    # remove
    # shift reference vector
    # b) add
    # add new variables and plug the refs (use sizehint)
    # delete local variable data
    # c) modify - technically is a constraint
    # Variable bounds and types

    # Constraints by type

    # a) delete
    # b) add
    # build sparse matrix
    # add a block of constraints
    # c) modify
    # Constrs RHS
    # Constrs mods (coeffs)

    # fix quadratics
    # later...

    # Not Lazy
    # objective
    # changes? -not supported
    # other attributes
end
function MOI.optimize!(m::XpressSolverInstance) 
    load!(m)
    optimize(m.inner)

    # unload data
    m.variable_solution = get_solution(m.inner)
    # m.variable_redcost
    # m.constraint_dual = 
    m.constraint_slack = get_slack(m.inner)

    return nothing
end

MOI.free!(m::XpressSolverInstance) = free_model(m.onner)

"""
    writeproblem(m::AbstractSolverInstance, filename::String)
Writes the current problem data to the given file.
Supported file types are solver-dependent.
"""
MOI.writeproblem(m::XpressSolverInstance, filename::Compat.ASCIIString, flags::Compat.ASCIIString="") = write_model(m.inner, filenameg, flags)


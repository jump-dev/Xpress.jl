@static if v"1.2" > VERSION >= v"1.1"
    # see: https://github.com/jump-dev/Xpress.jl/pull/44#issuecomment-585882858
    error("Versions 1.1.x of julia are not supported. The current verions is $(VERSION)")
end

import MathOptInterface
using SparseArrays

const MOI = MathOptInterface
const CleverDicts = MOI.Utilities.CleverDicts

@enum(
    VariableType,
    CONTINUOUS,
    BINARY,
    INTEGER,
    SEMIINTEGER,
    SEMICONTINUOUS,
)

@enum(
    ConstraintType,
    AFFINE,
    INDICATOR,
    QUADRATIC,
    SOC,
    RSOC,
    SOS_SET
)

@enum(
    BoundType,
    NONE,
    LESS_THAN,
    GREATER_THAN,
    LESS_AND_GREATER_THAN,
    INTERVAL,
    EQUAL_TO,
)

@enum(
    ObjectiveType,
    SINGLE_VARIABLE,
    SCALAR_AFFINE,
    SCALAR_QUADRATIC,
)

@enum(
    CallbackState,
    CB_NONE,
    CB_GENERIC,
    CB_LAZY,
    CB_USER_CUT,
    CB_HEURISTIC,
)

const SCALAR_SETS = Union{
    MOI.GreaterThan{Float64},
    MOI.LessThan{Float64},
    MOI.EqualTo{Float64},
    MOI.Interval{Float64},
}

const SIMPLE_SCALAR_SETS = Union{
    MOI.GreaterThan{Float64},
    MOI.LessThan{Float64},
    MOI.EqualTo{Float64},
}

const INDICATOR_SETS = Union{
    MOI.Indicator{MOI.ACTIVATE_ON_ONE,MOI.GreaterThan{Float64}},
    MOI.Indicator{MOI.ACTIVATE_ON_ZERO,MOI.GreaterThan{Float64}},
    MOI.Indicator{MOI.ACTIVATE_ON_ONE,MOI.LessThan{Float64}},
    MOI.Indicator{MOI.ACTIVATE_ON_ZERO,MOI.LessThan{Float64}},
    MOI.Indicator{MOI.ACTIVATE_ON_ONE,MOI.EqualTo{Float64}},
    MOI.Indicator{MOI.ACTIVATE_ON_ZERO,MOI.EqualTo{Float64}},
}

mutable struct VariableInfo
    index::MOI.VariableIndex
    column::Int
    bound::BoundType
    type::VariableType
    start::Union{Float64, Nothing}
    name::String
    # Storage for constraint names associated with variables because Xpress can
    # only store names for variables and proper constraints. We can perform an
    # optimization and only store three strings for the constraint names
    # because, at most, there can be three VariableIndex constraints, e.g.,
    # LessThan, GreaterThan, and Integer.
    lessthan_name::String
    greaterthan_interval_or_equalto_name::String
    type_constraint_name::String
    # Storage for the lower bound if the variable is the `t` variable in a
    # second order cone.
    lower_bound_if_soc::Float64
    num_soc_constraints::Int # this cannot be more than one in xpress
    in_soc::Bool
    previous_lower_bound::Float64
    previous_upper_bound::Float64
    semi_lower_bound::Float64
    function VariableInfo(index::MOI.VariableIndex, column::Int)
        return new(
            index,
            column,
            NONE,
            CONTINUOUS,
            nothing,
            "",
            "",
            "",
            "",
            NaN,
            0,
            false,
            NaN,
            NaN,
            NaN
        )
    end
end

mutable struct ConstraintInfo
    row::Int
    set::MOI.AbstractSet
    # Storage for constraint names. Where possible, these are also stored in the
    # Xpress model.
    # avoid passing names to xpress because it is a slow operation
    # perhaps call lazy on calls for writing lps and so on
    name::String
    type::ConstraintType
    ConstraintInfo(row::Int, set::MOI.AbstractSet, type::ConstraintType) = new(row, set, "", type)
end

mutable struct CachedSolution
    variable_primal::Vector{Float64}
    variable_dual::Vector{Float64}

    linear_primal::Vector{Float64}
    linear_dual::Vector{Float64}

    has_primal_certificate::Bool
    has_dual_certificate::Bool
    has_feasible_point::Bool

    solve_time::Float64
end

mutable struct CallbackCutData
    submitted::Bool
    cutptrs::Vector{Xpress.Lib.XPRScut}
end

mutable struct BasisStatus
    con_status::Vector{Cint}
    var_status::Vector{Cint}
end

mutable struct SensitivityCache 
    input::Vector{Float64}
    output::Vector{Float64}
    is_updated::Bool
end

mutable struct IISData
    stat::Cint
    is_standard_iis::Bool
    rownumber::Int # number of rows participating in the IIS
    colnumber::Int # number of columns participating in the IIS
    miisrow::Vector{Cint} # index of the rows that participate
    miiscol::Vector{Cint} # index of the columns that participate
    constrainttype::Vector{UInt8} # sense of the rows that participate
    colbndtype::Vector{UInt8} # sense of the column bounds that participate
end

mutable struct Optimizer <: MOI.AbstractOptimizer
    # The low-level Xpress model.
    inner::XpressProblem

    # The model name.
    name::String

    # A flag to keep track of MOI.Silent, which over-rides the OUTPUTLOG
    # parameter.
    log_level::Int32
    # option to show warnings in Windows
    show_warning::Bool

    # turn off warning by the MOI interface implementation [advanced usage]
    moi_warnings::Bool

    # false by default - ignores starting points which might be expensive to load.
    ignore_start::Bool

    # false by default - perform the postsolve routine
    post_solve::Bool

    # An enum to remember what objective is currently stored in the model.
    objective_type::ObjectiveType

    # track whether objective function is set and the state of objective sense
    is_objective_set::Bool
    objective_sense::Union{Nothing,MOI.OptimizationSense}

    # A mapping from the MOI.VariableIndex to the Xpress column. VariableInfo
    # also stores some additional fields like what bounds have been added, the
    # variable type, and the names of VariableIndex-in-Set constraints.
    variable_info::CleverDicts.CleverDict{
        MOI.VariableIndex,
        VariableInfo,
        typeof(CleverDicts.key_to_index),
        typeof(CleverDicts.index_to_key),
        }

    # An index that is incremented for each new constraint (regardless of type).
    # We can check if a constraint is valid by checking if it is in the correct
    # xxx_constraint_info. We should _not_ reset this to zero, since then new
    # constraints cannot be distinguished from previously created ones.
    last_constraint_index::Int
    # ScalarAffineFunction{Float64}-in-Set storage.
    # ScalarQuadraticFunction{Float64}-in-Set storage.
    # VectorAffineFunction{Float64}-in-Indicator storage.
    # VectorOfVariables-in-(R)SOC) storage.
    affine_constraint_info::Dict{Int, ConstraintInfo}
    # VectorOfVariables-in-Set storage.
    sos_constraint_info::Dict{Int, ConstraintInfo}
    # Note: we do not have a singlevariable_constraint_info dictionary. Instead,
    # data associated with these constraints are stored in the VariableInfo
    # objects.

    # Mappings from variable and constraint names to their indices. These are
    # lazily built on-demand, so most of the time, they are `nothing`.
    name_to_variable::Union{Nothing, Dict{String, Union{Nothing, MOI.VariableIndex}}}
    name_to_constraint_index::Union{Nothing, Dict{String, Union{Nothing, MOI.ConstraintIndex}}}

    # TODO: add functionality to the lower-level API to support querying single
    # elements of the solution.
    
    cached_solution::Union{Nothing, CachedSolution}
    basis_status::Union{Nothing, BasisStatus}
    conflict::Union{Nothing, IISData}
    termination_status::MOI.TerminationStatusCode
    primal_status::MOI.ResultStatusCode
    dual_status::MOI.ResultStatusCode

    solve_method::String
    solve_relaxation::Bool

    #Stores the input and output of derivatives
    forward_sensitivity_cache::Union{Nothing, SensitivityCache}
    backward_sensitivity_cache::Union{Nothing, SensitivityCache}

    # Callback fields.
    callback_cached_solution::Union{Nothing, CachedSolution}
    cb_cut_data::CallbackCutData
    callback_state::CallbackState
    cb_exception::Union{Nothing, Exception}

    lazy_callback::Union{Nothing, Function}
    user_cut_callback::Union{Nothing, Function}
    heuristic_callback::Union{Nothing, Function}

    has_generic_callback::Bool
    callback_data::Union{Nothing, Tuple{Ptr{Nothing}, _CallbackUserData}}
    message_callback::Union{Nothing, Tuple{Ptr{Nothing}, _CallbackUserData}}

    params::Dict{Any, Any}
    """
        Optimizer()

    Create a new Optimizer object.
    """
    function Optimizer(; kwargs...)
        model = new()

        model.params = Dict{Any,Any}()
        model.log_level = 1 # is xpress default
        model.show_warning = true
        model.moi_warnings = true
        model.ignore_start = false
        model.post_solve = true

        model.solve_method = ""
        model.solve_relaxation = false

        model.message_callback = nothing

        model.termination_status = MOI.OPTIMIZE_NOT_CALLED
        model.primal_status = MOI.NO_SOLUTION
        model.dual_status = MOI.NO_SOLUTION

        for (name, value) in kwargs
            name = MOI.RawOptimizerAttribute(string(name))
            model.params[name] = value
        end

        model.variable_info = CleverDicts.CleverDict{MOI.VariableIndex, VariableInfo}()
        model.affine_constraint_info = Dict{Int, ConstraintInfo}()
        model.sos_constraint_info = Dict{Int, ConstraintInfo}()

        MOI.empty!(model)  # inner is initialized here

        return model
    end
end

Base.show(io::IO, model::Optimizer) = show(io, model.inner)

function MOI.empty!(model::Optimizer)

    model.inner = XpressProblem()

    for (name, value) in model.params
        MOI.set(model, name, value)
    end

    MOI.set(model, MOI.RawOptimizerAttribute("MPSNAMELENGTH"), 64)
    MOI.set(model, MOI.RawOptimizerAttribute("CALLBACKFROMMASTERTHREAD"), 1)

    MOI.set(model, MOI.RawOptimizerAttribute("XPRESS_WARNING_WINDOWS"), model.show_warning)

    # disable log caching previous state
    log_level = model.log_level
    log_level != 0 && MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), 0)
    # silently load a empty model - to avoid useless printing
    Xpress.loadlp(model.inner)
    # re-enable logging
    log_level != 0 && MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), log_level)

    model.name = ""
    model.objective_type = SCALAR_AFFINE
    model.is_objective_set = false
    model.objective_sense = nothing
    empty!(model.variable_info)
    model.last_constraint_index = 0
    empty!(model.affine_constraint_info)
    empty!(model.sos_constraint_info)
    model.name_to_variable = nothing
    model.name_to_constraint_index = nothing

    model.cached_solution = nothing
    model.basis_status = nothing
    model.conflict = nothing

    model.termination_status = MOI.OPTIMIZE_NOT_CALLED
    model.primal_status = MOI.NO_SOLUTION
    model.dual_status = MOI.NO_SOLUTION

    model.callback_cached_solution = nothing
    model.cb_cut_data = CallbackCutData(false, Array{Xpress.Lib.XPRScut}(undef,0))
    model.callback_state = CB_NONE
    model.cb_exception = nothing

    model.forward_sensitivity_cache = nothing
    model.backward_sensitivity_cache = nothing

    model.lazy_callback = nothing
    model.user_cut_callback = nothing
    model.heuristic_callback = nothing

    model.has_generic_callback = false
    model.callback_data = nothing
    # model.message_callback = nothing

    for (name, value) in model.params
        MOI.set(model, name, value)
    end
    return
end

function MOI.is_empty(model::Optimizer)
    !isempty(model.name) && return false
    model.objective_type != SCALAR_AFFINE && return false
    model.is_objective_set == true && return false
    model.objective_sense !== nothing && return false
    !isempty(model.variable_info) && return false
    length(model.affine_constraint_info) != 0 && return false
    length(model.sos_constraint_info) != 0 && return false
    model.name_to_variable !== nothing && return false
    model.name_to_constraint_index !== nothing && return false

    model.cached_solution !== nothing && return false
    model.basis_status !== nothing && return false
    model.conflict !== nothing && return false

    model.termination_status != MOI.OPTIMIZE_NOT_CALLED && return false
    model.primal_status != MOI.NO_SOLUTION && return false
    model.dual_status != MOI.NO_SOLUTION && return false
    
    model.callback_cached_solution !== nothing && return false
    # model.cb_cut_data !== nothing && return false
    model.callback_state != CB_NONE && return false
    model.cb_exception !== nothing && return false

    model.lazy_callback !== nothing && return false
    model.user_cut_callback !== nothing && return false
    model.heuristic_callback !== nothing && return false

    model.has_generic_callback && return false
    model.callback_data !== nothing && return false

    # model.message_callback !== nothing && return false
    # otherwise jump complains it is not empty

    return true
end

function reset_cached_solution(model::Optimizer)
    num_variables = length(model.variable_info)
    num_affine = length(model.affine_constraint_info)
    if model.cached_solution === nothing
        model.cached_solution = CachedSolution(
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
        resize!(model.cached_solution.variable_primal, num_variables)
        resize!(model.cached_solution.variable_dual, num_variables)
        resize!(model.cached_solution.linear_primal, num_affine)
        resize!(model.cached_solution.linear_dual, num_affine)
        model.cached_solution.has_primal_certificate = false
        model.cached_solution.has_dual_certificate = false
        model.cached_solution.has_feasible_point = false
        model.cached_solution.solve_time = NaN
    end
    return model.cached_solution
end

function reset_callback_cached_solution(model::Optimizer)
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


MOI.get(::Optimizer, ::MOI.SolverName) = "Xpress"

# Currently this returns the version of the Xpress package as a whole
# which is different from the Xpress Optimizer version
# the first is a good match because is the version number that appears
# in the dowload package
function MOI.get(optimizer::Optimizer, ::MOI.SolverVersion)
    MOI.get(optimizer, MOI.RawOptimizerAttribute("XPRESSVERSION"))
end

function MOI.supports(
    ::Optimizer,
    ::MOI.ObjectiveFunction{F}
) where {F <: Union{
    MOI.VariableIndex,
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
}}
    return true
end

function MOI.supports_constraint(
    ::Optimizer, ::Type{MOI.VariableIndex}, ::Type{F}
) where {F <: Union{
    MOI.EqualTo{Float64},
    MOI.LessThan{Float64},
    MOI.GreaterThan{Float64},
    MOI.Interval{Float64},
    MOI.ZeroOne,
    MOI.Integer,
    MOI.Semicontinuous{Float64},
    MOI.Semiinteger{Float64},
}}
    return true
end

function MOI.supports_constraint(
    ::Optimizer, ::Type{MOI.VectorOfVariables}, ::Type{F}
) where {F <: Union{
    MOI.SOS1{Float64},
    MOI.SOS2{Float64},
    MOI.SecondOrderCone,
    MOI.RotatedSecondOrderCone,
    }
}
# Xpress only supports disjoint sets of SOC and RSOC (with no affine forms)
# hence we only allow constraints on creation
    return true
end

function MOI.supports_add_constrained_variables(
    ::Optimizer, ::Type{F}
) where {F <: Union{
    MOI.SecondOrderCone,
    MOI.RotatedSecondOrderCone,
    }
}
# Xpress only supports disjoint sets of SOC and RSOC (with no affine forms)
# hence we only allow constraints on creation
    return true
end

# We choose _not_ to support ScalarAffineFunction-in-Interval and
# ScalarQuadraticFunction-in-Interval due to the need for range constraints
# and the added complexity.

function MOI.supports_constraint(
    ::Optimizer, ::Type{MOI.ScalarAffineFunction{Float64}}, ::Type{F}
) where {F <: SIMPLE_SCALAR_SETS}
    return true
end

function MOI.supports_constraint(
    ::Optimizer, ::Type{MOI.ScalarQuadraticFunction{Float64}}, ::Type{F}
) where {F <: Union{
    MOI.LessThan{Float64}, MOI.GreaterThan{Float64}
}}
    # Note: Xpress does not support quadratic equality constraints.
    return true
end

MOI.supports_constraint(::Optimizer,
    ::Type{<:MOI.VectorAffineFunction},
    ::Type{T}) where T <: INDICATOR_SETS = true

MOI.supports(::Optimizer, ::MOI.VariableName, ::Type{MOI.VariableIndex}) = true
MOI.supports(::Optimizer, ::MOI.ConstraintName, ::Type{<:MOI.ConstraintIndex}) = true

MOI.supports(::Optimizer, ::MOI.Name) = true
MOI.supports(::Optimizer, ::MOI.Silent) = true
MOI.supports(::Optimizer, ::MOI.NumberOfThreads) = true
MOI.supports(::Optimizer, ::MOI.TimeLimitSec) = true
MOI.supports(::Optimizer, ::MOI.ObjectiveSense) = true
MOI.supports(::Optimizer, ::MOI.RawOptimizerAttribute) = true

function MOI.set(model::Optimizer, param::MOI.RawOptimizerAttribute, value)
    # Always store value in params dictionary when setting
    # This is because when calling `empty!` we create a new XpressProblem and
    # and want to set all the raw parameters and attributes again.
    model.params[param] = value
    if param == MOI.RawOptimizerAttribute("logfile")
        if value == ""
            # disable log file
            Xpress.setlogfile(model.inner, C_NULL)
        else
            Xpress.setlogfile(model.inner, value)
        end
        model.inner.logfile = value
        reset_message_callback(model)
    elseif param == MOI.RawOptimizerAttribute("MOI_POST_SOLVE")
        model.post_solve = value
    elseif param == MOI.RawOptimizerAttribute("MOI_IGNORE_START")
        model.ignore_start = value
    elseif param == MOI.RawOptimizerAttribute("MOI_WARNINGS")
        model.moi_warnings = value
    elseif param == MOI.RawOptimizerAttribute("MOI_SOLVE_MODE")
        # https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/R/HTML/lpoptimize.html
        model.solve_method = value
    elseif param == MOI.RawOptimizerAttribute("XPRESS_WARNING_WINDOWS")
        model.show_warning = value
        reset_message_callback(model)
    elseif param == MOI.RawOptimizerAttribute("OUTPUTLOG")
        model.log_level = value
        Xpress.setcontrol!(model.inner, "OUTPUTLOG", value)
        reset_message_callback(model)
    else
        Xpress.setcontrol!(model.inner, param.name, value)
    end
    return
end

function reset_message_callback(model)
    if model.message_callback !== nothing
        # remove all message callbacks
        removecbmessage(model.inner, C_NULL, C_NULL)
        model.message_callback = nothing
    end
    if model.inner.logfile == "" &&    # no file -> screen
           model.log_level != 0        # has log
        model.message_callback = setoutputcb!(model.inner, model.show_warning)
    end
end

function MOI.get(model::Optimizer, param::MOI.RawOptimizerAttribute)
    if param == MOI.RawOptimizerAttribute("logfile")
        return model.inner.logfile
    elseif param == MOI.RawOptimizerAttribute("MOI_IGNORE_START")
        return model.ignore_start
    elseif param == MOI.RawOptimizerAttribute("MOI_POST_SOLVE")
        return model.post_solve
    elseif param == MOI.RawOptimizerAttribute("MOI_WARNINGS")
        return model.moi_warnings
    elseif param == MOI.RawOptimizerAttribute("MOI_SOLVE_MODE")
        return model.solve_method
    elseif param == MOI.RawOptimizerAttribute("XPRESS_WARNING_WINDOWS")
        return model.show_warning
    else
        return Xpress.get_control_or_attribute(model.inner, param.name)
    end
end

function MOI.set(model::Optimizer, ::MOI.TimeLimitSec, limit::Real)
    # positive values would mean that its stops after `limit` seconds
    # iff there is already a MIP solution available.
    MOI.set(model, MOI.RawOptimizerAttribute("MAXTIME"), -floor(Int32, limit))
    return
end

function MOI.get(model::Optimizer, ::MOI.TimeLimitSec)
    # MOI.attribute_value_type(MOI.TimeLimitSec()) = Union{Nothing, Float64}
    return convert(Float64, -MOI.get(model, MOI.RawOptimizerAttribute("MAXTIME")))
end

MOI.supports_incremental_interface(::Optimizer) = true

function MOI.copy_to(dest::Optimizer, src::MOI.ModelLike)
    return MOI.Utilities.default_copy_to(dest, src)
end

function MOI.get(model::Optimizer, ::MOI.ListOfVariableAttributesSet)
    ret = MOI.AbstractVariableAttribute[]
    found_name = any(!isempty(info.name) for info in values(model.variable_info))
    found_start = any(info.start !== nothing for info in values(model.variable_info))
    if found_name
        push!(ret, MOI.VariableName())
    end
    if found_start
        push!(ret, MOI.VariablePrimalStart())
    end
    return ret
end

function MOI.get(model::Optimizer, ::MOI.ListOfModelAttributesSet)
    if MOI.is_empty(model)
        return Any[]
    end
    attributes = Any[]
    if model.objective_sense !== nothing
        push!(attributes, MOI.ObjectiveSense())
    end
    typ = MOI.get(model, MOI.ObjectiveFunctionType())
    if typ !== nothing
        push!(attributes, MOI.ObjectiveFunction{typ}())
    end
    if MOI.get(model, MOI.Name()) != ""
        push!(attributes, MOI.Name())
    end
    return attributes
end

function MOI.get(model::Optimizer, ::MOI.ListOfConstraintAttributesSet{F, S}) where {S, F}
    ret = MOI.AbstractConstraintAttribute[]
    constraint_indices = MOI.get(model, MOI.ListOfConstraintIndices{F, S}())
    found_name = any(!isempty(MOI.get(model, MOI.ConstraintName(), index)) for index in constraint_indices)
    if found_name
        push!(ret, MOI.ConstraintName())
    end
    return ret
end

function _indices_and_coefficients(
    indices::AbstractVector{<:Integer},
    coefficients::AbstractVector{Float64},
    model::Optimizer,
    f::MOI.ScalarAffineFunction{Float64}
)
    for (i, term) in enumerate(f.terms)
        indices[i] = _info(model, term.variable).column
        coefficients[i] = term.coefficient
    end
    return indices, coefficients
end

function _indices_and_coefficients(
    model::Optimizer, f::MOI.ScalarAffineFunction{Float64}
)
    f_canon = MOI.Utilities.canonical(f)
    nnz = length(f_canon.terms)
    indices = Vector{Int}(undef, nnz)
    coefficients = Vector{Float64}(undef, nnz)
    _indices_and_coefficients(indices, coefficients, model, f_canon)
    return indices, coefficients
end

function _indices_and_coefficients_indicator(
    model::Optimizer, f::MOI.VectorAffineFunction
)
    nnz = length(f.terms) - 1
    indices = Vector{Int}(undef, nnz)
    coefficients = Vector{Float64}(undef, nnz)
    i = 1
    for fi in f.terms
        if fi.output_index != 1
            indices[i] = _info(model,fi.scalar_term.variable).column
            coefficients[i] = fi.scalar_term.coefficient
            i += 1
        end
    end
    return indices, coefficients
end

function _indices_and_coefficients(
    I::AbstractVector{Int},
    J::AbstractVector{Int},
    V::AbstractVector{Float64},
    indices::AbstractVector{Int},
    coefficients::AbstractVector{Float64},
    model::Optimizer,
    f::MOI.ScalarQuadraticFunction
)
    for (i, term) in enumerate(f.quadratic_terms)
        I[i] = _info(model, term.variable_1).column
        J[i] = _info(model, term.variable_2).column
        V[i] =  term.coefficient

        # MOI    represents objective as 0.5 x' Q x
        # Example: obj = 2x^2 + x*y + y^2
        #              = 2x^2 + (1/2)*x*y + (1/2)*y*x + y^2
        #   |x y| * |a b| * |x| = |ax+by bx+cy| * |x| = 0.5ax^2 + bxy + 0.5cy^2
        #           |b c|   |y|                   |y|
        #   Hence:
        #          0.5*Q = |  2    1/2 |  => Q = | 4  1 |
        #                  | 1/2    1  |         | 1  2 |
        #   Only one triangle (upper and lower are equal) is saved in MOI
        #   Hence:
        #          ScalarQuadraticTerm.([4.0, 1.0, 2.0], [x, x, y], [x, y, y])
        # Xpress ALSO represents objective as 0.5 x' Q x
        #   Again, only one triangle is added.
        #   In other words,
        #      Xpress uses the SAME convention as MOI for OBJECTIVE
        #      Hence, no modifications are needed for OBJECTIVE.
        #   However,
        #     For onstraints, Xpress does NOT have the 0.5 factor in front of the Q matrix
        #     Hence,
        #     Only for constraints, MOI -> Xpress => divide all by 2
        #     Only for constraints, Xpress -> MOI => multiply all by 2

    end
    for (i, term) in enumerate(f.affine_terms)
        indices[i] = _info(model, term.variable).column
        coefficients[i] = term.coefficient
    end
    return
end

function _indices_and_coefficients(
    model::Optimizer, f::MOI.ScalarQuadraticFunction
)
    f_canon = MOI.Utilities.canonical(f)
    nnz_quadratic = length(f_canon.quadratic_terms)
    nnz_affine = length(f_canon.affine_terms)
    I = Vector{Int}(undef, nnz_quadratic)
    J = Vector{Int}(undef, nnz_quadratic)
    V = Vector{Float64}(undef, nnz_quadratic)
    indices = Vector{Int}(undef, nnz_affine)
    coefficients = Vector{Float64}(undef, nnz_affine)
    _indices_and_coefficients(I, J, V, indices, coefficients, model, f_canon)
    return indices, coefficients, I, J, V
end

_sense_and_rhs(s::MOI.LessThan{Float64}) = (Cchar('L'), s.upper)
_sense_and_rhs(s::MOI.GreaterThan{Float64}) = (Cchar('G'), s.lower)
_sense_and_rhs(s::MOI.EqualTo{Float64}) = (Cchar('E'), s.value)

###
### Variables
###

# Short-cuts to return the VariableInfo associated with an index.
function _info(model::Optimizer, key::MOI.VariableIndex)
    if !haskey(model.variable_info, key)
        throw(MOI.InvalidIndex(key))
    end
    return model.variable_info[key]
end

function MOI.add_variable(model::Optimizer)
    # Initialize `VariableInfo` with a dummy `VariableIndex` and a column,
    # because we need `add_item` to tell us what the `VariableIndex` is.
    index = CleverDicts.add_item(
        model.variable_info, VariableInfo(MOI.VariableIndex(0), 0)
    )
    info = _info(model, index)
    info.index = index
    info.column = length(model.variable_info)
    Xpress.addcols(
        model.inner,
        [0.0],#_dobj::Vector{Float64},
        Int[],#_mstart::Vector{Int},
        Int[],#_mrwind::Vector{Int},
        Float64[],#_dmatval::Vector{Float64},
        [-Inf],#_dbdl::Vector{Float64},
        [Inf],#_dbdu::Vector{Float64}
    )
    return index
end

function MOI.add_variables(model::Optimizer, N::Int)
    Xpress.addcols(
        model.inner,
        zeros(N),# _dobj::Vector{Float64},
        Int[],# _mstart::Vector{Int},
        Int[],# _mrwind::Vector{Int},
        Float64[],# _dmatval::Vector{Float64},
        fill(-Inf, N),# _dbdl::Vector{Float64},
        fill(Inf, N),# _dbdu::Vector{Float64}
    )
    indices = Vector{MOI.VariableIndex}(undef, N)
    num_variables = length(model.variable_info)
    for i in 1:N
        # Initialize `VariableInfo` with a dummy `VariableIndex` and a column,
        # because we need `add_item` to tell us what the `VariableIndex` is.
        index = CleverDicts.add_item(
            model.variable_info, VariableInfo(MOI.VariableIndex(0), 0)
        )
        info = _info(model, index)
        info.index = index
        info.column = num_variables + i
        indices[i] = index
    end
    return indices
end

function MOI.is_valid(model::Optimizer, v::MOI.VariableIndex)
    return haskey(model.variable_info, v)
end

function MOI.delete(model::Optimizer, v::MOI.VariableIndex)
    info = _info(model, v)
    if info.num_soc_constraints > 0
        throw(MOI.DeleteNotAllowed(v))
    end
    Xpress.delcols(model.inner, [info.column])
    delete!(model.variable_info, v)
    for other_info in values(model.variable_info)
        if other_info.column > info.column
            other_info.column -= 1
        end
    end
    model.name_to_variable = nothing
    # We throw away name_to_constraint_index so we will rebuild VariableIndex
    # constraint names without v.
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(model::Optimizer, ::Type{MOI.VariableIndex}, name::String)
    if model.name_to_variable === nothing
        _rebuild_name_to_variable(model)
    end
    if haskey(model.name_to_variable, name)
        variable = model.name_to_variable[name]
        if variable === nothing
            error("Duplicate variable name detected: $(name)")
        end
        return variable
    end
    return nothing
end

function _rebuild_name_to_variable(model::Optimizer)
    model.name_to_variable = Dict{String, Union{Nothing, MOI.VariableIndex}}()
    for (index, info) in model.variable_info
        if info.name == ""
            continue
        end
        if haskey(model.name_to_variable, info.name)
            model.name_to_variable[info.name] = nothing
        else
            model.name_to_variable[info.name] = index
        end
    end
    return
end

function MOI.get(model::Optimizer, ::MOI.VariableName, v::MOI.VariableIndex)
    return _info(model, v).name
end

function MOI.set(
    model::Optimizer, ::MOI.VariableName, v::MOI.VariableIndex, name::String
)
    info = _info(model, v)
    info.name = name
    # Note: don't set the string names in the Xpress C API because it complains
    # on duplicate variables.
    # That is, don't call `Xpress.addnames`.
    model.name_to_variable = nothing
    return
end

###
### Sensitivities
###

struct ForwardSensitivityInputConstraint <: MOI.AbstractConstraintAttribute end

struct ForwardSensitivityOutputVariable <: MOI.AbstractVariableAttribute end

struct BackwardSensitivityInputVariable <: MOI.AbstractVariableAttribute end

struct BackwardSensitivityOutputConstraint <: MOI.AbstractConstraintAttribute end

MOI.is_set_by_optimize(::ForwardSensitivityOutputVariable) = true

MOI.is_set_by_optimize(::BackwardSensitivityOutputConstraint) = true

function forward(model::Optimizer)
    rows = Xpress.getintattrib(model.inner, Lib.XPRS_ROWS)
    spare_rows = Xpress.getintattrib(model.inner, Lib.XPRS_SPAREROWS)
    cols = Xpress.getintattrib(model.inner, Lib.XPRS_COLS)

    #1 - Create vector 'aux_vector' of size ROWS of type Float64 (constraints)
    aux_vector = copy(model.forward_sensitivity_cache.input)

    #2 - Call XPRSftran with vector 'aux_vector' as an argument
    Xpress.ftran(model.inner, aux_vector)

    #3 - Create Dict of Basic variable to All variables
    basic_variables_ordered = Vector{Int32}(undef, rows)
    Xpress.getpivotorder(model.inner, basic_variables_ordered)

    aux_dict = Dict{Int, Int}()
    for i in 1:length(basic_variables_ordered)
        if rows+spare_rows <= basic_variables_ordered[i] <= rows+spare_rows + cols - 1
            aux_dict[i] = basic_variables_ordered[i] - (rows+spare_rows) + 1
        end
    end

    #5 - Populate vector of All variables with the correct value of the Basic variables
    fill!(model.forward_sensitivity_cache.output, 0.0)
    for (bi, vi) in aux_dict
        model.forward_sensitivity_cache.output[vi] = aux_vector[bi]
    end

    return
end

function backward(model::Optimizer)
    rows = Xpress.getintattrib(model.inner, Lib.XPRS_ROWS)
    spare_rows = Xpress.getintattrib(model.inner, Lib.XPRS_SPAREROWS)
    cols = Xpress.getintattrib(model.inner, Lib.XPRS_COLS)

    #1 - Get Basic variables
    basic_variables_ordered = Vector{Int32}(undef, rows)
    Xpress.getpivotorder(model.inner, basic_variables_ordered)

    aux_dict = Dict{Int,Int}()
    for i in 1:length(basic_variables_ordered)
        if rows + spare_rows <= basic_variables_ordered[i] <= rows + spare_rows + cols - 1
            aux_dict[i] = basic_variables_ordered[i] - (rows+spare_rows) + 1
        end
    end

    #2 - Create vector 'aux_vector' of size ROWS of type Float64 (constraints) initialized at zero
    aux_vector = zeros(rows)

    #3 - Populate vector 'aux_vector' with the respective values in the correct positions of the basic variables
    for (bi, vi) in aux_dict
        aux_vector[bi] = model.backward_sensitivity_cache.input[vi]
    end

    #4 - Call XPRSbtran with vector 'aux_vector' as an argument
    Xpress.btran(model.inner, aux_vector)

    #5 - Set constraint_output equal to vector 'aux_vector'
    model.backward_sensitivity_cache.output .= aux_vector
    return
end

function MOI.set(
    model::Optimizer, ::ForwardSensitivityInputConstraint, ci::MOI.ConstraintIndex, value::Float64
)
    rows = Xpress.getintattrib(model.inner, Lib.XPRS_ROWS)
    cols = Xpress.getintattrib(model.inner, Lib.XPRS_COLS)
    if model.forward_sensitivity_cache === nothing
        model.forward_sensitivity_cache = 
            SensitivityCache(
                zeros(rows),
                zeros(cols),
                false
            )
    elseif length(model.forward_sensitivity_cache.input) != rows
        model.forward_sensitivity_cache.input = zeros(rows)
    end
    model.forward_sensitivity_cache.input[_info(model, ci).row] = value
    model.forward_sensitivity_cache.is_updated = false
    return
end

function MOI.get(model::Optimizer, ::ForwardSensitivityOutputVariable, vi::MOI.VariableIndex)
    if is_mip(model) && model.moi_warnings
        @warn "The problem is a MIP, it might fail to get correct sensitivities."
    end
    if MOI.get(model, MOI.TerminationStatus()) != MOI.OPTIMAL 
        error("Model not optimized. Cannot get sensitivities.")
    end
    if model.forward_sensitivity_cache === nothing 
        error("Forward sensitivity cache not initiliazed correctly.")
    end
    if model.forward_sensitivity_cache.is_updated != true
        forward(model)
        model.forward_sensitivity_cache.is_updated = true
    end
    return model.forward_sensitivity_cache.output[_info(model, vi).column]
end

function MOI.set(
    model::Optimizer, ::BackwardSensitivityInputVariable, vi::MOI.VariableIndex, value::Float64
)
    rows = Xpress.getintattrib(model.inner, Lib.XPRS_ROWS)
    cols = Xpress.getintattrib(model.inner, Lib.XPRS_COLS)
    if model.backward_sensitivity_cache === nothing
        model.backward_sensitivity_cache = 
            SensitivityCache(
                zeros(cols),
                zeros(rows),
                false
            )
    elseif length(model.backward_sensitivity_cache.input) != cols
        model.backward_sensitivity_cache.input = zeros(cols)
    end
    model.backward_sensitivity_cache.input[_info(model, vi).column] = value
    model.backward_sensitivity_cache.is_updated = false
    return
end

function MOI.get(model::Optimizer, ::BackwardSensitivityOutputConstraint, ci::MOI.ConstraintIndex)
    if is_mip(model) && model.moi_warnings
        @warn "The problem is a MIP, it might fail to get correct sensitivities."
    end
    if MOI.get(model, MOI.TerminationStatus()) != MOI.OPTIMAL 
        error("Model not optimized. Cannot get sensitivities.")
    end
    if model.backward_sensitivity_cache === nothing 
        error("Backward sensitivity cache not initiliazed correctly.")
    end
    if model.backward_sensitivity_cache.is_updated != true
        backward(model)
        model.backward_sensitivity_cache.is_updated = true
    end
    return model.backward_sensitivity_cache.output[_info(model, ci).row]
end

###
### Objectives
###

function _zero_objective(model::Optimizer)
    num_vars = length(model.variable_info)
    obj = zeros(Float64, num_vars)
    if model.objective_type == SCALAR_QUADRATIC
        # We need to zero out the existing quadratic objective.
        Xpress.delqmatrix(model.inner, 0)
    end
    Xpress.chgobj(model.inner, collect(1:num_vars), obj)
    Lib.XPRSchgobj(prob, Cint(1), Ref(Cint(-1)), Ref(0.0))
    return
end

function MOI.set(
    model::Optimizer, ::MOI.ObjectiveSense, sense::MOI.OptimizationSense
)
    # TODO: should this propagate across a `MOI.empty!(optimizer)` call
    if sense == MOI.MIN_SENSE
        Xpress.chgobjsense(model.inner, :Min)
    elseif sense == MOI.MAX_SENSE
        Xpress.chgobjsense(model.inner, :Max)
    else
        @assert sense == MOI.FEASIBILITY_SENSE
        _zero_objective(model)
        Xpress.chgobjsense(model.inner, :Min)
    end
    model.objective_sense = sense
    return
end

function MOI.get(model::Optimizer, ::MOI.ObjectiveSense)
    if model.objective_sense !== nothing
        return model.objective_sense
    else
        return MOI.FEASIBILITY_SENSE
    end
end

function MOI.set(
    model::Optimizer, ::MOI.ObjectiveFunction{F}, f::F
) where {F <: MOI.VariableIndex}
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        convert(MOI.ScalarAffineFunction{Float64}, f)
    )
    model.objective_type = SINGLE_VARIABLE
    model.is_objective_set = true
    return
end

function MOI.get(model::Optimizer, ::MOI.ObjectiveFunction{MOI.VariableIndex})
    obj = MOI.get(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}()
    )
    return convert(MOI.VariableIndex, obj)
end

function MOI.set(
    model::Optimizer, ::MOI.ObjectiveFunction{F}, f::F
) where {F <: MOI.ScalarAffineFunction{Float64}}
    if model.objective_type == SCALAR_QUADRATIC
        # We need to zero out the existing quadratic objective.
        Xpress.delqmatrix(model.inner, 0)
    end
    num_vars = length(model.variable_info)
    # We zero all terms because we want to gurantee that the old terms
    # are removed
    obj = zeros(Float64, num_vars)
    for term in f.terms
        column = _info(model, term.variable).column
        obj[column] += term.coefficient
    end
    Xpress.chgobj(model.inner, collect(1:num_vars), obj)
    Lib.XPRSchgobj(model.inner, Cint(0), Ref(Cint(-1)), Ref(-f.constant))
    model.objective_type = SCALAR_AFFINE
    model.is_objective_set = true
    return
end

function MOI.get(
    model::Optimizer, ::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}
)
    dest = Xpress.getobj(model.inner)
    terms = MOI.ScalarAffineTerm{Float64}[]
    for (index, info) in model.variable_info
        coefficient = dest[info.column]
        iszero(coefficient) && continue
        push!(terms, MOI.ScalarAffineTerm(coefficient, index))
    end
    constant = Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_OBJRHS)
    return MOI.ScalarAffineFunction(terms, constant)
end

function MOI.set(
    model::Optimizer, ::MOI.ObjectiveFunction{F}, f::F
) where {F <: MOI.ScalarQuadraticFunction{Float64}}
    # setting linear part also clears the existing quadratic terms
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(f.affine_terms, f.constant)
    )
    affine_indices, affine_coefficients, I, J, V = _indices_and_coefficients(
        model, f
    )
    obj = zeros(length(model.variable_info))
    for (i, c) in zip(affine_indices, affine_coefficients)
        obj[i] = c
    end
    Xpress.chgmqobj(model.inner, I, J, V)
    model.objective_type = SCALAR_QUADRATIC
    model.is_objective_set = true
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarQuadraticFunction{Float64}}
)
    dest = zeros(length(model.variable_info))
    nnz = n_quadratic_elements(model.inner)
    n = n_variables(model.inner)
    nels = Array{Cint}(undef, 1)
    nels[1] = nnz
    mstart = Array{Cint}(undef, n + 1)
    mclind = Array{Cint}(undef, nnz)
    dobjval = Array{Float64}(undef, nnz)
    getmqobj(model.inner, mstart, mclind, dobjval, nnz, nels, 0, n - 1)
    triangle_nnz = nels[1]
    mstart[end] = triangle_nnz
    I = Array{Int}(undef, triangle_nnz)
    J = Array{Int}(undef, triangle_nnz)
    V = Array{Float64}(undef, triangle_nnz)
    for i in 1:length(mstart)-1
        for j in (mstart[i]+1):mstart[i+1]
            I[j] = i
            J[j] = mclind[j]+1
            V[j] = dobjval[j]
        end
    end
    q_terms = MOI.ScalarQuadraticTerm{Float64}[]
    row = 0
    for (i, j, coeff) in zip(I, J, V)
        iszero(coeff) && continue
        push!(
            q_terms,
            MOI.ScalarQuadraticTerm(
                coeff,
                model.variable_info[CleverDicts.LinearIndex(i)].index,
                model.variable_info[CleverDicts.LinearIndex(j)].index
            )
        )
    end
    affine_terms = MOI.get(model, MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}()).terms
    constant = Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_OBJRHS)
    return MOI.ScalarQuadraticFunction(q_terms, affine_terms, constant)
end

function MOI.modify(
    model::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chg::MOI.ScalarConstantChange{Float64}
)
    Lib.XPRSchgobj(model.inner, Cint(0), Ref(Cint(-1)), Ref(-chg.new_constant))
    return
end

##
##  VariableIndex-in-Set constraints.
##

function _info(
    model::Optimizer, c::MOI.ConstraintIndex{MOI.VariableIndex, <:Any}
)
    var_index = MOI.VariableIndex(c.value)
    if haskey(model.variable_info, var_index)
        return _info(model, var_index)
    end
    return throw(MOI.InvalidIndex(c))
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.LessThan{Float64}}
)
    if haskey(model.variable_info, MOI.VariableIndex(c.value))
        info = _info(model, c)
        return info.bound == LESS_THAN || info.bound == LESS_AND_GREATER_THAN
    end
    return false
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.GreaterThan{Float64}}
)
    if haskey(model.variable_info, MOI.VariableIndex(c.value))
        info = _info(model, c)
        return info.bound == GREATER_THAN || info.bound == LESS_AND_GREATER_THAN
    end
    return false
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Interval{Float64}}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).bound == INTERVAL
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.EqualTo{Float64}}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).bound == EQUAL_TO
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.ZeroOne}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).type == BINARY
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Integer}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).type == INTEGER
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semicontinuous{Float64}}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).type == SEMICONTINUOUS
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semiinteger{Float64}}
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
        _info(model, c).type == SEMIINTEGER
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VariableIndex, <:Any}
)
    MOI.throw_if_not_valid(model, c)
    return MOI.VariableIndex(c.value)
end

function MOI.set(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VariableIndex, <:Any}, ::MOI.VariableIndex
)
    return throw(MOI.SettingVariableIndexNotAllowed())
end

_bounds(s::MOI.GreaterThan{Float64}) = (s.lower, nothing)
_bounds(s::MOI.LessThan{Float64}) = (nothing, s.upper)
_bounds(s::MOI.EqualTo{Float64}) = (s.value, s.value)
_bounds(s::MOI.Interval{Float64}) = (s.lower, s.upper)

function _throw_if_existing_lower(
    bound::BoundType, var_type::VariableType,
    new_set::Type{<:MOI.AbstractSet},
    variable::MOI.VariableIndex
)
    existing_set = if bound == LESS_AND_GREATER_THAN || bound == GREATER_THAN
        MOI.GreaterThan{Float64}
    elseif bound == INTERVAL
        MOI.Interval{Float64}
    elseif bound == EQUAL_TO
        MOI.EqualTo{Float64}
    elseif var_type == SEMIINTEGER
        MOI.Semiinteger{Float64}
    elseif var_type == SEMICONTINUOUS
        MOI.Semicontinuous{Float64}
    else
        nothing  # Also covers `NONE` and `LESS_THAN`.
    end
    if existing_set !== nothing
        throw(MOI.LowerBoundAlreadySet{existing_set, new_set}(variable))
    end
end

function _throw_if_existing_upper(
    bound::BoundType,
    var_type::VariableType,
    new_set::Type{<:MOI.AbstractSet},
    variable::MOI.VariableIndex
)
    existing_set = if bound == LESS_AND_GREATER_THAN || bound == LESS_THAN
        MOI.LessThan{Float64}
    elseif bound == INTERVAL
        MOI.Interval{Float64}
    elseif bound == EQUAL_TO
        MOI.EqualTo{Float64}
    elseif var_type == SEMIINTEGER
        MOI.Semiinteger{Float64}
    elseif var_type == SEMICONTINUOUS
        MOI.Semicontinuous{Float64}
    else
        nothing  # Also covers `NONE` and `GREATER_THAN`.
    end
    if existing_set !== nothing
        throw(MOI.UpperBoundAlreadySet{existing_set, new_set}(variable))
    end
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VariableIndex, s::S
) where {S <: SCALAR_SETS}
    info = _info(model, f)
    if info.type == BINARY
        lower, upper = _bounds(s)
        if lower !== nothing
            if lower > 1
                error("The problem is infeasible")
            end
        end
        if upper !== nothing
            if upper < 0
                error("The problem is infeasible")
            end
        end
        if lower !== nothing && upper !== nothing
            if (lower > 0 && upper < 1)
                error("The problem is infeasible")
            end
        end
    end
    if S <: MOI.LessThan{Float64}
        _throw_if_existing_upper(info.bound, info.type, S, f)
        info.bound = info.bound == GREATER_THAN ? LESS_AND_GREATER_THAN : LESS_THAN
    elseif S <: MOI.GreaterThan{Float64}
        _throw_if_existing_lower(info.bound, info.type, S, f)
        info.bound = info.bound == LESS_THAN ? LESS_AND_GREATER_THAN : GREATER_THAN
    elseif S <: MOI.EqualTo{Float64}
        _throw_if_existing_lower(info.bound, info.type, S, f)
        _throw_if_existing_upper(info.bound, info.type, S, f)
        info.bound = EQUAL_TO
    else
        @assert S <: MOI.Interval{Float64}
        _throw_if_existing_lower(info.bound, info.type, S, f)
        _throw_if_existing_upper(info.bound, info.type, S, f)
        info.bound = INTERVAL
    end
    index = MOI.ConstraintIndex{MOI.VariableIndex, typeof(s)}(f.value)
    MOI.set(model, MOI.ConstraintSet(), index, s)
    return index
end

function MOI.add_constraints(
    model::Optimizer, f::Vector{MOI.VariableIndex}, s::Vector{S}
) where {S <: SCALAR_SETS}
    for fi in f
        info = _info(model, fi)
        if S <: MOI.LessThan{Float64}
            _throw_if_existing_upper(info.bound, info.type, S, fi)
            info.bound = info.bound == GREATER_THAN ? LESS_AND_GREATER_THAN : LESS_THAN
        elseif S <: MOI.GreaterThan{Float64}
            _throw_if_existing_lower(info.bound, info.type, S, fi)
            info.bound = info.bound == LESS_THAN ? LESS_AND_GREATER_THAN : GREATER_THAN
        elseif S <: MOI.EqualTo{Float64}
            _throw_if_existing_lower(info.bound, info.type, S, fi)
            _throw_if_existing_upper(info.bound, info.type, S, fi)
            info.bound = EQUAL_TO
        else
            @assert S <: MOI.Interval{Float64}
            _throw_if_existing_lower(info.bound, info.type, S, fi)
            _throw_if_existing_upper(info.bound, info.type, S, fi)
            info.bound = INTERVAL
        end
    end
    indices = [
        MOI.ConstraintIndex{MOI.VariableIndex, eltype(s)}(fi.value)
        for fi in f
    ]
    for (index, s) in zip(indices, s)
        MOI.set(model, MOI.ConstraintSet(), index, s)
    end
    return indices
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.LessThan{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_upper_bound(model, info, Inf)
    if info.bound == LESS_AND_GREATER_THAN
        info.bound = GREATER_THAN
    else
        info.bound = NONE
    end
    info.lessthan_name = ""
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        info.previous_lower_bound = _get_variable_lower_bound(model, info)
        info.previous_upper_bound = _get_variable_upper_bound(model, info)
        Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('B')))
    end
    return
end

"""
    _set_variable_lower_bound(model, info, value)

This function is used to indirectly set the lower bound of a variable.

We need to do it this way to account for potential lower bounds of 0.0 added by
VectorOfVariables-in-SecondOrderCone constraints.

See also `_get_variable_lower_bound`.
"""
function _set_variable_lower_bound(model, info, value)
    if info.num_soc_constraints == 0
        # No SOC constraints, set directly.
        @assert isnan(info.lower_bound_if_soc)
        Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('L')), Ref(value))
    elseif value >= 0.0
        # Regardless of whether there are SOC constraints, this is a valid bound
        # for the SOC constraint and should over-ride any previous bounds.
        info.lower_bound_if_soc = NaN
        Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('L')), Ref(value))
    elseif isnan(info.lower_bound_if_soc)
        # Previously, we had a non-negative lower bound (i.e., it was set in the
        # case above). Now we're setting this with a negative one, but there are
        # still some SOC constraints, so we cache `value` and set the variable
        # lower bound to `0.0`.
        @assert value < 0.0
        Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('L')), Ref(0.0))
        info.lower_bound_if_soc = value
    else
        # Previously, we had a negative lower bound. We're setting this with
        # another negative one, but there are still some SOC constraints.
        @assert info.lower_bound_if_soc < 0.0
        info.lower_bound_if_soc = value
    end
end

"""
    _get_variable_lower_bound(model, info)

Get the current variable lower bound, ignoring a potential bound of `0.0` set
by a second order cone constraint.

See also `_set_variable_lower_bound`.
"""
function _get_variable_lower_bound(model, info)
    if !isnan(info.lower_bound_if_soc)
        # There is a value stored. That means that we must have set a value that
        # was < 0.
        @assert info.lower_bound_if_soc < 0.0
        return info.lower_bound_if_soc
    end
    lb = Ref(0.0)
    Lib.XPRSgetlb(model.inner, lb, Cint(info.column-1), Cint(info.column-1))
    return lb[] == Xpress.Lib.XPRS_MINUSINFINITY ? -Inf : lb[]
end

"""
    _set_variable_semi_lower_bound(model, info, value)

This function set the semi lower bound of a semi-continuous or semi-integer variable.
The lower bound of the variable will still be zero, it only changes the lower bound
of the continuous or the integer part of the variable.

We need this function because Xpress has differents functions to change semi-continuous
or semi-integer lower bound and to change the lower bound.
"""

function _set_variable_semi_lower_bound(model, info, value)
    info.semi_lower_bound = value
    _set_variable_lower_bound(model, info, 0.0)
    Lib.XPRSchgglblimit(model.inner, Cint(1), Ref(Cint(info.column-1)), 
        Ref(Float64[value]))
end

function _get_variable_semi_lower_bound(model, info)
    return info.semi_lower_bound
end

function _set_variable_upper_bound(model, info, value)
    Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('U')), Ref(value))
    return
end

function _get_variable_upper_bound(model, info)
    ub = Ref(0.0)
    Lib.XPRSgetub(model.inner, ub, Cint(info.column-1), Cint(info.column-1))
    return ub[] == Xpress.Lib.XPRS_PLUSINFINITY ? Inf : ub[]
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.GreaterThan{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    if info.bound == LESS_AND_GREATER_THAN
        info.bound = LESS_THAN
    else
        info.bound = NONE
    end
    info.greaterthan_interval_or_equalto_name = ""
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        info.previous_lower_bound = _get_variable_lower_bound(model, info)
        info.previous_upper_bound = _get_variable_upper_bound(model, info)
        Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('B')))
    end
    return
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Interval{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.bound = NONE
    info.greaterthan_interval_or_equalto_name = ""
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        info.previous_lower_bound = _get_variable_lower_bound(model, info)
        info.previous_upper_bound = _get_variable_upper_bound(model, info)
        Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('B')))
    end
    return
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.EqualTo{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.bound = NONE
    info.greaterthan_interval_or_equalto_name = ""
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        info.previous_lower_bound = _get_variable_lower_bound(model, info)
        info.previous_upper_bound = _get_variable_upper_bound(model, info)
        Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('B')))
    end
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.GreaterThan{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    lower = _get_variable_lower_bound(model, _info(model, c))
    return MOI.GreaterThan(lower)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.LessThan{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    upper = _get_variable_upper_bound(model, _info(model, c))
    return MOI.LessThan(upper)
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.EqualTo{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    lower = _get_variable_lower_bound(model, _info(model, c))
    return MOI.EqualTo(lower)
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Interval{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    lower = _get_variable_lower_bound(model, info)
    upper = _get_variable_upper_bound(model, info)
    return MOI.Interval(lower, upper)
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, S}, s::S
) where {S<:SCALAR_SETS}
    MOI.throw_if_not_valid(model, c)
    lower, upper = _bounds(s)
    info = _info(model, c)
    if lower !== nothing
        _set_variable_lower_bound(model, info, lower)
    end
    if upper !== nothing
        _set_variable_upper_bound(model, info, upper)
    end
    info.previous_lower_bound = _get_variable_lower_bound(model, info)
    info.previous_upper_bound = _get_variable_upper_bound(model, info)
    return
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VariableIndex, ::MOI.ZeroOne
)
    info = _info(model, f)
    info.previous_lower_bound = _get_variable_lower_bound(model, info)
    info.previous_upper_bound = _get_variable_upper_bound(model, info)
    lower, upper = info.previous_lower_bound, info.previous_upper_bound
    if info.type == CONTINUOUS
        if lower !== nothing
            if lower > 1
                error("The problem is infeasible")
            end
        end
        if upper !== nothing
            if upper < 0
                error("The problem is infeasible")
            end
        end
        if lower !== nothing && upper !== nothing
            if (lower > 0 && upper < 1)
                error("The problem is infeasible")
            end
        end
    end
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('B')))
    if info.type == CONTINUOUS
        # The function chgcoltype reset the variable bounds to [0, 1],
        # so we need to add them again if they're set before.
        if lower !== nothing
            if lower >= 0
                _set_variable_lower_bound(model, info, info.previous_lower_bound)
            end
        end
        if upper !== nothing
            if upper <= 1
                _set_variable_upper_bound(model, info, info.previous_upper_bound)
            end
        end
    end
    info.type = BINARY
    return MOI.ConstraintIndex{MOI.VariableIndex, MOI.ZeroOne}(f.value)
end

function MOI.delete(
    model::Optimizer, c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.ZeroOne}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('C')))
    _set_variable_lower_bound(model, info, info.previous_lower_bound)
    _set_variable_upper_bound(model, info, info.previous_upper_bound)
    info.type = CONTINUOUS
    info.type_constraint_name = ""
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.ZeroOne}
)
    MOI.throw_if_not_valid(model, c)
    return MOI.ZeroOne()
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VariableIndex, ::MOI.Integer
)
    info = _info(model, f)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('I')))
    info.type = INTEGER
    return MOI.ConstraintIndex{MOI.VariableIndex, MOI.Integer}(f.value)
end

function MOI.delete(
    model::Optimizer, c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Integer}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('C')))
    info.type = CONTINUOUS
    info.type_constraint_name = ""
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Integer}
)
    MOI.throw_if_not_valid(model, c)
    return MOI.Integer()
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VariableIndex, s::MOI.Semicontinuous{Float64}
)
    info = _info(model, f)
    _throw_if_existing_lower(info.bound, info.type, typeof(s), f)
    _throw_if_existing_upper(info.bound, info.type, typeof(s), f)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('S')))
    _set_variable_semi_lower_bound(model, info, s.lower)
    _set_variable_upper_bound(model, info, s.upper)
    info.type = SEMICONTINUOUS
    return MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semicontinuous{Float64}}(f.value)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semicontinuous{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('C')))
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.semi_lower_bound = NaN
    info.type = CONTINUOUS
    info.type_constraint_name = ""
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semicontinuous{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    lower = _get_variable_semi_lower_bound(model, info)
    upper = _get_variable_upper_bound(model, info)
    return MOI.Semicontinuous(lower, upper)
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VariableIndex, s::MOI.Semiinteger{Float64}
)
    info = _info(model, f)
    _throw_if_existing_lower(info.bound, info.type, typeof(s), f)
    _throw_if_existing_upper(info.bound, info.type, typeof(s), f)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('R')))
    _set_variable_semi_lower_bound(model, info, s.lower)
    _set_variable_upper_bound(model, info, s.upper)
    info.type = SEMIINTEGER
    return MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semiinteger{Float64}}(f.value)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semiinteger{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    Lib.XPRSchgcoltype(model.inner, Cint(1), Ref(Cint(info.column-1)), Ref(UInt8('C')))
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.semi_lower_bound = NaN
    info.type = CONTINUOUS
    info.type_constraint_name = ""
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Semiinteger{Float64}}
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    lower = _get_variable_semi_lower_bound(model, info)
    upper = _get_variable_upper_bound(model, info)
    return MOI.Semiinteger(lower, upper)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{MOI.VariableIndex, S}
) where {S}
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    if S <: MOI.LessThan
        return info.lessthan_name
    elseif S <: Union{MOI.GreaterThan, MOI.Interval, MOI.EqualTo}
        return info.greaterthan_interval_or_equalto_name
    else
        @assert S <: Union{MOI.ZeroOne, MOI.Integer, MOI.Semiinteger, MOI.Semicontinuous}
        return info.type_constraint_name
    end
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{MOI.VariableIndex, S}, name::String
) where {S}
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    old_name = ""
    if S <: MOI.LessThan
        old_name = info.lessthan_name
        info.lessthan_name = name
    elseif S <: Union{MOI.GreaterThan, MOI.Interval, MOI.EqualTo}
        old_name = info.greaterthan_interval_or_equalto_name
        info.greaterthan_interval_or_equalto_name = name
    else
        @assert S <: Union{MOI.ZeroOne, MOI.Integer, MOI.Semiinteger, MOI.Semicontinuous}
        info.type_constraint_name
        info.type_constraint_name = name
    end
    model.name_to_constraint_index = nothing
    return
end

###
### ScalarAffineFunction-in-Set
###

function _info(
    model::Optimizer,
    key::MOI.ConstraintIndex{F, S}
) where {S, F<:Union{
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
    MOI.VectorAffineFunction{Float64},
    MOI.VectorOfVariables,
    }
}
    if haskey(model.affine_constraint_info, key.value)
        return model.affine_constraint_info[key.value]
    end
    throw(MOI.InvalidIndex(key))
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{F, S}
) where {S, F<:Union{
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
    MOI.VectorAffineFunction{Float64},
    MOI.VectorOfVariables,
    }
}
    info = get(model.affine_constraint_info, c.value, nothing)
    if info === nothing
        return false
    else
        return typeof(info.set) == S
    end
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.ScalarAffineFunction{Float64},
    s::SIMPLE_SCALAR_SETS
)
    if !iszero(f.constant)
        throw(MOI.ScalarFunctionConstantNotZero{Float64, typeof(f), typeof(s)}(f.constant))
    end
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, AFFINE)
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)
    Xpress.addrows(
        model.inner,
        [sense],#_srowtype,
        [rhs],#_drhs,
        C_NULL,#_drng,
        [1],#_mstart,
        (indices),#_mclind,
        coefficients,#_dmatval
    )
    return MOI.ConstraintIndex{typeof(f), typeof(s)}(model.last_constraint_index)
end

function MOI.add_constraints(
    model::Optimizer, f::Vector{MOI.ScalarAffineFunction{Float64}},
    s::Vector{<:SIMPLE_SCALAR_SETS}
)
    if length(f) != length(s)
        error("Number of functions does not equal number of sets.")
    end
    canonicalized_functions = MOI.Utilities.canonical.(f)
    # First pass: compute number of non-zeros to allocate space.
    nnz = 0
    for fi in canonicalized_functions
        if !iszero(fi.constant)
            throw(MOI.ScalarFunctionConstantNotZero{Float64, eltype(f), eltype(s)}(fi.constant))
        end
        nnz += length(fi.terms)
    end
    # Initialize storage
    indices = Vector{MOI.ConstraintIndex{eltype(f), eltype(s)}}(undef, length(f))
    row_starts = Vector{Int}(undef, length(f) + 1)
    row_starts[1] = 1
    columns = Vector{Int}(undef, nnz)
    coefficients = Vector{Float64}(undef, nnz)
    senses = Vector{Cchar}(undef, length(f))
    rhss = Vector{Float64}(undef, length(f))
    # Second pass: loop through, passing views to _indices_and_coefficients.
    for (i, (fi, si)) in enumerate(zip(canonicalized_functions, s))
        senses[i], rhss[i] = _sense_and_rhs(si)
        row_starts[i + 1] = row_starts[i] + length(fi.terms)
        _indices_and_coefficients(
            view(columns, row_starts[i]:row_starts[i + 1] - 1),
            view(coefficients, row_starts[i]:row_starts[i + 1] - 1),
            model, fi
        )
        model.last_constraint_index += 1
        indices[i] = MOI.ConstraintIndex{eltype(f), eltype(s)}(model.last_constraint_index)
        model.affine_constraint_info[model.last_constraint_index] =
            ConstraintInfo(length(model.affine_constraint_info) + 1, si, AFFINE)
    end
    pop!(row_starts)
    Xpress.addrows(
        model.inner,
        senses,#_srowtype,
        rhss,#_drhs,
        C_NULL,#_drng,
        row_starts,#_mstart,
        columns,#_mclind,
        coefficients,#_dmatval
        )
    return indices
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{T, <:Any}
) where {T<:Union{
    MOI.VectorAffineFunction{Float64},
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
}}
    row = _info(model, c).row
    Xpress.delrows(model.inner, [row])
    for (key, info) in model.affine_constraint_info
        if info.row > row
            info.row -= 1
        end
    end
    delete!(model.affine_constraint_info, c.value)
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{F, S}
) where {S,F<:Union{
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
}}
    rhs = Vector{Cdouble}(undef, 1)
    row = _info(model, c).row
    # Xpress.getrhs!(model.inner, rhs, row, row)
    Lib.XPRSgetrhs(model.inner, Cint(rhs), Ref(Cint(row-1)), Ref(Cint(row-1)))
    return S(rhs[1])
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, S}, s::S
) where {S}
    Lib.XPRSchgrhs(model.inner, Cint(1), Ref(Cint(_info(model, c).row - 1)), 
        Ref(MOI.constant(s)))
    return
end

function _get_affine_terms(model::Optimizer, c::MOI.ConstraintIndex)
    row = _info(model, c).row
    nzcnt_max = Xpress.n_non_zero_elements(model.inner)

    # nzcnt = Xpress.getrows_nnz(model.inner, row, row)
    nzcnt = Lib.XPRSgetrows(model.inner, C_NULL, C_NULL, C_NULL, 0, Cint(0), 
        Ref(Cint(row-1)), Ref(Cint(row-1)))

    @assert nzcnt <= nzcnt_max

    rmatbeg = zeros(Cint, row-row+2)
    rmatind = Array{Cint}(undef,  nzcnt)
    rmatval = Array{Float64}(undef,  nzcnt)

    Xpress.getrows(
        model.inner,
        rmatbeg,#_mstart,
        rmatind,#_mclind,
        rmatval,#_dmatval,
        nzcnt,#maxcoeffs,
        row,#first::Integer,
        row,#last::Integer
        )
    # Lib.XPRSgetrows(
    #     model.inner,
    #     Cint.(rmatbeg),#_mstart,
    #     Cint.(rmatind),#_mclind,
    #     Ref(rmatval),#_dmatval,
    #     Cint.(nzcnt),#maxcoeffs,
    #     Ref(Cint(row-1)),#first::Integer,
    #     Ref(Cint(row-1)),#last::Integer
    #     )

    terms = MOI.ScalarAffineTerm{Float64}[]
    for i = 1:nzcnt
        iszero(rmatval[i]) && continue
        push!(
            terms,
            MOI.ScalarAffineTerm(
                rmatval[i],
                model.variable_info[CleverDicts.LinearIndex(rmatind[i])].index
            )
        )
    end
    return terms
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, S}
) where {S}
    terms = _get_affine_terms(model, c)
    return MOI.ScalarAffineFunction(terms, 0.0)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{T, <:Any}
) where {T<:Union{
    MOI.VectorAffineFunction{Float64},
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
    MOI.VectorOfVariables
}}
    return _info(model, c).name
end

function MOI.set(
    model::Optimizer, ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{T, <:Any},
    name::String
) where {T<:Union{
    MOI.VectorAffineFunction{Float64},
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
    MOI.VectorOfVariables
}}
    info = _info(model, c)
    info.name = name
    # Note: don't set the string names in the Xpress C API because it complains
    # on duplicate contraints.
    # That is, don't call `Xpress.addnames`.
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(model::Optimizer, ::Type{MOI.ConstraintIndex}, name::String)
    if model.name_to_constraint_index === nothing
        _rebuild_name_to_constraint_index(model)
    end
    if haskey(model.name_to_constraint_index, name)
        constr = model.name_to_constraint_index[name]
        if constr === nothing
            error("Duplicate constraint name detected: $(name)")
        end
        return constr
    end
    return nothing
end

function MOI.get(
    model::Optimizer, C::Type{MOI.ConstraintIndex{F, S}}, name::String
) where {F, S}
    index = MOI.get(model, MOI.ConstraintIndex, name)
    if typeof(index) == C
        return index::MOI.ConstraintIndex{F, S}
    end
    return nothing
end

function _rebuild_name_to_constraint_index(model::Optimizer)
    model.name_to_constraint_index = Dict{String, Union{Nothing, MOI.ConstraintIndex}}()
    _rebuild_name_to_constraint_index_util(
        model, model.affine_constraint_info
    )
    _rebuild_name_to_constraint_index_util(
        model, model.sos_constraint_info, MOI.VectorOfVariables
    )
    _rebuild_name_to_constraint_index_variables(model)
    return
end

function _rebuild_name_to_constraint_index_util(model::Optimizer, dict)
    for (index, info) in dict
        if info.name == ""
            continue
        elseif haskey(model.name_to_constraint_index, info.name)
            model.name_to_constraint_index[info.name] = nothing
        else
            model.name_to_constraint_index[info.name] =
            if info.type == AFFINE
                MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, typeof(info.set)}(index)
            elseif info.type == QUADRATIC
                MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64}, typeof(info.set)}(index)
            elseif info.type == INDICATOR
                MOI.ConstraintIndex{MOI.VectorAffineFunction{Float64}, typeof(info.set)}(index)
            elseif info.type == SOC
                MOI.ConstraintIndex{MOI.VectorOfVariables, typeof(info.set)}(index)
            elseif info.type == RSOC
                MOI.ConstraintIndex{MOI.VectorOfVariables, typeof(info.set)}(index)
            else
                error("Unknown constraint type $(info.type)")
            end
        end
    end
    return
end

function _rebuild_name_to_constraint_index_util(model::Optimizer, dict, F)
    for (index, info) in dict
        if info.name == ""
            continue
        elseif haskey(model.name_to_constraint_index, info.name)
            model.name_to_constraint_index[info.name] = nothing
        else
            model.name_to_constraint_index[info.name] =
                MOI.ConstraintIndex{F, typeof(info.set)}(index)
        end
    end
    return
end

function _rebuild_name_to_constraint_index_variables(model::Optimizer)
    for (key, info) in model.variable_info
        for S in (
            MOI.LessThan{Float64}, MOI.GreaterThan{Float64},
            MOI.EqualTo{Float64}, MOI.Interval{Float64}, MOI.ZeroOne,
            MOI.Integer, MOI.Semicontinuous{Float64}, MOI.Semiinteger{Float64}
        )
            constraint_name = ""
            if info.bound in _bound_enums(S)
                constraint_name = S == MOI.LessThan{Float64} ?
                    info.lessthan_name : info.greaterthan_interval_or_equalto_name
            elseif info.type in _type_enums(S)
                constraint_name = info.type_constraint_name
            end
            if constraint_name == ""
                continue
            elseif haskey(model.name_to_constraint_index, constraint_name)
                model.name_to_constraint_index[constraint_name] = nothing
            else
                model.name_to_constraint_index[constraint_name] =
                    MOI.ConstraintIndex{MOI.VariableIndex, S}(key.value)
            end
        end
    end
    return
end

###
### VectorAffineFunction-in-INDICATOR_SET
###

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VectorAffineFunction{Float64}, MOI.Indicator{A,S}}
) where {A, S <: SCALAR_SETS}
    # rhs = Vector{Cdouble}(undef, 1)
    # info = _info(model, c)
    # row = info.row
    # set_cte = MOI.constant(info.set.set)
    # # a^T x + b <= c ===> a^T <= c - b
    # Xpress.getrhs!(model.inner, rhs, row, row)
    # return MOI.Indicator{A}(S(rhs[1]))
    return _info(model, c).set
end

function _indicator_variable(f::MOI.VectorAffineFunction)
    value = 0
    changes = 0
    for fi in f.terms
        if fi.output_index == 1
            value = fi.scalar_term.variable.value
            changes += 1
        end
    end
    if changes != 1
        error("There should be exactly one term in output_index 1, found $(changes)")
    end
    return value
end

indicator_activation(::Type{Val{MOI.ACTIVATE_ON_ZERO}}) = Cint(-1)
indicator_activation(::Type{Val{MOI.ACTIVATE_ON_ONE}}) = Cint(1)

function MOI.add_constraint(
    model::Optimizer, f::MOI.VectorAffineFunction{T}, is::MOI.Indicator{A, LT}) where {T<:Real, LT<:Union{MOI.LessThan,MOI.GreaterThan,MOI.EqualTo},A}
    con_value = _indicator_variable(f)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, is, INDICATOR)
    indices, coefficients = _indices_and_coefficients_indicator(model, f)
    cte = MOI.constant(f)[2]
    # a^T x + b <= c ===> a^T <= c - b
    sense, rhs = _sense_and_rhs(is.set)
    Xpress.addrows(
        model.inner,
        [sense],#_srowtype,
        [rhs-cte],#_drhs,
        C_NULL,#_drng,
        [1],#_mstart,
        (indices),#_mclind,
        coefficients,#_dmatval
    )
    Xpress.setindicators(model.inner, [Xpress.n_constraints(model.inner)], [con_value], [indicator_activation(Val{A})])
    index = MOI.ConstraintIndex{MOI.VectorAffineFunction{T}, typeof(is)}(model.last_constraint_index)
    return index
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorAffineFunction{Float64}, S}
) where {S}

    terms = MOI.VectorAffineTerm{Float64}[]
    aff_terms = _get_affine_terms(model, c)
    for term in aff_terms
        push!(terms, MOI.VectorAffineTerm(2, term))
    end

    info = _info(model, c)
    row = info.row

    comps = Array{Cint}(undef, 1)
    inds = Array{Cint}(undef, 1)
    Xpress.getindicators(model.inner, inds, comps, row, row)
    push!(terms,
            MOI.VectorAffineTerm(1,
                MOI.ScalarAffineTerm(1.0,
                    model.variable_info[CleverDicts.LinearIndex(inds[1])].index
                )
            )
        )
    rhs = Xpress.getrhs(model.inner, row, row)[1]
    val = - rhs + MOI.constant(info.set.set)
    return MOI.VectorAffineFunction(terms, [0.0,val])
end

###
### ScalarQuadraticFunction-in-SCALAR_SET
###

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.ScalarQuadraticFunction{Float64}, s::SCALAR_SETS
)
    if !iszero(f.constant)
        throw(MOI.ScalarFunctionConstantNotZero{Float64, typeof(f), typeof(s)}(f.constant))
    end
    sense, rhs = _sense_and_rhs(s)
    indices, coefficients, I, J, V = _indices_and_coefficients(model, f)
    Xpress.addrows(
        model.inner, [sense], [rhs], C_NULL, [1], indices, coefficients
    )
    V .*= 0.5 # only for constraints
    Xpress.addqmatrix(model.inner, Xpress.n_constraints(model.inner), I, J, V)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, QUADRATIC)
    return MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64}, typeof(s)}(model.last_constraint_index)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64}, S}
) where {S}

    affine_terms = _get_affine_terms(model, c)

    mqcol1, mqcol2, dqe = getqrowqmatrixtriplets(model.inner, _info(model, c).row)

    quadratic_terms = MOI.ScalarQuadraticTerm{Float64}[]
    for (i, j, coef) in zip(mqcol1, mqcol2, dqe)
        push!(
            quadratic_terms,
            MOI.ScalarQuadraticTerm(
                2 * coef, # only for constraints
                model.variable_info[CleverDicts.LinearIndex(i)].index,
                model.variable_info[CleverDicts.LinearIndex(j)].index
            )
        )
    end
    return MOI.ScalarQuadraticFunction(quadratic_terms, affine_terms, 0.0)
end

###
### VectorOfVariables-in-SOS{I|II}
###

const SOS = Union{MOI.SOS1{Float64}, MOI.SOS2{Float64}}

function _info(
    model::Optimizer,
    key::MOI.ConstraintIndex{MOI.VectorOfVariables, <:SOS}
)
    if haskey(model.sos_constraint_info, key.value)
        return model.sos_constraint_info[key.value]
    end
    throw(MOI.InvalidIndex(key))
end

_sos_type(::MOI.SOS1) = convert(Cchar, '1')
_sos_type(::MOI.SOS2) = convert(Cchar, '2')

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, S}
) where {S<:SOS}
    info = get(model.sos_constraint_info, c.value, nothing)
    if info === nothing || typeof(info.set) != S
        return false
    end
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    return all(MOI.is_valid.(model, f.variables))
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VectorOfVariables, s::SOS
)
    columns = Int[_info(model, v).column for v in f.variables]
    idx = [0, 0]
    Xpress.addsets(
        model.inner, # prob
        1, # newsets
        length(columns), # newnz
        Cchar[_sos_type(s)], # qstype
        idx, # msstart
        columns, # mscols
        s.weights, # dref
    )
    model.last_constraint_index += 1
    index = MOI.ConstraintIndex{MOI.VectorOfVariables, typeof(s)}(model.last_constraint_index)
    model.sos_constraint_info[index.value] = ConstraintInfo(
        length(model.sos_constraint_info) + 1, s, SOS_SET
    )
    return index
end

function MOI.delete(
    model::Optimizer, c::MOI.ConstraintIndex{MOI.VectorOfVariables, <:SOS}
)
    row = _info(model, c).row
    idx = collect(row:row)
    numdel = length(idx)
    delsets(model.inner, numdel, idx .- 1)
    for (key, info) in model.sos_constraint_info
        if info.row > row
            info.row -= 1
        end
    end
    delete!(model.sos_constraint_info, c.value)
    model.name_to_constraint_index = nothing
    return
end

function _get_sparse_sos(model)
    nnz = n_setmembers(model.inner)
    nsos = n_special_ordered_sets(model.inner)
    n = n_variables(model.inner)

    settypes = Array{Cchar}(undef, nsos)
    setstart = Array{Cint}(undef, nsos + 1)
    setcols = Array{Cint}(undef, nnz)
    setvals = Array{Float64}(undef, nnz)

    intents = Array{Cint}(undef, 1)
    nsets = Array{Cint}(undef, 1)

    Xpress.getglobal(
        model.inner, intents, nsets, C_NULL, C_NULL, C_NULL, settypes, setstart, setcols, setvals
    )

    setstart[end] = nnz

    I = Array{Int}(undef,  nnz)
    J = Array{Int}(undef,  nnz)
    V = Array{Float64}(undef,  nnz)
    for i in 1:length(setstart) - 1
        for j in (setstart[i]+1):setstart[i+1]
            I[j] = i
            J[j] = setcols[j] + 1
            V[j] = setvals[j]
        end
    end
    return sparse(I, J, V, nsets[1], n)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, S}
) where {S <: SOS}
    A = _get_sparse_sos(model)
    return S(A[_info(model, c).row, :].nzval)
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, S}
) where {S <: SOS}
    A = _get_sparse_sos(model)
    indices = SparseArrays.nonzeroinds(A[_info(model, c).row, :])
    return MOI.VectorOfVariables([
        model.variable_info[CleverDicts.LinearIndex(i)].index for i in indices
    ])
end

###
### Optimize methods.
###

function check_moi_callback_validity(model::Optimizer)
    has_moi_callback =
        model.lazy_callback !== nothing ||
        model.user_cut_callback !== nothing ||
        model.heuristic_callback !== nothing
    if has_moi_callback && model.has_generic_callback
        error(
            "Cannot use Xpress.CallbackFunction as well as " *
            "MOI.AbstractCallbackFunction"
        )
    end
    return has_moi_callback
end

# TODO alternatively do like Gurobi.jl and wrap all callbacks in a try/catch block
function pre_solve_reset(model::Optimizer)
    model.basis_status = nothing
    model.cb_exception = nothing
    reset_cached_solution(model)
    return
end
function check_cb_exception(model::Optimizer)
    if model.cb_exception !== nothing
        e = model.cb_exception
        model.cb_exception = nothing
        throw(e)
    end
    return
end

function is_mip(model)
    return Xpress.is_mixedinteger(model.inner) && !model.solve_relaxation
end

# Internal function.
# A variable may or may not have MIP-start. Such information is stored
# in the field `start` inside a `VariableInfo`. If `start` is `nothing`
# there is no MIP-start; otherwise it has a `Float64` MIP-start value.
# `_gather_MIP_start` returns the sparse representation of all MIP-starts
# that is needed by the XPRESS API function `addmipsol`.
# The sparse representation amounts to two `Vector` of the same size:
# `colind` and `solval`. `colind` has the internal column index for
# each variable that has a MIP-start. `solval` has the corresponding
# primal value for each column referred in `colind`.
function _gather_MIP_start(model)
    variable_info = model.variable_info
    n_var = length(variable_info)
    colind = Vector{Cint}(undef, 0)
    solval = Vector{Cdouble}(undef, 0)
    j = 0
    for (_, var_info) in variable_info
        if var_info.start !== nothing
            j += 1
            if j == 1 # only allocates if there is some start point
                resize!(colind, n_var)
                resize!(solval, n_var)
            end
            colind[j] = var_info.column - 1
            solval[j] = var_info.start :: Float64
        end
    end
    resize!(colind, j)
    resize!(solval, j)

    return colind, solval
end

# Internal function.
# Informs `inner.model` of the solution stored in the `start` fields
# of each element of `model.variable_info`.
function _update_MIP_start!(model)
    colind, solval = _gather_MIP_start(model)
    number_mip_started_var = length(colind)
    iszero(number_mip_started_var) && return
    # See: https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSaddmipsol.html
    # The documentation states that `colind` "Should be NULL when length is
    # equal to COLS, in which case it is assumed that solval provides a
    # complete solution vector."
    if number_mip_started_var == length(model.variable_info)
        # For the corner case in which `colind` is NOT already sorted we need
        # to be sure that `solval` is in the same order as the model.inner
        # columns.
        permute!(solval, sortperm(colind))
        addmipsol(model.inner, number_mip_started_var, solval, C_NULL, C_NULL)
    else
        addmipsol(model.inner, number_mip_started_var, solval, colind, C_NULL)
    end

    return
end

function MOI.optimize!(model::Optimizer)
    # Initialize callbacks if necessary.
    if check_moi_callback_validity(model)
        if model.moi_warnings && Xpress.getcontrol(model.inner,Xpress.Lib.XPRS_HEURSTRATEGY) != 0
            @warn "Callbacks in XPRESS might not work correctly with HEURSTRATEGY != 0"
        end
        MOI.set(model, CallbackFunction(), default_moi_callback(model))
        model.has_generic_callback = false # because it is set as true in the above
    end
    pre_solve_reset(model)
    # cache rhs: must be done before hand because it cant be
    # properly queried if the problem ends up in a presolve state
    rhs = Xpress.getrhs(model.inner)
    if !model.ignore_start && is_mip(model)
        _update_MIP_start!(model)
    end
    start_time = time()
    if is_mip(model)
        Xpress.mipoptimize(model.inner, model.solve_method)
    else
        Xpress.lpoptimize(model.inner, model.solve_method)
    end
    model.cached_solution.solve_time = time() - start_time
    check_cb_exception(model)

    if is_mip(model)
        Xpress.Lib.XPRSgetmipsol(
            model.inner,
            model.cached_solution.variable_primal,
            model.cached_solution.linear_primal,
        )
        fill!(model.cached_solution.linear_dual, NaN)
        fill!(model.cached_solution.variable_dual, NaN)
    else
        Xpress.Lib.XPRSgetlpsol(
            model.inner,
            model.cached_solution.variable_primal,
            model.cached_solution.linear_primal,
            model.cached_solution.linear_dual,
            model.cached_solution.variable_dual,
        )
    end

    # should be almost a no-op if not needed
    # might have minor overhead due to memory being freed
    if model.post_solve
        Xpress.postsolve(model.inner)
    end

    model.cached_solution.linear_primal .= rhs .- model.cached_solution.linear_primal
    model.termination_status = _cache_termination_status(model)
    model.primal_status = _cache_primal_status(model)
    model.dual_status = _cache_dual_status(model)
    status = MOI.get(model, MOI.PrimalStatus())
    if status == MOI.INFEASIBILITY_CERTIFICATE
        has_Ray = Int64[0]
        Xpress.getprimalray(model.inner, model.cached_solution.variable_primal , has_Ray)
        model.cached_solution.has_primal_certificate = _has_primal_ray(model)
    elseif status == MOI.FEASIBLE_POINT 
        model.cached_solution.has_feasible_point = true
    end
    status = MOI.get(model, MOI.DualStatus())
    if status == MOI.INFEASIBILITY_CERTIFICATE
        has_Ray = Int64[0]
        Xpress.getdualray(model.inner, model.cached_solution.linear_dual , has_Ray)
        model.cached_solution.has_dual_certificate = _has_dual_ray(model)
    end
    return
end

function _throw_if_optimize_in_progress(model, attr)
    if model.callback_state != CB_NONE
        throw(MOI.OptimizeInProgress(attr))
    end
end

function MOI.get(model::Optimizer, attr::MOI.RawStatusString)
    _throw_if_optimize_in_progress(model, attr)
    stop = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_STOPSTATUS)
    stop_str = STOPSTATUS_STRING[stop]
    if is_mip(model)
        stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_MIPSTATUS)
        return Xpress.MIPSTATUS_STRING[stat] * " - " * stop_str
    else
        stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_LPSTATUS)
        return Xpress.LPSTATUS_STRING[stat] * " - " * stop_str
    end
end

function _cache_termination_status(model::Optimizer)
    stop = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_STOPSTATUS)
    if stop != Xpress.Lib.XPRS_STOP_NONE
        if stop == Xpress.Lib.XPRS_STOP_TIMELIMIT
            return MOI.TIME_LIMIT
        elseif stop == Xpress.Lib.XPRS_STOP_CTRLC
            return MOI.INTERRUPTED
        elseif stop == Xpress.Lib.XPRS_STOP_NODELIMIT
            return MOI.NODE_LIMIT
        elseif stop == Xpress.Lib.XPRS_STOP_ITERLIMIT
            return MOI.ITERATION_LIMIT
        elseif stop == Xpress.Lib.XPRS_STOP_MIPGAP
            stat = Xpress.Lib.XPRS_MIP_NOT_LOADED
            if is_mip(model)
                stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_MIPSTATUS)
                if stat == Xpress.Lib.XPRS_MIP_OPTIMAL
                    return MOI.OPTIMAL
                else
                    return MOI.OTHER_ERROR
                end
            else
                return MOI.OTHER_ERROR
            end
        elseif stop == Xpress.Lib.XPRS_STOP_SOLLIMIT
            return MOI.SOLUTION_LIMIT
        else
            @assert stop == Xpress.Lib.XPRS_STOP_USER
            return MOI.INTERRUPTED
        end
        #=
        XPRS_STOP_NONE no interruption - the solve completed normally
        XPRS_STOP_TIMELIMIT time limit hit
        XPRS_STOP_CTRLC control C hit
        XPRS_STOP_NODELIMIT node limit hit
        XPRS_STOP_ITERLIMIT iteration limit hit
        XPRS_STOP_MIPGAP MIP gap is sufficiently small
        XPRS_STOP_SOLLIMIT solution limit hit
        XPRS_STOP_USER user interrupt
        =#
    end # else:
    if is_mip(model)
        stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_MIPSTATUS)
        if stat == Xpress.Lib.XPRS_MIP_NOT_LOADED
            return MOI.OPTIMIZE_NOT_CALLED
        elseif stat == Xpress.Lib.XPRS_MIP_LP_NOT_OPTIMAL # is a STOP
            return MOI.OTHER_ERROR
        elseif stat == Xpress.Lib.XPRS_MIP_LP_OPTIMAL # is a STOP
            return MOI.OTHER_ERROR
        elseif stat == Xpress.Lib.XPRS_MIP_NO_SOL_FOUND # is a STOP
            return MOI.OTHER_ERROR
        elseif stat == Xpress.Lib.XPRS_MIP_SOLUTION # is a STOP
            return MOI.LOCALLY_SOLVED
        elseif stat == Xpress.Lib.XPRS_MIP_INFEAS
            return MOI.INFEASIBLE
        elseif stat == Xpress.Lib.XPRS_MIP_OPTIMAL
            return MOI.OPTIMAL
        else
            @assert stat == Xpress.Lib.XPRS_MIP_UNBOUNDED
            return MOI.INFEASIBLE_OR_UNBOUNDED #? DUAL_INFEASIBLE?
        end
        #=
        0 Problem has not been loaded (XPRS_MIP_NOT_LOADED).
        1 Global search incomplete - the initial continuous relaxation has not been solved and
            no integer solution has been found (XPRS_MIP_LP_NOT_OPTIMAL).
        2 Global search incomplete - the initial continuous relaxation has been solved and no
            integer solution has been found (XPRS_MIP_LP_OPTIMAL).
        3 Global search incomplete - no integer solution found (XPRS_MIP_NO_SOL_FOUND).
        4 Global search incomplete - an integer solution has been found
            (XPRS_MIP_SOLUTION).
        5 Global search complete - no integer solution found (XPRS_MIP_INFEAS).
        6 Global search complete - integer solution found (XPRS_MIP_OPTIMAL).
        7 Global search incomplete - the initial continuous relaxation was found to be
            unbounded. A solution may have been found (XPRS_MIP_UNBOUNDED).
        =#
    else
        stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_LPSTATUS)
        if stat == Xpress.Lib.XPRS_LP_UNSTARTED
            return MOI.OPTIMIZE_NOT_CALLED
        elseif stat == Xpress.Lib.XPRS_LP_OPTIMAL
            return MOI.OPTIMAL
        elseif stat == Xpress.Lib.XPRS_LP_INFEAS
            return MOI.INFEASIBLE
        elseif stat == Xpress.Lib.XPRS_LP_CUTOFF
            return MOI.OTHER_LIMIT
        elseif stat == Xpress.Lib.XPRS_LP_UNFINISHED # is a STOP
            return MOI.OTHER_ERROR
        elseif stat == Xpress.Lib.XPRS_LP_UNBOUNDED
            return MOI.DUAL_INFEASIBLE
        elseif stat == Xpress.Lib.XPRS_LP_CUTOFF_IN_DUAL
            return MOI.OTHER_LIMIT
        elseif stat == Xpress.Lib.XPRS_LP_UNSOLVED
            return MOI.NUMERICAL_ERROR
        else
            @assert stat == Xpress.Lib.XPRS_LP_NONCONVEX
            return MOI.INVALID_OPTION
        end
        #=
        0 Unstarted (XPRS_LP_UNSTARTED).
        1 Optimal (XPRS_LP_OPTIMAL).
        2 Infeasible (XPRS_LP_INFEAS).
        3 Objective worse than cutoff (XPRS_LP_CUTOFF).
        4 Unfinished (XPRS_LP_UNFINISHED).
        5 Unbounded (XPRS_LP_UNBOUNDED).
        6 Cutoff in dual (XPRS_LP_CUTOFF_IN_DUAL).
        7 Problem could not be solved due to numerical issues. (XPRS_LP_UNSOLVED).
        8 Problem contains quadratic data, which is not convex (XPRS_LP_NONCONVEX)
        =#
    end
    return MOI.OTHER_ERROR
end

function MOI.get(model::Optimizer, attr::MOI.TerminationStatus)
    _throw_if_optimize_in_progress(model, attr)
    if model.cached_solution === nothing
        return MOI.OPTIMIZE_NOT_CALLED
    end
    return model.termination_status
end

function _has_dual_ray(model::Optimizer)
    has_Ray = Int64[0]
    Xpress.getdualray(model.inner, C_NULL , has_Ray)
    return has_Ray[1] != 0
end

function _has_primal_ray(model::Optimizer)
    has_Ray = Int64[0]
    Xpress.getprimalray(model.inner, C_NULL, has_Ray)
    return has_Ray[1] != 0
end

function _cache_primal_status(model)
    term_stat = MOI.get(model, MOI.TerminationStatus())
    if term_stat == MOI.OPTIMAL || term_stat == MOI.LOCALLY_SOLVED
        return MOI.FEASIBLE_POINT
    elseif term_stat == MOI.LOCALLY_INFEASIBLE
        return MOI.INFEASIBLE_POINT
    elseif term_stat == MOI.DUAL_INFEASIBLE
        if _has_primal_ray(model)
            return MOI.INFEASIBILITY_CERTIFICATE
        end
    elseif is_mip(model)
        stat = Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_MIPSTATUS)
        if stat == Xpress.Lib.XPRS_MIP_NOT_LOADED
            return MOI.NO_SOLUTION
        elseif stat == Xpress.Lib.XPRS_MIP_LP_NOT_OPTIMAL # - is a STOP
            return MOI.NO_SOLUTION
        elseif stat == Xpress.Lib.XPRS_MIP_LP_OPTIMAL # - is a STOP
            return MOI.INFEASIBLE_POINT
        elseif stat == Xpress.Lib.XPRS_MIP_NO_SOL_FOUND # - is a STOP
            return MOI.NO_SOLUTION
        elseif stat == Xpress.Lib.XPRS_MIP_SOLUTION # - is a STOP
            return MOI.FEASIBLE_POINT
        elseif stat == Xpress.Lib.XPRS_MIP_INFEAS
            return MOI.INFEASIBLE_POINT
        elseif stat == Xpress.Lib.XPRS_MIP_OPTIMAL
            return MOI.FEASIBLE_POINT
        elseif stat == Xpress.Lib.XPRS_MIP_UNBOUNDED
            return MOI.NO_SOLUTION #? DUAL_INFEASIBLE?
        end
    end
    if is_mip(model)
        if Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_MIPSOLS) > 0
            return MOI.FEASIBLE_POINT
        end
    end
    return MOI.NO_SOLUTION
end

function MOI.get(model::Optimizer, attr::MOI.PrimalStatus)
    _throw_if_optimize_in_progress(model, attr)
    if attr.result_index != 1
        return MOI.NO_SOLUTION
    end
    return model.primal_status
end

function _cache_dual_status(model)
    if is_mip(model)
        return MOI.NO_SOLUTION
    end
    term_stat = MOI.get(model, MOI.TerminationStatus())
    if term_stat == MOI.OPTIMAL
        return MOI.FEASIBLE_POINT
    elseif term_stat == MOI.INFEASIBLE
        if _has_dual_ray(model)
            return MOI.INFEASIBILITY_CERTIFICATE
        end
    end
    return MOI.NO_SOLUTION
    
end

function MOI.get(model::Optimizer, attr::MOI.DualStatus)
    _throw_if_optimize_in_progress(model, attr)
    if attr.result_index != 1
        return MOI.NO_SOLUTION
    end
    return model.dual_status
end

function MOI.get(model::Optimizer, attr::MOI.VariablePrimal, x::MOI.VariableIndex)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, x).column
    return model.cached_solution.variable_primal[column]
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.VariableIndex, <:Any}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    return MOI.get(model, MOI.VariablePrimal(), MOI.VariableIndex(c.value))
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, <:Any}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    return model.cached_solution.linear_primal[row]
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64}, <:Any}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    return model.cached_solution.linear_primal[row]
end

function _dual_multiplier(model::Optimizer)
    return MOI.get(model, MOI.ObjectiveSense()) == MOI.MIN_SENSE ? 1.0 : -1.0
end

"""
    _farkas_variable_dual(model::Optimizer, col::Cint)

Return a Farkas dual associated with the variable bounds of `col`.

Compute the Farkas dual as:

    ā * x = λ' * A * x <= λ' * b = -β + sum(āᵢ * Uᵢ | āᵢ < 0) + sum(āᵢ * Lᵢ | āᵢ > 0)

The Farkas dual of the variable is ā, and it applies to the upper bound if ā < 0,
and it applies to the lower bound if ā > 0.
"""
function _farkas_variable_dual(model::Optimizer, col::Int64)
    nvars = length(model.variable_info)
    nrows = length(model.affine_constraint_info)
    ncoeffs = Array{Cint}(undef,1)
    getcols(model.inner, C_NULL, C_NULL, C_NULL, nrows, ncoeffs, col, col)
    ncoeffs_ = ncoeffs[1]
    mstart = Array{Cint}(undef,2)
    mrwind = Array{Cint}(undef,ncoeffs_)
    dmatval = Array{Float64}(undef,ncoeffs_)
    getcols(model.inner, mstart, mrwind, dmatval, nrows, ncoeffs, col, col)
    return sum(v * model.cached_solution.linear_dual[i + 1] for (i, v) in zip(mrwind, dmatval))
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.LessThan{Float64}}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, c).column
    if model.cached_solution.has_dual_certificate
        dual = -_farkas_variable_dual(model, column)
        return min(dual, 0.0)
    end
    reduced_cost = model.cached_solution.variable_dual[column]
    sense = MOI.get(model, MOI.ObjectiveSense())
    # The following is a heuristic for determining whether the reduced cost
    # applies to the lower or upper bound. It can be wrong by at most
    # `FeasibilityTol`.
    if sense == MOI.MIN_SENSE && reduced_cost < 0
        # If minimizing, the reduced cost must be negative (ignoring
        # tolerances).
        return reduced_cost
    elseif sense == MOI.MAX_SENSE && reduced_cost > 0
        # If minimizing, the reduced cost must be positive (ignoring
        # tolerances). However, because of the MOI dual convention, we return a
        # negative value.
        return -reduced_cost
    else
        # The reduced cost, if non-zero, must related to the lower bound.
        return 0.0
    end
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.GreaterThan{Float64}}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, c).column
    if model.cached_solution.has_dual_certificate
        dual = -_farkas_variable_dual(model, column)
        return max(dual,0.0)
    end
    reduced_cost = model.cached_solution.variable_dual[column]
    sense = MOI.get(model, MOI.ObjectiveSense())
    # The following is a heuristic for determining whether the reduced cost
    # applies to the lower or upper bound. It can be wrong by at most
    # `FeasibilityTol`.
    if sense == MOI.MIN_SENSE && reduced_cost > 0
        # If minimizing, the reduced cost must be negative (ignoring
        # tolerances).
        return reduced_cost
    elseif sense == MOI.MAX_SENSE && reduced_cost < 0
        # If minimizing, the reduced cost must be positive (ignoring
        # tolerances). However, because of the MOI dual convention, we return a
        # negative value.
        return -reduced_cost
    else
        # The reduced cost, if non-zero, must related to the lower bound.
        return 0.0
    end
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.EqualTo{Float64}}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, c).column
    if model.cached_solution.has_dual_certificate
        return -_farkas_variable_dual(model, column)
    end
    reduced_cost = model.cached_solution.variable_dual[column]
    return _dual_multiplier(model) * reduced_cost
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Interval{Float64}}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, c).column
    if model.cached_solution.has_dual_certificate
        return -_farkas_variable_dual(model, column)
    end
    reduced_cost = model.cached_solution.variable_dual[column]
    return _dual_multiplier(model) * reduced_cost
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, <:Any}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    if model.cached_solution.has_dual_certificate
        return model.cached_solution.linear_dual[row]
    end
    return _dual_multiplier(model) * model.cached_solution.linear_dual[row]
end

function MOI.get(
    model::Optimizer, attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64}, <:Any}
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    pi = model.cached_solution.linear_dual[_info(model, c).row]
    return _dual_multiplier(model) * pi
end

function MOI.get(model::Optimizer, attr::MOI.ObjectiveValue)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    if is_mip(model)
        return Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_MIPOBJVAL)
    else
        return Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_LPOBJVAL)
    end
end

function MOI.get(model::Optimizer, attr::MOI.ObjectiveBound)
    _throw_if_optimize_in_progress(model, attr)
    if is_mip(model)
        return Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_BESTBOUND)
    else
        return Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_LPOBJVAL)
    end
end

function MOI.get(model::Optimizer, attr::MOI.SolveTimeSec)
    _throw_if_optimize_in_progress(model, attr)
    return model.cached_solution.solve_time
end

function MOI.get(model::Optimizer, attr::MOI.SimplexIterations)
    _throw_if_optimize_in_progress(model, attr)
    return Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_SIMPLEXITER)
end

function MOI.get(model::Optimizer, attr::MOI.BarrierIterations)
    _throw_if_optimize_in_progress(model, attr)
    return Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_BARITER)
end

function MOI.get(model::Optimizer, attr::MOI.NodeCount)
    _throw_if_optimize_in_progress(model, attr)
    return Xpress.getintattrib(model.inner, Xpress.Lib.XPRS_NODES)
end

function MOI.get(model::Optimizer, attr::MOI.RelativeGap)
    _throw_if_optimize_in_progress(model, attr)
    BESTBOUND = MOI.get(model, MOI.ObjectiveBound())
    MIPOBJVAL = MOI.get(model, MOI.ObjectiveValue())
    return abs(MIPOBJVAL - BESTBOUND) / max(abs(BESTBOUND), abs(MIPOBJVAL))
end

function MOI.get(model::Optimizer, attr::MOI.DualObjectiveValue)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    MOI.get(model, MOI.ObjectiveValue(attr.result_index))
end

function MOI.get(model::Optimizer, attr::MOI.ResultCount)
    _throw_if_optimize_in_progress(model, attr)
    if model.cached_solution === nothing
        return 0
    elseif model.cached_solution.has_dual_certificate
        return 1
    elseif model.cached_solution.has_primal_certificate
        return 1
    else
        return (model.cached_solution.has_feasible_point) ? 1 : 0
    end
end

function MOI.get(model::Optimizer, ::MOI.Silent)
    return model.log_level == 0
end

function MOI.set(model::Optimizer, ::MOI.Silent, flag::Bool)
    MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), ifelse(flag, 0, 1))
    return
end

function MOI.get(model::Optimizer, ::MOI.NumberOfThreads)
    return Int(MOI.get(model, MOI.RawOptimizerAttribute("THREADS")))
end

function MOI.set(model::Optimizer, ::MOI.NumberOfThreads, x::Int)
    return MOI.set(model, MOI.RawOptimizerAttribute("THREADS"), x)
end

function MOI.get(model::Optimizer, ::MOI.Name)
    return model.name
end

function MOI.set(model::Optimizer, ::MOI.Name, name::String)
    model.name = name
    Xpress.setprobname(model.inner, name)
    return
end

MOI.get(model::Optimizer, ::MOI.NumberOfVariables) = length(model.variable_info)
function MOI.get(model::Optimizer, ::MOI.ListOfVariableIndices)
    return sort!(collect(keys(model.variable_info)), by = x -> x.value)
end

MOI.get(model::Optimizer, ::MOI.RawSolver) = model.inner

function MOI.set(
    model::Optimizer,
    ::MOI.VariablePrimalStart,
    x::MOI.VariableIndex,
    value::Union{Nothing, Float64}
)
    info = _info(model, x)
    info.start = value
    return
end

function MOI.get(
    model::Optimizer, ::MOI.VariablePrimalStart, x::MOI.VariableIndex
)
    return _info(model, x).start
end

function MOI.supports(
    ::Optimizer, ::MOI.VariablePrimalStart, ::Type{MOI.VariableIndex})
    return true
end

function MOI.get(model::Optimizer, ::MOI.NumberOfConstraints{F, S}) where {F, S}
    # TODO: this could be more efficient.
    return length(MOI.get(model, MOI.ListOfConstraintIndices{F, S}()))
end

_bound_enums(::Type{<:MOI.LessThan}) = (LESS_THAN, LESS_AND_GREATER_THAN)
_bound_enums(::Type{<:MOI.GreaterThan}) = (GREATER_THAN, LESS_AND_GREATER_THAN)
_bound_enums(::Type{<:MOI.Interval}) = (INTERVAL,)
_bound_enums(::Type{<:MOI.EqualTo}) = (EQUAL_TO,)
_bound_enums(::Any) = (nothing,)

_type_enums(::Type{MOI.ZeroOne}) = (BINARY,)
_type_enums(::Type{MOI.Integer}) = (INTEGER,)
_type_enums(::Type{<:MOI.Semicontinuous}) = (SEMICONTINUOUS,)
_type_enums(::Type{<:MOI.Semiinteger}) = (SEMIINTEGER,)
_type_enums(::Any) = (nothing,)

function MOI.get(
    model::Optimizer, ::MOI.ListOfConstraintIndices{MOI.VariableIndex, S}
) where {S}
    indices = MOI.ConstraintIndex{MOI.VariableIndex, S}[]
    for (key, info) in model.variable_info
        if info.bound in _bound_enums(S) || info.type in _type_enums(S)
            push!(indices, MOI.ConstraintIndex{MOI.VariableIndex, S}(key.value))
        end
    end
    return sort!(indices, by = x -> x.value)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ListOfConstraintIndices{F, S}
) where {S, F<:Union{
    MOI.ScalarAffineFunction{Float64},
    MOI.VectorAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64},
    MOI.VectorOfVariables
}}
    indices = MOI.ConstraintIndex{F, S}[]
    for (key, info) in model.affine_constraint_info
        if typeof(info.set) == S
            push!(indices, MOI.ConstraintIndex{F, S}(key))
        end
    end
    return sort!(indices, by = x -> x.value)
end

function MOI.get(
    model::Optimizer, ::MOI.ListOfConstraintIndices{MOI.VectorOfVariables, S}
) where {S <: Union{<:MOI.SOS1, <:MOI.SOS2}}
    indices = MOI.ConstraintIndex{MOI.VectorOfVariables, S}[]
    for (key, info) in model.sos_constraint_info
        if typeof(info.set) == S
            push!(indices, MOI.ConstraintIndex{MOI.VectorOfVariables, S}(key))
        end
    end
    return sort!(indices, by = x -> x.value)
end

function MOI.get(model::Optimizer, ::MOI.ListOfConstraintTypesPresent)
    constraints = Set{Tuple{Type, Type}}()
    for info in values(model.variable_info)
        if info.bound == NONE
        elseif info.bound == LESS_THAN
            push!(constraints, (MOI.VariableIndex, MOI.LessThan{Float64}))
        elseif info.bound == GREATER_THAN
            push!(constraints, (MOI.VariableIndex, MOI.GreaterThan{Float64}))
        elseif info.bound == LESS_AND_GREATER_THAN
            push!(constraints, (MOI.VariableIndex, MOI.LessThan{Float64}))
            push!(constraints, (MOI.VariableIndex, MOI.GreaterThan{Float64}))
        elseif info.bound == EQUAL_TO
            push!(constraints, (MOI.VariableIndex, MOI.EqualTo{Float64}))
        elseif info.bound == INTERVAL
            push!(constraints, (MOI.VariableIndex, MOI.Interval{Float64}))
        end
        if info.type == CONTINUOUS
        elseif info.type == BINARY
            push!(constraints, (MOI.VariableIndex, MOI.ZeroOne))
        elseif info.type == INTEGER
            push!(constraints, (MOI.VariableIndex, MOI.Integer))
        elseif info.type == SEMICONTINUOUS
            push!(constraints, (MOI.VariableIndex, MOI.Semicontinuous{Float64}))
        elseif info.type == SEMIINTEGER
            push!(constraints, (MOI.VariableIndex, MOI.Semiinteger{Float64}))
        end
    end
    for info in values(model.affine_constraint_info)
        if info.type == AFFINE
            push!(constraints, (MOI.ScalarAffineFunction{Float64}, typeof(info.set)))
        elseif info.type == INDICATOR
            push!(constraints, (MOI.ScalarAffineFunction{Float64}, typeof(info.set)))
        elseif info.type == QUADRATIC
            push!(constraints, (MOI.ScalarQuadraticFunction{Float64}, typeof(info.set)))
        elseif info.type == SOC
            push!(constraints, (MOI.VectorOfVariables, MOI.SecondOrderCone))
        elseif info.type == RSOC
            push!(constraints, (MOI.VectorOfVariables, MOI.RotatedSecondOrderCone))
        else
            error("Unknown constraint type $(info.type)")
        end
    end
    for info in values(model.sos_constraint_info)
        push!(constraints, (MOI.VectorOfVariables, typeof(info.set)))
    end
    return collect(constraints)
end

function MOI.get(model::Optimizer, ::MOI.ObjectiveFunctionType)
    if !model.is_objective_set
        return nothing
    elseif model.objective_type == SINGLE_VARIABLE
        return MOI.VariableIndex
    elseif model.objective_type == SCALAR_AFFINE
        return MOI.ScalarAffineFunction{Float64}
    else
        @assert model.objective_type == SCALAR_QUADRATIC
        return MOI.ScalarQuadraticFunction{Float64}
    end
end

function MOI.modify(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, <:Any},
    chg::MOI.ScalarCoefficientChange{Float64}
)
    Lib.XPRSchgcoef(
        model.inner,
        Ref(Cint(_info(model, c).row - 1)),
        Ref(Cint(_info(model, chg.variable).column - 1)),
        Ref(chg.new_coefficient)
    )
    return
end

function MOI.modify(
    model::Optimizer,
    cis::Vector{MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, S}},
    chgs::Vector{MOI.ScalarCoefficientChange{Float64}}
) where {S}
    nels = length(cis)
    @assert nels == length(chgs)

    rows = Vector{Cint}(undef, nels)
    cols = Vector{Cint}(undef, nels)
    coefs = Vector{Float64}(undef, nels)

    for i in 1:nels
        rows[i] = Cint(_info(model, cis[i]).row)
        cols[i] = Cint(_info(model, chgs[i].variable).column)
        coefs[i] = chgs[i].new_coefficient
    end

    Lib.XPRSchgmcoef(
        model.inner,
        Cint(nels),
        Ref(Cint.(rows)),
        Ref(Cint.(cols)),
        Ref(coefs)
    )
    return
end

function MOI.modify(
    model::Optimizer,
    c::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chg::MOI.ScalarCoefficientChange{Float64}
)
    @assert model.objective_type == SCALAR_AFFINE
    column = _info(model, chg.variable).column
    Lib.XPRSchgobj(model.inner, Cint(column), Ref(Cint(-1)), Ref(chg.new_coefficient))
    model.is_objective_set = true
    return
end

function MOI.modify(
    model::Optimizer,
    c::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chgs::Vector{MOI.ScalarCoefficientChange{Float64}}
)
    @assert model.objective_type == SCALAR_AFFINE
    nels = length(chgs)
    cols = Vector{Int}(undef, nels)
    coefs = Vector{Float64}(undef, nels)

    for i in 1:nels
        cols[i] = _info(model, chgs[i].variable).column
        coefs[i] = chgs[i].new_coefficient
    end

    Xpress.chgobj(model.inner, cols, coefs)
    model.is_objective_set = true
    return
end

"""
    _replace_with_matching_sparsity!(
        model::Optimizer,
        previous::MOI.ScalarAffineFunction,
        replacement::MOI.ScalarAffineFunction, row::Int
    )

Internal function, not intended for external use.

Change the linear constraint function at index `row` in `model` from
`previous` to `replacement`. This function assumes that `previous` and
`replacement` have exactly the same sparsity pattern w.r.t. which variables
they include and that both constraint functions are in canonical form (as
returned by `MOIU.canonical()`. Neither assumption is checked within the body
of this function.
"""
function _replace_with_matching_sparsity!(
    model::Optimizer,
    previous::MOI.ScalarAffineFunction,
    replacement::MOI.ScalarAffineFunction, row::Int
)
    for term in replacement.terms
        col = _info(model, term.variable).column
        Lib.XPRSchgcoef(
            model.inner, (Cint(row-1)), (Cint(col-1)), 
            Ref(MOI.coefficient(term))
        )
    end
    return
end

"""
    _replace_with_different_sparsity!(
        model::Optimizer,
        previous::MOI.ScalarAffineFunction,
        replacement::MOI.ScalarAffineFunction, row::Int
    )

Internal function, not intended for external use.

    Change the linear constraint function at index `row` in `model` from
`previous` to `replacement`. This function assumes that `previous` and
`replacement` may have different sparsity patterns.

This function (and `_replace_with_matching_sparsity!` above) are necessary
because in order to fully replace a linear constraint, we have to zero out the
current matrix coefficients and then set the new matrix coefficients. When the
sparsity patterns match, the zeroing-out step can be skipped.
"""
function _replace_with_different_sparsity!(
    model::Optimizer,
    previous::MOI.ScalarAffineFunction,
    replacement::MOI.ScalarAffineFunction, row::Int
)
    # First, zero out the old constraint function terms.
    for term in previous.terms
        col = _info(model, term.variable).column
        Lib.XPRSchgcoef(model.inner, (Cint(row - 1)), (Cint(col - 1)), 
        Ref(0.0))
    end

    # Next, set the new constraint function terms.
    for term in previous.terms
        col = _info(model, term.variable).column
        Lib.XPRSchgcoef(model.inner, (Cint(row - 1)), (Cint(col - 1)), 
            Ref(MOI.coefficient(term)))
    end
    return
end

"""
    _matching_sparsity_pattern(
        f1::MOI.ScalarAffineFunction{Float64},
        f2::MOI.ScalarAffineFunction{Float64}
    )

Internal function, not intended for external use.

Determines whether functions `f1` and `f2` have the same sparsity pattern
w.r.t. their constraint columns. Assumes both functions are already in
canonical form.
"""
function _matching_sparsity_pattern(
    f1::MOI.ScalarAffineFunction{Float64}, f2::MOI.ScalarAffineFunction{Float64}
)
    if axes(f1.terms) != axes(f2.terms)
        return false
    end
    for (f1_term, f2_term) in zip(f1.terms, f2.terms)
        if MOI.term_indices(f1_term) != MOI.term_indices(f2_term)
            return false
        end
    end
    return true
end

function MOI.set(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, <:SCALAR_SETS},
    f::MOI.ScalarAffineFunction{Float64}
)
    # TODO: this query is very slow, potentially simply replace everything
    previous = MOI.get(model, MOI.ConstraintFunction(), c)
    MOI.Utilities.canonicalize!(previous)
    replacement = MOI.Utilities.canonical(f)
    # If the previous and replacement constraint functions have exactly
    # the same sparsity pattern, then we can take a faster path by just
    # passing the replacement terms to the model. But if their sparsity
    # patterns differ, then we need to first zero out the previous terms
    # and then set the replacement terms.
    row = _info(model, c).row
    if _matching_sparsity_pattern(previous, replacement)
        _replace_with_matching_sparsity!(model, previous, replacement, row)
    else
        _replace_with_different_sparsity!(model, previous, replacement, row)
    end
    rhs = Xpress.getrhs(model.inner, row, row)
    rhs[1] -= replacement.constant - previous.constant
    Lib.XPRSchgrhs(model.inner, Cint(1), Ref(Cint(row - 1)), Ref(rhs))
    return
end

function _generate_basis_status(model::Optimizer)
    nvars = length(model.variable_info)
    nrows = length(model.affine_constraint_info)
    cstatus = Vector{Cint}(undef, nrows)
    vstatus = Vector{Cint}(undef, nvars)
    getbasis(model.inner, cstatus, vstatus)
    basis_status = BasisStatus(cstatus, vstatus)
    model.basis_status = basis_status
    return
end


function MOI.get(
    model::Optimizer, ::MOI.ConstraintBasisStatus,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64}, S}
) where {S <: SCALAR_SETS}
    row = _info(model, c).row
    basis_status = model.basis_status
    if basis_status == nothing
        _generate_basis_status(model::Optimizer)
        basis_status = model.basis_status
    end
    cstatus = basis_status.con_status
    cbasis = cstatus[row]
    if cbasis == 1
        return MOI.BASIC
    elseif cbasis == 0
        return MOI.NONBASIC
    elseif cbasis == 2
        return MOI.NONBASIC
    elseif cbasis == 3
        return MOI.SUPER_BASIC
    else
        error("CBasis value of $(cbasis) isn't defined.")
    end
end

function MOI.get(
    model::Optimizer, ::MOI.VariableBasisStatus,
    x::MOI.VariableIndex
)
    column = _info(model, x).column
    basis_status = model.basis_status
    if basis_status == nothing
        _generate_basis_status(model::Optimizer)
        basis_status = model.basis_status
    end
    vstatus = basis_status.var_status
    vbasis = vstatus[column]
    if vbasis == 1
        return MOI.BASIC
    elseif vbasis == 0
        return MOI.NONBASIC_AT_LOWER
    elseif vbasis == 2
        return MOI.NONBASIC_AT_UPPER
    elseif vbasis == 3
        return MOI.SUPER_BASIC
    else
        error("VBasis value of $(vbasis) isn't defined.")
    end
end

###
### VectorOfVariables-in-SecondOrderCone
###

function MOI.add_constrained_variables(
    model::Optimizer, s::S
) where S <: Union{MOI.SecondOrderCone, MOI.RotatedSecondOrderCone}
    N = s.dimension
    vis = MOI.add_variables(model, N)
    return vis, MOI.add_constraint(model, MOI.VectorOfVariables(vis), s)
end
function MOI.add_constraint(
    model::Optimizer, f::MOI.VectorOfVariables, s::MOI.SecondOrderCone
)
    if length(f.variables) != s.dimension
        error("Dimension of $(s) does not match number of terms in $(f)")
    end

    N = s.dimension
    vis = f.variables

    # first check any variabel is alread in a (R)SOC

    vs_info = _info.(model, vis)

    has_v_in_soc = false
    for v in vs_info
        if v.in_soc
            has_v_in_soc = true
            break
        end
    end
    if has_v_in_soc
        list = MOI.VariableIndex[]
        for i in 1:N
            if vs_info[i].in_soc
                push!(list, vis[i])
            end
        end
        error("Variables $(list) already belong a to SOC or RSOC constraint")
    end

    # SOC is the cone: t ≥ ||x||₂ ≥ 0. In Xpress' quadratic form, this is
    # Σᵢ xᵢ² - t² <= 0 and t ≥ 0.

    # First, check the lower bound on t.

    t_info = vs_info[1]
    lb = _get_variable_lower_bound(model, t_info)
    if isnan(t_info.lower_bound_if_soc) && lb < 0.0
        t_info.lower_bound_if_soc = lb
        Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(t_info.column-1)), Ref(UInt8('L')), Ref(0.0))
    end
    t_info.num_soc_constraints += 1

    # Now add the quadratic constraint.

    I = Cint[vs_info[i].column for i in 1:N]
    V = fill(1.0, N)
    V[1] = -1.0
    Xpress.addrows(
        model.inner, [Cchar('L')], [0.0], C_NULL, [1], Cint[], Float64[]
    )
    Xpress.addqmatrix(model.inner, Xpress.n_constraints(model.inner), I, I, V)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, SOC)

    # set variables to SOC
    for v in vs_info
        v.in_soc = true
    end
    return MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.SecondOrderCone}(model.last_constraint_index)
end

function MOI.add_constraint(
    model::Optimizer, f::MOI.VectorOfVariables, s::MOI.RotatedSecondOrderCone
)

    if length(f.variables) != s.dimension
        error("Dimension of $(s) does not match number of terms in $(f)")
    end

    N = s.dimension
    vis = f.variables

    # first check any variable is already in a (R)SOC

    vs_info = _info.(model, vis)

    has_v_in_soc = false
    for v in vs_info
        if v.in_soc
            has_v_in_soc = true
            break
        end
    end
    if has_v_in_soc
        list = MOI.VariableIndex[]
        for i in 1:N
            if vs_info[i].in_soc
                push!(list, vis[i])
            end
        end
        error("Variables $(list) already belong a to SOC or RSOC constraint")
    end

    # RSOC is the cone: 2tu ≥ ||x||₂^2 ≥ 0, t ≥ 0, u ≥ 0. In Xpress' quadratic form, this is
    # Σᵢ xᵢ² - 2tu <= 0 and t ≥ 0, u ≥ 0.

    # First, check the lower bound on t and u.

    for i in 1:2
        t_info = vs_info[i]
        lb = _get_variable_lower_bound(model, t_info)
        if isnan(t_info.lower_bound_if_soc) && lb < 0.0
            t_info.lower_bound_if_soc = lb
            Lib.XPRSchgbounds(model.inner, Cint(1), Ref(Cint(t_info.column-1)), Ref(UInt8('L')), Ref(0.0))
        end
        t_info.num_soc_constraints += 1
    end

    # Now add the quadratic constraint.

    I = Cint[vs_info[i].column for i in 1:N if i != 2]
    J = Cint[vs_info[i].column for i in 1:N if i != 1]
    V = fill(1.0, N-1)
    V[1] = -1.0 # just the upper triangle
    Xpress.addrows(
        model.inner, [Cchar('L')], [0.0], C_NULL, [1], Cint[], Float64[]
    )
    Xpress.addqmatrix(model.inner, Xpress.n_constraints(model.inner), I, J, V)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, RSOC)

    # set variables to SOC
    for v in vs_info
        v.in_soc = true
    end
    return MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.RotatedSecondOrderCone}(model.last_constraint_index)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.SecondOrderCone}
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    info = _info(model, c)
    Xpress.delrows(model.inner, [info.row])
    for (key, info_2) in model.affine_constraint_info
        if info_2.row > info.row
            info_2.row -= 1
        end
    end
    model.name_to_constraint_index = nothing
    delete!(model.affine_constraint_info, c.value)
    # free variables from (R)SOC
    for v in _info.(model, f.variables)
        v.in_soc = false
    end
    # Reset the lower bound on the `t` variable.
    t_info = _info(model, f.variables[1])
    t_info.num_soc_constraints -= 1
    if t_info.num_soc_constraints > 0
        # Don't do anything. There are still SOC associated with this variable.
        # This should not happen in Xpress
        error("Error in Xpress' MathOptInteface SOC wrapper.")
        return
    elseif isnan(t_info.lower_bound_if_soc)
        # Don't do anything. It must have a >0 lower bound anyway.
        return
    end
    # There was a previous bound that we over-wrote, and it must have been
    # < 0 otherwise we wouldn't have needed to overwrite it.
    @assert t_info.lower_bound_if_soc < 0.0
    tmp_lower_bound = t_info.lower_bound_if_soc
    t_info.lower_bound_if_soc = NaN
    _set_variable_lower_bound(model, t_info, tmp_lower_bound)
    return
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.RotatedSecondOrderCone}
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    info = _info(model, c)
    Xpress.delrows(model.inner, [info.row])
    for (key, info_2) in model.affine_constraint_info
        if info_2.row > info.row
            info_2.row -= 1
        end
    end
    model.name_to_constraint_index = nothing
    delete!(model.affine_constraint_info, c.value)
    # free variables from (R)SOC
    for v in _info.(model, f.variables)
        v.in_soc = false
    end
    # Reset the lower bound on the `t` and `u` variable.
    for i in 1:2
        t_info = _info(model, f.variables[i])
        t_info.num_soc_constraints -= 1
        if t_info.num_soc_constraints > 0
            # Don't do anything. There are still SOC associated with this variable.
            # This should not happen in Xpress
            error("Error in Xpress' MathOptInteface SOC wrapper.")
            continue
        elseif isnan(t_info.lower_bound_if_soc)
            # Don't do anything. It must have a >0 lower bound anyway.
            continue
        end
        # There was a previous bound that we over-wrote, and it must have been
        # < 0 otherwise we wouldn't have needed to overwrite it.
        @assert t_info.lower_bound_if_soc < 0.0
        tmp_lower_bound = t_info.lower_bound_if_soc
        t_info.lower_bound_if_soc = NaN
        _set_variable_lower_bound(model, t_info, tmp_lower_bound)
    end
    return
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, S}
) where S <: Union{MOI.SecondOrderCone, MOI.RotatedSecondOrderCone}
    return _info(model, c).set
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.SecondOrderCone}
)

    I, J, V = getqrowqmatrixtriplets(model.inner, _info(model, c).row)

    t = nothing
    x = MOI.VariableIndex[]
    sizehint!(x, length(I)-1)
    for (i, j, coef) in zip(I, J, V)
        v = model.variable_info[CleverDicts.LinearIndex(i)].index
        @assert i == j  # Check for no off-diagonals.
        if coef == -1.0
            @assert t === nothing  # There should only be one `t`.
            t = v
        else
            @assert coef == 1.0  # The coefficients _must_ be -1 for `x` terms.
            push!(x, v)
        end
    end
    @assert t !== nothing  # Check that we found a `t` variable.
    return MOI.VectorOfVariables([t; x])
end

function MOI.get(
    model::Optimizer, ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, MOI.RotatedSecondOrderCone}
)

    I, J, V = getqrowqmatrixtriplets(model.inner, _info(model, c).row)

    t = nothing
    u = nothing
    x = MOI.VariableIndex[]
    sizehint!(x, length(I)-2)
    for (i, j, coef) in zip(I, J, V)
        if i == j
            v = model.variable_info[CleverDicts.LinearIndex(i)].index
            @assert coef == 1.0  # The coefficients _must_ be 1 for `x` terms.
            push!(x, v)
        else
            @assert t === nothing
            @assert u === nothing
            @assert coef == -1.0  # The coefficients _must_ be -1 for `t` and `u` term.
            t = model.variable_info[CleverDicts.LinearIndex(i)].index
            u = model.variable_info[CleverDicts.LinearIndex(j)].index
        end
    end
    @assert t !== nothing  # Check that we found a `t` variable.
    @assert u !== nothing  # Check that we found a `u` variable.
    return MOI.VectorOfVariables([t; u; x])
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables, <:Any}
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    return MOI.get(model, MOI.VariablePrimal(), f.variables)
end

###
### IIS
###

function getinfeasbounds(model::Optimizer)
    nvars = length(model.variable_info)
    lbs = getlb(model.inner, 1, nvars)
    ubs = getub(model.inner, 1, nvars)
    check_bounds = lbs .<= ubs
    if sum(check_bounds) == nvars
        error("There was an error in computation")
    end
    if model.moi_warnings
        @warn "Xpress can't find IIS with invalid bounds, the constraints that keep the model infeasible can't be found, only the infeasible bounds will be available"
    end
    col = 0
    ncols = 0
    infeas_cols = []
    for check_col in check_bounds
        if !check_col
            push!(infeas_cols, col)
            ncols += 1
        end
        col += 1
    end
    miiscol = Vector{Cint}(undef, ncols)
    for col = 1:ncols
        miiscol[col] = infeas_cols[col]
    end
    return ncols, miiscol
end

function getfirstiis(model::Optimizer)
    iismode = Cint(1)
    status_code = Array{Cint}(undef, 1)
    Lib.XPRSiisfirst(model.inner, iismode, status_code)

    if status_code[1] == 1
        # The problem is actually feasible.
        return IISData(status_code[1], true, 0, 0, Vector{Cint}(undef, 0), Vector{Cint}(undef, 0), Vector{UInt8}(undef, 0), Vector{UInt8}(undef, 0))
    elseif 2 <= status_code[1] <= 3 # 2 = error, 3 = timeout
        ncols, miiscol = getinfeasbounds(model)
        return IISData(status_code[1], false, 0, ncols, Vector{Cint}(undef, 0), miiscol, Vector{UInt8}(undef, 0), Vector{UInt8}(undef, 0))
    end

    # XPRESS' API works in two steps: first, retrieve the sizes of the arrays to
    # retrieve; then, the user is expected to allocate the needed memory,
    # before asking XPRESS to fill it.

    num = Cint(1)
    rownumber = Vector{Cint}(undef, 1)
    colnumber = Vector{Cint}(undef, 1)
    Xpress.getiisdata(
        model.inner, num, rownumber, colnumber, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)

    nrows = rownumber[1]
    ncols = colnumber[1]
    miisrow = Vector{Cint}(undef, nrows)
    miiscol = Vector{Cint}(undef, ncols)
    constrainttype = Vector{UInt8}(undef, nrows)
    colbndtype = Vector{UInt8}(undef, ncols)
    Xpress.getiisdata(
        model.inner, num, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, C_NULL, C_NULL, C_NULL, C_NULL)

    return IISData(status_code[1], true, nrows, ncols, miisrow, miiscol, constrainttype, colbndtype)
end

function MOI.compute_conflict!(model::Optimizer)
    model.conflict = getfirstiis(model)
    return
end

function _ensure_conflict_computed(model::Optimizer)
    if model.conflict === nothing
        error("Cannot access conflict status. Call `MOI.compute_conflict!(model)` first. " *
              "In case the model is modified, the computed conflict will not be purged.")
    end
end

function MOI.get(model::Optimizer, ::MOI.ConflictStatus)
    if model.conflict === nothing
        return MOI.COMPUTE_CONFLICT_NOT_CALLED
    elseif model.conflict.stat == 0 || !model.conflict.is_standard_iis
        # Currently this condition (!model.conflict.is_standard_iis) is always false.
        return MOI.CONFLICT_FOUND
    elseif model.conflict.stat == 1
        return MOI.NO_CONFLICT_EXISTS
    else
        # stat == 2 -> error
        # stat == 3 -> timeout
        return MOI.NO_CONFLICT_FOUND
        # return error("IIS failed internally.")
    end
end

function MOI.supports(::Optimizer, ::MOI.ConflictStatus)
    return true
end

function MOI.get(model::Optimizer, ::MOI.ConstraintConflictStatus, index::MOI.ConstraintIndex{<:MOI.ScalarAffineFunction, <:Union{MOI.LessThan, MOI.GreaterThan, MOI.EqualTo}})
    _ensure_conflict_computed(model)
    return (_info(model, index).row - 1) in model.conflict.miisrow ? MOI.IN_CONFLICT : MOI.NOT_IN_CONFLICT
end

col_type_char(::Type{MOI.LessThan{Float64}}) = 'U'
col_type_char(::Type{MOI.GreaterThan{Float64}}) = 'L'
col_type_char(::Type{MOI.EqualTo{Float64}}) = 'F'
# col_type_char(::Type{MOI.Interval{Float64}}) = 'T'
col_type_char(::Type{MOI.ZeroOne}) = 'B'
col_type_char(::Type{MOI.Integer}) = 'I'
col_type_char(::Type{MOI.Semicontinuous{Float64}}) = 'S'
col_type_char(::Type{MOI.Semiinteger{Float64}}) = 'R'
function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{MOI.VariableIndex, S}
) where S <: MOI.AbstractScalarSet
    _ensure_conflict_computed(model)
    _char = col_type_char(S)
    ref_col = _info(model, index).column - 1
    for (idx, col) in enumerate(model.conflict.miiscol)
        if col == ref_col && (
            model.conflict.stat > 1 ||
            Char(model.conflict.colbndtype[idx]) == _char
            )
            return MOI.IN_CONFLICT
        end
    end
    return MOI.NOT_IN_CONFLICT
end
function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{MOI.VariableIndex, MOI.Interval{Float64}}
)
    _ensure_conflict_computed(model)
    ref_col = _info(model, index).column - 1
    for (idx, col) in enumerate(model.conflict.miiscol)
        if col == ref_col && (
            model.conflict.stat > 1 ||
            Char(model.conflict.colbndtype[idx]) == 'U' ||
            Char(model.conflict.colbndtype[idx]) == 'L'
            )
            return MOI.IN_CONFLICT
        end
    end
    return MOI.NOT_IN_CONFLICT
end
function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{MOI.VariableIndex, MOI.ZeroOne}
) where S <: MOI.AbstractScalarSet
    _ensure_conflict_computed(model)
    ref_col = _info(model, index).column - 1
    for (idx, col) in enumerate(model.conflict.miiscol)
        if col == ref_col
            if Char(model.conflict.colbndtype[idx]) == 'B'
                return MOI.IN_CONFLICT
            elseif Char(model.conflict.colbndtype[idx]) == 'U'
                return MOI.MAYBE_IN_CONFLICT
            elseif Char(model.conflict.colbndtype[idx]) == 'L'
                return MOI.MAYBE_IN_CONFLICT
            end
        end
    end
    return MOI.NOT_IN_CONFLICT
end
function MOI.supports(
    ::Optimizer,
    ::MOI.ConstraintConflictStatus,
    ::Type{MOI.ConstraintIndex{<:MOI.VariableIndex, <:SCALAR_SETS}}
)
    return true
end

function MOI.supports(
    ::Optimizer,
    ::MOI.ConstraintConflictStatus,
    ::Type{MOI.ConstraintIndex{
        <:MOI.ScalarAffineFunction,
        <:Union{MOI.LessThan, MOI.GreaterThan, MOI.EqualTo}
    }}
)
    return true
end

include("MOI_callbacks.jl")

function extension(str::String)
    try
        match(r"\.[A-Za-z0-9]+$", str).match
    catch
        ""
    end
end

function MOI.write_to_file(model::Optimizer, name::String)
    ext = extension(name)
    if ext == ".lp"
        Xpress.writeprob(model.inner, name, "l")
    elseif ext == ".mps"
        Xpress.writeprob(model.inner, name)
    else
        Xpress.writeprob(model.inner, name, "l")
    end
end

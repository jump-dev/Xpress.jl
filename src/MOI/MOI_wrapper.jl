# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

const CleverDicts = MOI.Utilities.CleverDicts

@enum(VariableType, CONTINUOUS, BINARY, INTEGER, SEMIINTEGER, SEMICONTINUOUS)

@enum(
    ConstraintType,
    AFFINE,
    INDICATOR,
    QUADRATIC,
    SOC,
    RSOC,
    SOS_SET,
    SCALAR_NONLINEAR,
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

@enum(ObjectiveType, SINGLE_VARIABLE, SCALAR_AFFINE, SCALAR_QUADRATIC)

@enum(CallbackState, CB_NONE, CB_GENERIC, CB_LAZY, CB_USER_CUT, CB_HEURISTIC)

const SCALAR_SETS = Union{
    MOI.GreaterThan{Float64},
    MOI.LessThan{Float64},
    MOI.EqualTo{Float64},
    MOI.Interval{Float64},
}

const SIMPLE_SCALAR_SETS =
    Union{MOI.GreaterThan{Float64},MOI.LessThan{Float64},MOI.EqualTo{Float64}}

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
    start::Union{Float64,Nothing}
    name::String

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
            NaN,
            0,
            false,
            NaN,
            NaN,
            NaN,
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

    function ConstraintInfo(
        row::Int,
        set::MOI.AbstractSet,
        type::ConstraintType,
    )
        return new(row, set, "", type)
    end
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
    cutptrs::Vector{Lib.XPRScut}
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
    rownumber::Int # number of rows participating in the IIS
    colnumber::Int # number of columns participating in the IIS
    miisrow::Vector{Cint} # index of the rows that participate
    miiscol::Vector{Cint} # index of the columns that participate
    constrainttype::Vector{UInt8} # sense of the rows that participate
    colbndtype::Vector{UInt8} # sense of the column bounds that participate
end

"""
    Optimizer()

Create a new Optimizer object.
"""
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
    affine_constraint_info::Dict{Int,ConstraintInfo}
    # VectorOfVariables-in-Set storage.
    sos_constraint_info::Dict{Int,ConstraintInfo}
    # Note: we do not have a singlevariable_constraint_info dictionary. Instead,
    # data associated with these constraints are stored in the VariableInfo
    # objects.

    # Mappings from variable and constraint names to their indices. These are
    # lazily built on-demand, so most of the time, they are `nothing`.
    name_to_variable::Union{
        Nothing,
        Dict{String,Union{Nothing,MOI.VariableIndex}},
    }
    name_to_constraint_index::Union{
        Nothing,
        Dict{String,Union{Nothing,MOI.ConstraintIndex}},
    }

    # TODO: add functionality to the lower-level API to support querying single
    # elements of the solution.

    cached_solution::Union{Nothing,CachedSolution}
    basis_status::Union{Nothing,BasisStatus}
    conflict::Union{Nothing,IISData}
    termination_status::MOI.TerminationStatusCode
    primal_status::MOI.ResultStatusCode
    dual_status::MOI.ResultStatusCode

    solve_method::String
    solve_relaxation::Bool

    #Stores the input and output of derivatives
    forward_sensitivity_cache::Union{Nothing,SensitivityCache}
    backward_sensitivity_cache::Union{Nothing,SensitivityCache}

    # Callback fields.
    callback_cached_solution::Union{Nothing,CachedSolution}
    cb_cut_data::CallbackCutData
    callback_state::CallbackState
    cb_exception::Union{Nothing,Exception}

    lazy_callback::Union{Nothing,Function}
    user_cut_callback::Union{Nothing,Function}
    heuristic_callback::Union{Nothing,Function}

    has_generic_callback::Bool
    callback_data::Union{Nothing,Tuple{Ptr{Nothing},_CallbackUserData}}
    message_callback::Union{Nothing,Tuple{Ptr{Nothing},_CallbackUserData}}

    params::Dict{Any,Any}

    has_nlp_constraints::Bool

    xpress_version::VersionNumber
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
        model.variable_info =
            CleverDicts.CleverDict{MOI.VariableIndex,VariableInfo}()
        model.affine_constraint_info = Dict{Int,ConstraintInfo}()
        model.sos_constraint_info = Dict{Int,ConstraintInfo}()
        model.xpress_version = VersionNumber(0)
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
    model.xpress_version = Xpress.get_version()
    MOI.set(model, MOI.RawOptimizerAttribute("MPSNAMELENGTH"), 64)
    callback_main_thread = if model.xpress_version >= VersionNumber((46, 0, 0))
        "CALLBACKFROMMAINTHREAD"
    else
        # Kept for compatibility with older versions
        "CALLBACKFROMMASTERTHREAD"
    end
    MOI.set(model, MOI.RawOptimizerAttribute(callback_main_thread), 1)
    MOI.set(
        model,
        MOI.RawOptimizerAttribute("XPRESS_WARNING_WINDOWS"),
        model.show_warning,
    )
    log_level = model.log_level
    # silently load a empty model - to avoid useless printing
    if log_level != 0
        MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), 0)
    end
    @checked Lib.XPRSloadlp(
        model.inner,
        "",
        0,
        0,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    if log_level != 0
        MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), log_level)
    end
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
    model.cb_cut_data = CallbackCutData(false, Array{Lib.XPRScut}(undef, 0))
    model.callback_state = CB_NONE
    model.cb_exception = nothing
    model.forward_sensitivity_cache = nothing
    model.backward_sensitivity_cache = nothing
    model.lazy_callback = nothing
    model.user_cut_callback = nothing
    model.heuristic_callback = nothing
    model.has_generic_callback = false
    model.callback_data = nothing
    for (name, value) in model.params
        MOI.set(model, name, value)
    end
    model.has_nlp_constraints = false
    return
end

function MOI.is_empty(model::Optimizer)
    return isempty(model.name) &&
           model.objective_type == SCALAR_AFFINE &&
           !model.is_objective_set &&
           model.objective_sense === nothing &&
           isempty(model.variable_info) &&
           isempty(model.affine_constraint_info) &&
           isempty(model.sos_constraint_info) &&
           model.name_to_variable === nothing &&
           model.name_to_constraint_index === nothing &&
           model.cached_solution === nothing &&
           model.basis_status === nothing &&
           model.conflict === nothing &&
           model.termination_status == MOI.OPTIMIZE_NOT_CALLED &&
           model.primal_status == MOI.NO_SOLUTION &&
           model.dual_status == MOI.NO_SOLUTION &&
           model.callback_cached_solution === nothing &&
           model.callback_state == CB_NONE &&
           model.cb_exception === nothing &&
           model.lazy_callback === nothing &&
           model.user_cut_callback === nothing &&
           model.heuristic_callback === nothing &&
           !model.has_generic_callback &&
           model.callback_data === nothing
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
            NaN,
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
            NaN,
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
    return MOI.get(optimizer, MOI.RawOptimizerAttribute("XPRESSVERSION"))
end

function MOI.supports_add_constrained_variables(
    ::Optimizer,
    ::Type{F},
) where {F<:Union{MOI.SecondOrderCone,MOI.RotatedSecondOrderCone}}
    # Xpress only supports disjoint sets of SOC and RSOC (with no affine forms)
    # hence we only allow constraints on creation
    return true
end

# We choose _not_ to support ScalarAffineFunction-in-Interval and
# ScalarQuadraticFunction-in-Interval due to the need for range constraints
# and the added complexity.

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.ScalarAffineFunction{Float64}},
    ::Type{F},
) where {F<:SIMPLE_SCALAR_SETS}
    return true
end

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.ScalarQuadraticFunction{Float64}},
    ::Type{F},
) where {F<:Union{MOI.LessThan{Float64},MOI.GreaterThan{Float64}}}
    # Note: Xpress does not support quadratic equality constraints.
    return true
end

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{<:MOI.VectorAffineFunction},
    ::Type{T},
) where {T<:INDICATOR_SETS}
    return true
end

#=
    MOI.RawOptimizerAttribute
=#

function MOI.supports(model::Optimizer, attr::MOI.RawOptimizerAttribute)
    if attr.name in (
        "logfile",
        "MOI_POST_SOLVE",
        "MOI_IGNORE_START",
        "MOI_WARNINGS",
        "MOI_SOLVE_MODE",
        "XPRESS_WARNING_WINDOWS",
    )
        return true
    end
    p_id, p_type = Ref{Cint}(), Ref{Cint}()
    ret = Lib.XPRSgetcontrolinfo(model.inner, attr.name, p_id, p_type)
    if ret != 0 || p_type[] == Lib.XPRS_TYPE_NOTDEFINED
        ret = Lib.XPRSgetattribinfo(model.inner, attr.name, p_id, p_type)
    end
    p_type_fail = p_type[] in (Lib.XPRS_TYPE_NOTDEFINED, Lib.XPRS_TYPE_INT64)
    return ret == 0 && !p_type_fail
end

function MOI.set(model::Optimizer, param::MOI.RawOptimizerAttribute, value)
    if !MOI.supports(model, param)
        throw(MOI.UnsupportedAttribute(param))
    elseif param == MOI.RawOptimizerAttribute("logfile")
        model.inner.logfile = value
        reset_message_callback(model)
        value = ifelse(value == "", C_NULL, value)
        @checked Lib.XPRSsetlogfile(model.inner, value)
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
        setcontrol!(model.inner, "OUTPUTLOG", value)
        reset_message_callback(model)
    else
        setcontrol!(model.inner, param.name, value)
    end
    # Always store value in params dictionary when setting. This is because when
    # calling `MOI.empty!` we create a new XpressProblem and want to set all the
    # raw parameters and attributes again.
    model.params[param] = value
    return
end

function reset_message_callback(model)
    if model.message_callback !== nothing
        # remove all message callbacks
        @checked Lib.XPRSremovecbmessage(model.inner, C_NULL, C_NULL)
        model.message_callback = nothing
    end
    if isempty(model.inner.logfile) && model.log_level != 0
        model.message_callback = setoutputcb!(model.inner, model.show_warning)
    end
    return
end

function MOI.get(model::Optimizer, param::MOI.RawOptimizerAttribute)
    if !MOI.supports(model, param)
        throw(MOI.UnsupportedAttribute(param))
    elseif param == MOI.RawOptimizerAttribute("logfile")
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
    end
    return get_control_or_attribute(model.inner, param.name)
end

#=
    MOI.TimeLimitSec
=#

MOI.supports(::Optimizer, ::MOI.TimeLimitSec) = true

function MOI.set(model::Optimizer, ::MOI.TimeLimitSec, lim::Union{Real,Nothing})
    # 0     No time limit.
    # n > 0 If an integer solution has been found, stop MIP search after n ...
    # n < 0 Stop in LP or MIP search after n seconds.
    n = -floor(Cint, something(lim, 0.0))
    MOI.set(model, MOI.RawOptimizerAttribute("MAXTIME"), n)
    return
end

function MOI.get(model::Optimizer, ::MOI.TimeLimitSec)
    ret = MOI.get(model, MOI.RawOptimizerAttribute("MAXTIME"))
    return convert(Float64, -ret)
end

MOI.supports_incremental_interface(::Optimizer) = true

function MOI.copy_to(dest::Optimizer, src::MOI.ModelLike)
    return MOI.Utilities.default_copy_to(dest, src)
end

function MOI.get(model::Optimizer, ::MOI.ListOfVariableAttributesSet)
    ret = MOI.AbstractVariableAttribute[]
    if any(!isempty(info.name) for info in values(model.variable_info))
        push!(ret, MOI.VariableName())
    end
    if any(info.start !== nothing for info in values(model.variable_info))
        push!(ret, MOI.VariablePrimalStart())
    end
    return ret
end

function MOI.get(model::Optimizer, ::MOI.ListOfModelAttributesSet)
    attributes = MOI.AbstractModelAttribute[]
    if MOI.is_empty(model)
        return attributes
    end
    if model.objective_sense !== nothing
        push!(attributes, MOI.ObjectiveSense())
    end
    F = MOI.get(model, MOI.ObjectiveFunctionType())
    if F !== nothing
        push!(attributes, MOI.ObjectiveFunction{F}())
    end
    if !isempty(MOI.get(model, MOI.Name()))
        push!(attributes, MOI.Name())
    end
    return attributes
end

function MOI.get(
    ::Optimizer,
    ::MOI.ListOfConstraintAttributesSet{MOI.VariableIndex},
)
    return MOI.AbstractConstraintAttribute[]
end

function MOI.get(
    model::Optimizer,
    ::MOI.ListOfConstraintAttributesSet{F,S},
) where {F,S}
    ret = MOI.AbstractConstraintAttribute[]
    for ci in MOI.get(model, MOI.ListOfConstraintIndices{F,S}())
        if !isempty(MOI.get(model, MOI.ConstraintName(), ci))
            push!(ret, MOI.ConstraintName())
            break
        end
    end
    return ret
end

function _indices_and_coefficients(
    indices::AbstractVector{Cint},
    coefficients::AbstractVector{Cdouble},
    model::Optimizer,
    f::MOI.ScalarAffineFunction{Float64},
)
    for (i, term) in enumerate(f.terms)
        indices[i] = Cint(_info(model, term.variable).column - 1)
        coefficients[i] = term.coefficient
    end
    return indices, coefficients
end

function _indices_and_coefficients(
    model::Optimizer,
    f::MOI.ScalarAffineFunction{Float64},
)
    f_canon = MOI.Utilities.canonical(f)
    nnz = length(f_canon.terms)
    indices = Vector{Cint}(undef, nnz)
    coefficients = Vector{Float64}(undef, nnz)
    _indices_and_coefficients(indices, coefficients, model, f_canon)
    return indices, coefficients
end

function _indices_and_coefficients_indicator(
    model::Optimizer,
    f::MOI.VectorAffineFunction{Float64},
)
    indices = Vector{Cint}(undef, length(f.terms) - 1)
    coefficients = Vector{Float64}(undef, length(f.terms) - 1)
    i = 1
    for fi in f.terms
        if fi.output_index != 1
            indices[i] = Cint(_info(model, fi.scalar_term.variable).column - 1)
            coefficients[i] = fi.scalar_term.coefficient
            i += 1
        end
    end
    return indices, coefficients
end

function _indices_and_coefficients(
    I::AbstractVector{Cint},
    J::AbstractVector{Cint},
    V::AbstractVector{Float64},
    indices::AbstractVector{Cint},
    coefficients::AbstractVector{Float64},
    model::Optimizer,
    f::MOI.ScalarQuadraticFunction{Float64},
)
    for (i, term) in enumerate(f.quadratic_terms)
        I[i] = Cint(_info(model, term.variable_1).column - 1)
        J[i] = Cint(_info(model, term.variable_2).column - 1)
        V[i] = term.coefficient
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
        indices[i] = Cint(_info(model, term.variable).column - 1)
        coefficients[i] = term.coefficient
    end
    return
end

function _indices_and_coefficients(
    model::Optimizer,
    f::MOI.ScalarQuadraticFunction,
)
    f_canon = MOI.Utilities.canonical(f)
    nnz_quadratic = length(f_canon.quadratic_terms)
    nnz_affine = length(f_canon.affine_terms)
    I = Vector{Cint}(undef, nnz_quadratic)
    J = Vector{Cint}(undef, nnz_quadratic)
    V = Vector{Float64}(undef, nnz_quadratic)
    indices = Vector{Cint}(undef, nnz_affine)
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
        model.variable_info,
        VariableInfo(MOI.VariableIndex(0), 0),
    )
    info = _info(model, index)
    info.index = index
    info.column = length(model.variable_info)
    @checked Lib.XPRSaddcols(
        model.inner,
        1,          # length(_dbdl)::Int,
        0,          # length(_dmatval)::Int,
        Ref(0.0),   # _dobj::Vector{Float64},
        C_NULL,     # Cint.(_mrwind::Vector{Int}),
        C_NULL,     # Cint.(_mrstart::Vector{Int}),
        C_NULL,     # _dmatval::Vector{Float64},
        Ref(-Inf),  # _dbdl::Vector{Float64},
        Ref(Inf),   # _dbdu::Vector{Float64}
    )
    return index
end

function MOI.add_variables(model::Optimizer, N::Int)
    @checked Lib.XPRSaddcols(
        model.inner,
        N,              # length(_dbdl)::Int,
        0,              # length(_dmatval)::Int,
        zeros(N),       # _dobj::Vector{Float64},
        C_NULL,         # Cint.(_mrwind::Vector{Int}),
        C_NULL,         # Cint.(_mrstart::Vector{Int}),
        C_NULL,         # _dmatval::Vector{Float64},
        fill(-Inf, N),  #  _dbdl::Vector{Float64},
        fill(Inf, N),   # _dbdu::Vector{Float64}
    )
    indices = Vector{MOI.VariableIndex}(undef, N)
    num_variables = length(model.variable_info)
    for i in 1:N
        # Initialize `VariableInfo` with a dummy `VariableIndex` and a column,
        # because we need `add_item` to tell us what the `VariableIndex` is.
        index = CleverDicts.add_item(
            model.variable_info,
            VariableInfo(MOI.VariableIndex(0), 0),
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
    @checked Lib.XPRSdelcols(model.inner, 1, Ref{Cint}(info.column - 1))
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
    model.name_to_variable = Dict{String,Union{Nothing,MOI.VariableIndex}}()
    for (index, info) in model.variable_info
        if isempty(info.name)
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

#=
    MOI.VariableName
=#

MOI.supports(::Optimizer, ::MOI.VariableName, ::Type{MOI.VariableIndex}) = true

function MOI.get(model::Optimizer, ::MOI.VariableName, v::MOI.VariableIndex)
    return _info(model, v).name
end

function MOI.set(
    model::Optimizer,
    ::MOI.VariableName,
    v::MOI.VariableIndex,
    name::String,
)
    info = _info(model, v)
    info.name = name
    # Note: don't set the string names in the Xpress C API because it complains
    # on duplicate variables, that is, don't call `Lib.XPRSaddnames`.
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
    rows = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ROWS, _)::Int
    spare_rows =
        @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_SPAREROWS, _)::Int
    cols = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_COLS, _)::Int
    # 1 - Create vector 'aux_vector' of size ROWS of type Float64 (constraints)
    aux_vector = copy(model.forward_sensitivity_cache.input)
    # 2 - Call XPRSftran with vector 'aux_vector' as an argument
    @checked Lib.XPRSftran(model.inner, aux_vector)
    # 3 - Create Dict of Basic variable to All variables
    basic_variables_ordered = Vector{Cint}(undef, rows)
    @checked Lib.XPRSgetpivotorder(model.inner, basic_variables_ordered)
    aux_dict = Dict{Int,Int}()
    for i in 1:length(basic_variables_ordered)
        if rows + spare_rows <=
           basic_variables_ordered[i] <=
           rows + spare_rows + cols - 1
            aux_dict[i] = basic_variables_ordered[i] - (rows + spare_rows) + 1
        end
    end
    # 5 - Populate vector of All variables with the correct value of the Basic
    #     variables
    fill!(model.forward_sensitivity_cache.output, 0.0)
    for (bi, vi) in aux_dict
        model.forward_sensitivity_cache.output[vi] = aux_vector[bi]
    end
    return
end

function backward(model::Optimizer)
    rows = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ROWS, _)::Int
    spare_rows =
        @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_SPAREROWS, _)::Int
    cols = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_COLS, _)::Int
    # 1 - Get Basic variables
    basic_variables_ordered = Vector{Int32}(undef, rows)
    @checked Lib.XPRSgetpivotorder(model.inner, basic_variables_ordered)
    aux_dict = Dict{Int,Int}()
    for i in 1:length(basic_variables_ordered)
        if rows + spare_rows <=
           basic_variables_ordered[i] <=
           rows + spare_rows + cols - 1
            aux_dict[i] = basic_variables_ordered[i] - (rows + spare_rows) + 1
        end
    end
    # 2 - Create vector 'aux_vector' of size ROWS of type Float64 (constraints)
    #     initialized at zero
    aux_vector = zeros(rows)
    # 3 - Populate vector 'aux_vector' with the respective values in the correct
    #     positions of the basic variables
    for (bi, vi) in aux_dict
        aux_vector[bi] = model.backward_sensitivity_cache.input[vi]
    end
    # 4 - Call XPRSbtran with vector 'aux_vector' as an argument
    @checked Lib.XPRSbtran(model.inner, aux_vector)
    # 5 - Set constraint_output equal to vector 'aux_vector'
    model.backward_sensitivity_cache.output .= aux_vector
    return
end

function MOI.set(
    model::Optimizer,
    ::ForwardSensitivityInputConstraint,
    ci::MOI.ConstraintIndex,
    value::Float64,
)
    rows = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ROWS, _)::Int
    cols = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_COLS, _)::Int
    if model.forward_sensitivity_cache === nothing
        model.forward_sensitivity_cache =
            SensitivityCache(zeros(rows), zeros(cols), false)
    elseif length(model.forward_sensitivity_cache.input) != rows
        model.forward_sensitivity_cache.input = zeros(rows)
    end
    model.forward_sensitivity_cache.input[_info(model, ci).row] = value
    model.forward_sensitivity_cache.is_updated = false
    return
end

function MOI.get(
    model::Optimizer,
    ::ForwardSensitivityOutputVariable,
    vi::MOI.VariableIndex,
)
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
    model::Optimizer,
    ::BackwardSensitivityInputVariable,
    vi::MOI.VariableIndex,
    value::Float64,
)
    rows = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ROWS, _)::Int
    cols = @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_COLS, _)::Int
    if model.backward_sensitivity_cache === nothing
        model.backward_sensitivity_cache =
            SensitivityCache(zeros(cols), zeros(rows), false)
    elseif length(model.backward_sensitivity_cache.input) != cols
        model.backward_sensitivity_cache.input = zeros(cols)
    end
    model.backward_sensitivity_cache.input[_info(model, vi).column] = value
    model.backward_sensitivity_cache.is_updated = false
    return
end

function MOI.get(
    model::Optimizer,
    ::BackwardSensitivityOutputConstraint,
    ci::MOI.ConstraintIndex,
)
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
    if model.objective_type == SCALAR_QUADRATIC
        # We need to zero out the existing quadratic objective.
        @checked Lib.XPRSdelqmatrix(model.inner, -1)
    end
    num_vars = Cint(length(model.variable_info))
    @checked Lib.XPRSchgobj(
        model.inner,
        num_vars,
        collect(Cint(0):Cint(num_vars-1)),
        zeros(Float64, num_vars),
    )
    @checked Lib.XPRSchgobj(model.inner, Cint(1), Ref{Cint}(-1), Ref(0.0))
    return
end

#=
    MOI.ObjectiveSense
=#

MOI.supports(::Optimizer, ::MOI.ObjectiveSense) = true

function MOI.set(
    model::Optimizer,
    ::MOI.ObjectiveSense,
    sense::MOI.OptimizationSense,
)
    if sense == MOI.MIN_SENSE
        @checked Lib.XPRSchgobjsense(model.inner, Lib.XPRS_OBJ_MINIMIZE)
    elseif sense == MOI.MAX_SENSE
        @checked Lib.XPRSchgobjsense(model.inner, Lib.XPRS_OBJ_MAXIMIZE)
    else
        @assert sense == MOI.FEASIBILITY_SENSE
        _zero_objective(model)
        @checked Lib.XPRSchgobjsense(model.inner, Lib.XPRS_OBJ_MINIMIZE)
    end
    model.objective_sense = sense
    return
end

function MOI.get(model::Optimizer, ::MOI.ObjectiveSense)
    return something(model.objective_sense, MOI.FEASIBILITY_SENSE)
end

#=
    MOI.ObjectiveFunction
=#

function MOI.supports(
    ::Optimizer,
    ::MOI.ObjectiveFunction{F},
) where {
    F<:Union{
        MOI.VariableIndex,
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
    },
}
    return true
end

function MOI.set(
    model::Optimizer,
    ::MOI.ObjectiveFunction{F},
    f::F,
) where {F<:MOI.VariableIndex}
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        convert(MOI.ScalarAffineFunction{Float64}, f),
    )
    model.objective_type = SINGLE_VARIABLE
    model.is_objective_set = true
    return
end

function MOI.get(model::Optimizer, ::MOI.ObjectiveFunction{MOI.VariableIndex})
    obj = MOI.get(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
    )
    return convert(MOI.VariableIndex, obj)
end

function MOI.set(
    model::Optimizer,
    ::MOI.ObjectiveFunction{F},
    f::F,
) where {F<:MOI.ScalarAffineFunction{Float64}}
    if model.objective_type == SCALAR_QUADRATIC
        # We need to zero out the existing quadratic objective.
        @checked Lib.XPRSdelqmatrix(model.inner, -1)
    end
    num_vars = length(model.variable_info)
    # We zero all terms because we want to gurantee that the old terms
    # are removed
    obj = zeros(Float64, num_vars)
    for term in f.terms
        column = _info(model, term.variable).column
        obj[column] += term.coefficient
    end
    @checked Lib.XPRSchgobj(
        model.inner,
        Cint(num_vars),
        collect(Cint(0):Cint(num_vars-1)),
        obj,
    )
    @checked Lib.XPRSchgobj(
        model.inner,
        Cint(1),
        Ref{Cint}(-1),
        Ref(-f.constant),
    )
    model.objective_type = SCALAR_AFFINE
    model.is_objective_set = true
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
)
    ncols = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALCOLS,
        _,
    )::Int
    first = 0
    last = ncols - 1
    _dobj = Vector{Float64}(undef, ncols)
    @checked Lib.XPRSgetobj(model.inner, _dobj, first, last)
    dest = _dobj
    terms = MOI.ScalarAffineTerm{Float64}[]
    for (index, info) in model.variable_info
        coefficient = dest[info.column]
        iszero(coefficient) && continue
        push!(terms, MOI.ScalarAffineTerm(coefficient, index))
    end
    constant =
        @_invoke Lib.XPRSgetdblattrib(model.inner, Lib.XPRS_OBJRHS, _)::Float64
    return MOI.ScalarAffineFunction(terms, constant)
end

function MOI.set(
    model::Optimizer,
    ::MOI.ObjectiveFunction{F},
    f::F,
) where {F<:MOI.ScalarQuadraticFunction{Float64}}
    # setting linear part also clears the existing quadratic terms
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(f.affine_terms, f.constant),
    )
    affine_indices, affine_coefficients, I, J, V =
        _indices_and_coefficients(model, f)
    obj = zeros(length(model.variable_info))
    for (i, c) in zip(affine_indices, affine_coefficients)
        obj[i+1] = c
    end
    @checked Lib.XPRSchgmqobj(model.inner, length(I), I, J, V)
    model.objective_type = SCALAR_QUADRATIC
    model.is_objective_set = true
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarQuadraticFunction{Float64}},
)
    dest = zeros(length(model.variable_info))
    nnz = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALQELEMS, _)::Int
    )
    n = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALCOLS,
        _,
    )::Int
    nels = Ref{Cint}(nnz)
    mstart = Array{Cint}(undef, n + 1)
    mclind = Array{Cint}(undef, nnz)
    dobjval = Array{Float64}(undef, nnz)
    @checked Lib.XPRSgetmqobj(
        model.inner,
        mstart,
        mclind,
        dobjval,
        nnz,
        nels,
        Cint(0),
        Cint(n - 1),
    )
    triangle_nnz = nels[]
    mstart[end] = triangle_nnz
    I = Array{Cint}(undef, triangle_nnz)
    J = Array{Cint}(undef, triangle_nnz)
    V = Array{Float64}(undef, triangle_nnz)
    for i in 1:(length(mstart)-1)
        for j in (mstart[i]+1):mstart[i+1]
            I[j] = i
            J[j] = mclind[j] + 1
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
                model.variable_info[CleverDicts.LinearIndex(j)].index,
            ),
        )
    end
    affine_terms = MOI.get(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
    ).terms
    constant =
        @_invoke Lib.XPRSgetdblattrib(model.inner, Lib.XPRS_OBJRHS, _)::Float64
    return MOI.ScalarQuadraticFunction(q_terms, affine_terms, constant)
end

function MOI.modify(
    model::Optimizer,
    ::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chg::MOI.ScalarConstantChange{Float64},
)
    @checked Lib.XPRSchgobj(
        model.inner,
        Cint(1),
        Ref{Cint}(-1),
        Ref(-chg.new_constant),
    )
    return
end

##
##  VariableIndex-in-Set constraints.
##

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.VariableIndex},
    ::Type{S},
) where {
    S<:Union{
        MOI.EqualTo{Float64},
        MOI.LessThan{Float64},
        MOI.GreaterThan{Float64},
        MOI.Interval{Float64},
        MOI.ZeroOne,
        MOI.Integer,
        MOI.Semicontinuous{Float64},
        MOI.Semiinteger{Float64},
    },
}
    return true
end

function _info(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,<:Any},
)
    var_index = MOI.VariableIndex(c.value)
    if haskey(model.variable_info, var_index)
        return _info(model, var_index)
    end
    return throw(MOI.InvalidIndex(c))
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.LessThan{Float64}},
)
    if haskey(model.variable_info, MOI.VariableIndex(c.value))
        info = _info(model, c)
        return info.bound == LESS_THAN || info.bound == LESS_AND_GREATER_THAN
    end
    return false
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.GreaterThan{Float64}},
)
    if haskey(model.variable_info, MOI.VariableIndex(c.value))
        info = _info(model, c)
        return info.bound == GREATER_THAN || info.bound == LESS_AND_GREATER_THAN
    end
    return false
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Interval{Float64}},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).bound == INTERVAL
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.EqualTo{Float64}},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).bound == EQUAL_TO
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.ZeroOne},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).type == BINARY
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Integer},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).type == INTEGER
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semicontinuous{Float64}},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).type == SEMICONTINUOUS
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semiinteger{Float64}},
)
    return haskey(model.variable_info, MOI.VariableIndex(c.value)) &&
           _info(model, c).type == SEMIINTEGER
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VariableIndex,<:Any},
)
    MOI.throw_if_not_valid(model, c)
    return MOI.VariableIndex(c.value)
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VariableIndex,<:Any},
    ::MOI.VariableIndex,
)
    return throw(MOI.SettingVariableIndexNotAllowed())
end

_bounds(s::MOI.GreaterThan{Float64}) = (s.lower, nothing)
_bounds(s::MOI.LessThan{Float64}) = (nothing, s.upper)
_bounds(s::MOI.EqualTo{Float64}) = (s.value, s.value)
_bounds(s::MOI.Interval{Float64}) = (s.lower, s.upper)

function _throw_if_existing_lower(
    bound::BoundType,
    var_type::VariableType,
    new_set::Type{<:MOI.AbstractSet},
    variable::MOI.VariableIndex,
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
        throw(MOI.LowerBoundAlreadySet{existing_set,new_set}(variable))
    end
    return
end

function _throw_if_existing_upper(
    bound::BoundType,
    var_type::VariableType,
    new_set::Type{<:MOI.AbstractSet},
    variable::MOI.VariableIndex,
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
        throw(MOI.UpperBoundAlreadySet{existing_set,new_set}(variable))
    end
    return
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VariableIndex,
    s::S,
) where {S<:SCALAR_SETS}
    info = _info(model, f)
    if info.type == BINARY
        lower, upper = something.(_bounds(s), (0.0, 1.0))
        if (1 < lower) || (upper < 0) || (0 < lower && upper < 1)
            error("The problem is infeasible")
        end
    end
    if S <: MOI.LessThan{Float64}
        _throw_if_existing_upper(info.bound, info.type, S, f)
        info.bound =
            info.bound == GREATER_THAN ? LESS_AND_GREATER_THAN : LESS_THAN
    elseif S <: MOI.GreaterThan{Float64}
        _throw_if_existing_lower(info.bound, info.type, S, f)
        info.bound =
            info.bound == LESS_THAN ? LESS_AND_GREATER_THAN : GREATER_THAN
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
    index = MOI.ConstraintIndex{MOI.VariableIndex,typeof(s)}(f.value)
    MOI.set(model, MOI.ConstraintSet(), index, s)
    return index
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.LessThan{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_upper_bound(model, info, Inf)
    info.previous_upper_bound = Inf
    if info.bound == LESS_AND_GREATER_THAN
        info.bound = GREATER_THAN
    else
        info.bound = NONE
    end
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        @checked Lib.XPRSchgcoltype(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
        )
    end
    return
end

"""
    _set_variable_fixed_bound(model, info, value)

This function is used to indirectly set the fixed bound of a variable.

We need to do it this way to account for potential lower bounds of 0.0 added by
VectorOfVariables-in-SecondOrderCone constraints.

See also `_get_variable_lower_bound`.
"""
function _set_variable_fixed_bound(model, info, value)
    if info.num_soc_constraints == 0
        # No SOC constraints, set directly.
        @assert isnan(info.lower_bound_if_soc)
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
            Ref(value),
        )
        return
    elseif value >= 0.0
        # Regardless of whether there are SOC constraints, this is a valid bound
        # for the SOC constraint and should over-ride any previous bounds.
        info.lower_bound_if_soc = NaN
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
            Ref(value),
        )
        return
    elseif isnan(info.lower_bound_if_soc)
        # Previously, we had a non-negative lower bound (i.e., it was set in the
        # case above). Now we're setting this with a negative one, but there are
        # still some SOC constraints, so the negative upper bound jointly with
        # the SOC constraint will make the problem infeasible.
        @assert value < 0.0
        @checked Lib.XPRSchgbounds(
            model.inner,
            2,
            [Cint(info.column - 1), Cint(info.column - 1)],
            [UInt8('L'), UInt8('U')],
            [0.0, value],
        )
        info.lower_bound_if_soc = value
        return
    else
        # Previously, we had a negative lower bound. We're setting this with
        # another negative one, but there are still some SOC constraints.
        # this case will also lead to a infeasibility
        @assert info.lower_bound_if_soc < 0.0
        info.lower_bound_if_soc = value
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('U')),
            Ref(value),
        )
        return
    end
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
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('L')),
            Ref(value),
        )
        return
    elseif value >= 0.0
        # Regardless of whether there are SOC constraints, this is a valid bound
        # for the SOC constraint and should over-ride any previous bounds.
        info.lower_bound_if_soc = NaN
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('L')),
            Ref(value),
        )
        return
    elseif isnan(info.lower_bound_if_soc)
        # Previously, we had a non-negative lower bound (i.e., it was set in the
        # case above). Now we're setting this with a negative one, but there are
        # still some SOC constraints, so we cache `value` and set the variable
        # lower bound to `0.0`.
        @assert value < 0.0
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('L')),
            Ref(0.0),
        )
        info.lower_bound_if_soc = value
        return
    else
        # Previously, we had a negative lower bound. We're setting this with
        # another negative one, but there are still some SOC constraints.
        @assert info.lower_bound_if_soc < 0.0
        info.lower_bound_if_soc = value
        return
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
    @checked Lib.XPRSgetlb(
        model.inner,
        lb,
        Cint(info.column - 1),
        Cint(info.column - 1),
    )
    return lb[] == Lib.XPRS_MINUSINFINITY ? -Inf : lb[]
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
    @checked Lib.XPRSchgglblimit(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(Cdouble(value)),
    )
end

function _get_variable_semi_lower_bound(model, info)
    return info.semi_lower_bound
end

function _set_variable_upper_bound(model, info, value)
    @checked Lib.XPRSchgbounds(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('U')),
        Ref(value),
    )
    return
end

function _get_variable_upper_bound(model, info)
    ub = Ref(0.0)
    @checked Lib.XPRSgetub(
        model.inner,
        ub,
        Cint(info.column - 1),
        Cint(info.column - 1),
    )
    return ub[] == Lib.XPRS_PLUSINFINITY ? Inf : ub[]
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.GreaterThan{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    info.previous_lower_bound = -Inf
    if info.bound == LESS_AND_GREATER_THAN
        info.bound = LESS_THAN
    else
        info.bound = NONE
    end
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        @checked Lib.XPRSchgcoltype(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
        )
    end
    return
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Interval{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    info.previous_lower_bound = -Inf
    _set_variable_upper_bound(model, info, Inf)
    info.previous_upper_bound = Inf
    info.bound = NONE
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        @checked Lib.XPRSchgcoltype(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
        )
    end
    return
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.EqualTo{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    _set_variable_lower_bound(model, info, -Inf)
    info.previous_lower_bound = -Inf
    _set_variable_upper_bound(model, info, Inf)
    info.previous_upper_bound = Inf
    info.bound = NONE
    model.name_to_constraint_index = nothing
    if info.type == BINARY
        @checked Lib.XPRSchgcoltype(
            model.inner,
            Cint(1),
            Ref(Cint(info.column - 1)),
            Ref(UInt8('B')),
        )
    end
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.GreaterThan{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    lower = _get_variable_lower_bound(model, _info(model, c))
    return MOI.GreaterThan(lower)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.LessThan{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    upper = _get_variable_upper_bound(model, _info(model, c))
    return MOI.LessThan(upper)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.EqualTo{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    lower = _get_variable_lower_bound(model, _info(model, c))
    return MOI.EqualTo(lower)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Interval{Float64}},
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
    c::MOI.ConstraintIndex{MOI.VariableIndex,S},
    s::S,
) where {S<:SCALAR_SETS}
    MOI.throw_if_not_valid(model, c)
    lower, upper = _bounds(s)
    info = _info(model, c)
    if lower == upper
        if lower !== nothing
            _set_variable_fixed_bound(model, info, lower)
            info.previous_lower_bound = lower
            info.previous_upper_bound = upper
        end
    else
        if lower !== nothing
            _set_variable_lower_bound(model, info, lower)
            info.previous_lower_bound = lower
        end
        if upper !== nothing
            _set_variable_upper_bound(model, info, upper)
            info.previous_upper_bound = upper
        end
    end
    return
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VariableIndex,
    ::MOI.ZeroOne,
)
    info = _info(model, f)
    lower, upper = info.previous_lower_bound, info.previous_upper_bound
    if info.type == CONTINUOUS
        l, u = something(lower, 0.0), something(upper, 1.0)
        if (l > 1) || (u < 0) || (l > 0 && u < 1)
            error("The problem is infeasible")
        end
    end
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('B')),
    )
    if info.type == CONTINUOUS
        # The function chgcoltype reset the variable bounds to [0, 1], so we
        # need to add them again if they're set before.
        if lower !== nothing && lower >= 0
            _set_variable_lower_bound(model, info, info.previous_lower_bound)
        end
        if upper !== nothing && upper <= 1
            _set_variable_upper_bound(model, info, info.previous_upper_bound)
        end
    end
    info.type = BINARY
    return MOI.ConstraintIndex{MOI.VariableIndex,MOI.ZeroOne}(f.value)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.ZeroOne},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('C')),
    )
    if !isnan(info.previous_lower_bound)
        _set_variable_lower_bound(model, info, info.previous_lower_bound)
    end
    if !isnan(info.previous_upper_bound)
        _set_variable_upper_bound(model, info, info.previous_upper_bound)
    end
    info.type = CONTINUOUS
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.ZeroOne},
)
    MOI.throw_if_not_valid(model, c)
    return MOI.ZeroOne()
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VariableIndex,
    ::MOI.Integer,
)
    info = _info(model, f)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('I')),
    )
    info.type = INTEGER
    return MOI.ConstraintIndex{MOI.VariableIndex,MOI.Integer}(f.value)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Integer},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('C')),
    )
    info.type = CONTINUOUS
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Integer},
)
    MOI.throw_if_not_valid(model, c)
    return MOI.Integer()
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VariableIndex,
    s::MOI.Semicontinuous{Float64},
)
    info = _info(model, f)
    _throw_if_existing_lower(info.bound, info.type, typeof(s), f)
    _throw_if_existing_upper(info.bound, info.type, typeof(s), f)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('S')),
    )
    _set_variable_semi_lower_bound(model, info, s.lower)
    _set_variable_upper_bound(model, info, s.upper)
    info.type = SEMICONTINUOUS
    return MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semicontinuous{Float64}}(
        f.value,
    )
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semicontinuous{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('C')),
    )
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.semi_lower_bound = NaN
    info.type = CONTINUOUS
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semicontinuous{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    lower = _get_variable_semi_lower_bound(model, info)
    upper = _get_variable_upper_bound(model, info)
    return MOI.Semicontinuous(lower, upper)
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VariableIndex,
    s::MOI.Semiinteger{Float64},
)
    info = _info(model, f)
    _throw_if_existing_lower(info.bound, info.type, typeof(s), f)
    _throw_if_existing_upper(info.bound, info.type, typeof(s), f)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('R')),
    )
    _set_variable_semi_lower_bound(model, info, s.lower)
    _set_variable_upper_bound(model, info, s.upper)
    info.type = SEMIINTEGER
    return MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semiinteger{Float64}}(
        f.value,
    )
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semiinteger{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    @checked Lib.XPRSchgcoltype(
        model.inner,
        Cint(1),
        Ref(Cint(info.column - 1)),
        Ref(UInt8('C')),
    )
    _set_variable_lower_bound(model, info, -Inf)
    _set_variable_upper_bound(model, info, Inf)
    info.semi_lower_bound = NaN
    info.type = CONTINUOUS
    model.name_to_constraint_index = nothing
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Semiinteger{Float64}},
)
    MOI.throw_if_not_valid(model, c)
    info = _info(model, c)
    lower = _get_variable_semi_lower_bound(model, info)
    upper = _get_variable_upper_bound(model, info)
    return MOI.Semiinteger(lower, upper)
end

###
### ScalarAffineFunction-in-Set
###

function _info(
    model::Optimizer,
    key::MOI.ConstraintIndex{F,S},
) where {
    S,
    F<:Union{
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorAffineFunction{Float64},
        MOI.VectorOfVariables,
    },
}
    if haskey(model.affine_constraint_info, key.value)
        return model.affine_constraint_info[key.value]
    end
    throw(MOI.InvalidIndex(key))
end

function MOI.is_valid(
    model::Optimizer,
    c::MOI.ConstraintIndex{F,S},
) where {
    S,
    F<:Union{
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorAffineFunction{Float64},
        MOI.VectorOfVariables,
    },
}
    info = get(model.affine_constraint_info, c.value, nothing)
    if info === nothing
        return false
    end
    return info.type in _function_enums(F) && typeof(info.set) == S
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.ScalarAffineFunction{Float64},
    s::SIMPLE_SCALAR_SETS,
)
    F, S = typeof(f), typeof(s)
    if !iszero(f.constant)
        throw(MOI.ScalarFunctionConstantNotZero{Float64,F,S}(f.constant))
    end
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, AFFINE)
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)
    @checked Lib.XPRSaddrows(
        model.inner,
        1,                  # length(_drhs)
        length(indices),    # length(_mclind)
        Ref{UInt8}(sense),  # _srowtype
        Ref(rhs),           # _drhs
        C_NULL,             # _drng
        Ref{Cint}(0),       # _mrstart::Vector{Int}
        indices,            # _mclind::Vector{Int}
        coefficients,       # _dmatval
    )
    return MOI.ConstraintIndex{F,S}(model.last_constraint_index)
end

function MOI.add_constraints(
    model::Optimizer,
    f::Vector{MOI.ScalarAffineFunction{Float64}},
    s::Vector{<:SIMPLE_SCALAR_SETS},
)
    if length(f) != length(s)
        error("Number of functions does not equal number of sets.")
    end
    canonicalized_functions = MOI.Utilities.canonical.(f)
    # First pass: compute number of non-zeros to allocate space.
    nnz = 0
    F, S = eltype(f), eltype(s)
    for fi in canonicalized_functions
        if !iszero(fi.constant)
            throw(MOI.ScalarFunctionConstantNotZero{Float64,F,S}(fi.constant))
        end
        nnz += length(fi.terms)
    end
    # Initialize storage
    indices = Vector{MOI.ConstraintIndex{F,S}}(undef, length(f))
    row_starts = Vector{Cint}(undef, length(f) + 1)
    row_starts[1] = 0
    columns = Vector{Cint}(undef, nnz)
    coefficients = Vector{Float64}(undef, nnz)
    senses = Vector{Cchar}(undef, length(f))
    rhss = Vector{Float64}(undef, length(f))
    # Second pass: loop through, passing views to _indices_and_coefficients.
    for (i, (fi, si)) in enumerate(zip(canonicalized_functions, s))
        senses[i], rhss[i] = _sense_and_rhs(si)
        row_starts[i+1] = row_starts[i] + length(fi.terms)
        _indices_and_coefficients(
            view(columns, (row_starts[i]+1):row_starts[i+1]),
            view(coefficients, (row_starts[i]+1):row_starts[i+1]),
            model,
            fi,
        )
        model.last_constraint_index += 1
        indices[i] = MOI.ConstraintIndex{F,S}(model.last_constraint_index)
        model.affine_constraint_info[model.last_constraint_index] =
            ConstraintInfo(length(model.affine_constraint_info) + 1, si, AFFINE)
    end
    pop!(row_starts)
    @checked Lib.XPRSaddrows(
        model.inner,
        length(rhss),     # length(_drhs)
        length(columns),  # length(_mclind)
        senses,           # _srowtype
        rhss,             # _drhs
        C_NULL,           # _drng
        row_starts,       # _mrstart
        columns,          # _mclind
        coefficients,     # _dmatval
    )
    return indices
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{T,<:Any},
) where {
    T<:Union{
        MOI.VectorAffineFunction{Float64},
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
    },
}
    row = _info(model, c).row
    @checked Lib.XPRSdelrows(model.inner, 1, Ref{Cint}(row - 1))
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
    c::MOI.ConstraintIndex{F,S},
) where {
    S,
    F<:Union{
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
    },
}
    rhs = Ref(Cdouble(NaN))
    row = _info(model, c).row
    @checked Lib.XPRSgetrhs(model.inner, rhs, Cint(row - 1), Cint(row - 1))
    return S(rhs[])
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},S},
    s::S,
) where {S}
    @checked Lib.XPRSchgrhs(
        model.inner,
        Cint(1),
        Ref(Cint(_info(model, c).row - 1)),
        Ref(MOI.constant(s)),
    )
    return
end

function _get_affine_terms(model::Optimizer, c::MOI.ConstraintIndex)
    row = _info(model, c).row
    nzcnt_max =
        @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ELEMS, _)::Int

    _nzcnt = Ref(Cint(0))
    @checked Lib.XPRSgetrows(
        model.inner,
        C_NULL,
        C_NULL,
        C_NULL,
        0,
        _nzcnt,
        Cint(row - 1),
        Cint(row - 1),
    )
    nzcnt = _nzcnt[]

    @assert nzcnt <= nzcnt_max

    rmatbeg = zeros(Cint, row - row + 2)
    rmatind = Array{Cint}(undef, nzcnt)
    rmatval = Array{Float64}(undef, nzcnt)

    @checked Lib.XPRSgetrows(
        model.inner,
        rmatbeg,#_mstart,
        rmatind,#_mclind,
        rmatval,#_dmatval,
        nzcnt,#maxcoeffs,
        Ref(Cint(0)),#temp,
        Cint(row - 1),#Cint(first-1)::Integer,
        Cint(row - 1),#Cint(last-1)::Integer,
    )
    rmatbeg .+= 1
    rmatind .+= 1

    terms = MOI.ScalarAffineTerm{Float64}[]
    for i in 1:nzcnt
        iszero(rmatval[i]) && continue
        push!(
            terms,
            MOI.ScalarAffineTerm(
                rmatval[i],
                model.variable_info[CleverDicts.LinearIndex(rmatind[i])].index,
            ),
        )
    end
    return terms
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},S},
) where {S}
    terms = _get_affine_terms(model, c)
    return MOI.ScalarAffineFunction(terms, 0.0)
end

#=
    MOI.ConstraintName
=#

function MOI.supports(
    ::Optimizer,
    ::MOI.ConstraintName,
    ::Type{<:MOI.ConstraintIndex{F}},
) where {
    F<:Union{
        MOI.VectorAffineFunction{Float64},
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorOfVariables,
    },
}
    return true
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{T,<:Any},
) where {
    T<:Union{
        MOI.VectorAffineFunction{Float64},
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorOfVariables,
    },
}
    return _info(model, c).name
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintName,
    c::MOI.ConstraintIndex{T,<:Any},
    name::String,
) where {
    T<:Union{
        MOI.VectorAffineFunction{Float64},
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorOfVariables,
    },
}
    info = _info(model, c)
    info.name = name
    # Note: don't set the string names in the Xpress C API because it complains
    # on duplicate contraints.
    # That is, don't call `Lib.XPRsaddnames`.
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
    model::Optimizer,
    C::Type{MOI.ConstraintIndex{F,S}},
    name::String,
) where {F,S}
    index = MOI.get(model, MOI.ConstraintIndex, name)
    if typeof(index) == C
        return index::MOI.ConstraintIndex{F,S}
    end
    return nothing
end

function _rebuild_name_to_constraint_index(model::Optimizer)
    model.name_to_constraint_index =
        Dict{String,Union{Nothing,MOI.ConstraintIndex}}()
    _rebuild_name_to_constraint_index_util(model, model.affine_constraint_info)
    _rebuild_name_to_constraint_index_util(
        model,
        model.sos_constraint_info,
        MOI.VectorOfVariables,
    )
    return
end

function _rebuild_name_to_constraint_index_util(model::Optimizer, dict)
    for (index, info) in dict
        if info.name == ""
            continue
        elseif haskey(model.name_to_constraint_index, info.name)
            model.name_to_constraint_index[info.name] = nothing
        else
            F = if info.type == AFFINE
                MOI.ScalarAffineFunction{Float64}
            elseif info.type == QUADRATIC
                MOI.ScalarQuadraticFunction{Float64}
            elseif info.type == INDICATOR
                MOI.VectorAffineFunction{Float64}
            elseif info.type == SOC
                MOI.VectorOfVariables
            elseif info.type == RSOC
                MOI.VectorOfVariables
            else
                @assert info.type == SCALAR_NONLINEAR
                MOI.ScalarNonlinearFunction
            end
            model.name_to_constraint_index[info.name] =
                MOI.ConstraintIndex{F,typeof(info.set)}(index)
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
                MOI.ConstraintIndex{F,typeof(info.set)}(index)
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
    c::MOI.ConstraintIndex{
        MOI.VectorAffineFunction{Float64},
        MOI.Indicator{A,S},
    },
) where {A,S<:SCALAR_SETS}
    # rhs = Vector{Cdouble}(undef, 1)
    # info = _info(model, c)
    # row = info.row
    # set_cte = MOI.constant(info.set.set)
    # # a^T x + b <= c ===> a^T <= c - b
    # getrhs!(model.inner, rhs, row, row)
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
        error(
            "There should be exactly one term in output_index 1, found $(changes)",
        )
    end
    return value
end

indicator_activation(::Type{Val{MOI.ACTIVATE_ON_ZERO}}) = Cint(-1)
indicator_activation(::Type{Val{MOI.ACTIVATE_ON_ONE}}) = Cint(1)

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VectorAffineFunction{T},
    is::MOI.Indicator{A,LT},
) where {T<:Real,LT<:Union{MOI.LessThan,MOI.GreaterThan,MOI.EqualTo},A}
    con_value = _indicator_variable(f)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, is, INDICATOR)
    indices, coefficients = _indices_and_coefficients_indicator(model, f)
    cte = MOI.constant(f)[2]
    # a^T x + b <= c ===> a^T <= c - b
    sense, rhs = _sense_and_rhs(is.set)
    @checked Lib.XPRSaddrows(
        model.inner,
        1,                  # length(_drhs)
        length(indices),    # length(_mclind)
        Ref{UInt8}(sense),  # _srowtype
        Ref(rhs - cte),     # _drhs
        C_NULL,             # _drng
        Ref{Cint}(0),       # _mrstart
        indices,            # _mrwind
        coefficients,       # _dmatval
    )
    ncons = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALROWS,
        _,
    )::Int
    @checked Lib.XPRSsetindicators(
        model.inner,
        1,
        Ref{Cint}(ncons - 1),
        Ref{Cint}(con_value - 1),
        Ref{Cint}(indicator_activation(Val{A})),
    )
    F, S = MOI.VectorAffineFunction{T}, typeof(is)
    return MOI.ConstraintIndex{F,S}(model.last_constraint_index)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorAffineFunction{Float64},S},
) where {S}
    terms = MOI.VectorAffineTerm{Float64}[]
    aff_terms = _get_affine_terms(model, c)
    for term in aff_terms
        push!(terms, MOI.VectorAffineTerm(2, term))
    end

    info = _info(model, c)
    row = info.row

    comps = Ref{Cint}(0)
    inds = Ref{Cint}(0)
    @checked Lib.XPRSgetindicators(
        model.inner,
        inds,
        comps,
        Cint(row - 1),
        Cint(row - 1),
    )
    push!(
        terms,
        MOI.VectorAffineTerm(
            1,
            MOI.ScalarAffineTerm(
                1.0,
                model.variable_info[CleverDicts.LinearIndex(inds[] + 1)].index,
            ),
        ),
    )
    _drhs = Ref(0.0)
    @checked Lib.XPRSgetrhs(model.inner, _drhs, Cint(row - 1), Cint(row - 1))
    rhs = _drhs[]
    val = -rhs + MOI.constant(info.set.set)
    return MOI.VectorAffineFunction(terms, [0.0, val])
end

###
### ScalarQuadraticFunction-in-SCALAR_SET
###

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.ScalarQuadraticFunction{Float64},
    s::SCALAR_SETS,
)
    F, S = typeof(f), typeof(s)
    if !iszero(f.constant)
        throw(MOI.ScalarFunctionConstantNotZero{Float64,F,S}(f.constant))
    end
    sense, rhs = _sense_and_rhs(s)
    indices, coefficients, I, J, V = _indices_and_coefficients(model, f)
    V .*= 0.5  # only for constraints
    @checked Lib.XPRSaddrows(
        model.inner,
        1,
        length(indices),
        Ref{UInt8}(sense),
        Ref(rhs),
        C_NULL,
        Ref{Cint}(0),
        indices,
        coefficients,
    )
    ncons = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALROWS,
        _,
    )::Int
    @checked Lib.XPRSaddqmatrix(
        model.inner,
        ncons - 1,
        Cint(length(I)),
        I,
        J,
        V,
    )
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, QUADRATIC)
    return MOI.ConstraintIndex{F,S}(model.last_constraint_index)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64},S},
) where {S}
    affine_terms = _get_affine_terms(model, c)
    nqelem = Ref{Cint}()
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    mqcol1 = Array{Cint}(undef, nqelem[])
    mqcol2 = Array{Cint}(undef, nqelem[])
    dqe = Array{Float64}(undef, nqelem[])
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        mqcol1,
        mqcol2,
        dqe,
    )
    mqcol1 .+= 1
    mqcol2 .+= 1

    quadratic_terms = MOI.ScalarQuadraticTerm{Float64}[]
    for (i, j, coef) in zip(mqcol1, mqcol2, dqe)
        push!(
            quadratic_terms,
            MOI.ScalarQuadraticTerm(
                2 * coef, # only for constraints
                model.variable_info[CleverDicts.LinearIndex(i)].index,
                model.variable_info[CleverDicts.LinearIndex(j)].index,
            ),
        )
    end
    return MOI.ScalarQuadraticFunction(quadratic_terms, affine_terms, 0.0)
end

###
### VectorOfVariables-in-SOS{I|II}
###

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.VectorOfVariables},
    ::Type{F},
) where {
    F<:Union{
        MOI.SOS1{Float64},
        MOI.SOS2{Float64},
        MOI.SecondOrderCone,
        MOI.RotatedSecondOrderCone,
    },
}
    # Xpress only supports disjoint sets of SOC and RSOC (with no affine forms)
    # hence we only allow constraints on creation
    return true
end

const SOS = Union{MOI.SOS1{Float64},MOI.SOS2{Float64}}

function _info(
    model::Optimizer,
    key::MOI.ConstraintIndex{MOI.VectorOfVariables,<:SOS},
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
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,S},
) where {S<:SOS}
    info = get(model.sos_constraint_info, c.value, nothing)
    if info === nothing || typeof(info.set) != S
        return false
    end
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    return all(MOI.is_valid.(model, f.variables))
end

function MOI.add_constraint(model::Optimizer, f::MOI.VectorOfVariables, s::SOS)
    columns = Cint[Cint(_info(model, v).column - 1) for v in f.variables]
    idx = Cint[0, 0]
    @checked Lib.XPRSaddsets(
        model.inner, # prob
        1, # newsets
        length(columns), # newnz
        Ref{UInt8}(_sos_type(s)), # qstype
        idx, # Cint.(msstart)
        columns, # Cint.(mscols)
        s.weights, # dref
    )
    model.last_constraint_index += 1
    index = MOI.ConstraintIndex{MOI.VectorOfVariables,typeof(s)}(
        model.last_constraint_index,
    )
    model.sos_constraint_info[index.value] =
        ConstraintInfo(length(model.sos_constraint_info) + 1, s, SOS_SET)
    return index
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,<:SOS},
)
    row = _info(model, c).row - 1
    idx = collect(row:row)
    numdel = length(idx)
    @checked Lib.XPRSdelsets(model.inner, numdel, idx)
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
    nnz = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALSETMEMBERS, _)::Int
    )
    nsos = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALSETS, _)::Int
    )
    settypes = Array{Cchar}(undef, nsos)
    setstart = zeros(Cint, nsos + 1)
    setcols = zeros(Cint, nnz)
    setvals = zeros(Float64, nnz)
    intents, nsets = Ref{Cint}(), Ref{Cint}()
    if get_version() >= v"41.01"
        @checked Lib.XPRSgetmipentities(
            model.inner,
            intents,
            nsets,
            C_NULL,
            C_NULL,
            C_NULL,
            settypes,
            setstart,
            setcols,
            setvals,
        )
    else
        @checked Lib.XPRSgetglobal(
            model.inner,
            intents,
            nsets,
            C_NULL,
            C_NULL,
            C_NULL,
            settypes,
            setstart,
            setcols,
            setvals,
        )
    end
    return setstart, setcols, setvals
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,S},
) where {S<:SOS}
    setstart, setcols, setvals = _get_sparse_sos(model)
    row = _info(model, c).row
    return S(setvals[(setstart[row]+1):setstart[row+1]])
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,S},
) where {S<:SOS}
    setstart, setcols, setvals = _get_sparse_sos(model)
    row = _info(model, c).row
    indices = (setstart[row]+1):setstart[row+1]
    cols = CleverDicts.LinearIndex.(setcols[indices] .+ 1)
    return MOI.VectorOfVariables([model.variable_info[c].index for c in cols])
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
            "MOI.AbstractCallbackFunction",
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

function is_mip(model::Optimizer)
    n = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALMIPENTS, _)::Int,
    )
    nsos = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALSETS, _)::Int,
    )
    return !model.solve_relaxation && n + nsos > 0
end

function _set_MIP_start(model)
    colind, solval = Cint[], Cdouble[]
    for info in values(model.variable_info)
        if info.start !== nothing
            push!(colind, Cint(info.column - 1))
            push!(solval, info.start)
        end
    end
    nnz = length(colind)
    if nnz > 0
        @checked Lib.XPRSaddmipsol(model.inner, nnz, solval, colind, C_NULL)
    end
    return
end

function MOI.optimize!(model::Optimizer)
    # Initialize callbacks if necessary.
    if check_moi_callback_validity(model)
        if model.moi_warnings &&
           getcontrol(model.inner, "XPRS_HEURSTRATEGY") != 0
            @warn(
                "Callbacks in XPRESS might not work correctly with HEURSTRATEGY != 0",
            )
        end
        MOI.set(model, CallbackFunction(), default_moi_callback(model))
        model.has_generic_callback = false # because it is set as true in the above
    end
    pre_solve_reset(model)
    # cache rhs: must be done before hand because it cant be
    # properly queried if the problem ends up in a presolve state
    ncons = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALROWS,
        _,
    )::Int
    rhs = Vector{Float64}(undef, ncons)
    @checked Lib.XPRSgetrhs(model.inner, rhs, Cint(0), Cint(ncons - 1))
    if !model.ignore_start && is_mip(model)
        _set_MIP_start(model)
    end
    start_time = time()
    if model.has_nlp_constraints
        @checked Lib.XPRSnlpoptimize(model.inner, model.solve_method)
    elseif is_mip(model)
        @checked Lib.XPRSmipoptimize(model.inner, model.solve_method)
    else
        @checked Lib.XPRSlpoptimize(model.inner, model.solve_method)
    end
    model.cached_solution.solve_time = time() - start_time
    check_cb_exception(model)
    # Should be almost a no-op if not needed. Might have minor overhead due to
    # memory being freed
    if model.post_solve
        @checked Lib.XPRSpostsolve(model.inner)
    end
    model.termination_status = _cache_termination_status(model)
    model.primal_status = _cache_primal_status(model)
    model.dual_status = _cache_dual_status(model)
    # TODO: add @checked here - must review statuses
    if model.has_nlp_constraints
        Lib.XPRSgetnlpsol(
            model.inner,
            model.cached_solution.variable_primal,
            model.cached_solution.linear_primal,
            model.cached_solution.linear_dual,
            model.cached_solution.variable_dual,
        )
    elseif is_mip(model)
        # TODO @checked (only works if not in [MOI.NO_SOLUTION, MOI.INFEASIBILITY_CERTIFICATE, MOI.INFEASIBLE_POINT])
        Lib.XPRSgetmipsol(
            model.inner,
            model.cached_solution.variable_primal,
            model.cached_solution.linear_primal,
        )
        fill!(model.cached_solution.linear_dual, NaN)
        fill!(model.cached_solution.variable_dual, NaN)
    else
        Lib.XPRSgetlpsol(
            model.inner,
            model.cached_solution.variable_primal,
            model.cached_solution.linear_primal,
            model.cached_solution.linear_dual,
            model.cached_solution.variable_dual,
        )
    end
    model.cached_solution.linear_primal .=
        rhs .- model.cached_solution.linear_primal
    status = MOI.get(model, MOI.PrimalStatus())
    if status == MOI.INFEASIBILITY_CERTIFICATE
        has_Ray = Int64[0]
        @checked Lib.XPRSgetprimalray(
            model.inner,
            model.cached_solution.variable_primal,
            has_Ray,
        )
        model.cached_solution.has_primal_certificate = _has_primal_ray(model)
    elseif status == MOI.FEASIBLE_POINT
        model.cached_solution.has_feasible_point = true
    end
    status = MOI.get(model, MOI.DualStatus())
    if status == MOI.INFEASIBILITY_CERTIFICATE
        has_Ray = Int64[0]
        @checked Lib.XPRSgetdualray(
            model.inner,
            model.cached_solution.linear_dual,
            has_Ray,
        )
        model.cached_solution.has_dual_certificate = _has_dual_ray(model)
    end
    return
end

function _throw_if_optimize_in_progress(model, attr)
    if model.callback_state != CB_NONE
        throw(MOI.OptimizeInProgress(attr))
    end
    return
end

const _MIPSTATUS = Dict(
    Lib.XPRS_MIP_NOT_LOADED => (
        "0 Problem has not been loaded ( XPRS_MIP_NOT_LOADED).",
        MOI.OPTIMIZE_NOT_CALLED,
    ),
    Lib.XPRS_MIP_LP_NOT_OPTIMAL => (
        "1 Global search incomplete - the initial continuous relaxation has not been solved and no integer solution has been found ( XPRS_MIP_LP_NOT_OPTIMAL).",
        MOI.OTHER_ERROR,
    ),
    Lib.XPRS_MIP_LP_OPTIMAL => (
        "2 Global search incomplete - the initial continuous relaxation has been solved and no integer solution has been found ( XPRS_MIP_LP_OPTIMAL).",
        MOI.OTHER_ERROR,
    ),
    Lib.XPRS_MIP_NO_SOL_FOUND => (
        "3 Global search incomplete - no integer solution found ( XPRS_MIP_NO_SOL_FOUND).",
        MOI.OTHER_ERROR,
    ),
    Lib.XPRS_MIP_SOLUTION => (
        "4 Global search incomplete - an integer solution has been found ( XPRS_MIP_SOLUTION).",
        MOI.LOCALLY_SOLVED,
    ),
    Lib.XPRS_MIP_INFEAS => (
        "5 Global search complete - no integer solution found ( XPRS_MIP_INFEAS).",
        MOI.INFEASIBLE,
    ),
    Lib.XPRS_MIP_OPTIMAL => (
        "6 Global search complete - integer solution found ( XPRS_MIP_OPTIMAL).",
        MOI.OPTIMAL,
    ),
    Lib.XPRS_MIP_UNBOUNDED => (
        "7 Global search incomplete - the initial continuous relaxation was found to be unbounded. A solution may have been found ( XPRS_MIP_UNBOUNDED).",
        MOI.INFEASIBLE_OR_UNBOUNDED,
    ),
)

const _LPSTATUS = Dict(
    Lib.XPRS_LP_UNSTARTED =>
        ("0 Unstarted ( XPRS_LP_UNSTARTED).", MOI.OPTIMIZE_NOT_CALLED),
    Lib.XPRS_LP_OPTIMAL => ("1 Optimal ( XPRS_LP_OPTIMAL).", MOI.OPTIMAL),
    Lib.XPRS_LP_INFEAS =>
        ("2 Infeasible ( XPRS_LP_INFEAS).", MOI.INFEASIBLE),
    Lib.XPRS_LP_CUTOFF => (
        "3 Objective worse than cutoff ( XPRS_LP_CUTOFF).",
        MOI.OTHER_LIMIT,
    ),
    Lib.XPRS_LP_UNFINISHED =>
        ("4 Unfinished ( XPRS_LP_UNFINISHED).", MOI.OTHER_ERROR),
    Lib.XPRS_LP_UNBOUNDED =>
        ("5 Unbounded ( XPRS_LP_UNBOUNDED).", MOI.DUAL_INFEASIBLE),
    Lib.XPRS_LP_CUTOFF_IN_DUAL =>
        ("6 Cutoff in dual ( XPRS_LP_CUTOFF_IN_DUAL).", MOI.OTHER_LIMIT),
    Lib.XPRS_LP_UNSOLVED => (
        "7 Problem could not be solved due to numerical issues. ( XPRS_LP_UNSOLVED).",
        MOI.NUMERICAL_ERROR,
    ),
    Lib.XPRS_LP_NONCONVEX => (
        "8 Problem contains quadratic data, which is not convex ( XPRS_LP_NONCONVEX).",
        MOI.INVALID_OPTION,
    ),
)

const _NLPSTATUS = Dict(
    Lib.XPRS_NLPSTATUS_UNSTARTED => (
        "0 Optimization unstarted ( XSLP_NLPSTATUS_UNSTARTED)",
        MOI.OPTIMIZE_NOT_CALLED,
    ),
    Lib.XPRS_NLPSTATUS_SOLUTION =>
        ("1 Solution found ( XSLP_NLPSTATUS_SOLUTION)", MOI.LOCALLY_SOLVED),
    Lib.XPRS_NLPSTATUS_OPTIMAL =>
        ("2 Globally optimal ( XSLP_NLPSTATUS_OPTIMAL)", MOI.OPTIMAL),
    Lib.XPRS_NLPSTATUS_NOSOLUTION => (
        "3 No solution found ( XSLP_NLPSTATUS_NOSOLUTION)",
        MOI.OTHER_ERROR,
    ),
    Lib.XPRS_NLPSTATUS_INFEASIBLE => (
        "4 Proven infeasible ( XSLP_NLPSTATUS_INFEASIBLE)",
        MOI.INFEASIBLE,
    ),
    Lib.XPRS_NLPSTATUS_UNBOUNDED => (
        "5 Locally unbounded ( XSLP_NLPSTATUS_UNBOUNDED)",
        MOI.DUAL_INFEASIBLE,
    ),
    Lib.XPRS_NLPSTATUS_UNFINISHED => (
        "6 Not yet solved to completion ( XSLP_NLPSTATUS_UNFINISHED)",
        MOI.OTHER_ERROR,
    ),
    Lib.XPRS_NLPSTATUS_UNSOLVED => (
        "7 Could not be solved due to numerical issues ( XSLP_NLPSTATUS_UNSOLVED)",
        MOI.NUMERICAL_ERROR,
    ),
)

const _STOPSTATUS = Dict(
    Lib.XPRS_STOP_NONE =>
        ("no interruption - the solve completed normally", MOI.OPTIMAL),
    Lib.XPRS_STOP_TIMELIMIT => ("time limit hit", MOI.TIME_LIMIT),
    Lib.XPRS_STOP_CTRLC => ("control C hit", MOI.INTERRUPTED),
    Lib.XPRS_STOP_NODELIMIT => ("node limit hit", MOI.NODE_LIMIT),
    Lib.XPRS_STOP_ITERLIMIT => ("iteration limit hit", MOI.ITERATION_LIMIT),
    Lib.XPRS_STOP_MIPGAP => ("MIP gap is sufficiently small", MOI.OPTIMAL),
    Lib.XPRS_STOP_SOLLIMIT => ("solution limit hit", MOI.SOLUTION_LIMIT),
    Lib.XPRS_STOP_USER => ("user interrupt.", MOI.INTERRUPTED),
)

function MOI.get(model::Optimizer, attr::MOI.RawStatusString)
    _throw_if_optimize_in_progress(model, attr)
    stop =
        @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_STOPSTATUS, _)::Int
    if model.has_nlp_constraints
        stat = @_invoke Lib.XPRSgetintattrib(
            model.inner,
            Lib.XPRS_NLPSTATUS,
            _,
        )::Int
        return _NLPSTATUS[stat][1] * " - " * _STOPSTATUS[stop][1]
    elseif is_mip(model)
        stat = @_invoke Lib.XPRSgetintattrib(
            model.inner,
            Lib.XPRS_MIPSTATUS,
            _,
        )::Int
        return _MIPSTATUS[stat][1] * " - " * _STOPSTATUS[stop][1]
    else
        stat = @_invoke Lib.XPRSgetintattrib(
            model.inner,
            Lib.XPRS_LPSTATUS,
            _,
        )::Int
        return _LPSTATUS[stat][1] * " - " * _STOPSTATUS[stop][1]
    end
end

function _cache_termination_status(model::Optimizer)
    stop =
        @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_STOPSTATUS, _)::Int
    if stop != Lib.XPRS_STOP_NONE && stop != Lib.XPRS_STOP_MIPGAP
        return _STOPSTATUS[stop][2]
    elseif model.has_nlp_constraints
        nlpstatus = Lib.XPRS_NLPSTATUS
        stat = @_invoke Lib.XPRSgetintattrib(model.inner, nlpstatus, _)::Int
        return _NLPSTATUS[stat][2]
    elseif is_mip(model)
        mipstatus = Lib.XPRS_MIPSTATUS
        stat = @_invoke Lib.XPRSgetintattrib(model.inner, mipstatus, _)::Int
        return _MIPSTATUS[stat][2]
    else
        lpstatus = Lib.XPRS_LPSTATUS
        stat = @_invoke Lib.XPRSgetintattrib(model.inner, lpstatus, _)::Int
        return _LPSTATUS[stat][2]
    end
end

function MOI.get(model::Optimizer, attr::MOI.TerminationStatus)
    _throw_if_optimize_in_progress(model, attr)
    if model.cached_solution === nothing
        return MOI.OPTIMIZE_NOT_CALLED
    end
    return model.termination_status
end

function _has_dual_ray(model::Optimizer)
    has_Ray = Ref{Cint}(0)
    @checked Lib.XPRSgetdualray(model.inner, C_NULL, has_Ray)
    return has_Ray[] != 0
end

function _has_primal_ray(model::Optimizer)
    has_Ray = Ref{Cint}(0)
    @checked Lib.XPRSgetprimalray(model.inner, C_NULL, has_Ray)
    return has_Ray[] != 0
end

function _cache_primal_status(model)
    if _has_primal_ray(model)
        return MOI.INFEASIBILITY_CERTIFICATE
    end
    dict, attr = if model.has_nlp_constraints
        _NLPSTATUS, Lib.XPRS_NLPSTATUS
    elseif is_mip(model)
        _MIPSTATUS, Lib.XPRS_MIPSTATUS
    else
        _LPSTATUS, Lib.XPRS_LPSTATUS
    end
    stat = @_invoke Lib.XPRSgetintattrib(model.inner, attr, _)::Int
    if dict[stat][2] in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED)
        return MOI.FEASIBLE_POINT
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
    if term_stat in (MOI.OPTIMAL, MOI.LOCALLY_SOLVED)
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

#=
    MOI.VariablePrimal
=#

function MOI.get(
    model::Optimizer,
    attr::MOI.VariablePrimal,
    x::MOI.VariableIndex,
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, x).column
    return model.cached_solution.variable_primal[column]
end

#=
    MOI.ConstraintPrimal
=#

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.VariableIndex,<:Any},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    return MOI.get(model, MOI.VariablePrimal(), MOI.VariableIndex(c.value))
end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},<:Any},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    return model.cached_solution.linear_primal[row]
end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64},<:Any},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    return model.cached_solution.linear_primal[row]
end

#=
    MOI.ConstraintDual
=#

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
    ncoeffs = Ref{Cint}(0)
    @checked Lib.XPRSgetcols(
        model.inner,
        C_NULL,
        C_NULL,
        C_NULL,
        nrows,
        ncoeffs,
        Cint(col - 1),
        Cint(col - 1),
    )
    ncoeffs_ = ncoeffs[]
    mstart = Array{Cint}(undef, 2)
    mrwind = Array{Cint}(undef, ncoeffs_)
    dmatval = Array{Float64}(undef, ncoeffs_)
    @checked Lib.XPRSgetcols(
        model.inner,
        mstart,
        mrwind,
        dmatval,
        nrows,
        ncoeffs,
        Cint(col - 1),
        Cint(col - 1),
    )
    return sum(
        v * model.cached_solution.linear_dual[i+1] for
        (i, v) in zip(mrwind, dmatval)
    )
end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.LessThan{Float64}},
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
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.GreaterThan{Float64}},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, c).column
    if model.cached_solution.has_dual_certificate
        dual = -_farkas_variable_dual(model, column)
        return max(dual, 0.0)
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
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.EqualTo{Float64}},
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
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.VariableIndex,MOI.Interval{Float64}},
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
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},<:Any},
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
    model::Optimizer,
    attr::MOI.ConstraintDual,
    c::MOI.ConstraintIndex{MOI.ScalarQuadraticFunction{Float64},<:Any},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    pi = model.cached_solution.linear_dual[_info(model, c).row]
    return _dual_multiplier(model) * pi
end

#=
    MOI.ObjectiveValue
=#

function MOI.get(model::Optimizer, attr::MOI.ObjectiveValue)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    attr = if model.has_nlp_constraints
        Lib.XPRS_NLPOBJVAL
    elseif is_mip(model)
        Lib.XPRS_MIPOBJVAL
    else
        Lib.XPRS_LPOBJVAL
    end
    return @_invoke Lib.XPRSgetdblattrib(model.inner, attr, _)::Float64
end

#=
    MOI.ObjectiveBound
=#

function MOI.get(model::Optimizer, attr::MOI.ObjectiveBound)
    _throw_if_optimize_in_progress(model, attr)
    attr = is_mip(model) ? Lib.XPRS_BESTBOUND : Lib.XPRS_LPOBJVAL
    return @_invoke Lib.XPRSgetdblattrib(model.inner, attr, _)::Float64
end

#=
    MOI.SolveTimeSec
=#

function MOI.get(model::Optimizer, attr::MOI.SolveTimeSec)
    _throw_if_optimize_in_progress(model, attr)
    return model.cached_solution.solve_time
end

#=
    MOI.SimplexIterations
=#

function MOI.get(model::Optimizer, attr::MOI.SimplexIterations)
    _throw_if_optimize_in_progress(model, attr)
    return @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_SIMPLEXITER,
        _,
    )::Int
end

#=
    MOI.BarrierIterations
=#

function MOI.get(model::Optimizer, attr::MOI.BarrierIterations)
    _throw_if_optimize_in_progress(model, attr)
    return @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_BARITER, _)::Int
end

#=
    MOI.NodeCount
=#

function MOI.get(model::Optimizer, attr::MOI.NodeCount)
    _throw_if_optimize_in_progress(model, attr)
    return @_invoke Lib.XPRSgetintattrib(model.inner, Lib.XPRS_NODES, _)::Int
end

#=
    MOI.RelativeGap
=#

function MOI.get(model::Optimizer, attr::MOI.RelativeGap)
    _throw_if_optimize_in_progress(model, attr)
    BESTBOUND = MOI.get(model, MOI.ObjectiveBound())
    MIPOBJVAL = MOI.get(model, MOI.ObjectiveValue())
    return abs(MIPOBJVAL - BESTBOUND) / max(abs(BESTBOUND), abs(MIPOBJVAL))
end

#=
    MOI.DualObjectiveValue
=#

# TODO(odow): this is wrong
function MOI.get(model::Optimizer, attr::MOI.DualObjectiveValue)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    return MOI.get(model, MOI.ObjectiveValue(attr.result_index))
end

#=
    MOI.ResultCount
=#

function MOI.get(model::Optimizer, attr::MOI.ResultCount)
    _throw_if_optimize_in_progress(model, attr)
    if model.cached_solution === nothing
        return 0
    elseif model.cached_solution.has_dual_certificate
        return 1
    elseif model.cached_solution.has_primal_certificate
        return 1
    end
    return model.cached_solution.has_feasible_point ? 1 : 0
end

#=
    MOI.Silent
=#

MOI.supports(::Optimizer, ::MOI.Silent) = true

MOI.get(model::Optimizer, ::MOI.Silent) = model.log_level == 0

function MOI.set(model::Optimizer, ::MOI.Silent, flag::Bool)
    MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), ifelse(flag, 0, 1))
    return
end

#=
    MOI.NumberOfThreads
=#

MOI.supports(::Optimizer, ::MOI.NumberOfThreads) = true

function MOI.get(model::Optimizer, ::MOI.NumberOfThreads)
    return Int(MOI.get(model, MOI.RawOptimizerAttribute("THREADS")))
end

function MOI.set(model::Optimizer, ::MOI.NumberOfThreads, x::Int)
    return MOI.set(model, MOI.RawOptimizerAttribute("THREADS"), x)
end

#=
    MOI.Name
=#

MOI.supports(::Optimizer, ::MOI.Name) = true

function MOI.get(model::Optimizer, ::MOI.Name)
    return model.name
end

function MOI.set(model::Optimizer, ::MOI.Name, name::String)
    model.name = name
    @checked Lib.XPRSsetprobname(model.inner, name)
    return
end

#=
    MOI.RawSolver
=#

MOI.get(model::Optimizer, ::MOI.RawSolver) = model.inner

#=
    MOI.NumberOfVariables
=#

MOI.get(model::Optimizer, ::MOI.NumberOfVariables) = length(model.variable_info)

#=
    MOI.ListOfVariableIndices
=#

function MOI.get(model::Optimizer, ::MOI.ListOfVariableIndices)
    return sort!(collect(keys(model.variable_info)); by = x -> x.value)
end

#=
    MOI.VariablePrimalStart
=#

function MOI.supports(
    ::Optimizer,
    ::MOI.VariablePrimalStart,
    ::Type{MOI.VariableIndex},
)
    return true
end

function MOI.set(
    model::Optimizer,
    ::MOI.VariablePrimalStart,
    x::MOI.VariableIndex,
    value::Union{Nothing,Float64},
)
    info = _info(model, x)
    info.start = value
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.VariablePrimalStart,
    x::MOI.VariableIndex,
)
    return _info(model, x).start
end

function MOI.get(model::Optimizer, ::MOI.NumberOfConstraints{F,S}) where {F,S}
    # TODO: this could be more efficient.
    return length(MOI.get(model, MOI.ListOfConstraintIndices{F,S}()))
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
    model::Optimizer,
    ::MOI.ListOfConstraintIndices{MOI.VariableIndex,S},
) where {S}
    indices = MOI.ConstraintIndex{MOI.VariableIndex,S}[]
    for (key, info) in model.variable_info
        if info.bound in _bound_enums(S) || info.type in _type_enums(S)
            push!(indices, MOI.ConstraintIndex{MOI.VariableIndex,S}(key.value))
        end
    end
    return sort!(indices; by = x -> x.value)
end

_function_enums(::Type{<:MOI.ScalarAffineFunction}) = (AFFINE,)
_function_enums(::Type{<:MOI.ScalarQuadraticFunction}) = (QUADRATIC,)
_function_enums(::Type{<:MOI.ScalarNonlinearFunction}) = (SCALAR_NONLINEAR,)
_function_enums(::Type{<:MOI.VectorAffineFunction}) = (INDICATOR,)
_function_enums(::Type{<:MOI.VectorOfVariables}) = (SOC, RSOC)

function MOI.get(
    model::Optimizer,
    ::MOI.ListOfConstraintIndices{F,S},
) where {
    F<:Union{
        MOI.ScalarAffineFunction{Float64},
        MOI.ScalarQuadraticFunction{Float64},
        MOI.ScalarNonlinearFunction,
        MOI.VectorAffineFunction{Float64},
        MOI.VectorOfVariables,
    },
    S,
}
    indices = MOI.ConstraintIndex{F,S}[]
    for (key, info) in model.affine_constraint_info
        if info.type in _function_enums(F) && typeof(info.set) == S
            push!(indices, MOI.ConstraintIndex{F,S}(key))
        end
    end
    return sort!(indices; by = x -> x.value)
end

function MOI.get(
    model::Optimizer,
    ::MOI.ListOfConstraintIndices{MOI.VectorOfVariables,S},
) where {S<:Union{<:MOI.SOS1,<:MOI.SOS2}}
    indices = MOI.ConstraintIndex{MOI.VectorOfVariables,S}[]
    for (key, info) in model.sos_constraint_info
        if typeof(info.set) == S
            push!(indices, MOI.ConstraintIndex{MOI.VectorOfVariables,S}(key))
        end
    end
    return sort!(indices; by = x -> x.value)
end

function MOI.get(model::Optimizer, ::MOI.ListOfConstraintTypesPresent)
    constraints = Set{Tuple{Type,Type}}()
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
            push!(
                constraints,
                (MOI.ScalarAffineFunction{Float64}, typeof(info.set)),
            )
        elseif info.type == INDICATOR
            push!(
                constraints,
                (MOI.VectorAffineFunction{Float64}, typeof(info.set)),
            )
        elseif info.type == QUADRATIC
            push!(
                constraints,
                (MOI.ScalarQuadraticFunction{Float64}, typeof(info.set)),
            )
        elseif info.type == SOC
            push!(constraints, (MOI.VectorOfVariables, MOI.SecondOrderCone))
        elseif info.type == RSOC
            push!(
                constraints,
                (MOI.VectorOfVariables, MOI.RotatedSecondOrderCone),
            )
        else
            @assert info.type == SCALAR_NONLINEAR
            push!(constraints, (MOI.ScalarNonlinearFunction, typeof(info.set)))
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
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},<:Any},
    chg::MOI.ScalarCoefficientChange{Float64},
)
    @checked Lib.XPRSchgcoef(
        model.inner,
        Cint(_info(model, c).row - 1),
        Cint(_info(model, chg.variable).column - 1),
        chg.new_coefficient,
    )
    return
end

function MOI.modify(
    model::Optimizer,
    cis::Vector{MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},S}},
    chgs::Vector{MOI.ScalarCoefficientChange{Float64}},
) where {S}
    nels = length(cis)
    @assert nels == length(chgs)
    rows = Vector{Cint}(undef, nels)
    cols = Vector{Cint}(undef, nels)
    coefs = Vector{Float64}(undef, nels)
    for i in 1:nels
        rows[i] = Cint(_info(model, cis[i]).row - 1)
        cols[i] = Cint(_info(model, chgs[i].variable).column - 1)
        coefs[i] = chgs[i].new_coefficient
    end
    @checked Lib.XPRSchgmcoef(model.inner, Cint(nels), rows, cols, coefs)
    return
end

function MOI.modify(
    model::Optimizer,
    c::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chg::MOI.ScalarCoefficientChange{Float64},
)
    @assert model.objective_type == SCALAR_AFFINE
    column = _info(model, chg.variable).column
    @checked Lib.XPRSchgobj(
        model.inner,
        Cint(1),
        Ref(Cint(column - 1)),
        Ref(chg.new_coefficient),
    )
    model.is_objective_set = true
    return
end

function MOI.modify(
    model::Optimizer,
    c::MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}},
    chgs::Vector{MOI.ScalarCoefficientChange{Float64}},
)
    @assert model.objective_type == SCALAR_AFFINE
    nels = length(chgs)
    cols = Vector{Cint}(undef, nels)
    coefs = Vector{Float64}(undef, nels)
    for i in 1:nels
        cols[i] = _info(model, chgs[i].variable).column - 1
        coefs[i] = chgs[i].new_coefficient
    end
    @checked Lib.XPRSchgobj(model.inner, Cint(length(coefs)), cols, coefs)
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
    replacement::MOI.ScalarAffineFunction,
    row::Integer,
)
    for term in replacement.terms
        col = _info(model, term.variable).column
        @checked Lib.XPRSchgcoef(
            model.inner,
            Cint(row - 1),
            Cint(col - 1),
            MOI.coefficient(term),
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
    replacement::MOI.ScalarAffineFunction,
    row::Integer,
)
    for term in previous.terms
        col = _info(model, term.variable).column
        @checked Lib.XPRSchgcoef(model.inner, row - 1, col - 1, 0.0)
    end
    for term in replacement.terms
        col = _info(model, term.variable).column
        val = MOI.coefficient(term)
        @checked Lib.XPRSchgcoef(model.inner, row - 1, col - 1, val)
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
    f1::MOI.ScalarAffineFunction{Float64},
    f2::MOI.ScalarAffineFunction{Float64},
)
    for (f1_term, f2_term) in zip(f1.terms, f2.terms)
        if MOI.term_indices(f1_term) != MOI.term_indices(f2_term)
            return false
        end
    end
    return true
end

function MOI.set(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},<:SCALAR_SETS},
    f::MOI.ScalarAffineFunction{Float64},
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
    _rhs = Ref(0.0)
    @checked Lib.XPRSgetrhs(model.inner, _rhs, Cint(row - 1), Cint(row - 1))
    rhs = Ref(_rhs[] - (replacement.constant - previous.constant))
    @checked Lib.XPRSchgrhs(model.inner, Cint(1), Ref(Cint(row - 1)), rhs)
    return
end

function _generate_basis_status(model::Optimizer)
    nvars = length(model.variable_info)
    nrows = length(model.affine_constraint_info)
    cstatus = Vector{Cint}(undef, nrows)
    vstatus = Vector{Cint}(undef, nvars)
    @checked Lib.XPRSgetbasis(model.inner, cstatus, vstatus)
    basis_status = BasisStatus(cstatus, vstatus)
    model.basis_status = basis_status
    return
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintBasisStatus,
    c::MOI.ConstraintIndex{MOI.ScalarAffineFunction{Float64},S},
) where {S<:SCALAR_SETS}
    if model.basis_status == nothing
        _generate_basis_status(model)
    end
    cbasis = model.basis_status.con_status[_info(model, c).row]
    if cbasis == 1
        return MOI.BASIC
    elseif cbasis == 0
        return MOI.NONBASIC
    elseif cbasis == 2
        return MOI.NONBASIC
    else
        @assert cbasis == 3
        return MOI.SUPER_BASIC
    end
end

function MOI.get(
    model::Optimizer,
    ::MOI.VariableBasisStatus,
    x::MOI.VariableIndex,
)
    if model.basis_status == nothing
        _generate_basis_status(model)
    end
    vbasis = model.basis_status.var_status[_info(model, x).column]
    if vbasis == 1
        return MOI.BASIC
    elseif vbasis == 0
        return MOI.NONBASIC_AT_LOWER
    elseif vbasis == 2
        return MOI.NONBASIC_AT_UPPER
    else
        @assert vbasis == 3
        return MOI.SUPER_BASIC
    end
end

###
### VectorOfVariables-in-SecondOrderCone
###

function MOI.add_constrained_variables(
    model::Optimizer,
    s::S,
) where {S<:Union{MOI.SecondOrderCone,MOI.RotatedSecondOrderCone}}
    N = s.dimension
    vis = MOI.add_variables(model, N)
    return vis, MOI.add_constraint(model, MOI.VectorOfVariables(vis), s)
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VectorOfVariables,
    s::MOI.SecondOrderCone,
)
    if length(f.variables) != s.dimension
        error("Dimension of $(s) does not match number of terms in $(f)")
    end
    vs_info = _info.(model, f.variables)
    for v in vs_info
        if v.in_soc
            error(
                "Variable $(v.index) already belongs a to SOC or RSOC constraint",
            )
        end
    end
    # SOC is the cone: t ≥ ||x||₂ ≥ 0. In Xpress' quadratic form, this is
    # Σᵢ xᵢ² - t² <= 0 and t ≥ 0.
    # First, check the lower bound on t.
    lb = _get_variable_lower_bound(model, vs_info[1])
    if isnan(vs_info[1].lower_bound_if_soc) && lb < 0.0
        vs_info[1].lower_bound_if_soc = lb
        @checked Lib.XPRSchgbounds(
            model.inner,
            Cint(1),
            Ref(Cint(vs_info[1].column - 1)),
            Ref(UInt8('L')),
            Ref(0.0),
        )
    end
    vs_info[1].num_soc_constraints += 1
    # Now add the quadratic constraint.
    I = Cint[Cint(vs_info[i].column - 1) for i in 1:s.dimension]
    V = fill(1.0, s.dimension)
    V[1] = -1.0
    @checked Lib.XPRSaddrows(
        model.inner,
        1,
        Cint(0),
        Ref{UInt8}(Cchar('L')),
        Ref(0.0),
        C_NULL,
        Ref{Cint}(0),
        C_NULL,
        C_NULL,
    )
    ncons = @_invoke Lib.XPRSgetintattrib(
        model.inner,
        Lib.XPRS_ORIGINALROWS,
        _,
    )::Int
    @checked Lib.XPRSaddqmatrix(model.inner, ncons - 1, length(I), I, I, V)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, SOC)
    for v in vs_info
        v.in_soc = true
    end
    F, S = MOI.VectorOfVariables, MOI.SecondOrderCone
    return MOI.ConstraintIndex{F,S}(model.last_constraint_index)
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.VectorOfVariables,
    s::MOI.RotatedSecondOrderCone,
)
    if length(f.variables) != s.dimension
        error("Dimension of $(s) does not match number of terms in $(f)")
    end
    vs_info = _info.(model, f.variables)
    for v in vs_info
        if v.in_soc
            error(
                "Variable $(v.index) already belongs a to SOC or RSOC constraint",
            )
        end
    end
    # RSOC is the cone: 2tu ≥ ||x||₂^2 ≥ 0, t ≥ 0, u ≥ 0. In Xpress' quadratic
    # form, this is
    #   Σᵢ xᵢ² - 2tu <= 0 and t ≥ 0, u ≥ 0.
    # First, check the lower bound on t and u.
    for i in 1:2
        lb = _get_variable_lower_bound(model, vs_info[i])
        if isnan(vs_info[i].lower_bound_if_soc) && lb < 0.0
            vs_info[i].lower_bound_if_soc = lb
            @checked Lib.XPRSchgbounds(
                model.inner,
                Cint(1),
                Ref(Cint(vs_info[i].column - 1)),
                Ref(UInt8('L')),
                Ref(0.0),
            )
        end
        vs_info[i].num_soc_constraints += 1
    end
    # Now add the quadratic constraint.
    I = Cint[Cint(vs_info[i].column - 1) for i in 1:s.dimension if i != 2]
    J = Cint[Cint(vs_info[i].column - 1) for i in 1:s.dimension if i != 1]
    V = fill(1.0, s.dimension - 1)
    V[1] = -1.0 # just the upper triangle
    @checked Lib.XPRSaddrows(
        model.inner,
        1,
        Cint(0),
        Ref{UInt8}(Cchar('L')),
        Ref(0.0),
        C_NULL,
        Ref{Cint}(0),
        C_NULL,
        C_NULL,
    )
    ncons = @_invoke(
        Lib.XPRSgetintattrib(model.inner, Lib.XPRS_ORIGINALROWS, _)::Int,
    )
    @checked Lib.XPRSaddqmatrix(model.inner, ncons - 1, length(I), I, J, V)
    model.last_constraint_index += 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(length(model.affine_constraint_info) + 1, s, RSOC)
    # set variables to SOC
    for v in vs_info
        v.in_soc = true
    end
    F, S = MOI.VectorOfVariables, MOI.RotatedSecondOrderCone
    return MOI.ConstraintIndex{F,S}(model.last_constraint_index)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.SecondOrderCone},
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    info = _info(model, c)
    @checked Lib.XPRSdelrows(model.inner, 1, Ref{Cint}(info.row - 1))
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
    @assert t_info.num_soc_constraints == 0
    if isnan(t_info.lower_bound_if_soc)
        return  # Don't do anything. It must have a >0 lower bound anyway.
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
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.RotatedSecondOrderCone},
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    info = _info(model, c)
    @checked Lib.XPRSdelrows(model.inner, 1, Ref{Cint}(info.row - 1))
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
        @assert t_info.num_soc_constraints == 0
        if isnan(t_info.lower_bound_if_soc)
            continue  # Don't do anything. It must have a >0 lower bound anyway.
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
    model::Optimizer,
    ::MOI.ConstraintSet,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,S},
) where {S<:Union{MOI.SecondOrderCone,MOI.RotatedSecondOrderCone}}
    return _info(model, c).set
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.SecondOrderCone},
)
    nqelem = Ref{Cint}()
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    mqcol1 = Array{Cint}(undef, nqelem[])
    mqcol2 = Array{Cint}(undef, nqelem[])
    dqe = Array{Float64}(undef, nqelem[])
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        mqcol1,
        mqcol2,
        dqe,
    )
    mqcol1 .+= 1
    mqcol2 .+= 1
    I, J, V = mqcol1, mqcol2, dqe
    t = nothing
    x = MOI.VariableIndex[]
    sizehint!(x, length(I) - 1)
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
    model::Optimizer,
    ::MOI.ConstraintFunction,
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.RotatedSecondOrderCone},
)
    nqelem = Ref{Cint}()
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    I = Array{Cint}(undef, nqelem[])
    J = Array{Cint}(undef, nqelem[])
    V = Array{Float64}(undef, nqelem[])
    @checked Lib.XPRSgetqrowqmatrixtriplets(
        model.inner,
        _info(model, c).row - 1,
        nqelem,
        I,
        J,
        V,
    )
    I .+= 1
    J .+= 1
    t = nothing
    u = nothing
    x = MOI.VariableIndex[]
    sizehint!(x, length(I) - 2)
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
    c::MOI.ConstraintIndex{MOI.VectorOfVariables,<:Any},
)
    f = MOI.get(model, MOI.ConstraintFunction(), c)
    return MOI.get(model, MOI.VariablePrimal(), f.variables)
end

###
### IIS
###

function getfirstiis(model::Optimizer)
    status_code = Ref{Cint}(0)
    @checked Lib.XPRSiisfirst(model.inner, 1, status_code)
    if status_code[] == 1  # The problem is actually feasible.
        return IISData(status_code[], 0, 0, Cint[], Cint[], UInt8[], UInt8[])
    elseif 2 <= status_code[] <= 3 # 2 = error, 3 = timeout
        if model.moi_warnings
            @warn(
                "Xpress can't find IIS with invalid bounds, the constraints " *
                "that keep the model infeasible can't be found, only the " *
                "infeasible bounds will be available",
            )
        end
        nvars = length(model.variable_info)
        lbs, ubs = zeros(Cdouble, nvars), zeros(Cdouble, nvars)
        @checked Lib.XPRSgetlb(model.inner, lbs, Cint(0), Cint(nvars - 1))
        @checked Lib.XPRSgetub(model.inner, ubs, Cint(0), Cint(nvars - 1))
        miiscol, colbndtype = Cint[], Cchar[]
        for (col, (l, u)) in enumerate(zip(lbs, ubs))
            if l > u
                push!(miiscol, Cint(col - 1))
                push!(colbndtype, Cchar('L'))
                push!(miiscol, Cint(col - 1))
                push!(colbndtype, Cchar('U'))
            end
        end
        ncols = length(miiscol)
        code = status_code[]
        return IISData(code, 0, ncols, Cint[], miiscol, UInt8[], colbndtype)
    end
    # XPRESS' API works in two steps: first, retrieve the sizes of the arrays to
    # retrieve; then, the user is expected to allocate the needed memory,
    # before asking XPRESS to fill it.
    num = Cint(1)
    rownumber = Ref{Cint}(0)
    colnumber = Ref{Cint}(0)
    @checked Lib.XPRSgetiisdata(
        model.inner,
        num,
        rownumber,
        colnumber,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    nrows = rownumber[]
    ncols = colnumber[]
    miisrow = Vector{Cint}(undef, nrows)
    miiscol = Vector{Cint}(undef, ncols)
    constrainttype = Vector{UInt8}(undef, nrows)
    colbndtype = Vector{UInt8}(undef, ncols)
    @checked Lib.XPRSgetiisdata(
        model.inner,
        num,
        rownumber,
        colnumber,
        miisrow,
        miiscol,
        constrainttype,
        colbndtype,
        C_NULL,
        C_NULL,
        C_NULL,
        C_NULL,
    )
    return IISData(
        status_code[],
        nrows,
        ncols,
        miisrow,
        miiscol,
        constrainttype,
        colbndtype,
    )
end

function MOI.compute_conflict!(model::Optimizer)
    model.conflict = getfirstiis(model)
    return
end

function _ensure_conflict_computed(model::Optimizer)
    if model.conflict === nothing
        error(
            "Cannot access conflict status. Call `MOI.compute_conflict!(model)` first. " *
            "In case the model is modified, the computed conflict will not be purged.",
        )
    end
    return
end

function MOI.get(model::Optimizer, ::MOI.ConflictStatus)
    if model.conflict === nothing
        return MOI.COMPUTE_CONFLICT_NOT_CALLED
    elseif model.conflict.stat == 0
        return MOI.CONFLICT_FOUND
    elseif model.conflict.stat == 1
        return MOI.NO_CONFLICT_EXISTS
    else
        # stat == 2 -> error
        # stat == 3 -> timeout
        if model.conflict.colnumber > 0
            # We can sometimes find a bound violation conflict
            return MOI.CONFLICT_FOUND
        end
        return MOI.NO_CONFLICT_FOUND
    end
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{
        <:MOI.ScalarAffineFunction,
        <:Union{MOI.LessThan,MOI.GreaterThan,MOI.EqualTo},
    },
)
    _ensure_conflict_computed(model)
    if _info(model, index).row - 1 in model.conflict.miisrow
        return MOI.IN_CONFLICT
    end
    return MOI.NOT_IN_CONFLICT
end

col_type_char(::Type{MOI.LessThan{Float64}}) = (Cchar('U'),)
col_type_char(::Type{MOI.GreaterThan{Float64}}) = (Cchar('L'),)
col_type_char(::Type{MOI.EqualTo{Float64}}) = Cchar.(('F', 'L', 'U'))
col_type_char(::Type{MOI.Interval{Float64}}) = Cchar.(('T', 'L', 'U'))
col_type_char(::Type{MOI.Integer}) = (Cchar('I'),)
col_type_char(::Type{MOI.Semicontinuous{Float64}}) = Cchar.(('S', 'L', 'U'))
col_type_char(::Type{MOI.Semiinteger{Float64}}) = Cchar.(('R', 'L', 'U'))

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{MOI.VariableIndex,S},
) where {S<:MOI.AbstractScalarSet}
    _ensure_conflict_computed(model)
    ref_col = _info(model, index).column - 1
    for (bnd, col) in zip(model.conflict.colbndtype, model.conflict.miiscol)
        if col == ref_col && bnd in col_type_char(S)
            return MOI.IN_CONFLICT
        end
    end
    return MOI.NOT_IN_CONFLICT
end

function MOI.get(
    model::Optimizer,
    ::MOI.ConstraintConflictStatus,
    index::MOI.ConstraintIndex{MOI.VariableIndex,MOI.ZeroOne},
)
    _ensure_conflict_computed(model)
    ref_col = _info(model, index).column - 1
    for (bnd, col) in zip(model.conflict.colbndtype, model.conflict.miiscol)
        if col == ref_col
            if bnd == Cchar('B')
                return MOI.IN_CONFLICT
            elseif bnd == Cchar('L') || bnd == Cchar('U')
                return MOI.MAYBE_IN_CONFLICT
            end
        end
    end
    return MOI.NOT_IN_CONFLICT
end

#=
    MOI.write_to_file
=#

function MOI.write_to_file(model::Optimizer, name::String)
    flag = endswith(name, ".mps") ? "" : "l"
    @checked Lib.XPRSwriteprob(model.inner, name, flag)
    return
end

#=
    _pass_names_to_solver
=#

function _pass_names_to_solver(model::Optimizer; warn::Bool = true)
    _pass_variable_names_to_solver(model; warn = warn)
    _pass_constraint_names_to_solver(model; warn = warn)
    return
end

function _pass_variable_names_to_solver(model::Optimizer; warn::Bool = true)
    max_name_length = 64
    n = length(model.variable_info)
    if n == 0
        return
    end
    names = String["C$i" for i in 1:n]
    duplicate_check = Set{String}()
    for info in values(model.variable_info)
        if isempty(info.name)
            continue
        elseif length(info.name) > max_name_length
            if warn
                @warn(
                    "Skipping variable name because it is longer than " *
                    "$max_name_length characters: $(info.name)",
                )
            end
        elseif info.name in duplicate_check
            if warn
                @warn("Skipping duplicate variable name $(info.name)")
            end
        else
            names[info.column] = info.name
            push!(duplicate_check, info.name)
        end
    end
    @checked Lib.XPRSaddnames(model.inner, 2, join(names, "\0"), 0, n - 1)
    return
end

function _pass_constraint_names_to_solver(model::Optimizer; warn::Bool = true)
    max_name_length = 64
    n = length(model.affine_constraint_info)
    if n == 0
        return
    end
    names = String["R$i" for i in 1:n]
    duplicate_check = Set{String}()
    for info in values(model.affine_constraint_info)
        if isempty(info.name)
            continue
        elseif length(info.name) > max_name_length
            if warn
                @warn(
                    "Skipping constraint name because it is longer than " *
                    "$max_name_length characters: $(info.name)",
                )
            end
        elseif info.name in duplicate_check
            if warn
                @warn("Skipping duplicate constraint name $(info.name)")
            end
        else
            names[info.row] = info.name
            push!(duplicate_check, info.name)
        end
    end
    @checked Lib.XPRSaddnames(model.inner, 1, join(names, "\0"), 0, n - 1)
    return
end

function _get_variable_names(model::Optimizer)
    return _get_names(model, Cint(2), length(model.variable_info))
end

function _get_constraint_names(model::Optimizer)
    return _get_names(model, Cint(1), length(model.affine_constraint_info))
end

function _get_names(model::Optimizer, type::Cint, n::Int; name_length::Int = 64)
    buffer = fill(UInt8('\0'), n * (8 * name_length + 1))
    GC.@preserve buffer begin
        @checked Lib.XPRSgetnames(model.inner, type, pointer(buffer), 0, n - 1)
    end
    return String.(strip.(split(String(buffer), '\0'; keepempty = false)))
end

#=
    Reduced costs
=#

struct ReducedCost <: MOI.AbstractVariableAttribute
    result_index::Int
    ReducedCost(result_index::Int = 1) = new(result_index)
end

MOI.is_set_by_optimize(::ReducedCost) = true

MOI.attribute_value_type(::ReducedCost) = Float64

function MOI.get(model::Optimizer, attr::ReducedCost, vi::MOI.VariableIndex)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    column = _info(model, vi).column
    return model.cached_solution.variable_dual[column]
end

#=
    RelativeGapTolerance
=#

MOI.supports(::Optimizer, ::MOI.RelativeGapTolerance) = true

function MOI.get(model::Optimizer, ::MOI.RelativeGapTolerance)
    return getcontrol(model.inner, "XPRS_MIPRELSTOP")
end

function MOI.set(model::Optimizer, ::MOI.RelativeGapTolerance, value::Float64)
    setcontrol!(model.inner, "XPRS_MIPRELSTOP", value)
    return
end

#=
    AbsoluteGapTolerance
=#

MOI.supports(::Optimizer, ::MOI.AbsoluteGapTolerance) = true

function MOI.get(model::Optimizer, ::MOI.AbsoluteGapTolerance)
    return getcontrol(model.inner, "XPRS_MIPABSSTOP")
end

function MOI.set(model::Optimizer, ::MOI.AbsoluteGapTolerance, value::Float64)
    setcontrol!(model.inner, "XPRS_MIPABSSTOP", value)
    return
end

#=
    ScalarNonlinearFunction
=#

_supports_nonlinear() = get_version() >= v"41"

function MOI.supports_constraint(
    ::Optimizer,
    ::Type{MOI.ScalarNonlinearFunction},
    ::Type{
        <:Union{
            MOI.LessThan{Float64},
            MOI.GreaterThan{Float64},
            MOI.EqualTo{Float64},
        },
    },
)
    return get_version() >= v"41"
end

const _FUNCTION_MAP = Dict(
    # Handled explicitly: Lib.XPRS_OP_UMINUS
    :^ => (Lib.XPRS_TOK_OP, Lib.XPRS_OP_EXPONENT),
    :* => (Lib.XPRS_TOK_OP, Lib.XPRS_OP_MULTIPLY),
    :/ => (Lib.XPRS_TOK_OP, Lib.XPRS_OP_DIVIDE),
    :+ => (Lib.XPRS_TOK_OP, Lib.XPRS_OP_PLUS),
    :- => (Lib.XPRS_TOK_OP, Lib.XPRS_OP_MINUS),
    # const XPRS_DEL_COMMA = 1
    # const XPRS_DEL_COLON = 2
    # const XPRS_IFUN_LOG = 13
    :log10 => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_LOG10),
    :log => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_LN),
    :exp => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_EXP),
    :abs => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ABS),
    :sqrt => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_SQRT),
    :sin => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_SIN),
    :cos => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_COS),
    :tan => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_TAN),
    :asin => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ARCSIN),
    :acos => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ARCCOS),
    :atan => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ARCTAN),
    :max => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_MIN),
    :min => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_MAX),
    # const XPRS_IFUN_PWL = 35
    # Handled explicitly: XPRS_IFUN_SUM
    # Handled explicitly: XPRS_IFUN_PROD
    :sign => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_SIGN),
    :erf => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ERF),
    :erfc => (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_ERFC),
)

function _reverse_polish(
    model::Optimizer,
    f::MOI.ScalarNonlinearFunction,
    type::Vector{Cint},
    value::Vector{Cdouble},
)
    ret = get(_FUNCTION_MAP, f.head, nothing)
    if ret === nothing
        throw(MOI.UnsupportedNonlinearOperator(f.head))
    elseif f.head == :+ && length(f.args) != 2  # Special handling for n-ary +
        ret = (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_SUM)
    elseif f.head == :* && length(f.args) != 2  # Special handling for n-ary *
        ret = (Lib.XPRS_TOK_IFUN, Lib.XPRS_IFUN_PROD)
    elseif f.head == :- && length(f.args) == 1  # Special handling for unary -
        ret = (Lib.XPRS_TOK_OP, Lib.XPRS_OP_UMINUS)
    end
    push!(type, ret[1])
    push!(value, ret[2])
    for arg in reverse(f.args)
        _reverse_polish(model, arg, type, value)
    end
    if ret[1] == Lib.XPRS_TOK_IFUN
        # XPRS_TOK_LB is not needed because it is implied by XPRS_TOK_IFUN
        push!(type, Lib.XPRS_TOK_RB)
        push!(value, 0.0)
    end
    return
end

function _reverse_polish(
    ::Optimizer,
    f::Real,
    type::Vector{Cint},
    value::Vector{Cdouble},
)
    push!(type, Lib.XPRS_TOK_CON)
    push!(value, Cdouble(f))
    return
end

function _reverse_polish(
    model::Optimizer,
    x::MOI.VariableIndex,
    type::Vector{Cint},
    value::Vector{Cdouble},
)
    push!(type, Lib.XPRS_TOK_COL)
    push!(value, _info(model, x).column - 1)
    return
end

function _reverse_polish(
    model::Optimizer,
    f::MOI.AbstractScalarFunction,
    type::Vector{Cint},
    value::Vector{Cdouble},
)
    _reverse_polish(model, convert(MOI.ScalarNonlinearFunction, f), type, value)
    return
end

function MOI.add_constraint(
    model::Optimizer,
    f::MOI.ScalarNonlinearFunction,
    s::Union{
        MOI.LessThan{Float64},
        MOI.GreaterThan{Float64},
        MOI.EqualTo{Float64},
    },
)
    model.last_constraint_index += 1
    row = length(model.affine_constraint_info) + 1
    model.affine_constraint_info[model.last_constraint_index] =
        ConstraintInfo(row, s, SCALAR_NONLINEAR)
    sense, rhs = _sense_and_rhs(s)
    @checked Lib.XPRSaddrows(
        model.inner,
        1,
        0,
        Ref{UInt8}(sense),
        Ref(rhs),
        C_NULL,
        Cint[0],
        Cint[],
        Cdouble[],
    )
    parsed, type, value = Cint(1), Cint[], Cdouble[]
    _reverse_polish(model, f, type, value)
    reverse!(type)
    reverse!(value)
    push!(type, Lib.XPRS_TOK_EOF)
    push!(value, 0.0)
    @checked Lib.XPRSnlpchgformula(model.inner, row - 1, parsed, type, value)
    model.has_nlp_constraints = true
    return MOI.ConstraintIndex{typeof(f),typeof(s)}(model.last_constraint_index)
end

function MOI.delete(
    model::Optimizer,
    c::MOI.ConstraintIndex{MOI.ScalarNonlinearFunction,<:Any},
)
    row = _info(model, c).row
    @checked Lib.XPRSnlpdelformulas(model.inner, 1, Ref{Cint}(row - 1))
    @checked Lib.XPRSdelrows(model.inner, 1, Ref{Cint}(row - 1))
    for (key, info) in model.affine_constraint_info
        if info.row > row
            info.row -= 1
        end
    end
    delete!(model.affine_constraint_info, c.value)
    model.name_to_constraint_index = nothing
    return
end

# This seemed to return wrong answers, likely because it is locally solving to
# the local SLP solution, not the dual solution expected by, e.g., Ipopt?
# function MOI.get(
#     model::Optimizer,
#     attr::MOI.ConstraintDual,
#     c::MOI.ConstraintIndex{MOI.ScalarNonlinearFunction,<:Any},
# )
#     _throw_if_optimize_in_progress(model, attr)
#     MOI.check_result_index_bounds(model, attr)
#     row = _info(model, c).row
#     return _dual_multiplier(model) * model.cached_solution.linear_dual[row]
# end

function MOI.get(
    model::Optimizer,
    attr::MOI.ConstraintPrimal,
    c::MOI.ConstraintIndex{MOI.ScalarNonlinearFunction,<:Any},
)
    _throw_if_optimize_in_progress(model, attr)
    MOI.check_result_index_bounds(model, attr)
    row = _info(model, c).row
    return model.cached_solution.linear_primal[row]
end

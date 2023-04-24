struct XpressError <: Exception
    errorcode::Int
    msg::String
    # TODO try to append string from Xpress.getlasterror(model) here
    # only possible on call that had the model as parameter
end

function Base.showerror(io::IO, err::XpressError)
    print(io, "XpressError($(err.errorcode)): ")
    if err.errorcode == 1
        print(io, "Bad input encountered.")
    elseif err.errorcode == 2
        print(io, "Bad or corrupt file - unrecoverable.")
    elseif err.errorcode == 4
        print(io, "Memory error.")
    elseif err.errorcode == 8
        print(io, "Corrupt use.")
    elseif err.errorcode == 16
        print(io, "Program error.")
    elseif err.errorcode == 32
        print(io, "Subroutine not completed successfully, possibly due to invalid argument.")
    elseif err.errorcode == 128
        print(io, "Too many users.")
    else
        print(io, "Unrecoverable error.")
    end
    print(io, " $(err.msg)")
end

function fixinfinity(val::Float64)
    if val == Inf
        return Lib.XPRS_PLUSINFINITY
    elseif val == -Inf
        return Lib.XPRS_MINUSINFINITY
    else
        return val
    end
end

function fixinfinity!(vals::Vector{Float64})
    map!(fixinfinity, vals, vals)
end

"""
    Xpress.CWrapper

abstract type Xpress.CWrapper
"""
abstract type CWrapper end

Base.unsafe_convert(::Type{Ptr{Cvoid}}, t::CWrapper) = (t.ptr == C_NULL) ? throw(XpressError(255, "Received null pointer in CWrapper. Something must be wrong.")) : t.ptr

mutable struct XpressProblem <: CWrapper
    ptr::Lib.XPRSprob
    logfile::String
    function XpressProblem(ptr::Lib.XPRSprob; finalize_env::Bool = true, logfile = "")
        model = new(ptr, logfile)
        if finalize_env
            finalizer(destroyprob, model)
        end
        return model
    end
end

function get_xpress_error_message(prob::XpressProblem)
    last_error = @_invoke Lib.XPRSgetlasterror(prob, _)::String 
    lstrip(last_error, ['?'])
end

function XpressProblem(; logfile = "")
    ref = Ref{Lib.XPRSprob}()
    Lib.XPRScreateprob(ref)
    @assert ref[] != C_NULL "Failed to create XpressProblem. Received null pointer from Xpress C interface."
    p = XpressProblem(ref[], logfile = logfile)
    if logfile != ""
        Lib.XPRSsetlogfile(p, logfile)
    end
    return p
end

get_banner() = @_invoke Lib.XPRSgetbanner(_)::String
get_version_raw() = @_invoke Lib.XPRSgetversion(_)::String
get_version() = VersionNumber(parse.(Int, split(get_version_raw(), "."))...)

#addcolnames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 2)
#addrownames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 1)

function get_control_or_attribute(prob::XpressProblem, control::Integer)
    if control in INTEGER_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetintcontrol(prob, Int32(control), _)::Int
    elseif control in DOUBLE_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetdblcontrol(prob, Int32(control), _)::Float64
    elseif control in STRING_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetstrcontrol(prob, Int32(control), _)::String
    elseif control in INTEGER_ATTRIBUTES_VALUES
        return @_invoke Lib.XPRSgetintattrib(prob, Int32(control), _)::Int
    elseif control in DOUBLE_ATTRIBUTES_VALUES
        return @_invoke Lib.XPRSgetdblattrib(prob, Int32(control), _)::Float64
    elseif control in STRING_ATTRIBUTES_VALUES
        return @_invoke Lib.XPRSgetstrattrib(prob, Int32(control), _)::String
    else
        error("Unrecognized parameter: $(control).")
    end
end
function get_control_or_attribute(prob::XpressProblem, control::String)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetintcontrol(prob, Int32(control_index), _)::Int
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetdblcontrol(prob, Int32(control_index), _)::Float64
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetstrcontrol(prob, Int32(control_index), _)::String
    end
    control_index = get(INTEGER_ATTRIBUTES, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetintattrib(prob, control_index, _)::Int
    end
    control_index = get(DOUBLE_ATTRIBUTES, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetdblattrib(prob, control_index, _)::Float64
    end
    control_index = get(STRING_ATTRIBUTES, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetstrattrib(prob, control_index, _)::String
    end
    error("Unrecognized control parameter: $(control).")
end

"""
    getcontrol(prob::XpressProblem, control::Integer)
    getcontrol(prob::XpressProblem, control::String)
    getcontrol(prob::XpressProblem, control::Symbol)

Get parameter of any type
"""
function getcontrol(prob::XpressProblem, control::Integer)
    # TODO: dispatch on Val(control) instead?
    if control in INTEGER_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetintcontrol(prob, Int32(control), _)::Int
    elseif control in DOUBLE_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetdblcontrol(prob, Int32(control), _)::Float64
    elseif control in STRING_CONTROLS_VALUES
        return @_invoke Lib.XPRSgetstrcontrol(prob, Int32(control), _)::String
    else
        error("Unrecognized control parameter: $(control).")
    end
end
function getcontrol(prob::XpressProblem, control::String)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetintcontrol(prob, Int32(control_index), _)::Int
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetdblcontrol(prob, Int32(control_index), _)::Float64
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return @_invoke Lib.XPRSgetstrcontrol(prob, Int32(control_index), _)::String
    end
    error("Unrecognized control parameter: $(control).")
end

# getcontrol(prob::XpressProblem, control::Symbol) = getcontrol(prob, getproperty(Lib, Symbol("XPRS_$(String(control))")))

"""
    setcontrol!(prob::XpressProblem, control::Symbol, val::Any)
    setcontrol!(prob::XpressProblem, control::String, val::Any)
    setcontrol!(prob::XpressProblem, control::Integer, val::Any)

Set parameter of any type
"""
# setcontrol!(prob::XpressProblem, control::Symbol, val::Any) = setcontrol!(prob, getproperty(Lib, Symbol("XPRS_$(String(control))")), val::Any)
setcontrol!(prob::XpressProblem, control::Integer, val) = setcontrol!(prob, Cint(control), val)
function setcontrol!(prob::XpressProblem, control::Cint, val)
    # TODO: dispatch on Val(control) instead?
    if control in INTEGER_CONTROLS_VALUES
        if isinteger(val)
            Lib.XPRSsetintcontrol(prob, Cint(control), Int32(val))
        else
            error("Expected and integer and got $val")
        end
    elseif control in DOUBLE_CONTROLS_VALUES
        Lib.XPRSsetdblcontrol(prob, control, Float64(val))
    elseif control in STRING_CONTROLS_VALUES
        Lib.XPRSsetstrcontrol(prob, control, val)
    else
        error("Unrecognized control parameter: $(control).")
    end
end
function setcontrol!(prob::XpressProblem, control::String, val)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        if isinteger(val)
            return Lib.XPRSsetintcontrol(prob, Cint(control_index), Int32(val))
        else
            error("Expected and integer and got $val")
        end
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return Lib.XPRSsetdblcontrol(prob, control_index, Float64(val))
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return Lib.XPRSsetstrcontrol(prob, control_index, val)
    end
    error("Unrecognized control parameter: $(control).")
end

"""
    setparams!(prob::XpressProblem;args...)

Set multiple parameters of any type
"""
function setcontrols!(prob::XpressProblem; args...)
    for (control, val) in args
        setcontrol!(prob, getproperty(Lib, control), val)
    end
end

# originals are more important to be used everywhere, presolved are actually
# secondary
n_variables(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALCOLS, _)::Int
n_constraints(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALROWS, _)::Int
n_special_ordered_sets(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALSETS, _)::Int
n_quadratic_constraints(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALQCONSTRAINTS, _)::Int
n_non_zero_elements(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ELEMS, _)::Int
n_quadratic_elements(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALQELEMS, _)::Int
n_quadratic_row_coefficients(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALQCELEMS, _)::Int
n_entities(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALMIPENTS, _)::Int
n_setmembers(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALSETMEMBERS, _)::Int

n_original_variables(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALCOLS, _)::Int
n_original_constraints(prob::XpressProblem) = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALROWS, _)::Int

obj_sense(prob::XpressProblem) = @_invoke Lib.XPRSgetdblattrib(prob, Lib.XPRS_OBJSENSE, _)::Float64
objective_sense(prob::XpressProblem) = obj_sense(prob)  == Lib.XPRS_OBJ_MINIMIZE ? :minimize : :maximize

# derived attribute functions

"""
    n_nlp_constraints(prob::XpressProblem)
Return the number of nlp contraints in the XpressProblem
"""
n_nlp_constraints(prob::XpressProblem) = is_nonlinear(prob) ? n_constraints(prob) : 0

"""
    n_linear_constraints(prob::XpressProblem)
Return the number of purely linear contraints in the XpressProblem
"""
n_linear_constraints(prob::XpressProblem) = n_constraints(prob) - n_quadratic_constraints(prob) - n_nlp_constraints(prob)

"""
    is_qcp(prob::XpressProblem)
Return `true` if there are quadratic constraints in the XpressProblem
"""
is_quadratic_constraints(prob::XpressProblem) = n_quadratic_constraints(prob) > 0

"""
    is_mip(prob::XpressProblem)
Return `true` if there are integer entities in the XpressProblem
"""
is_mixedinteger(prob::XpressProblem) = (n_entities(prob) + n_special_ordered_sets(prob)) > 0

"""
    is_nonlinear(prob::XpressProblem)
Return `true` if there are nonlinear strings in the XpressProblem
"""

function is_nonlinear(prob::XpressProblem)
    buffer = Array{Cchar}(undef, 80)
    buffer_p = pointer(buffer)
    out = Cstring(buffer_p)
    ret=Lib.XPRSnlpgetformulastring(prob, Cint(0), out , 80)
    version = unsafe_string(out)::String

    buffer= Array{Cchar}(undef, 80)
    buffer_p = pointer(buffer)
    out = Cstring(buffer_p)
    ret=Lib.XPRSnlpgetobjformulastring(prob, out , 80)
    version_obj = unsafe_string(out)::String

    if version == "" && version_obj == ""
        return false
    end
    return true
end

"""
    is_quadratic_objective(prob::XpressProblem)
Return `true` if there are quadratic terms in the objective in the XpressProblem
"""
is_quadratic_objective(prob::XpressProblem) = n_quadratic_elements(prob) > 0

"""
    problem_type(prob::XpressProblem)
Return a symbol enconding the type of the problem.]
Options are: `:LP`, `:QP` and `:QCP`
"""
function problem_type(prob::XpressProblem)
    is_nonlinear(prob) ? (:NLP) :
    is_quadratic_constraints(prob) ? (:QCP) :
    is_quadratic_objective(prob)  ? (:QP)  : (:LP)
end

"""
    show(io::IO, prob::XpressProblem)
Prints a simplified problem description
"""
function Base.show(io::IO, prob::XpressProblem)
    println(io, "Xpress Problem:"     )
    if is_mixedinteger(prob)
    println(io, "    type   : $(problem_type(prob)) (MIP)")
    else
    println(io, "    type   : $(problem_type(prob))")
    end
    println(io, "    sense  : $(objective_sense(prob))")
    println(io, "    number of variables                    = $(n_variables(prob))")
    println(io, "    number of linear constraints           = $(n_linear_constraints(prob))")
    println(io, "    number of quadratic constraints        = $(n_quadratic_constraints(prob))")
    println(io, "    number of sos constraints              = $(n_special_ordered_sets(prob))")
    println(io, "    number of nonlinear constraints        = $(n_nlp_constraints(prob))")
    println(io, "    number of non-zero coeffs              = $(n_non_zero_elements(prob))")
    println(io, "    number of non-zero qp objective terms  = $(n_quadratic_elements(prob))")
    println(io, "    number of non-zero qp constraint terms = $(n_quadratic_row_coefficients(prob))")
    println(io, "    number of integer entities             = $(n_entities(prob))")
end

const NLPSTATUS_STRING = Dict{Int,String}(
    Lib.XPRS_NLPSTATUS_UNSTARTED => "0 Unstarted ( XPRS_NLPSTATUS_UNSTARTED).",
    Lib.XPRS_NLPSTATUS_SOLUTION => "1 Global search incomplete - an integer solution has been found ( XPRS_NLPSTATUS_SOLUTION).",
    Lib.XPRS_NLPSTATUS_OPTIMAL => "2 Optimal ( XPRS_NLPSTATUS_OPTIMAL).",
    Lib.XPRS_NLPSTATUS_NOSOLUTION => "3 Global search complete - No solution found ( XPRS_NLPSTATUS_NOSOLUTION).",
    Lib.XPRS_NLPSTATUS_INFEASIBLE => "4 Infeasible ( XPRS_NLPSTATUS_INFEASIBLE).",
    Lib.XPRS_NLPSTATUS_UNBOUNDED => "5 Unbounded ( XPRS_NLPSTATUS_UNBOUNDED).",
    Lib.XPRS_NLPSTATUS_UNFINISHED => "6 Unfinished ( XPRS_NLPSTATUS_UNFINISHED).",
    Lib.XPRS_NLPSTATUS_UNSOLVED => "7 Problem could not be solved due to numerical issues. ( XPRS_NLPSTATUS_UNSOLVED).",
)

function nlp_solve_complete(stat)
    stat in [Lib.XPRS_NLPSTATUS_INFEASIBLE, Lib.XPRS_NLPSTATUS_OPTIMAL]
end
function nlp_solve_stopped(stat)
    stat in [Lib.XPRS_NLPSTATUS_INFEASIBLE, Lib.XPRS_NLPSTATUS_OPTIMAL]
end

const MIPSTATUS_STRING = Dict{Int,String}(
    Lib.XPRS_MIP_NOT_LOADED => "0 Problem has not been loaded ( XPRS_MIP_NOT_LOADED).",
    Lib.XPRS_MIP_LP_NOT_OPTIMAL => "1 Global search incomplete - the initial continuous relaxation has not been solved and no integer solution has been found ( XPRS_MIP_LP_NOT_OPTIMAL).",
    Lib.XPRS_MIP_LP_OPTIMAL => "2 Global search incomplete - the initial continuous relaxation has been solved and no integer solution has been found ( XPRS_MIP_LP_OPTIMAL).",
    Lib.XPRS_MIP_NO_SOL_FOUND => "3 Global search incomplete - no integer solution found ( XPRS_MIP_NO_SOL_FOUND).",
    Lib.XPRS_MIP_SOLUTION => "4 Global search incomplete - an integer solution has been found ( XPRS_MIP_SOLUTION).",
    Lib.XPRS_MIP_INFEAS => "5 Global search complete - no integer solution found ( XPRS_MIP_INFEAS).",
    Lib.XPRS_MIP_OPTIMAL => "6 Global search complete - integer solution found ( XPRS_MIP_OPTIMAL).",
    Lib.XPRS_MIP_UNBOUNDED => "7 Global search incomplete - the initial continuous relaxation was found to be unbounded. A solution may have been found ( XPRS_MIP_UNBOUNDED).",
)

function mip_solve_complete(stat)
    stat in [Lib.XPRS_MIP_INFEAS, Lib.XPRS_MIP_OPTIMAL]
end
function mip_solve_stopped(stat)
    stat in [Lib.XPRS_MIP_INFEAS, Lib.XPRS_MIP_OPTIMAL]
end

const LPSTATUS_STRING = Dict{Int,String}(
    Lib.XPRS_LP_UNSTARTED => "0 Unstarted ( XPRS_LP_UNSTARTED).",
    Lib.XPRS_LP_OPTIMAL => "1 Optimal ( XPRS_LP_OPTIMAL).",
    Lib.XPRS_LP_INFEAS => "2 Infeasible ( XPRS_LP_INFEAS).",
    Lib.XPRS_LP_CUTOFF => "3 Objective worse than cutoff ( XPRS_LP_CUTOFF).",
    Lib.XPRS_LP_UNFINISHED => "4 Unfinished ( XPRS_LP_UNFINISHED).",
    Lib.XPRS_LP_UNBOUNDED => "5 Unbounded ( XPRS_LP_UNBOUNDED).",
    Lib.XPRS_LP_CUTOFF_IN_DUAL => "6 Cutoff in dual ( XPRS_LP_CUTOFF_IN_DUAL).",
    Lib.XPRS_LP_UNSOLVED => "7 Problem could not be solved due to numerical issues. ( XPRS_LP_UNSOLVED).",
    Lib.XPRS_LP_NONCONVEX => "8 Problem contains quadratic data, which is not convex ( XPRS_LP_NONCONVEX).",
)

const STOPSTATUS_STRING = Dict{Int, String}(
    Lib.XPRS_STOP_NONE => "no interruption - the solve completed normally",
    Lib.XPRS_STOP_TIMELIMIT => "time limit hit",
    Lib.XPRS_STOP_CTRLC => "control C hit",
    Lib.XPRS_STOP_NODELIMIT => "node limit hit",
    Lib.XPRS_STOP_ITERLIMIT => "iteration limit hit",
    Lib.XPRS_STOP_MIPGAP => "MIP gap is sufficiently small",
    Lib.XPRS_STOP_SOLLIMIT => "solution limit hit",
    Lib.XPRS_STOP_USER => "user interrupt.",
)

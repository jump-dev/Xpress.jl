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
        return Xpress.Lib.XPRS_PLUSINFINITY
    elseif val == -Inf
        return Xpress.Lib.XPRS_MINUSINFINITY
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
    lstrip(Xpress.getlasterror(prob), ['?'])
end

function XpressProblem(; logfile = "")
    ref = Ref{Lib.XPRSprob}()
    createprob(ref)
    @assert ref[] != C_NULL "Failed to create XpressProblem. Received null pointer from Xpress C interface."
    p = XpressProblem(ref[], logfile = logfile)
    if logfile != ""
        setlogfile(p, logfile)
    end
    return p
end

addcolnames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 2)
addrownames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 1)

function get_control_or_attribute(prob::XpressProblem, control::Integer)
    if control in INTEGER_CONTROLS_VALUES
        return getintcontrol(prob, Int32(control))
    elseif control in DOUBLE_CONTROLS_VALUES
        return getdblcontrol(prob, Int32(control))
    elseif control in STRING_CONTROLS_VALUES
        return getstrcontrol(prob, Int32(control))
    elseif control in INTEGER_ATTRIBUTES_VALUES
        return getintattrib(prob, Int32(control))
    elseif control in DOUBLE_ATTRIBUTES_VALUES
        return getdblattrib(prob, Int32(control))
    elseif control in STRING_ATTRIBUTES_VALUES
        return getstrattrib(prob, Int32(control))
    else
        error("Unrecognized parameter: $(control).")
    end
end
function get_control_or_attribute(prob::XpressProblem, control::String)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        return getintcontrol(prob, control_index)
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return getdblcontrol(prob, control_index)
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return getstrcontrol(prob, control_index)
    end
    control_index = get(INTEGER_ATTRIBUTES, control, -1)
    if control_index != -1
        return getintattrib(prob, control_index)
    end
    control_index = get(DOUBLE_ATTRIBUTES, control, -1)
    if control_index != -1
        return getdblattrib(prob, control_index)
    end
    control_index = get(STRING_ATTRIBUTES, control, -1)
    if control_index != -1
        return getstrattrib(prob, control_index)
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
        return getintcontrol(prob, Int32(control))
    elseif control in DOUBLE_CONTROLS_VALUES
        return getdblcontrol(prob, Int32(control))
    elseif control in STRING_CONTROLS_VALUES
        return getstrcontrol(prob, Int32(control))
    else
        error("Unrecognized control parameter: $(control).")
    end
end
function getcontrol(prob::XpressProblem, control::String)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        return getintcontrol(prob, control_index)
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return getdblcontrol(prob, control_index)
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return getstrcontrol(prob, control_index)
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
            setintcontrol(prob, control, Int32(val))
        else
            error("Expected and integer and got $val")
        end
    elseif control in DOUBLE_CONTROLS_VALUES
        setdblcontrol(prob, control, Float64(val))
    elseif control in STRING_CONTROLS_VALUES
        setstrcontrol(prob, control, val)
    else
        error("Unrecognized control parameter: $(control).")
    end
end
function setcontrol!(prob::XpressProblem, control::String, val)
    control_index = get(INTEGER_CONTROLS, control, -1)
    if control_index != -1
        if isinteger(val)
            return setintcontrol(prob, control_index, Int32(val))
        else
            error("Expected and integer and got $val")
        end
    end
    control_index = get(DOUBLE_CONTROLS, control, -1)
    if control_index != -1
        return setdblcontrol(prob, control_index, Float64(val))
    end
    control_index = get(STRING_CONTROLS, control, -1)
    if control_index != -1
        return setstrcontrol(prob, control_index, val)
    end
    error("Unrecognized control parameter: $(control).")
end

"""
    setparams!(prob::XpressProblem;args...)

Set multiple parameters of any type
"""
function setcontrols!(prob::XpressProblem; args...)
    for (control, val) in args
        setcontrols!(prob, getproperty(Lib, control), val)
    end
end

# originals are more important to be used everywhere, presolved are actually
# secondary
n_variables(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALCOLS)
n_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALROWS)
n_special_ordered_sets(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALSETS)
n_quadratic_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALQCONSTRAINTS)
n_non_zero_elements(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ELEMS)
n_quadratic_elements(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALQELEMS)
n_quadratic_row_coefficients(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALQCELEMS)
n_entities(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALMIPENTS)
n_setmembers(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALSETMEMBERS)

n_original_variables(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALCOLS)
n_original_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALROWS)

objective_sense(prob::XpressProblem) = getdblattrib(prob, Lib.XPRS_OBJSENSE) == Lib.XPRS_OBJ_MINIMIZE ? :minimize : :maximize

# derived attribute functions

"""
    n_linear_constraints(prob::XpressProblem)
Return the number of purely linear contraints in the XpressProblem
"""
n_linear_constraints(prob::XpressProblem) = n_constraints(prob) - n_quadratic_constraints(prob)

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
    println(io, "    number of non-zero coeffs              = $(n_non_zero_elements(prob))")
    println(io, "    number of non-zero qp objective terms  = $(n_quadratic_elements(prob))")
    println(io, "    number of non-zero qp constraint terms = $(n_quadratic_row_coefficients(prob))")
    println(io, "    number of integer entities             = $(n_entities(prob))")
end

const MIPSTATUS_STRING = Dict{Int,String}(
    Xpress.Lib.XPRS_MIP_NOT_LOADED => "0 Problem has not been loaded ( XPRS_MIP_NOT_LOADED).",
    Xpress.Lib.XPRS_MIP_LP_NOT_OPTIMAL => "1 Global search incomplete - the initial continuous relaxation has not been solved and no integer solution has been found ( XPRS_MIP_LP_NOT_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_LP_OPTIMAL => "2 Global search incomplete - the initial continuous relaxation has been solved and no integer solution has been found ( XPRS_MIP_LP_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_NO_SOL_FOUND => "3 Global search incomplete - no integer solution found ( XPRS_MIP_NO_SOL_FOUND).",
    Xpress.Lib.XPRS_MIP_SOLUTION => "4 Global search incomplete - an integer solution has been found ( XPRS_MIP_SOLUTION).",
    Xpress.Lib.XPRS_MIP_INFEAS => "5 Global search complete - no integer solution found ( XPRS_MIP_INFEAS).",
    Xpress.Lib.XPRS_MIP_OPTIMAL => "6 Global search complete - integer solution found ( XPRS_MIP_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_UNBOUNDED => "7 Global search incomplete - the initial continuous relaxation was found to be unbounded. A solution may have been found ( XPRS_MIP_UNBOUNDED).",
)

function mip_solve_complete(stat)
    stat in [Xpress.Lib.XPRS_MIP_INFEAS, Xpress.Lib.XPRS_MIP_OPTIMAL]
end
function mip_solve_stopped(stat)
    stat in [Xpress.Lib.XPRS_MIP_INFEAS, Xpress.Lib.XPRS_MIP_OPTIMAL]
end

const LPSTATUS_STRING = Dict{Int,String}(
    Xpress.Lib.XPRS_LP_UNSTARTED => "0 Unstarted ( XPRS_LP_UNSTARTED).",
    Xpress.Lib.XPRS_LP_OPTIMAL => "1 Optimal ( XPRS_LP_OPTIMAL).",
    Xpress.Lib.XPRS_LP_INFEAS => "2 Infeasible ( XPRS_LP_INFEAS).",
    Xpress.Lib.XPRS_LP_CUTOFF => "3 Objective worse than cutoff ( XPRS_LP_CUTOFF).",
    Xpress.Lib.XPRS_LP_UNFINISHED => "4 Unfinished ( XPRS_LP_UNFINISHED).",
    Xpress.Lib.XPRS_LP_UNBOUNDED => "5 Unbounded ( XPRS_LP_UNBOUNDED).",
    Xpress.Lib.XPRS_LP_CUTOFF_IN_DUAL => "6 Cutoff in dual ( XPRS_LP_CUTOFF_IN_DUAL).",
    Xpress.Lib.XPRS_LP_UNSOLVED => "7 Problem could not be solved due to numerical issues. ( XPRS_LP_UNSOLVED).",
    Xpress.Lib.XPRS_LP_NONCONVEX => "8 Problem contains quadratic data, which is not convex ( XPRS_LP_NONCONVEX).",
)

const STOPSTATUS_STRING = Dict{Int, String}(
    Xpress.Lib.XPRS_STOP_NONE => "no interruption - the solve completed normally",
    Xpress.Lib.XPRS_STOP_TIMELIMIT => "time limit hit",
    Xpress.Lib.XPRS_STOP_CTRLC => "control C hit",
    Xpress.Lib.XPRS_STOP_NODELIMIT => "node limit hit",
    Xpress.Lib.XPRS_STOP_ITERLIMIT => "iteration limit hit",
    Xpress.Lib.XPRS_STOP_MIPGAP => "MIP gap is sufficiently small",
    Xpress.Lib.XPRS_STOP_SOLLIMIT => "solution limit hit",
    Xpress.Lib.XPRS_STOP_USER => "user interrupt.",
)

# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

struct XpressError <: Exception
    errorcode::Int
    msg::String
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
        print(
            io,
            "Subroutine not completed successfully, possibly due to invalid argument.",
        )
    elseif err.errorcode == 128
        print(io, "Too many users.")
    else
        print(io, "Unrecoverable error.")
    end
    return print(io, " $(err.msg)")
end

mutable struct XpressProblem
    ptr::Lib.XPRSprob
    logfile::String

    function XpressProblem(
        ptr::Lib.XPRSprob = C_NULL;
        finalize_env::Bool = true,
        logfile = "",
    )
        if ptr === C_NULL
            ref = Ref{Lib.XPRSprob}()
            Lib.XPRScreateprob(ref)
            ptr = ref[]
        end
        if ptr == C_NULL
            error(
                "Failed to create XpressProblem. Received null pointer from Xpress C interface.",
            )
        end
        model = new(ptr, logfile)
        if !isempty(logfile)
            Lib.XPRSsetlogfile(model, logfile)
        end
        if finalize_env
            finalizer(Lib.XPRSdestroyprob, model)
        end
        return model
    end
end

Base.cconvert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob

Base.unsafe_convert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob.ptr

function _invoke(f::Function, pos::Int, ::Type{Int}, args...)
    out = Ref{Cint}(0)
    args = collect(args)
    insert!(args, pos, out)
    if (r = f(args...)) != 0
        throw(XpressError(r, "Unable to invoke $f"))
    end
    return out[]
end

function _invoke(f::Function, pos::Int, ::Type{Float64}, args...)
    out = Ref{Float64}(0.0)
    args = collect(args)
    insert!(args, pos, out)
    if (r = f(args...)) != 0
        throw(XpressError(r, "Unable to invoke $f"))
    end
    return out[]
end

function _invoke(f::Function, pos::Int, ::Type{String}, args...)
    buffer = Array{Cchar}(undef, 1024)
    GC.@preserve buffer begin
        out = Cstring(pointer(buffer))
        args = collect(Any, args)
        insert!(args, pos, out)
        if (r = f(args...)) != 0
            throw(XpressError(r, "Unable to invoke $f"))
        end
        return unsafe_string(out)
    end
end

macro _invoke(expr)
    @assert Meta.isexpr(expr, :(::)) "macro argument must have return type declaration"
    f, return_type = expr.args
    @assert Meta.isexpr(f, :call) "macro argument must have a function call"
    invoke_expr = Expr(:call, _invoke, f.args[1], 0, return_type)
    for i in 2:length(f.args)
        if f.args[i] == :_
            invoke_expr.args[3] = i - 1
        else
            push!(invoke_expr.args, esc(f.args[i]))
        end
    end
    return invoke_expr
end

"""
    @checked f(prob)

Lets you invoke a lower level `Lib` function and check that Xpress does not
error.

Use this macro to minimize repetition and increase readability.

The first argument must be a object that can be cast into an Xpress pointer,
e.g., `Ptr{XpressProblem}`.

This is passed to `get_xpress_error_message(xprs_ptr)` to get the error message.

## Example

```julia
@checked Lib.XPRSsetprobname(prob, name)
```
"""
macro checked(expr)
    @assert expr.head == :call "Can only use @checked on function calls"
    @assert (expr.args[1].head == :(.)) && (expr.args[1].args[1] == :Lib) "Can only use @checked on Lib.\$function"
    @assert length(expr.args) >= 2 "Lib.\$function must be contain atleast one argument and the first argument must be of type XpressProblem"
    prob = expr.args[2]
    return quote
        val = $(esc(expr))::Cint
        if val != 0
            e = get_xpress_error_message($(esc(prob)))
            throw(XpressError(val, "Xpress internal error:\n\n$e.\n"))
        end
    end
end

function get_xpress_error_message(prob)
    return lstrip(@_invoke(Lib.XPRSgetlasterror(prob, _)::String), ['?'])
end

function getattribute(prob::XpressProblem, name::String)
    p_id, p_type = Ref{Cint}(), Ref{Cint}()
    Lib.XPRSgetattribinfo(prob, name, p_id, p_type)
    if p_type[] == Lib.XPRS_TYPE_INT
        return @_invoke Lib.XPRSgetintattrib(prob, p_id[], _)::Int
        # TODO(odow):
        #   @_invoke doesn't support Int64 attributes
        # elseif p_type[] == Lib.XPRS_TYPE_INT64
        #     return @_invoke Lib.XPRSgetintattrib64(prob, p_id[], _)::Int64
    elseif p_type[] == Lib.XPRS_TYPE_DOUBLE
        return @_invoke Lib.XPRSgetdblattrib(prob, p_id[], _)::Float64
    elseif p_type[] == Lib.XPRS_TYPE_STRING
        return @_invoke Lib.XPRSgetstrattrib(prob, p_id[], _)::String
    end
    return error("Unrecognized attribute: $name")
end

function getcontrol(prob::XpressProblem, name::String)
    p_id, p_type = Ref{Cint}(), Ref{Cint}()
    Lib.XPRSgetcontrolinfo(prob, name, p_id, p_type)
    if p_type[] == Lib.XPRS_TYPE_INT
        return @_invoke Lib.XPRSgetintcontrol(prob, p_id[], _)::Int
        # elseif p_type[] == Lib.XPRS_TYPE_INT64
        #     return @_invoke Lib.XPRSgetintcontrol64(prob, p_id[], _)::Int64
    elseif p_type[] == Lib.XPRS_TYPE_DOUBLE
        return @_invoke Lib.XPRSgetdblcontrol(prob, p_id[], _)::Float64
    elseif p_type[] == Lib.XPRS_TYPE_STRING
        return @_invoke Lib.XPRSgetstrcontrol(prob, p_id[], _)::String
    end
    return error("Unrecognized control: $name")
end

function get_control_or_attribute(prob::XpressProblem, name::String)
    p_id, p_type = Ref{Cint}(), Ref{Cint}()
    Lib.XPRSgetcontrolinfo(prob, name, p_id, p_type)
    if p_type[] != Lib.XPRS_TYPE_NOTDEFINED
        return getcontrol(prob, name)
    end
    return getattribute(prob, name)
end

function setcontrol!(prob::XpressProblem, name::String, val)
    p_id, p_type = Ref{Cint}(), Ref{Cint}()
    Lib.XPRSgetcontrolinfo(prob, name, p_id, p_type)
    if p_type[] == Lib.XPRS_TYPE_INT
        Lib.XPRSsetintcontrol(prob, p_id[], Int32(val))
        # elseif p_type[] == Lib.XPRS_TYPE_INT64
        #     Lib.XPRSsetintcontrol64(prob, p_id[], Int64(val))
    elseif p_type[] == Lib.XPRS_TYPE_DOUBLE
        Lib.XPRSsetdblcontrol(prob, p_id[], Float64(val))
    elseif p_type[] == Lib.XPRS_TYPE_STRING
        Lib.XPRSsetstrcontrol(prob, p_id[], String(val))
    else
        return error("Unrecognized control: $name")
    end
end

get_banner() = @_invoke Lib.XPRSgetbanner(_)::String

get_version() = VersionNumber(@_invoke Lib.XPRSgetversion(_)::String)

"""
    show(io::IO, prob::XpressProblem)

Prints a simplified problem description
"""
function Base.show(io::IO, prob::XpressProblem)
    m = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALCOLS, _)::Int
    sensei = @_invoke Lib.XPRSgetdblattrib(prob, Lib.XPRS_OBJSENSE, _)::Float64
    sense = sensei == Lib.XPRS_OBJ_MINIMIZE ? :minimize : :maximize
    qcons = @_invoke Lib.XPRSgetintattrib(
        prob,
        Lib.XPRS_ORIGINALQCONSTRAINTS,
        _,
    )::Int
    ncons = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALROWS, _)::Int
    qcelems =
        @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALQCELEMS, _)::Int
    qelems =
        @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALQELEMS, _)::Int
    nnz = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ELEMS, _)::Int
    problem_type = ifelse(qcons > 0, "QCP", ifelse(qelems > 0, "QP", "LP"))
    nsos = @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALSETS, _)::Int
    mipents =
        @_invoke Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALMIPENTS, _)::Int
    suffix = ifelse(mipents + nsos > 0, " (MIP)", "")
    print(
        io,
        """
        Xpress Problem:
            type   : $problem_type$suffix
            sense  : $sense
            number of variables                    = $m
            number of linear constraints           = $(ncons - qcons)
            number of quadratic constraints        = $qcons
            number of sos constraints              = $nsos
            number of non-zero coeffs              = $nnz
            number of non-zero qp objective terms  = $qelems
            number of non-zero qp constraint terms = $qcelems
            number of integer entities             = $mipents
        """,
    )
    return
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

const STOPSTATUS_STRING = Dict{Int,String}(
    Lib.XPRS_STOP_NONE => "no interruption - the solve completed normally",
    Lib.XPRS_STOP_TIMELIMIT => "time limit hit",
    Lib.XPRS_STOP_CTRLC => "control C hit",
    Lib.XPRS_STOP_NODELIMIT => "node limit hit",
    Lib.XPRS_STOP_ITERLIMIT => "iteration limit hit",
    Lib.XPRS_STOP_MIPGAP => "MIP gap is sufficiently small",
    Lib.XPRS_STOP_SOLLIMIT => "solution limit hit",
    Lib.XPRS_STOP_USER => "user interrupt.",
)

mutable struct CallbackData
    model_root::XpressProblem
    data::Any
    model::XpressProblem
end

Base.broadcastable(x::CallbackData) = Ref(x)

mutable struct _CallbackUserData
    callback::Function
    model::XpressProblem
    data::Any
end

Base.cconvert(::Type{Ptr{Cvoid}}, x::_CallbackUserData) = x

function Base.unsafe_convert(::Type{Ptr{Cvoid}}, x::_CallbackUserData)
    return pointer_from_objref(x)::Ptr{Cvoid}
end

function _setcboptnode_wrapper(
    ptr_inner::Lib.XPRSprob,
    ptr_user_data::Ptr{Cvoid},
    feas::Ptr{Cint},
)
    user_data = unsafe_pointer_to_objref(ptr_user_data)::_CallbackUserData
    inner = XpressProblem(ptr_inner; finalize_env = false)
    user_data.callback(CallbackData(user_data.model, user_data.data, inner))
    return Cint(0)
end

function set_callback_optnode!(
    model::XpressProblem,
    callback::Function,
    data::Any = nothing,
)
    callback_ptr = @cfunction(
        _setcboptnode_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint})
    )
    user_data = _CallbackUserData(callback, model, data)
    Lib.XPRSaddcboptnode(model.ptr, callback_ptr, user_data, 0)
    return callback_ptr, user_data
end

function _setcbpreintsol_wrapper(
    ptr_model::Lib.XPRSprob,
    ptr_user_data::Ptr{Cvoid},
    ::Ptr{Cint},
    ::Ptr{Cint},
    ::Ptr{Cdouble},
)
    user_data = unsafe_pointer_to_objref(ptr_user_data)::_CallbackUserData
    inner = XpressProblem(ptr_model; finalize_env = false)
    user_data.callback(CallbackData(user_data.model, user_data.data, inner))
    return Cint(0)
end

function set_callback_preintsol!(
    model::XpressProblem,
    callback::Function,
    data::Any = nothing,
)
    callback_ptr = @cfunction(
        _setcbpreintsol_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble})
    )
    user_data = _CallbackUserData(callback, model, data)
    Lib.XPRSaddcbpreintsol(model.ptr, callback_ptr, user_data, 0)
    return callback_ptr, user_data
end

function _addcboutput2screen_wrapper(
    ::Lib.XPRSprob,
    ptr_user_data::Ptr{Cvoid},
    msg::Ptr{Cchar},
    ::Cint,
    msgtype::Cint,
)
    user_data = unsafe_pointer_to_objref(ptr_user_data)::_CallbackUserData
    if msgtype == 1 || (msgtype == 3 && user_data.data::Bool)
        # Information || Warning
        println(unsafe_string(msg))
    elseif msgtype == 2 || msgtype == 4
        # Not used || Error
    else
        # Exiting - buffers need flushing
        flush(stdout)
    end
    return Cint(0)
end

function setoutputcb!(model::XpressProblem, show_warning::Bool)
    callback_ptr = @cfunction(
        _addcboutput2screen_wrapper,
        Cint,
        (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cchar}, Cint, Cint)
    )
    user_data = _CallbackUserData(() -> nothing, model, show_warning)
    Lib.XPRSaddcbmessage(model.ptr, callback_ptr, user_data, 0)
    return callback_ptr, user_data
end

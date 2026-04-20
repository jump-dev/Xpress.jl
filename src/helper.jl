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
    ptr::XPRSprob
    logfile::String

    function XpressProblem(
        ptr::XPRSprob = C_NULL;
        finalize_env::Bool = true,
        logfile = "",
    )
        if ptr === C_NULL
            ref = Ref{XPRSprob}()
            _ = XPRScreateprob(ref)
            ptr = ref[]
        end
        if ptr == C_NULL
            error(
                "Failed to create XpressProblem. Received null pointer from Xpress C interface.",
            )
        end
        model = new(ptr, logfile)
        if !isempty(logfile)
            _ = XPRSsetlogfile(model, logfile)
        end
        if finalize_env
            finalizer(XPRSdestroyprob, model)
        end
        return model
    end
end

Base.cconvert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob

Base.unsafe_convert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob.ptr

function _check(prob, ret::Cint)
    if ret != 0
        buffer = Array{Cchar}(undef, 1024)
        GC.@preserve buffer begin
            out = Cstring(pointer(buffer))
            _ = XPRSgetlasterror(prob, out)
            msg = lstrip(unsafe_string(out), ['?'])
            throw(XpressError(ret, "Xpress internal error:\n\n$msg.\n"))
        end
    end
    return
end

function get_version()
    buffer = Array{Cchar}(undef, 1024)
    GC.@preserve buffer begin
        out = Cstring(pointer(buffer))
        _ = XPRSgetversion(out)
        return VersionNumber(unsafe_string(out))
    end
end

"""
    show(io::IO, prob::XpressProblem)

Prints a simplified problem description
"""
function Base.show(io::IO, prob::XpressProblem)
    pInt, pFloat = Ref{Cint}(0), Ref{Cdouble}(0.0)
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALCOLS, pInt)
    _check(prob, ret)
    m = pInt[]
    ret = XPRSgetdblattrib(prob, XPRS_OBJSENSE, pFloat)
    _check(prob, ret)
    sense = pFloat[] == XPRS_OBJ_MINIMIZE ? :minimize : :maximize
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALQCONSTRAINTS, pInt)
    _check(prob, ret)
    qcons = pInt[]
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALROWS, pInt)
    _check(prob, ret)
    ncons = pInt[]
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALQCELEMS, pInt)
    _check(prob, ret)
    qcelems = pInt[]
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALQELEMS, pInt)
    _check(prob, ret)
    qelems = pInt[]
    ret = XPRSgetintattrib(prob, XPRS_ELEMS, pInt)
    _check(prob, ret)
    nnz = pInt[]
    problem_type = ifelse(qcons > 0, "QCP", ifelse(qelems > 0, "QP", "LP"))
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALSETS, pInt)
    _check(prob, ret)
    nsos = pInt[]
    ret = XPRSgetintattrib(prob, XPRS_ORIGINALMIPENTS, pInt)
    _check(prob, ret)
    mipents = pInt[]
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
    ptr_inner::XPRSprob,
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
    _ = XPRSaddcboptnode(model.ptr, callback_ptr, user_data, 0)
    return callback_ptr, user_data
end

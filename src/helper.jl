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
        return XPRS_PLUSINFINITY
    elseif val == -Inf
        return XPRS_MINUSINFINITY
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

Base.unsafe_convert(T::Type{Ptr{Nothing}}, t::CWrapper) = (t.ptr == C_NULL) ? throw(XpressError(255, "Received null pointer in CWrapper. Something must be wrong.")) : t.ptr

mutable struct XpressProblem <: CWrapper
    ptr::Lib.XPRSprob
    callback::Array{Any}
    time::Float64
    function XpressProblem()
        ref = Ref{Lib.XPRSprob}()
        createprob(ref)
        ptr = ref[]
        @assert ptr != C_NULL "Failed to create XpressProblem. Received null pointer from Xpress C interface."
        p = new(ptr, Any[], 0.0)
        atexit(() -> destroyprob(p))
        return p
    end
end

addcolnames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 2)
addrownames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 1)

"""
    getparam(prob::XpressProblem, param::Integer)

Get parameter of any type
"""
function getparam(prob::XpressProblem, param::Integer)
    # TODO: this function is not type stable
    if convert(Int, param) in XPRS_INT_CONTROLS
        return get_int_param(prob, param)
    elseif convert(Int, param) in XPRS_DBL_CONTROLS
        return get_dbl_param(prob, param)
    elseif convert(Int, param) in XPRS_STR_CONTROLS
        return get_str_param(prob, param)
    else
        error("Unrecognized parameter number: $(param).")
    end
end

"""
    setparam!(prob::XpressProblem, param::Symbol, val::Any)
    setparam!(prob::XpressProblem, param::Integer, val::Any)

Set parameter of any type
"""
setparam!(prob::XpressProblem, param::Symbol, val::Any) = setparam!(prob, Cint(XPRS_CONTROLS_DICT[param]),val)
setparam!(prob::XpressProblem, param::Integer, val::Any) = setparam!(prob, Cint(param), val::Any)
function setparam!(prob::XpressProblem, param::Cint, val::Any)
    if convert(Int, param) in XPRS_INT_CONTROLS
        set_int_param(prob, param, val)
    elseif convert(Int, param) in XPRS_DBL_CONTROLS
        set_dbl_param(prob, param, val)
    elseif convert(Int, param) in XPRS_STR_CONTROLS
        set_str_param(prob, param, val)
    else
        error("Unrecognized parameter number: $(param).")
    end
end

"""
    setparams!(prob::XpressProblem;args...)

Set multiple parameters of any type
"""
function setparams!(prob::XpressProblem; args...)
    for (param,val) in args
        setparam!(prob, XPRS_CONTROLS_DICT[param],val)
    end
end

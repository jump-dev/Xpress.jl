"""
    get_int_param(m::Model, param::Integer)

get the value of some integer valued parameter
"""
get_int_param(m::Model, param::Integer) = get_int_param(m::Model, Cint(param))
function get_int_param(m::Model, param::Cint)

    ipar = convert(Cint,param)
    igval = Array{Cint}(1)

    ret = @xprs_ccall(getintcontrol, Cint, (Ptr{Nothing},Cint,Ptr{Cint}),
        m.ptr_model, ipar, igval)
    if ret != 0
        throw(XpressError(m))
    end
    convert(Int, igval[1])
end

"""
    get_dbl_param(m::Model, param::Integer)

get the value of some double valued parameter
"""
get_dbl_param(m::Model, param::Integer) = get_dbl_param(m::Model, Cint(param))
function get_dbl_param(m::Model, param::Cint)

    ipar = convert(Cint,param)
    dgval = Array{Float64}(1)

    ret = @xprs_ccall(getdblcontrol, Cint, (Ptr{Nothing},Cint,Ptr{Cdouble}),
        m.ptr_model, ipar, dgval)
    if ret != 0
        throw(XpressError(m))
    end
    convert(Float64, dgval[1])
end

"""
    get_str_param(m::Model, param::Integer)

get the value of some string valued parameter
"""
get_str_param(m::Model, param::Integer) = get_str_param(m::Model, Cint(param))
function get_str_param(m::Model, param::Cint)

    ipar = convert(Cint,param)
    cgval = Array{Cchar}( 256)

    ret = @xprs_ccall(getstrcontrol, Cint, (Ptr{Nothing},Cint,Ptr{Cchar}),
        m.ptr_model, ipar, cgval)
    if ret != 0
        throw(XpressError(m))
    end

    unsafe_string(pointer(out))
end

"""
    set_int_param(m::Model, ipar::Integer, isval::Integer)

set intger valued parameter
"""
set_int_param(m::Model, ipar::Integer, isval::Integer) = set_int_param(m::Model, Cint(ipar), Cint(isval)) 
function set_int_param(m::Model, ipar::Cint, isval::Cint)

    ipar = convert(Cint,ipar)
    isval = convert(Cint,isval)
    ret = @xprs_ccall(setintcontrol, Cint, (Ptr{Nothing},Cint,Cint),
        m.ptr_model, ipar, isval)
    if ret != 0
        throw(XpressError(m))
    end
    return nothing
end

"""
    set_dbl_param(m::Model, ipar::Int, dsval::Float64)

set double valued parameter
"""
set_dbl_param(m::Model, ipar::Int, dsval::Float64) = set_dbl_param(m::Model, Cint(ipa), Float64(dsval))
function set_dbl_param(m::Model, ipar::Cint, dsval::Float64)

    ipar = convert(Cint,ipar)
    dsval = convert(Cdouble,dsval)
    ret = @xprs_ccall(setdblcontrol, Cint, (Ptr{Nothing},Cint,Cdouble),
        m.ptr_model, ipar, dsval)
    if ret != 0
        throw(XpressError(m))
    end
    return nothing
end

"""
    set_str_param(m::Model, ipar::Integer, csval::String)

Set string valued parameter
"""
set_str_param(m::Model, ipar::Integer, csval::String) = set_str_param(m::Model, Cint(ipar), csval)
function set_str_param(m::Model, ipar::Cint, csval::String)

    ipar = convert(Cint,ipar)
    csval = convert(String,csval)
    ret = @xprs_ccall(setstrcontrol, Cint, (Ptr{Nothing},Cint,Ptr{Cchar}),
        m.ptr_model, ipar, csval)
    if ret != 0
        throw(XpressError(m))
    end
    return nothing
end

"""
    getparam(m::Model, param::Integer)

get parameter of any type
"""
function getparam(m::Model, param::Integer)
    if convert(Int,param) in XPRS_INT_CONTROLS
        return get_int_param(m, param)
    elseif convert(Int,param) in XPRS_DBL_CONTROLS
        return get_dbl_param(m, param)
    elseif convert(Int,param) in XPRS_STR_CONTROLS
        return get_str_param(m, param)
    else
        error("Unrecognized parameter number: $(param).")
    end
end

"""
    setparam!(m::Model, param::Symbol, val::Any)
    setparam!(m::Model, param::Integer, val::Any)

set parameter of any type
"""
setparam!(m::Model, param::Symbol, val::Any) = setparam!(m,Cint(XPRS_CONTROLS_DICT[param]),val)
setparam!(m::Model, param::Integer, val::Any) = setparam!(m::Model, Cint(param), val::Any)
function setparam!(m::Model, param::Cint, val::Any)
    if convert(Int,param) in XPRS_INT_CONTROLS
        set_int_param(m, param, val)
    elseif convert(Int,param) in XPRS_DBL_CONTROLS
        set_dbl_param(m, param, val)
    elseif convert(Int,param) in XPRS_STR_CONTROLS
        set_str_param(m, param, val)
    else
        error("Unrecognized parameter number: $(param).")
    end
end

"""
    setparams!(m::Model;args...)

set multiple parameters of any type
"""
function setparams!(m::Model;args...)
    for (param,val) in args
        setparam!(m,XPRS_CONTROLS_DICT[param],val)
    end
end

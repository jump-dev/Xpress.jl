
#get

function get_int_param(m::Model,param::Int)

	ipar = convert(Cint,param)
	igval = Array(Cint,1)

	ret = @xprs_ccall(getintcontrol, Cint, (Ptr{Void},Cint,Ptr{Cint}),
		m.ptr_model, ipar, igval)
	if ret != 0
		throw(XpressError(m))
	end
	convert(Int, igval[1])
end

function get_dbl_param(m::Model,param::Int)

	ipar = convert(Cint,param)
	dgval = Array(Cdouble,1)

	ret = @xprs_ccall(getdblcontrol, Cint, (Ptr{Void},Cint,Ptr{Cdouble}),
		m.ptr_model, ipar, dgval)
	if ret != 0
		throw(XpressError(m))
	end
	convert(Float64, dgval[1])
end

function get_str_param(m::Model,param::Int)

	ipar = convert(Cint,param)
	cgval = Array(Cchar, 256)

	ret = @xprs_ccall(getstrcontrol, Cint, (Ptr{Void},Cint,Ptr{Cchar}),
		m.ptr_model, ipar, cgval)
	if ret != 0
		throw(XpressError(m))
	end

	bytestring(pointer(out))
end

#set

function set_int_param(m::Model,ipar::Int,isval::Int)

	ipar = convert(Cint,ipar)
	isval = convert(Cint,isval)

	ret = @xprs_ccall(setintcontrol, Cint, (Ptr{Void},Cint,Cint),
		m.ptr_model, ipar, isval)
	if ret != 0
		throw(XpressError(m))
	end

	nothing
end

function set_dbl_param(m::Model,ipar::Int,dsval::Float64)

	ipar = convert(Cint,ipar)
	dsval = convert(Cdouble,dsval)

	ret = @xprs_ccall(setdblcontrol, Cint, (Ptr{Void},Cint,Cdouble),
		m.ptr_model, ipar, dsval)
	if ret != 0
		throw(XpressError(m))
	end

	nothing
end

function set_str_param(m::Model,ipar::Int,csval::AbstractString)

	ipar = convert(Cint,ipar)
	csval = convert(ASCIIString,csval)

	ret = @xprs_ccall(setstrcontrol, Cint, (Ptr{Void},Cint,Ptr{Cchar}),
		m.ptr_model, ipar, csval)
	if ret != 0
		throw(XpressError(m))
	end

	nothing
end



function getparam(m::Model,param::Int)
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

function setparam!(m::Model,param::Int,val::Any)
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

function setparams!(m::Model;args...)
	for (param,val) in args
		setparam!(m,XPRS_CONTROLS_DICT[param],val)
	end
end

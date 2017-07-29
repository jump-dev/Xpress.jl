# Xpress model

#################################################
#
#  model type & constructors
#
#################################################

"""
    Model

Type to hold an Xpress model
"""
type Model
    ptr_model::Ptr{Void}
    callback::Any
    finalize_env::Bool
    
    time::Float64

    function Model(p::Ptr{Void}; finalize_env::Bool=true)
        model = new(p, nothing, finalize_env, 0.0)
        if finalize_env
            finalizer(model, m -> (free_model(m)) )
        end
        model
    end
end

"""
    Model(; finalize_env::Bool=false)

Xpress model constructor (autimatically sets OUTPUTLOG = 1)
"""
function Model(; finalize_env::Bool=true)

    a = Array{Ptr{Void}}( 1)
    ret = @xprs_ccall(createprob, Cint, ( Ptr{Ptr{Void}},), a )
    if ret != 0
        error("It was not possible to create a model, try running Env() and then create the model again.")
    end

    m = Model(a[1]; finalize_env = finalize_env)
    
    # turn off default printing on unix
    setparam!(m, XPRS_OUTPUTLOG, 0)
    setparam!(m, XPRS_CALLBACKFROMMASTERTHREAD, 1) #cannot be changed in julia

    load_empty(m)

    return m
end
function Model(name::String, sense::Symbol = :minimize)
    model = Model()
    if sense != :minimize
        set_sense!(model, sense)
    end
    model
end

#################################################
#
#  model error handling
#
#################################################
function get_error_msg(m::Model)
    #@assert env.ptr_env == 1
    out = Array{Cchar}( 512)
    ret = @xprs_ccall(getlasterror, Cint, (Ptr{Void},Ptr{Cchar}),
        m.ptr_model, out)

    error( unsafe_string(pointer(out))  )
end
function get_error_msg(m::Model, ret::Int)
    #@assert env.ptr_env == 1
    out = Array{Cint}(1)
    out2 = @xprs_ccall(getintattrib, Cint,(Ptr{Void}, Cint, Ptr{Cint}),
        m.ptr_model, ret , out)
end

##############################################
# Error handling
##############################################
type XpressError
    code::Int
    msg::String
end
function XpressError(m::Model)#, code::Integer)
    XpressError( 0, get_error_msg(m) )#convert(Int, code), get_error_msg(env))
end
function XpressError(m::Model, ret::Int)
    XpressError( get_error_msg(m, ret), "get message from optimizer manual" )
end

#################################################
#
#  model manipulation
#
#################################################

Base.unsafe_convert(ty::Type{Ptr{Void}}, model::Model) = model.ptr_model::Ptr{Void}

"""
    free_model(model::Model)

Free all memory allocated in C related to Model
"""
function free_model(model::Model)
    if model.ptr_model != C_NULL
        ret = @xprs_ccall(destroyprob, Cint, (Ptr{Void},), model.ptr_model)
        if ret != 0
            throw(XpressError(model))
        end
        model.ptr_model = C_NULL
    end

    return nothing
end

"""
    copy(model_src::Model)

Creates copy of the Xpress Model

Callbacks and setting are not copied
"""
function copy(model_src::Model)
    # only copies problem not callbacks and controls
    if model_src.ptr_model != C_NULL
        model_dest = Model()#env)
        ret = @xprs_ccall(copyprob, Cint, (Ptr{Void},Ptr{Void},Ptr{UInt8}),
            model_dest.ptr_model, model_src.ptr_model, "")
        if ret != 0
            throw(XpressError(model_src))
        end
    end
    model_dest
end
function copycontrols!(mdest::Xpress.Model, msrc::Xpress.Model)
    ret = Xpress.@xprs_ccall(copycontrols, Cint, (Ptr{Void}, Ptr{Void}),
    mdest.ptr_model, msrc.ptr_model)
    if ret != 0
        throw(Xpress.XpressError(mdest))
    end
    nothing
end


# read / write file
#=
XPRSprob a-> Ptr{Void}
const char *a -> Ptr{UInt8}  -> "" : String
int -> Cint
const char a[] -> Ptr{Cchar} -> Cchar[]
=#
function load_empty(model::Model)
#=int XPRS_CC XPRSloadlp(XPRSprob prob, const char *probname, int ncol, int
      nrow, const char qrtype[], const double rhs[], const double range[],
      const double obj[], const int mstart[], const int mnel[], const int
      mrwind[], const double dmatval[], const double dlb[], const double
      dub[]);
=#
    ret = @xprs_ccall(loadlp, Cint,
        (Ptr{Void},
            Ptr{UInt8},
            Cint,
            Cint,
            Ptr{Cchar},#type
            Ptr{Float64},#rhs
            Ptr{Float64},#range
            Ptr{Float64},#obj
            Ptr{Cint},#mastart
            Ptr{Cint},#mnel
            Ptr{Cint},#mrwind
            Ptr{Float64},#dmat
            Ptr{Float64},#lb
            Ptr{Float64}#ub
            ),model.ptr_model,"",0,0,Cchar[],Float64[],Float64[],Float64[],
                Cint[],Cint[],Cint[],Float64[],Float64[],Float64[]
    )
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

"""
    read_model(model::Model, filename::String)

Read file and add its informationt o the model
"""
function read_model(model::Model, filename::String)
    #@assert is_valid(model.env)
    flags = ""
    ret = @xprs_ccall(readprob, Cint,
        (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}),
        model.ptr_model, filename, flags)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

"""
    write_model(model::Model, filename::String, flags::String)

Writes a model into file.
For flags setting see the manual (writeprob)
"""
write_model(model::Model, filename::String) = write_model(model, filename, "")
function write_model(model::Model, filename::String, flags::String)
    ret = @xprs_ccall(writeprob, Cint, (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}),
        model.ptr_model, filename, flags)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

"""
    fixglobals(model::Model, round::Bool)

Fix globals entities after a first Global search.
"""
function fixglobals(model::Model, round::Bool)
    flag = 0
    if round
        flag = 1
    end
    ret = @xprs_ccall(fixglobals, Cint, (Ptr{Void}, Cint),
        model.ptr_model, flag)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

"""
    setlogfile(model::Model, filename::String)

Attach a log file to the model
"""
function setlogfile(model::Model, filename::String)
    #int XPRS_CC XPRSsetlogfile(XPRSprob prob, const char *filename);

    flags = ""
    ret = @xprs_ccall(setlogfile, Cint, (Ptr{Void}, Ptr{UInt8}),
        model.ptr_model, filename)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end


addcolnames(m::Xpress.Model, names::Vector) = addnames(m, names, Int32(2))
addrownames(m::Xpress.Model, names::Vector) = addnames(m, names, Int32(1))
function addnames(m::Xpress.Model, names::Vector, nametype::Int32)
    # XPRSaddnames(prob, int type, char name[], int first, int last)

    NAMELENGTH = 64
    
    #nametype = 2
    first = 0
    last = length(names)-1

    cnames = ""
    for str in names  
        cnames = string(cnames, join(take(str,NAMELENGTH)), "\0")
    end
	ret = Xpress.@xprs_ccall(addnames, Cint, (Ptr{Void}, Cint,Ptr{Cchar}, Cint, Cint),
		m.ptr_model, nametype, cnames, first, last)

	if ret != 0
		throw(Xpress.XpressError(m))
	end

    nothing
end

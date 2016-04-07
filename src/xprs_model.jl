# Gurobi model

#################################################
#
#  model type & constructors
#
#################################################

type Model
    env::Env
    ptr_model::Ptr{Void}
    callback::Any
    finalize_env::Bool
    
    function Model(env::Env, p::Ptr{Void}; finalize_env::Bool=false)
        model = new(env, p, nothing, finalize_env)
        #finalizer(model, m -> (free_model(m); if m.finalize_env; free_env(m.env); end))
        model
    end
end

# If environment is tied to this model, the, we can safely finalize
# both at the same time, working around the Julia GC.
function Model(env::Env; finalize_env::Bool=false)

    @assert is_valid(env)
    
    a = Array(Ptr{Void}, 1)
    ret = @xprs_ccall(createprob, Cint, ( Ptr{Ptr{Void}},), a )
    println(a)
    if ret != 0
        error("could not create prob")
        #throw(XpressError(env, ret))
    end
    
    m = Model(env, a[1]; finalize_env=finalize_env)
    load_empty(m)
    return m
end


# function Model(env::Env, name::ASCIIString, sense::Symbol)
#     model = Model(env, name)
#     if sense != :minimize
#         set_sense!(model, sense)
#     end
#     model 
# end


#################################################
#
#  model error handling
#
#################################################
function get_error_msg(m::Model)
    #@assert env.ptr_env == 1
    out = Array(Cchar, 512) 
    sz = @xprs_ccall(getlasterror, Cint, (Ptr{Void},Ptr{Cchar}), 
        m.ptr_model, out)
    ascii( bytestring(pointer(out))  )
end
function get_error_msg(m::Model,ret::Int)
    #@assert env.ptr_env == 1
    out = Array(Cint,1)
    out2 = @xprs_ccall(getintattrib, Cint,(Ptr{Void}, Cint, Ptr{Cint}),
        m.ptr_model, ret , out)
    #convert(Int,out[1])
end
# 
# # error
# 
type XpressError
    code::Int
    msg::ASCIIString 
end
#function XpressError(ret::Int,m::Model)#, code::Integer)
#    XpressError( ret, get_error_msg(m) )#convert(Int, code), get_error_msg(env))
#end
function XpressError(m::Model)#, code::Integer)
    XpressError( 0, get_error_msg(m) )#convert(Int, code), get_error_msg(env))
end
function XpressError(m::Model,ret::Int)
    XpressError( get_error_msg(m,ret), "get message from optimizer manual" )
end

#################################################
#
#  model manipulation
#
#################################################

Base.unsafe_convert(ty::Type{Ptr{Void}}, model::Model) = model.ptr_model::Ptr{Void}

function free_model(model::Model)

    if model.ptr_model != C_NULL
        ret = @xprs_ccall(destroyprob, Cint, (Ptr{Void},), model.ptr_model)
        if ret != 0
            throw(XpressError(model))
        end
        model.ptr_model = C_NULL
    end
end

function copy(model_src::Model)
    # only copies problem not callbacks and controls
    if model_src.ptr_model != C_NULL
        model_dest = Model(env)
        ret = @xprs_ccall(copyprob, Cint, (Ptr{Void},Ptr{Void},Ptr{UInt8}), 
            model_dest.ptr_model, model_src.ptr_model, "")
        if ret != 0
            throw(XpressError(model_src))
        end
    end
    model_dest
end

# function update_model!(model::Model)
#     @assert model.ptr_model != C_NULL
#     ret = @grb_ccall(updatemodel, Cint, (Ptr{Void},), model.ptr_model)
#     if ret != 0
#         throw(GurobiError(model.env, ret))
#     end
#     nothing
# end

# function reset_model!(model::Model)
#     @assert model.ptr_model != C_NULL
#     ret = @grb_ccall(resetmodel, Cint, (Ptr{Void},), model.ptr_model)
#     if ret != 0
#         throw(GurobiError(model.env, ret))
#     end
#     nothing
# end
# 
# read / write file
#=
XPRSprob a-> Ptr{Void}
const char *a -> Ptr{UInt8}  -> "" : ASCIIString
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
    ret = @xprs_ccall(loadlp,Cint,
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
function read_model(model::Model, filename::ASCIIString)
    @assert is_valid(model.env)
    flags = ""
    ret = @xprs_ccall(readprob, Cint, 
        (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}), 
        model.ptr_model, filename, flags)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

function write_model(model::Model, filename::ASCIIString)
    flags = ""
    ret = @xprs_ccall(writeprob, Cint, (Ptr{Void}, Ptr{UInt8}, Ptr{UInt8}), 
        model.ptr_model, filename, flags)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

# function tune_model(model::Model)
#     ret = @grb_ccall(tunemodel, Cint, (Ptr{Void},), model.ptr_model)
#     if ret != 0
#         throw(GurobiError(model.env, ret))
#     end
#     nothing
# end

# function get_tune_result!(model::Model,i::Int)
#     ret = @grb_ccall(gettuneresult, Cint, (Ptr{Void}, Cint), model.ptr_model, i)
#     if ret != 0
#         throw(GurobiError(model.env, ret))
#     end
#     nothing
# end

# terminate(model::Model) = @grb_ccall(terminate, Void, (Ptr{Void},), model.ptr_model)

# Presolve the model but don't solve. For some reason this is not
# documented for the C interface, but is for all the other interfaces.
# Source: https://twitter.com/iaindunning/status/519620465992556544
# function presolve_model(model::Model)
#     ret = @grb_ccall(presolvemodel, Ptr{Void}, (Ptr{Void},), model.ptr_model)
#     if ret == C_NULL
#         # Presumably failed to return a model
#         error("presolve_model did not return a model")
#     end
#     return Model(model.env, ret)
# end

# function fixed_model(model::Model)
#     @assert model.ptr_model != C_NULL
#     fixed::Ptr{Void} = C_NULL
#     fixed = @grb_ccall(fixedmodel, Ptr{Void}, (Ptr{Void},), model.ptr_model)
#     if fixed == C_NULL
#         error("Unable to create fixed model")
#     end
#     Model(model.env, fixed)
# end






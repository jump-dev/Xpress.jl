# Xpress environment and other supporting facilities


type Env
    ptr_env::Int
    
    function Env()
        ret = @xprs_ccall(init, Cint, (Ptr{Cchar},), C_NULL)
        if ret != 0
            error("Failed to create environment (error $ret).")
        end
        env = ret
        # finalizer(env, free_env)  ## temporary disable: which tends to sometimes caused warnings
        env
    end
end

#Base.unsafe_convert(ty::Type{Ptr{Void}}, env::Env) = env.ptr_env::Ptr{Void}

function is_valid(env::Env)
    env.ptr_env == 0
end

function free_env(env::Env)
    if env.ptr_env == C_NULL
        ret = @xprs_ccall(free, Cint, (Void,))
        if ret != 0
            error("Failed to free environment (error $ret).")
        end
        env.ptr_env = 0
    end
end

function get_error_msg(env::Env)
    @assert env.ptr_env == 0
    sz = @xprs_ccall(geterrormsg, Ptr{UInt8}, (Ptr{Void},), env.ptr_env)
    bytestring(sz)
end

# error

type XpressError
    code::Int
    msg::ASCIIString 
    
    function XpressError(env::Env, code::Integer)
        new(convert(Int, code), get_error_msg(env))
    end
end


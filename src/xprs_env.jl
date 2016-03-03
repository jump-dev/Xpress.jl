# Xpress environment and other supporting facilities


type Env
    ptr_env::Ptr{Void}
    
    function Env()
        a = Array(Ptr{Void}, 1)
        ret = @xprs_ccall(init, Cint, (Ptr{Cchar},), C_NULL)
        if ret != 0
            if ret == 10009
                error("Invalid Xpress license")
            else
                error("Failed to create environment (error $ret).")
            end
        end
        env = new(a[1])
        # finalizer(env, free_env)  ## temporary disable: which tends to sometimes caused warnings
        env
    end
end

#Base.unsafe_convert(ty::Type{Ptr{Void}}, env::Env) = env.ptr_env::Ptr{Void}

function is_valid(env::Env)
    env.ptr_env != C_NULL
end

function free_env(env::Env)
    if env.ptr_env != C_NULL
        @xprs_ccall(free, Cint, (Void,))
        env.ptr_env = C_NULL
    end
end

function get_error_msg(env::Env)
    @assert env.ptr_env != C_NULL
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


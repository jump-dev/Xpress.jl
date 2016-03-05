# Xpress environment and other supporting facilities


type Env
    ptr_env::Int
    
    function Env()
        ret = @xprs_ccall(init, Cint, (Ptr{Cchar},), C_NULL)
        if ret != 0
            if ret == 10009
                error("Invalid Xpress license")
            else
                error("Failed to create environment (error $ret).")
            end
        end
        env = new(1)
        # finalizer(env, free_env)  ## temporary disable: which tends to sometimes caused warnings
        env
    end
end

#Base.unsafe_convert(ty::Type{Ptr{Void}}, env::Env) = env.ptr_env::Ptr{Void}

function is_valid(env::Env)
    env.ptr_env == 1
end

function free_env(env::Env)
    if env.ptr_env != 0
        ret = @xprs_ccall(free, Cint, ())
        env.ptr_env = 0
    end
end


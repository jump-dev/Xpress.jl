# Xpress environment and other supporting facilities

function Env()
    ret = @xprs_ccall(init, Cint, (Ptr{Cchar},), C_NULL)
    if ret != 0
        if ret == :number
            error("Invalid Xpress license")
        else
            error("Failed to create environment (error $ret).")
        end
    end
    # finalizer(env, free_env)  ## temporary disable: which tends to sometimes caused warnings
end

#Base.unsafe_convert(ty::Type{Ptr{Void}}, env::Env) = env.ptr_env::Ptr{Void}

function is_valid()
    #env.ptr_env == 1
    error("is_valid does not apply to xpress models")
end

function free_env()
    ret = @xprs_ccall(free, Cint, ())
end

## errors are handled in model level
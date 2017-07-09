# Xpress environment and other supporting facilities
"""
    Env()

Initialize Xpress environment.
Need to do ir once and only once.
"""
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

function is_valid()
    #env.ptr_env == 1
    error("is_valid does not apply to xpress models")
end

"""
    free_env()

Finalize Xpress environment.
"""
function free_env()
    ret = @xprs_ccall(free, Cint, ())
end
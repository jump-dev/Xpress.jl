# Xpress environment and other supporting facilities
"""
    Env()

Initialize Xpress environment.
Need to do ir once and only once.
"""
mutable struct Env
    ptr_env::Ptr{Cvoid}

    function Env()
        a = Ref{Ptr{Cvoid}}()
        ret = @xprs_ccall(init, Cint, (Ptr{Cchar},), C_NULL)
        if ret != 0
            if ret == :number
                error("Invalid Xpress license")
            else
                error("Failed to create environment (error $ret).")
            end
        end
        env = new(a[])
        # finalizer(env, free_env)  ## temporary disable: which tends to sometimes caused warnings
        env
    end
end

function is_valid()
    #env.ptr_env == 1
    error("is_valid does not apply to xpress models")
end

"""
    free_env()

Finalize Xpress environment.
"""
function free_env(env::Env)
    if env.ptr_env != C_NULL
        ret = @xprs_ccall(free, Cint, ())
        env.ptr_env = C_NULL
    end
end

Base.unsafe_convert(ty::Type{Ptr{Cvoid}}, env::Env) = env.ptr_env::Ptr{Cvoid}

function is_valid(env::Env)
    env.ptr_env != C_NULL
end

#= error
function get_error_msg(env::Env)
    @assert env.ptr_env != C_NULL
    sz = @grb_ccall(geterrormsg, Ptr{UInt8}, (Ptr{Cvoid},), env.ptr_env)
    unsafe_string(sz)
end



mutable struct XpressError <: Exception
    code::Int
    msg::String

    function XpressError(env::Env, code::Integer)
        new(convert(Int, code), get_error_msg(env))
    end
end
=#

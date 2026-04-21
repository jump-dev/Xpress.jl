# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module Xpress

import MathOptInterface as MOI

let _DEPS_JL = joinpath(dirname(@__DIR__), "deps", "deps.jl")
    if isfile(_DEPS_JL)
        include(_DEPS_JL)
    else
        global libxprs = ""
    end
end

function __init__()
    if get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") == "true"
        return
    elseif haskey(ENV, "XPRESS_JL_LIBRARY")
        global libxprs = ENV["XPRESS_JL_LIBRARY"]
    elseif isempty(libxprs) && !haskey(ENV, "XPRESS_JL_NO_DEPS_ERROR")
        error("XPRESS cannot be loaded. Please run Pkg.build(\"Xpress\").")
    end
    # Validate that the Xpress library is compatible with this release. This is
    # safe to call even if XPRSinit has not been called.
    _validate_version(get_version())
    if !haskey(ENV, "XPRESS_JL_NO_AUTO_INIT")
        initialize()
    end
    return
end

include("libxprs.jl")

function get_version()
    buffer = Array{Cchar}(undef, 1024)
    GC.@preserve buffer begin
        out = Cstring(pointer(buffer))
        _ = XPRSgetversion(out)
        return VersionNumber(unsafe_string(out))
    end
end

function _validate_version(version::VersionNumber)
    if version < v"41"
        error(
            "Unsupported Xpress version: $version. We require Xpress v41.0.0 (v9) or above",
        )
    end
    return
end

# ==============================================================================
# Code to check and throw pretty errors.

struct XpressError <: Exception
    errorcode::Int
    msg::String
end

# prob::Any is explicitly left un-typed because it could be a `::XpressProblem`
# or a `::Optimizer`.
function _check(prob::Any, ret::Cint)
    if ret != 0
        buffer = Array{Cchar}(undef, 1024)
        GC.@preserve buffer begin
            out = Cstring(pointer(buffer))
            _ = XPRSgetlasterror(prob, out)
            # Do not ask why Xpress starts their error messages with '?'... they
            # just do.
            msg = lstrip(unsafe_string(out), ['?'])
            throw(XpressError(ret, "Xpress internal error:\n\n$msg.\n"))
        end
    end
    return
end

function Base.showerror(io::IO, err::XpressError)
    print(io, "XpressError($(err.errorcode)): ")
    if err.errorcode == 1
        print(io, "Bad input encountered.")
    elseif err.errorcode == 2
        print(io, "Bad or corrupt file - unrecoverable.")
    elseif err.errorcode == 4
        print(io, "Memory error.")
    elseif err.errorcode == 8
        print(io, "Corrupt use.")
    elseif err.errorcode == 16
        print(io, "Program error.")
    elseif err.errorcode == 32
        print(
            io,
            "Subroutine not completed successfully, possibly due to invalid argument.",
        )
    elseif err.errorcode == 128
        print(io, "Too many users.")
    else
        print(io, "Unrecoverable error.")
    end
    return print(io, " $(err.msg)")
end

# ==============================================================================
# Constructor for XpressProblem

mutable struct XpressProblem
    ptr::XPRSprob
    logfile::String

    function XpressProblem(
        ptr::XPRSprob;
        finalize_env::Bool = true,
        logfile = "",
    )
        if ptr == C_NULL
            msg = "Failed to create XpressProblem. Received null pointer from Xpress C interface."
            throw(XpressError(16, msg))
        end
        prob = new(ptr, logfile)
        if !isempty(logfile)
            ret = XPRSsetlogfile(prob, logfile)
            _check(prob, ret)
        end
        if finalize_env
            finalizer(XPRSdestroyprob, prob)
        end
        return prob
    end
end

function XpressProblem(; kwargs...)
    ref = Ref{XPRSprob}()
    _ = XPRScreateprob(ref)
    return XpressProblem(ref[]; kwargs...)
end

Base.cconvert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob

Base.unsafe_convert(::Type{Ptr{Cvoid}}, prob::XpressProblem) = prob.ptr

# ==============================================================================
# Code related to XPRSinit

function _get_xpauthpath(xpauth_path = "", verbose::Bool = true)
    # The directory of the xprs shared object. This is the root from which we
    # search for licenses.
    libdir = dirname(libxprs)
    XPAUTH = "xpauth.xpr"
    # Search in absolute path given by the user (assuming it was a file), and as
    # a directory by appending XPAUTH.
    candidates = [xpauth_path, joinpath(xpauth_path, XPAUTH)]
    # Search in the directories of the XPAUTH_PATH and XPRESSDIR environnment
    # variables.
    for key in ("XPAUTH_PATH", "XPRESSDIR")
        if haskey(ENV, key)
            path = replace(ENV[key], "\"" => "")
            # With the default filename
            push!(candidates, joinpath(path, XPAUTH))
            # in /bin
            push!(candidates, joinpath(path, "bin", XPAUTH))
            # and without
            push!(candidates, path)
        end
    end
    # Search in `xpress/lib/../bin/xpauth.xpr`. This is a common location on
    # Windows.
    push!(candidates, joinpath(dirname(libdir), "bin", XPAUTH))
    # This location is used by Xpress_jll
    push!(
        candidates,
        joinpath(dirname(dirname(libxprs)), "license", "community-xpauth.xpr"),
    )
    for candidate in candidates
        # We assume a relative root directory of the shared library. If
        # `candidate` is an absolute path, then joinpath will ignore libdir and
        # return candidate.
        filename = joinpath(libdir, candidate)
        # If the file exists, we assume it is a license. We don't attempt to
        # validate the contents of the file.
        if isfile(filename)
            if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
                @info("Xpress: Found license file $filename")
            end
            return filename
        end
    end
    return error(
        "Could not find xpauth.xpr license file. Set the `XPRESSDIR` or " *
        "`XPAUTH_PATH` environment variables.",
    )
end

"""
    initialize(;
        liccheck::Function = identity,
        verbose::Bool = true,
        xpauth_path::String = ""
    )

Performs license checking with `liccheck` validation function on dir
`xpauth_path`.

This function must be called before any XPRS functions can be called.

By default, `__init__` calls this with no keyword arguments.

## Example

```julia
ENV["XPRESS_JL_NO_AUTO_INIT"] = true
using Xpress
liccheck(x::Vector{Cint}) = Cint[xor(x[1], 0x0123)]
Xpress.initialize(;
    liccheck = liccheck,
    verbose = false,
    xpauth_path = "/tmp/xpauth.xpr,
)
# Now you can use Xpress
```
"""
function initialize(;
    liccheck::Function = identity,
    verbose::Bool = true,
    xpauth_path::String = "",
    call_init::Bool = true,
)
    verbose &= !haskey(ENV, "XPRESS_JL_NO_INFO")
    path_lic = _get_xpauthpath(xpauth_path, verbose)
    # Pre-allocate storage for the license integer. For backward compatibility,
    # we use `Vector{Cint}`, because some users may have `liccheck` functions
    # which rely on this.
    license = Cint[1]
    # First, call XPRSlicense to populate `license` with an integer. We don't
    # check the return code.
    _ = XPRSlicense(license, path_lic)
    # Then, for some licenses, we need to modify the license integer by a
    # secret password.
    license = liccheck(license)
    # Now, we need to send the password back to Xpress.
    err = XPRSlicense(license, path_lic)
    if !(err == 16 || err == 0)
        @info("Xpress: Failed to find working license.")
        buffer = Vector{Cchar}(undef, 1024 * 8)
        p_buffer = pointer(buffer)
        GC.@preserve buffer begin
            _ = XPRSgetlicerrmsg(p_buffer, 1024)
            throw(XpressError(err, unsafe_string(p_buffer)))
        end
    elseif verbose
        type = err == 16 ? "Development" : "User"
        @info("Xpress: $type license detected.")
    end
    if call_init
        _ = XPRSinit(C_NULL)
    end
    return
end

# Keep `userlic` for backwards compatibility. PSR have a customized setup for
# managing licenses.
#
# New users should use `Xpress.initialize`.
userlic(; kwargs...) = initialize(; call_init = false, kwargs...)

# ==============================================================================
# The MOI wrapper

include("MOI/MOI_wrapper.jl")
include("MOI/MOI_callbacks.jl")

# ==============================================================================
# Public exports
#
# Xpress exports all `XPRSxxx` symbols. If you don't want all of these symbols
# in your environment, then use `import Xpress` instead of `using Xpress`.

for sym in filter(s -> startswith("$s", "XPRS"), names(@__MODULE__; all = true))
    @eval export $sym
end

export CallbackData

end  # Xpress

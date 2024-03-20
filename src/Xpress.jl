# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module Xpress

import Libdl
import MathOptInterface as MOI
import SparseArrays

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")

if isfile(depsjl_path)
    include(depsjl_path)
elseif !haskey(ENV, "XPRESS_JL_NO_DEPS_ERROR")
    error("XPRESS cannot be loaded. Please run Pkg.build(\"Xpress\").")
else
    const xpressdlpath = ""
end

const libxprs = joinpath(
    xpressdlpath,
    string(Sys.iswindows() ? "" : "lib", "xprs", ".", Libdl.dlext),
)

include("Lib/Lib.jl")
include("helper.jl")
include("api.jl")
include("MOI/MOI_wrapper.jl")
include("MOI/MOI_callbacks.jl")

function _get_xpauthpath(; verbose::Bool)
    candidates = String[pwd(), dirname(libxprs)]
    for key in ("XPAUTH_PATH", "XPRESS_DIR")
        if haskey(ENV, key)
            push!(candidates, replace(ENV[key], "\"" => ""))
        end
    end
    push!(candidates, joinpath(dirname(dirname(libxprs)), "bin"))
    for candidate in candidates
        for filename in (candidate, joinpath(candidate, "xpauth.xpr"))
            if isfile(filename)
                if verbose
                    @info("Xpress: Found license file $filename")
                end
                return filename
            end
        end
    end
    return error(
        "Could not find xpauth.xpr license file. Set the `XPRESSDIR` or " *
        "`XPAUTH_PATH` environment variables.",
    )
end

function initialize()
    Libdl.dlopen(libxprs)
    verbose = !haskey(ENV, "XPRESS_JL_NO_INFO")
    path_lic = _get_xpauthpath(; verbose)
    touch(path_lic)
    lic = Ref{Cint}(1)
    # TODO(odow): why do we call XPRSlicense twice?
    Lib.XPRSlicense(lic, path_lic)
    buffer = Vector{Cchar}(undef, 1024 * 8)
    ierr = GC.@preserve buffer begin
        Lib.XPRSlicense(lic, Cstring(pointer(buffer)))
    end
    if ierr == 16
        if verbose
            @info("Xpress: Development license detected.")
        end
    elseif ierr == 0
        if verbose
            @info("Xpress: User license detected.")
        end
    else
        @info("Xpress: Failed to find working license.")
        GC.@preserve buffer begin
            Lib.XPRSgetlicerrmsg(pointer(buffer), 1024)
            error(unsafe_string(pointer(buffer)))
        end
    end
    Lib.XPRSinit(C_NULL)
    return
end

function __init__()
    if !haskey(ENV, "XPRESS_JL_NO_AUTO_INIT") &&
       get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") != "true"
        initialize()
    end
    return
end

export CallbackData

end  # Xpress

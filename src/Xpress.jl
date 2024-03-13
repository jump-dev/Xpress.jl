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

include("utils.jl")
include("helper.jl")
include("attributes_controls.jl")
include("api.jl")
include("xprs_callbacks.jl")
include("license.jl")

_is_xprs_attribute(name::Symbol) = _is_xprs_attribute(string(name))

function _is_xprs_attribute(name::String)
    return startswith(name, "XPRS_") &&
           all(isuppercase(c) || isdigit(c) for c in name if c != '_')
end

const XPRS_ATTRIBUTES = Dict{String,Any}(
    replace("$name", "XPRS_" => "") => getfield(Lib, name) for
    name in filter(_is_xprs_attribute, names(Lib; all = true))
)

function initialize()
    Libdl.dlopen(libxprs)
    userlic()
    Lib.XPRSinit(C_NULL)
    # Calling free is not necessary since destroyprob is called
    # in the finalizer.
    return
end

include("MOI/MOI_wrapper.jl")
include("MOI/MOI_callbacks.jl")

function __init__()
    if !haskey(ENV, "XPRESS_JL_NO_AUTO_INIT") &&
       get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") != "true"
        initialize()
    end
    return
end

end  # Xpress

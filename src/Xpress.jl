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
include("license.jl")

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
function initialize(; kwargs...)
    Libdl.dlopen(libxprs)
    userlic(; kwargs...)
    Lib.XPRSinit(C_NULL)
    # Calling XPRSfree is not necessary since XPRSdestroyprob is called in the
    # finalizer.
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

export CallbackData

end  # Xpress

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
    if haskey(ENV, "XPRESS_JL_LIBRARY")
        global libxprs = ENV["XPRESS_JL_LIBRARY"]
    elseif isempty(libxprs) && !haskey(ENV, "XPRESS_JL_NO_DEPS_ERROR")
        error("XPRESS cannot be loaded. Please run Pkg.build(\"Xpress\").")
    end
    if !haskey(ENV, "XPRESS_JL_NO_AUTO_INIT") &&
       get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") != "true"
        initialize()
    end
    return
end

include("libxprs.jl")
include("helper.jl")
include("license.jl")
include("MOI/MOI_wrapper.jl")
include("MOI/MOI_callbacks.jl")

# Xpress exports all `XPRSxxx` symbols. If you don't want all of these symbols
# in your environment, then use `import Xpress` instead of `using Xpress`.

for sym in filter(s -> startswith("$s", "XPRS"), names(@__MODULE__; all = true))
    @eval export $sym
end

export CallbackData

end  # Xpress

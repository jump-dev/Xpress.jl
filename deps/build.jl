# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

import Libdl

const DEPS_FILE = joinpath(dirname(@__FILE__), "deps.jl")

function write_deps_file(path)
    open(DEPS_FILE, "w") do io
        return print(io, "const xpressdlpath = \"$(escape_string(path))\"")
    end
    return
end

function local_installation()
    lib_name = string(Sys.iswindows() ? "" : "lib", "xprs", ".", Libdl.dlext)
    paths_to_try = String["", @__DIR__]
    if haskey(ENV, "XPRESSDIR")
        push!(
            paths_to_try,
            joinpath(ENV["XPRESSDIR"], Sys.iswindows() ? "bin" : "lib"),
        )
    end
    for dir in paths_to_try
        path = joinpath(dir, lib_name)
        if Libdl.dlopen_e(path) != C_NULL
            @info("Found $path")
            write_deps_file(dir)
            return
        end
    end
    return error("""
    Unable to locate Xpress installation.

    Please check your enviroment variable `XPRESSDIR`.

    Note that Xpress must be obtained separately from fico.com.
    """)
end

if isfile(DEPS_FILE)
    rm(DEPS_FILE)
end

if haskey(ENV, "XPRESS_JL_SKIP_LIB_CHECK")
    # Skip!
elseif get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") == "true"
    write_deps_file("julia_registryci_automerge")
else
    local_installation()
end

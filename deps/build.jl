# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

import Downloads
import Libdl

const DEPS_FILE = joinpath(dirname(@__FILE__),"deps.jl")

function write_deps_file(path)
    open(DEPS_FILE,"w") do io
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

function ci_installation()
    url = if Sys.islinux()
        "https://anaconda.org/fico-xpress/xpress/9.3.0/download/linux-64/xpress-9.3.0-py310ha14b774_0.tar.bz2"
    else
        @assert Sys.isapple()
        "https://anaconda.org/fico-xpress/xpress/9.3.0/download/osx-64/xpress-9.3.0-py310h9b76c6a_0.tar.bz2"
    end
    Downloads.download(url, "xpress.tar.bz2")
    run(`tar -xjf xpress.tar.bz2`)
    root = "lib/python3.10/site-packages/xpress"
    run(`cp $root/license/community-xpauth.xpr $root/lib/xpauth.xpr`)
    if Sys.islinux()
        run(`cp $root/lib/libxprs.so.42 $root/lib/libxprs.so`)
    end
    write_deps_file(joinpath(@__DIR__, root, "lib"))
    return
end

if isfile(DEPS_FILE)
    rm(DEPS_FILE)
end

if haskey(ENV, "XPRESS_JL_SKIP_LIB_CHECK")
    # Skip!
elseif get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") == "true"
    write_deps_file("julia_registryci_automerge")
elseif get(ENV, "CI", "") == "true"
    ci_installation()
else
    local_installation()
end

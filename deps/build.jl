# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Libdl

depsfile = joinpath(dirname(@__FILE__),"deps.jl")

if isfile(depsfile)
    rm(depsfile)
end


function my_download(url::AbstractString, filename::AbstractString)
    if Sys.iswindows() && VERSION < v"1.1"
        # from https://github.com/JuliaLang/julia/blob/788b2c77c10c2160f4794a4d4b6b81a95a90940c/base/download.jl#L26
        # otherwise files are not properly downloaded - check sizes
        curl_exe = joinpath(get(ENV, "SYSTEMROOT", "C:\\Windows"), "System32\\curl.exe")
        process = run(`$curl_exe -s -S -g -L -f -o $filename $url`)#, wait=false)
        return filename
    else
        return download(url, filename)
    end
end

function write_depsfile(path)
    f = open(depsfile,"w")
    if Sys.iswindows()
        path = replace(path, "\\" => "\\\\")
    end
    print(f,"""
    const xpressdlpath = \"$(path)\"
    """)
    close(f)
end

function local_installation()

    libname = string(Sys.iswindows() ? "" : "lib", "xprs", ".", Libdl.dlext)
    paths_to_try = String[]

    push!(paths_to_try, "")
    push!(paths_to_try, @__DIR__)

    if haskey(ENV, "XPRESSDIR")
        push!(paths_to_try, joinpath(ENV["XPRESSDIR"], Sys.iswindows() ? "bin" : "lib"))
    end

    global found = false
    for l in paths_to_try
        path = joinpath(l, libname)
        d = Libdl.dlopen_e(path)
        if d != C_NULL
            global found = true
            @info("Found $path")
            write_depsfile(l)
            break
        end
    end

    if !found && !(Sys.isapple() || Sys.islinux())
        error("""
        Unable to locate Xpress installation.
        Please check your enviroment variable XPRESSDIR.
        Note that Xpress must be obtained separately from fico.com.
        """)
    end
end

if haskey(ENV, "XPRESS_JL_SKIP_LIB_CHECK")
    # Skip!
elseif get(ENV, "JULIA_REGISTRYCI_AUTOMERGE", "false") == "true"
    write_depsfile("julia_registryci_automerge")
else
    local_installation()
end

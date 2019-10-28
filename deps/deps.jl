import Libdl

libname = string(Sys.iswindows() ? "" : "lib", "xprs", ".", Libdl.dlext)

if !haskey(ENV, "XPRESSDIR")
    error("XPRESSDIR environment variable must be defined")
end

const libxprs = joinpath(ENV["XPRESSDIR"], Sys.iswindows() ? "bin" : "lib", libname)

function check_deps()
    global libxprs
    if !isfile(libxprs)
        error("$(libxprs) does not exist. Please refer to the documentation on how to install XPRESS.")
    end

    if Libdl.dlopen_e(libxprs) in (C_NULL, nothing)
        error("$(libxprs) cannot be opened because something went wrong. Please contact the developers and provide a detailed stacktrace.")
    end

end


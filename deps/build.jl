depsfile = joinpath(dirname(@__FILE__),"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

function write_depsfile(path)
    f = open(depsfile,"w")
    @windows_only path = replace(path, "\\", "\\\\")
    println(f,"const xprs = \"$(path)\"")
    close(f)
end

aliases = ASCIIString["xprs"]

paths_to_try = copy(aliases)

for a in aliases
    @windows_only  if haskey(ENV, "XPRESSDIR")
        push!(paths_to_try, joinpath(ENV["XPRESSDIR"],"bin",string(a,".",Libdl.dlext)))
    end
    @unix_only if haskey(ENV, "XPRESS")
        push!(paths_to_try, joinpath(ENV["XPRESS"],"lib",string("lib",a,".",Libdl.dlext)))
        push!(paths_to_try, joinpath(ENV["XPRESS"],"..","lib",string("lib",a,".",Libdl.dlext)))
    end
end

println(paths_to_try)
found = false
for l in paths_to_try[2:end]
    d = Libdl.dlopen_e(l)
    if d != C_NULL
        found = true
        write_depsfile(l)
        break
    end
end

if !found
    error("Unable to locate Xpress installation, please check your enviromental variable (XPRESSDIR in windows and XPRESS in unix). Note that this must be downloaded separately from fico.com")
end

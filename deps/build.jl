depsfile = joinpath(dirname(@__FILE__),"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

function write_depsfile(path)
    f = open(depsfile,"w")
    println(f,"const xprs = \"$path\"")
    close(f)
end

aliases = ["xpress"]

paths_to_try = copy(aliases)

for a in aliases
    if haskey(ENV, "XPRESS")
        @unix_only push!(paths_to_try, joinpath(ENV["XPRESS"],"lib",string("lib",a,".so")))
        @windows_only push!(paths_to_try, joinpath(ENV["XPRESS"],"bin",string(a,".",Libdl.dlext)))
    end
    # # gurobi uses .so on OS X for some reason
    # @osx_only push!(paths_to_try, string("lib$a.so"))
end

found = false
for l in paths_to_try
    d = Libdl.dlopen_e(l)
    if d != C_NULL
        found = true
        write_depsfile(l)
        break
    end
end

if !found
    error("Unable to locate Xpress installation. Note that this must be downloaded separately from fico.com")
end

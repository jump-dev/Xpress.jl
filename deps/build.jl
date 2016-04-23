depsfile = joinpath(dirname(@__FILE__),"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

function write_depsfile(path)
    f = open(depsfile,"w")
    println(f,"const xprs = \"$(path)\"")
    close(f)
end

aliases = ASCIIString["xprs"]

paths_to_try = copy(aliases)

for a in aliases
    if haskey(ENV, "XPRESSDIR")
        @unix_only push!(paths_to_try, joinpath(ENV["XPRESSDIR"],"lib",string("lib",a,".so")))
        @windows_only push!(paths_to_try, joinpath(ENV["XPRESSDIR"],"bin",string(a,".",Libdl.dlext)))
    end
end

println(paths_to_try)
found = false
for l in paths_to_try[2:end]
    d = Libdl.dlopen_e(l)
    if d != C_NULL
        found = true
        #print($(l))
        write_depsfile(l)
        break
    end
end

if !found
    error("Unable to locate Xpress installation, please check your enviromental variable XPRESSDIR. Note that this must be downloaded separately from fico.com")
end

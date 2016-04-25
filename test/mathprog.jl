using Xpress

include(joinpath(Pkg.dir("MathProgBase"),"test","linproginterface.jl"))
println("Testing linproginterface with solver Xpress.XpressSolver")
linprogsolvertest(XpressSolver())
println("Done")

include(joinpath(Pkg.dir("MathProgBase"),"test","linprog.jl"))
linprogtest(XpressSolver(PRESOLVE = 0))

include(joinpath(Pkg.dir("MathProgBase"),"test","mixintprog.jl"))
mixintprogtest(XpressSolver())

include(joinpath(Pkg.dir("MathProgBase"),"test","quadprog.jl"))
quadprogtest(XpressSolver(BARGAPSTOP = 1e-9))
socptest(XpressSolver())
#qpdualtest(XpressSolver()) #fails

include(joinpath(Pkg.dir("MathProgBase"),"test","conicinterface.jl"))
println("Testing coniclineartest with solver Xpress.XpressSolver")
coniclineartest(XpressSolver())
println("Done")
println("Testing conicSOCtest with solver Xpress.XpressSolver")
conicSOCtest(XpressSolver())
println("Done")


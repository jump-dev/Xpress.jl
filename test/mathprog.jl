using Xpress

include(joinpath(Pkg.dir("MathProgBase"),"test","linproginterface.jl"))
println("Testing linproginterface with solver Xpress.XpressSolver")
linprogsolvertest(Xpress.XpressSolver())
println("Done")

include(joinpath(Pkg.dir("MathProgBase"),"test","linprog.jl"))
linprogtest(Xpress.XpressSolver(PRESOLVE = 0))

include(joinpath(Pkg.dir("MathProgBase"),"test","mixintprog.jl"))
mixintprogtest(Xpress.XpressSolver())

include(joinpath(Pkg.dir("MathProgBase"),"test","quadprog.jl"))
quadprogtest(Xpress.XpressSolver(BARGAPSTOP = 1e-9))
socptest(Xpress.XpressSolver())
#qpdualtest(Xpress.XpressSolver()) #fails

include(joinpath(Pkg.dir("MathProgBase"),"test","conicinterface.jl"))
println("Testing coniclineartest with solver Xpress.XpressSolver")
coniclineartest(Xpress.XpressSolver())
println("Done")
println("Testing conicSOCtest with solver Xpress.XpressSolver")
conicSOCtest(Xpress.XpressSolver())
println("Done")


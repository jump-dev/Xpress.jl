using Xpress

include(joinpath(Pkg.dir("MathProgBase"),"test","linproginterface.jl"))
println("Testing linproginterface with solver Xpress.XpressSolver")
linprogsolvertest(XpressSolver())
println("Done")

include(joinpath(Pkg.dir("MathProgBase"),"test","mixintprog.jl"))
mixintprogtest(XpressSolver())


include(joinpath(Pkg.dir("MathProgBase"),"test","quadprog.jl"))
#quadprogtest(XpressSolver(OPTIMALITYTOL = 1e-8,
#CROSSOVERACCURACYTOL = 1e-8,
#BARDUALSTOP = 1e-8,
#BARPRIMALSTOP = 1e-8,
#BARGAPTARGET = 1e-9,
#BARGAPSTOP = 1e-9,
#DEFAULTALG = 4)) #fails due to precision
socptest(XpressSolver())
#qpdualtest(XpressSolver()) #fails

include(joinpath(Pkg.dir("MathProgBase"),"test","conicinterface.jl"))
println("Testing coniclineartest with solver Xpress.XpressSolver")
coniclineartest(XpressSolver())
println("Done")
println("Testing conicSOCtest with solver Xpress.XpressSolver")
conicSOCtest(XpressSolver())
println("Done")

include(joinpath(Pkg.dir("MathProgBase"),"test","linprog.jl"))
linprogtest(XpressSolver()) #fails on rays

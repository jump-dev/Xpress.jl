using Xpress

mpb_path = ""
if VERSION < v"0.7"
    mpb_path = Pkg.dir("MathProgBase")
else
    import MathProgBase
    mpb_path = joinpath(dirname(pathof(MathProgBase)),"..")
end

include(joinpath(mpb_path,"test","linproginterface.jl"))
println("Testing linproginterface with solver Xpress.XpressSolver")
linprogsolvertest(Xpress.XpressSolver())
println("Done")

include(joinpath(mpb_path,"test","linprog.jl"))
linprogtest(Xpress.XpressSolver(PRESOLVE = 0))

include(joinpath(mpb_path,"test","mixintprog.jl"))
mixintprogtest(Xpress.XpressSolver())

include(joinpath(mpb_path,"test","quadprog.jl"))
quadprogtest(Xpress.XpressSolver(BARGAPSTOP = 1e-9))
socptest(Xpress.XpressSolver())
#qpdualtest(Xpress.XpressSolver()) #fails

include(joinpath(mpb_path,"test","conicinterface.jl"))
println("Testing coniclineartest with solver Xpress.XpressSolver")
coniclineartest(Xpress.XpressSolver())
println("Done")
println("Testing conicSOCtest with solver Xpress.XpressSolver")
conicSOCtest(Xpress.XpressSolver())
println("Done")


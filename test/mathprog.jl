using Xpress

include(joinpath(Pkg.dir("MathProgBase"),"test","linprog.jl"))
linprogtest(XpressSolver(InfUnbdInfo=1))

include(joinpath(Pkg.dir("MathProgBase"),"test","linproginterface.jl"))
linprogsolvertest(XpressSolver())

include(joinpath(Pkg.dir("MathProgBase"),"test","mixintprog.jl"))
mixintprogtest(XpressSolver())


include(joinpath(Pkg.dir("MathProgBase"),"test","quadprog.jl"))
quadprogtest(XpressSolver())
socptest(XpressSolver())
qpdualtest(XpressSolver(QCPDual=1))

include(joinpath(Pkg.dir("MathProgBase"),"test","conicinterface.jl"))
coniclineartest(XpressSolver())
conicSOCtest(XpressSolver())

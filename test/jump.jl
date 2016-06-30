using Xpress, JuMP

include(Pkg.dir("JuMP","test","solvers.jl"))
lp_solvers = [XpressSolver()]
ip_solvers = [XpressSolver()]

include(Pkg.dir("JuMP","test","model.jl"))
include(Pkg.dir("JuMP","test","probmod.jl"))

FactCheck.exitstatus()

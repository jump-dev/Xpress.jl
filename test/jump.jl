using Xpress, JuMP, MathProgBase, Base.Test, OffsetArrays

lp_solvers = Any[]
ip_solvers = Any[]
ip_dual_solvers = Any[]
semi_solvers = Any[]
sos_solvers = Any[]
conic_solvers_with_duals = Any[]
lazy_solvers, lazylocal_solvers, cut_solvers, cutlocal_solvers, heur_solvers, info_solvers = Any[], Any[], Any[], Any[], Any[], Any[]
quad_solvers = Any[]
quad_mip_solvers = copy(quad_solvers)
soc_solvers = copy(quad_solvers)
rsoc_solvers = Any[]
nlp_solvers = Any[]
convex_nlp_solvers = copy(nlp_solvers)
minlp_solvers = Any[]
sdp_solvers = Any[]
error_map = Dict()
grb, cpx, cbc, glp, mos = false, false, false, false, false
xpr = true

lp_solvers = [XpressSolver()]
ip_solvers = [XpressSolver()]

sos_solvers = [XpressSolver()]

semi_solvers = [XpressSolver()]

soc_solvers = [XpressSolver()]
rsoc_solvers = [XpressSolver()]

quad_solvers = [Xpress.XpressSolver(FEASTOL = 1e-9, BARPRIMALSTOP = 1e-9, BARGAPSTOP = 1e-9, BARDUALSTOP = 1e-9)]
quad_mip_solvers = [Xpress.XpressSolver(FEASTOL = 1e-9, BARPRIMALSTOP = 1e-9, BARGAPSTOP = 1e-9, BARDUALSTOP = 1e-9)]

include(Pkg.dir("JuMP","test","model.jl"))
include(Pkg.dir("JuMP","test","probmod.jl"))

include(Pkg.dir("JuMP","test","socduals.jl"))
include(Pkg.dir("JuMP","test","qcqpmodel.jl"))
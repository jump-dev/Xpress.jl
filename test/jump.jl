using Xpress, JuMP, MathProgBase, Base.Test, OffsetArrays
import Xpress.XpressSolver

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
quad_soc_solvers = copy(quad_solvers)
rsoc_solvers = Any[]
nlp_solvers = Any[]
convex_nlp_solvers = copy(nlp_solvers)
minlp_solvers = Any[]
sdp_solvers = Any[]
error_map = Dict()
grb, cpx, cbc, glp, mos = false, false, false, false, false
xpr = true

lp_solvers = [Xpress.XpressSolver()]
ip_solvers = [Xpress.XpressSolver()]

sos_solvers = [Xpress.XpressSolver()]

semi_solvers = [Xpress.XpressSolver()]

soc_solvers = [Xpress.XpressSolver()]
rsoc_solvers = [Xpress.XpressSolver()]

tol = 1e-12

quad_solvers = [Xpress.XpressSolver(FEASTOL = tol, BARPRIMALSTOP = tol, BARGAPSTOP = tol, BARDUALSTOP = tol)]
quad_soc_solvers = [Xpress.XpressSolver(FEASTOL = tol, BARPRIMALSTOP = tol, BARGAPSTOP = tol, BARDUALSTOP = tol)]
quad_mip_solvers = [Xpress.XpressSolver(FEASTOL = tol, BARPRIMALSTOP = tol, BARGAPSTOP = tol, BARDUALSTOP = tol)]

include(Pkg.dir("JuMP","test","model.jl"))
include(Pkg.dir("JuMP","test","probmod.jl"))

include(Pkg.dir("JuMP","test","socduals.jl"))
include(Pkg.dir("JuMP","test","qcqpmodel.jl"))
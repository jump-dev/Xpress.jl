using Xpress, JuMP, MathProgBase

lp_solvers = Any[]
ip_solvers = Any[]
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

#include(Pkg.dir("JuMP","test","solvers.jl"))
lp_solvers = [XpressSolver()]
ip_solvers = [XpressSolver()]

sos_solvers = [XpressSolver()]

semi_solvers = [XpressSolver()]

soc_solvers = [XpressSolver()]
rsoc_solvers = [XpressSolver()]
conic_solvers_with_duals = Any[]#[XpressSolver()]

quad_solvers = [Xpress.XpressSolver(FEASTOL = 1e-9, BARPRIMALSTOP = 1e-9, BARGAPSTOP = 1e-9, BARDUALSTOP = 1e-9)]
quad_mip_solvers = [Xpress.XpressSolver(FEASTOL = 1e-9, BARPRIMALSTOP = 1e-9, BARGAPSTOP = 1e-9, BARDUALSTOP = 1e-9)]

include(Pkg.dir("JuMP","test","model.jl"))
include(Pkg.dir("JuMP","test","probmod.jl"))

facts("[probmod] Applicable regressions") do

function methods_test(solvername, solverobj, supp)
    mod = Model(solver=solverobj)
    @variable(mod, x >= 0)
    @constraint(mod, 2x == 2)
    solve(mod, suppress_warnings=true)
    internal_mod = internalmodel(mod)
    context(solvername) do
        for (it,(meth, args)) in enumerate(mpb_methods)
            if supp[it]
                @fact applicable(meth, internal_mod, args...) --> true
                @fact method_exists(meth, map(typeof, tuple(internal_mod, args...))) --> true
            end
        end
    end
end

const mpb_methods =
    [(MathProgBase.addquadconstr!, (Cint[1],Float64[1.0],Cint[1],Cint[1],Float64[1],'>',1.0)),
     (MathProgBase.setquadobjterms!, (Cint[1], Cint[1], Float64[1.0])),
     (MathProgBase.addconstr!,   ([1],[1.0],1.0,1.0)),
     (MathProgBase.addsos1!,     ([1],[1.0])),
     (MathProgBase.addsos2!,     ([1],[1.0])),
     (MathProgBase.addvar!,      ([1],[1.0],1.0,1.0,1.0)),
     (MathProgBase.setvarLB!,    ([1.0],)),
     (MathProgBase.setvarUB!,    ([1.0],)),
     (MathProgBase.setconstrLB!, ([1.0],)),
     (MathProgBase.setconstrUB!, ([1.0],)),
     (MathProgBase.setobj!,      ([1.0],)),
     (MathProgBase.setsense!,    (:Min,)),
     (MathProgBase.setvartype!,  ([:Cont],)),
     (MathProgBase.getinfeasibilityray, ()),
     (MathProgBase.getunboundedray, ()),
     (MathProgBase.getreducedcosts, ()),
     (MathProgBase.getconstrduals, ()),
     (MathProgBase.setwarmstart!, ([1.0]))]

supp = (true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,true,false)
methods_test("Xpress", Xpress.XpressSolver(), supp)

end

include(Pkg.dir("JuMP","test","socduals.jl"))
include(Pkg.dir("JuMP","test","qcqpmodel.jl"))






FactCheck.exitstatus()

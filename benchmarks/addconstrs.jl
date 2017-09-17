

using Xpress
Solver = Xpress

using BenchmarkTools

BenchmarkTools.DEFAULT_PARAMETERS.samples = 100

const nvars = 1000
const ncons = 1000
const ncoefs = 100

const inds = collect(1:div(nvars,ncoefs):nvars)
const coefs = collect(1.0:Float64(ncoefs))
@assert length(inds) == length(coefs)

const At = sparse(repmat(inds, ncons), repmat(collect(1:ncoefs),1,ncons)'[:], repmat(coefs, ncons), nvars, ncons)
const rhs = fill(24.1,ncons)

# env = Solver.Env()
# m1 = Solver.Model(env,"model")
m1 = Solver.Model()
Solver.add_cvars!(m1, zeros(nvars))
function add100cons1(m)
    for i in 1:ncons
        Solver.add_constr!(m, inds, coefs, '<', 24.1)
    end
end

m2 = Solver.Model()
Solver.add_cvars!(m2, zeros(nvars))
function add100cons2(m)

    add_constrs_t!(m, At, '<', rhs)
    nothing
end

# @benchmark add100cons1(m1)
# @benchmark add100cons2(m2)
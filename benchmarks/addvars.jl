

using Xpress
Solver = Xpress

using BenchmarkTools

BenchmarkTools.DEFAULT_PARAMETERS.samples = 100

# env = Solver.Env()
# m1 = Solver.Model(env,"model")
m1 = Solver.Model()
function add1000vars1(m)
    for i in 1:1000
        Solver.add_cvar!(m, 0.0)  # x
    end
end

m2 = Solver.Model()
function add1000vars2(m)
    Solver.add_cvars!(m, zeros(1000))  # x
    nothing
end

# @benchmark add1000vars1(m1)
# @benchmark add1000vars2(m2)
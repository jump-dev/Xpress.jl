include("Xpress.jl")

env = Env()

m = Model(env)

read_model(m, "Optfolio.mps")

write_model(m, "opt2.mps")

m2 = copy(m)

write_model(m2, "opt3.mps")
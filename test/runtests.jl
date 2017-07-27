using Xpress, Base.Test

# tests = ["xprs_attrs_test",
#          "lp_01a", 
#          "lp_01b", 
#          "lp_02", 
#          "lp_03",
#          "lp_04",
#          "mip_01", 
#          "qp_01",
#          "qp_02",
#          "qcqp_01",
#          "mathprog",
#          "jump",
         
#          ]

# for t in tests
#     fp = "$(t).jl"
#     println("running $(fp) ...")
#     evalfile(fp)
# end 


using MathOptInterface
include(joinpath("D:\\Repositories\\MathOptInterface", "test", "contlinear.jl"))
include(joinpath("D:\\Repositories\\MathOptInterface", "test", "intlinear.jl"))
# include(joinpath(Pkg.dir("MathOptInterface"), "test", "contlinear.jl"))

# contlinear
linear1test(XpressSolver())
linear2test(XpressSolver())
linear3test(XpressSolver())
linear4test(XpressSolver())
linear5test(XpressSolver())
linear6test(XpressSolver())
# wont pass - vector affine
# linear7test(XpressSolver())

# intlinear
knapsacktest(XpressSolver())
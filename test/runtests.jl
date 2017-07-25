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
# include(joinpath(Pkg.dir("MathOptInterface"), "test", "contlinear.jl"))

linear1test(XpressSolver())

# include("constants.jl")
# include("low_level_api.jl")
# @testset "LP" begin
#     include("lp_01.jl")
#     include("lp_02.jl")
#     include("lp_03.jl")
# end
# include("mip_01.jl")
# @testset "QP" begin
#     include("qp_01.jl")
#     include("qp_02.jl")
# end
# include("qcqp_01.jl")
# include("env.jl")
# include("sos.jl")
# include("problemtype.jl")
# include("miqcp.jl")
# @testset "MathProgBase" begin
#     include("mathprog.jl")
# end

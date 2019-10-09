using Xpress, Test
using SparseArrays
using LinearAlgebra
using Test

#=
tests = ["xprs_attrs_test",
         "lp_01a",
         "lp_01b",
         "lp_02",
         "lp_03",
         "lp_04",
         "mip_01",
         "qp_01",
         "qp_02",
         "qcqp_01",
         "iis",
         "mathprog",
         "MOIWrapper",
        #  "wordhunt"
         ]
=#

tests = ["MOI_Wrapper",
        #  "wordhunt"
         ]

for t in tests
    fp = "$(t).jl"
    println("running $(fp) ...")
    evalfile(fp)
end

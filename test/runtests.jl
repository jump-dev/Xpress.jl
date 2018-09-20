using Xpress, Compat.Test
using Compat.SparseArrays
using Compat.LinearAlgebra

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
         "mathprog",
         "MOIWrapper"
         ]

if VERSION < v"0.7.0"
    push!(tests, "jump")
end

for t in tests
    fp = "$(t).jl"
    println("running $(fp) ...")
    evalfile(fp)
end 

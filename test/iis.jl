using Xpress, Compat.Test
using Compat.SparseArrays

@testset "IIS computation" begin
    @testset "Feasible problem" begin
        # simple model:
        #    min x
        #    s.t. x >= 0
        model = Xpress.Model("lp_01", :minimize)
        add_cvar!(model, 1.0, 0.0, Inf)
        optimize(model)

        iisdata = Xpress.getfirstiis(model)

        @test iisdata.stat == 1
        @test iisdata.rownumber == 0
        @test iisdata.colnumber == 0
        @test length(iisdata.miisrow) == 0
        @test length(iisdata.miiscol) == 0
        @test length(iisdata.constrainttype) == 0
        @test length(iisdata.colbndtype) == 0
    end
end

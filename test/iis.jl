using Xpress, Test
using SparseArrays

@testset "IIS computation" begin
    @testset "Feasible problem, C API" begin
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

    @testset "Infeasible problem, C API" begin
        # simple model:
        #    min x
        #    s.t. x >= 2 && x <= 1
        model = Xpress.Model("lp_01", :minimize)
        add_cvar!(model, 1.0, 0.0, Inf)
        add_constr!(model, [1.], '>', 2.)
        add_constr!(model, [1.], '<', 1.)
        optimize(model)

        iisdata = Xpress.getfirstiis(model)

        @test iisdata.stat == 0
        @test iisdata.rownumber == 2
        @test iisdata.colnumber == 0
        @test length(iisdata.miisrow) == 2
        @test iisdata.miisrow[1] == 0
        @test iisdata.miisrow[2] == 1
        @test length(iisdata.miiscol) == 0
        @test length(iisdata.constrainttype) == 0
        @test length(iisdata.colbndtype) == 0
    end

    @testset "Infeasible problem, more complex, C API" begin
        # simple model:
        #    min x
        #    s.t. x <= -1
        model = Xpress.Model("lp_01", :minimize)
        add_cvar!(model, 1.0, 0.0, Inf)
        add_constr!(model, [1.], '<', -1.)
        optimize(model)

        iisdata = Xpress.getfirstiis(model)

        @test iisdata.stat == 0
        @test iisdata.rownumber == 1
        @test iisdata.colnumber == 1
        @test length(iisdata.miisrow) == 1
        @test iisdata.miisrow[1] == 0
        @test length(iisdata.miiscol) == 1
        @test iisdata.miiscol[1] == 0
        @test length(iisdata.constrainttype) == 1
        @test iisdata.constrainttype[1] == UInt8('L')
        @test length(iisdata.colbndtype) == 1
        @test iisdata.colbndtype[1] == UInt8('L')
    end
end

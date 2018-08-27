# a simple LP example
#
#   maximize x + y
#
#   s.t. 50 x + 24 y <= 2400
#        30 x + 33 y <= 2100
#        x >= 45, y >= 5
#
#   solution: x = 45, y = 6.25, objv = 51.25

using Xpress, Compat.Test
@testset "Basics 1b" begin
    model = Xpress.Model("lp_01", :maximize)

    # add variables
    add_cvars!(model, [1., 1.], [45., 5.], Inf)

    # add constraints
    add_constrs!(model, Cint[1, 3], Cint[1, 2, 1, 2],
        [50., 24., 30., 33.], '<', [2400., 2100.])

    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == sparse([50 24; 30 33])
    @test Xpress.get_rhs(model) == [2400, 2100]
    @test Xpress.get_lb(model) == [45, 5]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=,:<=]

    # perform optimization
    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test get_solution(model) == [45.0 , 6.25]

    @test get_objval(model) == 51.25
end
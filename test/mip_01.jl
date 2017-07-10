# an example on mixed integer programming
#
#   maximize x + 2 y + 5 z
#
#   s.t.  x + y + z <= 10
#         x + 2 y + z <= 15
#
#         x is continuous: 0 <= x <= 5
#         y is integer: 0 <= y <= 10
#         z is binary
#
# z = 1, y= 7, x = 0
@testset "MIP 4" begin

    model = Xpress.Model( "mip_01", :maximize)

    add_cvar!(model, 1., 0., 5.)  # x
    add_ivar!(model, 2., 0, 10)   # y
    add_bvar!(model, 5.)          # z

    add_constr!(model, ones(3), '<', 10.)
    add_constr!(model, [1., 2., 1.], '<', 15.)

    @test Xpress.get_obj(model) == [1, 2, 5]
    @test Xpress.get_constrmatrix(model) == sparse([1. 1. 1.; 1. 2. 1.])
    @test Xpress.get_rhs(model) == [10, 15]
    @test Xpress.get_lb(model) == [0, 0, 0]
    @test Xpress.get_ub(model) == [5, 10, 1]
    @test Xpress.get_sense(model) == [:<=,:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_mip == :mip_optimal

    @test isapprox(get_solution(model), [0, 7, 1]; atol = 1e-3)

    @test isapprox(get_objval(model), 19; atol = 1e-3)
end
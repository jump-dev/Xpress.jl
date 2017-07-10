# QP example
#
#    minimize 1/2*(2 x^2 + y^2 + xy) + x + y
#
#       s.t.  x, y >= 0
#             x + y = 1
#
#    solution: (0, 1), objv = 1.875
#
using Xpress, Base.Test
@testset "QP 1" begin
    model = Xpress.Model("qp_02")

    add_cvars!(model, [1., 1.], 0., Inf)

    add_qpterms!(model, [1, 1, 2], [1, 2, 2], [2., 1., 1.])
    add_constr!(model, [1., 1.], '=', 1.)

    @test Xpress.getq(model) == triu(sparse([2. 1.; 1. 1.]))
    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == sparse([1 1])
    @test Xpress.get_rhs(model) == [1]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:(==)]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [0.0, 1]; atol = 1e-3)

    @test isapprox(get_objval(model), 1.5; atol = 1e-3)
end
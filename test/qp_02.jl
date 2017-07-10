# Quadratic programming in MATLAB-like style
#
#   minimize x^2 + xy + y^2 + yz + z^2
#
#   s.t.    x + 2 y + 3 z >= 4
#           x +   y       >= 1
#

using Xpress, Base.Test
@testset "QP 2" begin
    model = xpress_model( 
    name = "qp_02", 
    f = [0., 0., 0.],
    H = [2. 1. 0.; 1. 2. 1.; 0. 1. 2.],
    A = -[1. 2. 3.; 1. 1. 0.], 
    b = -[4., 1.])

    @test Xpress.getq(model) == triu(sparse([2. 1. 0.; 1. 2. 1.; 0. 1. 2.]))
    @test Xpress.get_obj(model) == [0,0,0]
    @test Xpress.get_constrmatrix(model) == sparse([-1 -2 -3; -1 -1 0])
    @test Xpress.get_rhs(model) == [-4,-1]
    @test Xpress.get_lb(model) == [-1e20, -1e20, -1e20]
    @test Xpress.get_ub(model) == [1e20, 1e20, 1e20]
    @test Xpress.get_sense(model) == [:(<=),:(<=)]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [0.5714, .4285, .8571]; atol = 1e-3)

    @test isapprox(get_objval(model), 1.857; atol = 1e-3)
end
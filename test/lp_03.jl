# Test get/set objective coefficients in LP

using Xpress, Compat.Test

@testset "Basics 3" begin
    # original model
    #
    #   maximize  2x + 2y
    #
    #   s.t. 0.2 <= x, y <= 1

    model = xpress_model(
    name="lp_03",
    sense=:maximize,
    f=[2.0, 2.0],
    lb=[0.2, 0.2],
    ub=[1.0, 1.0])

    lb_ = lowerbounds(model)
    ub_ = upperbounds(model)
    c_ = objcoeffs(model)

    @test lb_ == [0.2, 0.2]
    @test ub_ == [1.0, 1.0]
    @test c_ == [2.0, 2.0]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [1, 1]; atol = 1e-3)
    @test isapprox(get_objval(model), 4; atol = 1e-3)

    # change objective (warm start)
    #
    #    maximize x - y
    #
    #    s.t. 0.2 <= x, y <= 1
    #

    set_objcoeffs!(model, [1, -1])

    c_ = objcoeffs(model)
    @test c_ == [1.0, -1.0]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [1.0, 0.2]; atol = 1e-3)
    @test isapprox(get_objval(model), 0.8; atol = 1e-3)
end
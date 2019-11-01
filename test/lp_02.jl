# LP programming using MATLAB-like construction
#
#   maximize 1000 x + 350 y
#
#       s.t. x >= 30, y >= 0
#            x - 1.5y >= 0  (i.e. -x + 1.5 y <= 0)
#            12 x + 8 y <= 1000
#            1000 x + 300 y <= 70000
#
#   solution: (59.0909, 36.3636)
#   objv: 71818.1818
#

using MathProgBase
using Xpress, Compat.Test
using Compat.SparseArrays

@testset "Basics 2" begin
    model = xpress_model(
        name="lp_02",
        sense=:maximize,
        f = [1000., 350.],
        A = [-1. 1.5; 12. 8.; 1000. 300.],
        b = [0., 1000., 70000.],
        lb = [0., 30.])

    @test Xpress.get_obj(model) == [1000, 350]
    @test Xpress.get_constrmatrix(model) == sparse([-1 1.5; 12 8; 1000 300])
    @test Xpress.get_rhs(model) == [0, 1000, 70000]
    @test Xpress.get_lb(model) == [0, 30]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=,:<=,:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [59.0909 , 36.3636]; atol = 1e-3)

    @test isapprox(get_objval(model), 71818.1818181818; atol = 1e-3)
end

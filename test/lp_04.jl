# Start from simple LP
# Solve it
# Copy and solve again
# Chg coeff, solve, change back solve
# del constr and solve
# del var and solve

# a simple LP example
#
#   maximize x + y
#
#   s.t. 2 x + 1 y <= 4
#        1 x + 2 y <= 4
#        x >= 0, y >= 0
#
#   solution: x = 1.3333333, y = 1.3333333, objv = 2.66666666
using Xpress, Compat.Test
using Compat.SparseArrays

@testset "Basics 4" begin

    model = Xpress.Model("lp_04", :maximize)

    add_cvars!(model, [1., 1.], [0., 0.], Inf)

    add_constrs!(model, Cint[1, 3], Cint[1, 2, 1, 2], 
        [2., 1., 1., 2.], '<', [4., 4.])

    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == sparse([2. 1.; 1. 2.])
    @test Xpress.get_rhs(model) == [4, 4]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=,:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [1.33333, 1.33333]; atol = 1e-3)

    @test isapprox(get_objval(model), 2.666666; atol = 1e-3)

    # PART 2: 
    # copy and solve

    model2 = copy(model)

    @test Xpress.get_obj(model2) == [1, 1]
    @test Xpress.get_constrmatrix(model2) == sparse([2. 1.; 1. 2.])
    @test Xpress.get_rhs(model2) == [4, 4]
    @test Xpress.get_lb(model2) == [0, 0]
    @test Xpress.get_ub(model2) == [1e20, 1e20]
    @test Xpress.get_sense(model2) == [:<=,:<=]

    optimize(model2)

    ans = get_optiminfo(model2)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model2), [1.33333, 1.33333]; atol = 1e-3)

    @test isapprox(get_objval(model2), 2.666666; atol = 1e-3)

    # PART 3: 
    # change coeff and solve

    #   maximize x + y
    #
    #   s.t. 2 x + 2 y <= 4
    #        1 x + 2 y <= 4
    #        x >= 0, y >= 0
    #
    #   solution: x = 0, y = 2, objv = 2

    chg_coeffs!(model, [1], [2],  [2.])

    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == sparse([2. 2.; 1. 2.])
    @test Xpress.get_rhs(model) == [4, 4]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=,:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [0, 2]; atol = 1e-3)

    @test isapprox(get_objval(model), 2; atol = 1e-3)

    # PART 4: 
    # change coeff and solve

    #   maximize x + y
    #
    #   s.t. 1 x + 2 y <= 4
    #        x >= 0, y >= 0
    #
    #   solution: x = 4, y = 0, objv = 4

    del_constrs!(model, [1])

    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == sparse([1. 2.])
    @test Xpress.get_rhs(model) == [4]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [4, 0]; atol = 1e-3)

    @test isapprox(get_objval(model), 4; atol = 1e-3)

    # PART 5: 
    # del var and solve

    #   maximize y
    #
    #   s.t.  2 y <= 4
    #           y >= 0
    #
    #   solution: y = 2, objv = 2

    del_vars!(model, [1])

    @test Xpress.get_obj(model) == [1]
    @test Xpress.get_constrmatrix(model) == sparse([2;]')
    @test Xpress.get_rhs(model) == [4]
    @test Xpress.get_lb(model) == [0]
    @test Xpress.get_ub(model) == [1e20]
    @test Xpress.get_sense(model) == [:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [2]; atol = 1e-3)

    @test isapprox(get_objval(model), 2; atol = 1e-3)

end
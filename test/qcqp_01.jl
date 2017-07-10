# QCQP example 
#    maximize x + y
#
#    s.t.  x, y >= 0
#          x^2 + y^2 <= 1
#
#    solution: (0.71, 0.71) objv = 1.414
using Xpress, Base.Test
@testset "QCQP 1" begin
    model = Xpress.Model( "qcqp_01", :maximize)

    add_cvars!(model, [1., 1.], 0., Inf)

    # add_qpterms!(model, linearindices, linearcoeffs, qrowinds, qcolinds, qcoeffs, sense, rhs)
    add_qconstr!(model, [], [], [1, 2], [1, 2], [1, 1.], '<', 1.0)

    @test Xpress.get_obj(model) == [1, 1]
    @test Xpress.get_constrmatrix(model) == spzeros(1,2)
    @test Xpress.get_rhs(model) == [1]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [1e20, 1e20]
    @test Xpress.get_sense(model) == [:<=]

    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

    @test isapprox(get_solution(model), [0.7071, 0.7071]; atol = 1e-3)

    @test isapprox(get_objval(model), 1.414; atol = 1e-3)
end
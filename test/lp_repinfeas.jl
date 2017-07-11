# a simple LP example
#
#   maximize 3x + 2y
#
#   s.t. 1 x + 1 y == 20
#        x \in [0, 10], y \in [0, 5]
#

using Xpress, Base.Test

# @testset "Basics 1" begin
    model = Xpress.Model("lp_01", :minimize)

    # add variables
    add_cvar!(model, 3.0, 0., 10.)  # x
    add_cvar!(model, 2.0,  0., 5.)  # y

    # add constraints
    add_constr!(model, [1., 1.], '=', 20.)

    @test Xpress.get_obj(model) == [3, 2]
    @test Xpress.get_constrmatrix(model) == sparse([1 1])
    @test Xpress.get_rhs(model) == [20]
    @test Xpress.get_lb(model) == [0, 0]
    @test Xpress.get_ub(model) == [10, 5]
    @test Xpress.get_sense(model) == [:(==)]

    # perform optimization
    optimize(model)

    ans = get_optiminfo(model)
    @test ans.status_lp == :infeasible

    lrp = Float64[0.0]
    grp = Float64[0.1]
    lbp = Float64[0.0,0.0]
    ubp = Float64[0.0,0.0]

    @test 0 == Xpress.repairweightedinfeasibility(model, lrp, grp, lbp, ubp, phase2 = Cchar('d'))
    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

@show Xpress.get_objval(model)
@show Xpress.get_solution(model) 
@show Xpress.get_dual(model)

    @test 0 == Xpress.repairweightedinfeasibility(model, lrp, grp, lbp, ubp, phase2 = Cchar('x'))
    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

@show Xpress.get_objval(model)
@show Xpress.get_solution(model) 
@show Xpress.get_dual(model)

    @test 0 == Xpress.repairweightedinfeasibility(model, lrp, grp, lbp, ubp, phase2 = Cchar('f'))
    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

@show Xpress.get_objval(model)
@show Xpress.get_solution(model) 
@show Xpress.get_dual(model)

    @test 0 == Xpress.repairweightedinfeasibility(model, lrp, grp, lbp, ubp, phase2 = Cchar('n'))
    ans = get_optiminfo(model)
    @test ans.status_lp == :optimal

@show Xpress.get_objval(model)
@show Xpress.get_solution(model) 
@show Xpress.get_dual(model)
;
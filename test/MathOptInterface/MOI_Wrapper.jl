module TestMOIWrapper

using Xpress
using MathOptInterface
using Test

const MOI = MathOptInterface

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$(name)", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
end

function test_runtests()
    optimizer = Xpress.Optimizer(OUTPUTLOG = 0)
    model = MOI.Bridges.full_bridge_optimizer(optimizer, Float64)
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(atol = 1e-3, rtol = 1e-3),
        exclude = String[
		    # tested with PRESOLVE=0
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_",
            # It seems that Xpress cannot handle nonconvex quadratic constraint
            "test_quadratic_nonconvex_",
            # TODO: conflict tests should be investigated further
            "test_solve_conflict_",
			# TODO: needs investigation
			"test_objective_set_via_modify"
        ],
    )

    optimizer_no_presolve = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    model = MOI.Bridges.full_bridge_optimizer(optimizer_no_presolve, Float64)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(
            atol = 1e-3,
            rtol = 1e-3,
            exclude = Any[MOI.ConstraintDual, MOI.DualObjectiveValue],
        ),
        include = String[
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_"
        ]
    )
    return
end

function test_Delete_equality_constraint_in_binary_variable()
    atol = rtol = 1e-6
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    # an example on mixed integer programming
    #
    #   maximize 1.1x + 2 y + 5 z
    #
    #   s.t.  x + y + z <= 10
    #         x + 2 y + z <= 15
    #
    #         x is continuous: 0 <= x <= 5
    #         y is integer: 0 <= y <= 10
    #         z is binary
    v = MOI.add_variables(model, 3)

    cf = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0, 1.0], v), 0.0)
    c = MOI.add_constraint(model, cf, MOI.LessThan(10.0))
    cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 2.0, 1.0], v), 0.0)
    c2 = MOI.add_constraint(model, cf2, MOI.LessThan(15.0))

    vc1 = MOI.add_constraint(
        model,
        v[1],
        MOI.Interval(0.0, 5.0),
    )
    vc2 = MOI.add_constraint(
        model,
        v[2],
        MOI.Interval(0.0, 10.0),
    )
    vc3 = MOI.add_constraint(model, v[2], MOI.Integer())
    vc4 = MOI.add_constraint(model, v[3], MOI.ZeroOne())

    objf =
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.1, 2.0, 5.0], v), 0.0)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        objf,
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)

    MOI.optimize!(model)

    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.PrimalStatus()) in
            [MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT]
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c2) ≈ 15 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ObjectiveBound()) >= 19.4 - atol

    z_value = MOI.get(model, MOI.VariablePrimal(), v)[3]
    
    # Relax binary bounds of z variable
    MOI.delete(model, vc4)

    # Fix z to its optimal value
    vc5 = MOI.add_constraint(model, v[3], MOI.EqualTo(z_value))

    MOI.optimize!(model)

    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.PrimalStatus()) in
            [MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT]
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c2) ≈ 15 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ObjectiveBound()) >= 19.4 - atol

    # Add back binary bounds to z
    vc4 = MOI.add_constraint(model, v[3], MOI.ZeroOne())

    # Remove equality constraint
    MOI.delete(model, vc5)

    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.PrimalStatus()) in
            [MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT]
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c2) ≈ 15 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ObjectiveBound()) >= 19.4 - atol
end

function test_Binary_Variables_Infeasibility()
    atol = rtol = 1e-6
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    v = MOI.add_variable(model)

    infeas_err = ErrorException("The problem is infeasible")
    vc1 = MOI.add_constraint(model, v, MOI.ZeroOne())
    @test_throws infeas_err vc2 = MOI.add_constraint(
        model,
        v,
        MOI.GreaterThan(2.0),
    )
    @test_throws infeas_err vc3 = MOI.add_constraint(
        model,
        v,
        MOI.LessThan(-1.0),
    )
    @test_throws infeas_err vc4 = MOI.add_constraint(
        model,
        v,
        MOI.Interval(-1.0,-0.5),
    )
    @test_throws infeas_err vc5 = MOI.add_constraint(
        model,
        v,
        MOI.EqualTo(2.0),
    )
end

end

TestMOIWrapper.runtests()
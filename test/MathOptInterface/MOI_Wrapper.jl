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
            "test_objective_set_via_modify",
            "test_model_ListOfConstraintAttributesSet",
            "test_solve_conflict_feasible",
            "test_objective_get_ObjectiveFunction_ScalarAffineFunction",
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_",
            # It seems that Xpress cannot handle nonconvex quadratic constraint
            "test_quadratic_nonconvex_",
            # TODO: conflict tests should be investigated further
            "test_solve_conflict_"
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

function test_IIS_Variable_bounds()
    for warning in [true, false]
        model = Xpress.Optimizer(OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
        MOI.set(model, MOI.RawOptimizerAttribute("MOIWarnings"), warning)
        x = MOI.add_variable(model)
        c1 = MOI.add_constraint(model, x, MOI.GreaterThan(2.0))
        c2 = MOI.add_constraint(model, x, MOI.LessThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.IN_CONFLICT
    end
end

function test_IIS_Two_conflicting_constraints_GreaterThan_LessThan()
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    x = MOI.add_variable(model)
    y = MOI.add_variable(model)
    b1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(0.0))
    b2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0), MOI.GreaterThan(0.0))
    cf1 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]), 0.0)
    c1 = MOI.add_constraint(model, cf1, MOI.LessThan(-1.0))
    cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]), 0.0)
    c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

    # Getting the results before the conflict refiner has been called must return an error.
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
    @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

    # Once it's called, no problem.
    # Two possible IISes: b1, b2, c1 OR b2, c1, c2
    MOI.compute_conflict!(model)
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) in [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) in [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
end

function test_IIS_Two_conflicting_constraints_EqualTo()
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    x = MOI.add_variable(model)
    y = MOI.add_variable(model)
    b1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(0.0))
    b2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0), MOI.GreaterThan(0.0))
    cf1 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]), 0.0)
    c1 = MOI.add_constraint(model, cf1, MOI.EqualTo(-1.0))
    cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]), 0.0)
    c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

    # Getting the results before the conflict refiner has been called must return an error.
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
    @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

    # Once it's called, no problem.
    # Two possible IISes: b1, b2, c1 OR b2, c1, c2
    MOI.compute_conflict!(model)
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) in [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) in [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
end

function test_IIS_Variables_outside_conflict()
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    x = MOI.add_variable(model)
    y = MOI.add_variable(model)
    z = MOI.add_variable(model)
    b1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(0.0))
    b2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0), MOI.GreaterThan(0.0))
    b3 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [z]), 0.0), MOI.GreaterThan(0.0))
    cf1 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]), 0.0)
    c1 = MOI.add_constraint(model, cf1, MOI.LessThan(-1.0))
    cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, -1.0, 1.0], [x, y, z]), 0.0)
    c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

    # Getting the results before the conflict refiner has been called must return an error.
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
    @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

    # Once it's called, no problem.
    MOI.compute_conflict!(model)
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), b3) == MOI.NOT_IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.NOT_IN_CONFLICT
end

function test_IIS_No_conflict()
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    x = MOI.add_variable(model)
    c1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(1.0))
    c2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.LessThan(2.0))

    # Getting the results before the conflict refiner has been called must return an error.
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
    @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

    # Once it's called, no problem.
    MOI.compute_conflict!(model)
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.NO_CONFLICT_FOUND
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.NOT_IN_CONFLICT
    @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.NOT_IN_CONFLICT
end

function test_farkas_dual_min()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.VariableIndex}(),
        x[1],
    )
    clb = MOI.add_constraint.(
        model, x, MOI.GreaterThan(0.0)
    )
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([2.0, 1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] > 1e-6
    @test clb_dual[2] > 1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ -2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ -c_dual atol = 1e-6
end

function test_farkas_dual_min_interval()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.VariableIndex}(),
        x[1],
    )
    clb = MOI.add_constraint.(
        model, x, MOI.Interval(0.0, 10.0)
    )
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([2.0, 1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] > 1e-6
    @test clb_dual[2] > 1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ -2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ -c_dual atol = 1e-6
end

function test_farkas_dual_min_equalto()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.VariableIndex}(),
        x[1],
    )
    clb = MOI.add_constraint.(model, x, MOI.EqualTo(0.0))
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([2.0, 1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] > 1e-6
    @test clb_dual[2] > 1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ -2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ -c_dual atol = 1e-6
end

function test_farkas_dual_min_ii()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(
        model, x, MOI.LessThan(0.0)
    )
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([-2.0, -1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] < -1e-6
    @test clb_dual[2] < -1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ 2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ c_dual atol = 1e-6
end

function test_farkas_dual_max()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.VariableIndex}(),
        x[1],
    )
    clb = MOI.add_constraint.(
        model, x, MOI.GreaterThan(0.0)
    )
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([2.0, 1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] > 1e-6
    @test clb_dual[2] > 1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ -2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ -c_dual atol = 1e-6
end

function test_farkas_dual_max_ii()
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(
        model, x, MOI.LessThan(0.0)
    )
    c = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([-2.0, -1.0], x), 0.0),
        MOI.LessThan(-1.0),
    )
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
    @test MOI.get(model, MOI.DualStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    clb_dual = MOI.get.(model, MOI.ConstraintDual(), clb)
    c_dual = MOI.get(model, MOI.ConstraintDual(), c)
    @test clb_dual[1] < -1e-6
    @test clb_dual[2] < -1e-6
    @test c_dual[1] < -1e-6
    @test clb_dual[1] ≈ 2 * c_dual atol = 1e-6
    @test clb_dual[2] ≈ c_dual atol = 1e-6
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
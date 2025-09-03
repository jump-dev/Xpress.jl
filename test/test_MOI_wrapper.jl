# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module TestMOIWrapper

using Xpress
using Test

import MathOptInterface as MOI

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$(name)", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
    return
end

function test_Basic_Parameters()
    optimizer = Xpress.Optimizer(; OUTPUTLOG = 0)
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("logfile")) == ""
    optimizer = Xpress.Optimizer(; OUTPUTLOG = 0, logfile = "output.log")
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("logfile")) ==
          "output.log"
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 100) === nothing
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 3600.0) === nothing

    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP")) == 0.0001
    MOI.set(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP"), 0.123)
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP")) == 0.123

    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME")) == ""
    MOI.set(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME"), "qwerty")
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME")) ==
          "qwerty"

    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("PRESOLVE")) == 1
    MOI.set(optimizer, MOI.RawOptimizerAttribute("PRESOLVE"), 3)
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("PRESOLVE")) == 3

    @show MOI.get(optimizer, MOI.RawOptimizerAttribute("XPRESSVERSION"))
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MATRIXNAME")) == ""
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("SUMPRIMALINF")) == 0.0
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("NAMELENGTH")) == 8
    @test MOI.get(optimizer, MOI.SolverName()) == "Xpress"
end

function test_runtests()
    model = MOI.instantiate(Xpress.Optimizer; with_bridge_type = Float64)
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(; atol = 1e-3, rtol = 1e-3);
        exclude = [
            # An upstream bug in Xpress@9.7.0
            "test_solve_conflict_bound_bound",
            # tested with PRESOLVE=0 below
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_",
            # Xpress cannot handle nonconvex quadratic constraint
            "test_quadratic_nonconvex_",
            # Nonlinear tests because these return LOCALLY_SOLVED
            "test_nonlinear_",
        ],
    )
    MOI.Test.runtests(
        model,
        MOI.Test.Config(;
            atol = 1e-3,
            rtol = 1e-3,
            exclude = Any[MOI.ConstraintDual],
            optimal_status = MOI.LOCALLY_SOLVED,
        );
        include = ["test_nonlinear_"],
        # This test is actually MOI.OPTIMAL. It's okay to ignore for now.
        exclude = [
            "test_nonlinear_expression_overrides_objective",
            "test_nonlinear_quadratic_1",
            "test_nonlinear_quadratic_4",
            "test_nonlinear_with_scalar_quadratic_function_with_off_diag",
        ],
    )
    MOI.Test.runtests(
        model,
        MOI.Test.Config(;
            atol = 1e-3,
            rtol = 1e-3,
            exclude = Any[MOI.ConstraintDual],
        );
        include = [
            "test_nonlinear_expression_overrides_objective",
            "test_nonlinear_quadratic_1",
            "test_nonlinear_quadratic_4",
            # TODO(odow): this test triggers a segfault in
            # MathOptInterface/actions/workflows/solvertests.yml
            # "test_nonlinear_with_scalar_quadratic_function_with_off_diag",
        ],
    )
    MOI.set(model, MOI.RawOptimizerAttribute("PRESOLVE"), 0)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(;
            atol = 1e-3,
            rtol = 1e-3,
            exclude = Any[MOI.ConstraintDual, MOI.DualObjectiveValue],
        );
        include = String[
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_",
        ],
    )
    return
end

function test_Binaryfixing()
    @testset "Binary Equal to 1" begin
        T = Float64
        config = MOI.Test.Config(; atol = 1e-3, rtol = 1e-3)
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        MOI.add_constraint(model, x, MOI.EqualTo(T(1)))
        f = MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(T(1), x)], T(0))
        MOI.add_constraint(model, x, MOI.ZeroOne())
        MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
        MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
        MOI.Test._test_model_solution(
            model,
            config;
            objective_value = T(1),
            variable_primal = [(x, T(1))],
        )
    end

    @testset "Binary Equal to 1 - delete constraint" begin
        T = Float64
        config = MOI.Test.Config(; atol = 1e-3, rtol = 1e-3)
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        MOI.add_constraint(model, x, MOI.ZeroOne())
        c1 = MOI.add_constraint(model, x, MOI.EqualTo(T(1)))
        MOI.delete(model, c1)
        f = MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(T(1), x)], T(0))
        MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
        MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
        MOI.Test._test_model_solution(
            model,
            config;
            objective_value = T(0),
            variable_primal = [(x, T(0))],
        )
    end
end

function test_Conflicts()
    @testset "Binary" begin
        T = Float64
        model = Xpress.Optimizer(; OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
        x, c1 = MOI.add_constrained_variable(model, MOI.ZeroOne())
        c2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(
                MOI.ScalarAffineTerm.(one(T), [x]),
                zero(T),
            ),
            MOI.EqualTo(T(0.5)),
        )
        MOI.optimize!(model)
        @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        zeroone_conflict = MOI.get(model, MOI.ConstraintConflictStatus(), c1)
        @test zeroone_conflict == MOI.MAYBE_IN_CONFLICT ||
              zeroone_conflict == MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) ==
              MOI.IN_CONFLICT
    end
    for warning in [true, false]
        @testset "Variable bounds" begin
            model =
                Xpress.Optimizer(; OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
            MOI.set(model, MOI.RawOptimizerAttribute("MOI_WARNINGS"), warning)
            x = MOI.add_variable(model)
            c1 = MOI.add_constraint(model, x, MOI.GreaterThan(2.0))
            c2 = MOI.add_constraint(model, x, MOI.LessThan(1.0))

            # Getting the results before the conflict refiner has been called must return an error.
            @test MOI.get(model, MOI.ConflictStatus()) ==
                  MOI.COMPUTE_CONFLICT_NOT_CALLED
            @test_throws ErrorException MOI.get(
                model,
                MOI.ConstraintConflictStatus(),
                c1,
            )

            # Once it's called, no problem.
            MOI.compute_conflict!(model)
            @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
            @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) ==
                  MOI.IN_CONFLICT
            @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) ==
                  MOI.IN_CONFLICT
        end
    end

    @testset "Two conflicting constraints (GreaterThan, LessThan)" begin
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        y = MOI.add_variable(model)
        b1 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0),
            MOI.GreaterThan(0.0),
        )
        b2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0),
            MOI.GreaterThan(0.0),
        )
        cf1 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
            0.0,
        )
        c1 = MOI.add_constraint(model, cf1, MOI.LessThan(-1.0))
        cf2 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]),
            0.0,
        )
        c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) ==
              MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(
            model,
            MOI.ConstraintConflictStatus(),
            c1,
        )

        # Once it's called, no problem.
        # Two possible IISes: b1, b2, c1 OR b2, c1, c2
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) in
              [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) in
              [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
    end

    @testset "Two conflicting constraints (EqualTo)" begin
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        y = MOI.add_variable(model)
        b1 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0),
            MOI.GreaterThan(0.0),
        )
        b2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0),
            MOI.GreaterThan(0.0),
        )
        cf1 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
            0.0,
        )
        c1 = MOI.add_constraint(model, cf1, MOI.EqualTo(-1.0))
        cf2 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]),
            0.0,
        )
        c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) ==
              MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(
            model,
            MOI.ConstraintConflictStatus(),
            c1,
        )

        # Once it's called, no problem.
        # Two possible IISes: b1, b2, c1 OR b2, c1, c2
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) in
              [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) in
              [MOI.IN_CONFLICT, MOI.NOT_IN_CONFLICT]
    end

    @testset "Variables outside conflict" begin
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        y = MOI.add_variable(model)
        z = MOI.add_variable(model)
        b1 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0),
            MOI.GreaterThan(0.0),
        )
        b2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0),
            MOI.GreaterThan(0.0),
        )
        b3 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [z]), 0.0),
            MOI.GreaterThan(0.0),
        )
        cf1 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
            0.0,
        )
        c1 = MOI.add_constraint(model, cf1, MOI.LessThan(-1.0))
        cf2 = MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.([1.0, -1.0, 1.0], [x, y, z]),
            0.0,
        )
        c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) ==
              MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(
            model,
            MOI.ConstraintConflictStatus(),
            c1,
        )

        # Once it's called, no problem.
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b1) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b2) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), b3) ==
              MOI.NOT_IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) ==
              MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) ==
              MOI.NOT_IN_CONFLICT
    end

    @testset "No conflict" begin
        model = Xpress.Optimizer(; OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        c1 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0),
            MOI.GreaterThan(1.0),
        )
        c2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0),
            MOI.LessThan(2.0),
        )

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) ==
              MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(
            model,
            MOI.ConstraintConflictStatus(),
            c1,
        )

        # Once it's called, no problem.
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.NO_CONFLICT_EXISTS
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) ==
              MOI.NOT_IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) ==
              MOI.NOT_IN_CONFLICT
    end
end

# Xpress can only obtain primal and dual rays without presolve. Check more on
# https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSgetprimalray.html
function test_Farkas_Dual_Min()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(model, MOI.ObjectiveFunction{MOI.VariableIndex}(), x[1])
    clb = MOI.add_constraint.(model, x, MOI.GreaterThan(0.0))
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

function test_Farkas_Dual_Min_Interval()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(model, MOI.ObjectiveFunction{MOI.VariableIndex}(), x[1])
    clb = MOI.add_constraint.(model, x, MOI.Interval(0.0, 10.0))
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

function test_Farkas_Dual_Min_Equalto()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(model, MOI.ObjectiveFunction{MOI.VariableIndex}(), x[1])
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

function test_Farkas_Dual_Min_2()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(model, x, MOI.LessThan(0.0))
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

function test_Farkas_Dual_Max()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(model, MOI.ObjectiveFunction{MOI.VariableIndex}(), x[1])
    clb = MOI.add_constraint.(model, x, MOI.GreaterThan(0.0))
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

function test_Farkas_Dual_Max_2()
    model = Xpress.Optimizer(; OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(model, x, MOI.LessThan(0.0))
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
    model = Xpress.Optimizer(; OUTPUTLOG = 0)
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

    cf =
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0, 1.0], v), 0.0)
    c = MOI.add_constraint(model, cf, MOI.LessThan(10.0))
    cf2 =
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 2.0, 1.0], v), 0.0)
    c2 = MOI.add_constraint(model, cf2, MOI.LessThan(15.0))

    vc1 = MOI.add_constraint(model, v[1], MOI.Interval(0.0, 5.0))
    vc2 = MOI.add_constraint(model, v[2], MOI.Interval(0.0, 10.0))
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
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol = rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol = rtol
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
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol = rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol = rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c2) ≈ 15 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ObjectiveBound()) >= 19.4 - atol

    # Add back binary bounds to z
    vc4 = MOI.add_constraint(model, v[3], MOI.ZeroOne())

    # Remove equality constraint
    MOI.delete(model, vc5)
    MOI.optimize!(model)
    @test MOI.get(model, MOI.TerminationStatus()) == MOI.OPTIMAL
    @test MOI.get(model, MOI.ResultCount()) >= 1
    @test MOI.get(model, MOI.PrimalStatus()) in
          [MOI.FEASIBLE_POINT, MOI.NEARLY_FEASIBLE_POINT]
    @test MOI.get(model, MOI.ObjectiveValue()) ≈ 19.4 atol = atol rtol = rtol
    @test MOI.get(model, MOI.VariablePrimal(), v) ≈ [4, 5, 1] atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c) ≈ 10 atol = atol rtol = rtol
    @test MOI.get(model, MOI.ConstraintPrimal(), c2) ≈ 15 atol = atol rtol =
        rtol
    @test MOI.get(model, MOI.ObjectiveBound()) >= 19.4 - atol
end

function test_Binary_Variables_Infeasibility()
    atol = rtol = 1e-6
    model = Xpress.Optimizer(; OUTPUTLOG = 0)
    v = MOI.add_variable(model)

    infeas_err = ErrorException("The problem is infeasible")
    vc1 = MOI.add_constraint(model, v, MOI.ZeroOne())
    @test_throws infeas_err vc2 =
        MOI.add_constraint(model, v, MOI.GreaterThan(2.0))
    @test_throws infeas_err vc3 =
        MOI.add_constraint(model, v, MOI.LessThan(-1.0))
    @test_throws infeas_err vc4 =
        MOI.add_constraint(model, v, MOI.Interval(-1.0, -0.5))
    @test_throws infeas_err vc5 = MOI.add_constraint(model, v, MOI.EqualTo(2.0))
end

function test_MIP_Start()
    # The idea of the test is the following:
    # * Give Xpress a problem it can solve quickly but not simple enough to be
    #   solved at the root node when heuristics and cuts are disabled.
    # * Assert the solution was not found at the root node (query attribute
    #   MIPSOLNODE, it should be higher than one).
    # * Limit the model to searching the root node.
    # * Run again without the MIP-start, so the solution found is worse.
    #   (This is mostly done to be sure no status since the optimal solve
    #   was kept.)
    # * MIP-start the model with the optimal solution.
    # * If the solution found is the MIP-started solution then XPRESS has
    #   used the MIP-start (we checked XPRESS could not solve it using
    #   a single node).
    atol = rtol = 1e-6
    weight = Float64[
        677,
        460,
        752,
        852,
        580,
        116,
        457,
        121,
        454,
        870,
        443,
        196,
        411,
        539,
        348,
        187,
        771,
        127,
        338,
        527,
        932,
        961,
        48,
        135,
        367,
        998,
        363,
        153,
        921,
        578,
        311,
        560,
        293,
        258,
        474,
        884,
        162,
        136,
        479,
        289,
        813,
        139,
        795,
        825,
        945,
        750,
        462,
        659,
        270,
        34,
        758,
        865,
        238,
        367,
        444,
        116,
        69,
        894,
        584,
        96,
        29,
        199,
        712,
        703,
        856,
        692,
        396,
        409,
        603,
        632,
        479,
        848,
        822,
        248,
        424,
        978,
        738,
        655,
        210,
        173,
        731,
        100,
        889,
        195,
        245,
        329,
        446,
        47,
        235,
        25,
        254,
        150,
        520,
        665,
        391,
        907,
        123,
        826,
        959,
        176,
    ]
    profit = weight .- (5.0,)
    capacity = 10000.0
    model = Xpress.Optimizer(;
        OUTPUTLOG = 0,
        HEURSTRATEGY = 0,
        HEUREMPHASIS = 0,
        CUTSTRATEGY = 0,
        PRESOLVE = 0,
        MIPPRESOLVE = 0,
        PRESOLVEOPS = 0,
        # USERSOLHEURISTIC = 1,
    )
    # The variables: x[1:100], Bin
    x, _ = MOI.add_constrained_variables(model, fill(MOI.ZeroOne(), 100))
    # The objective function: maximize sum(profit' * x)
    objf = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(profit, x), 0.0)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        objf,
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    # The capacity constraint: sum(weight' * x) <= capacity
    MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(weight, x), 0.0),
        MOI.LessThan(capacity),
    )

    # FIRST RUN: get the optimal value. Check that the optimal
    # value was not discovered at the root node.
    MOI.optimize!(model)

    solution = MOI.get(model, MOI.VariablePrimal(), x)
    computed_obj_value = profit' * solution
    obtained_obj_value = MOI.get(model, MOI.ObjectiveValue())::Float64
    @test isapprox(
        obtained_obj_value,
        computed_obj_value;
        rtol = rtol,
        atol = atol,
    )
    @test isapprox(9945.0, computed_obj_value; rtol = rtol, atol = atol)

    node_solution_was_found =
        MOI.get(model, MOI.RawOptimizerAttribute("MIPSOLNODE"))

    @test node_solution_was_found > 1

    # SECOND RUN: run without MIP-start and only searching the first node.
    # Should give a worse solution than the previous one.
    MOI.set(model, MOI.RawOptimizerAttribute("MAXNODE"), 1)

    MOI.optimize!(model)

    # One node may not be enough to even get any solution.
    if MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT
        solution2 = MOI.get(model, MOI.VariablePrimal(), x)
        computed_obj_value2 = profit' * solution2
        obtained_obj_value2 = MOI.get(model, MOI.ObjectiveValue())::Float64
        @test isapprox(
            obtained_obj_value2,
            computed_obj_value2;
            rtol = rtol,
            atol = atol,
        )
        # There should be at least one unit of difference.
        @test obtained_obj_value1 > obtained_obj_value2 + 0.5
    end

    # THIRD RUN: run with MIP-start and searching only the root node.
    # Should find the optimal solution impossible to get in one node.
    MOI.set.(model, MOI.VariablePrimalStart(), x, solution)

    # This postsolve is necessary because of an unrelated bug. Apparently,
    # if Xpress is stopped because MAXNODE and has no feasible solution,
    # then MOI.optimize! will not call postsolve over it, however calling
    # postsolve is necessary otherwise a new call to MOI.optimize will
    # trigger error 707 ("707 Error: Function cannot be called during the
    # global search, except in callbacks.").
    # Xpress.Lib.XPRSpostsolve(model.inner)

    MOI.set(model, MOI.RawOptimizerAttribute("MAXNODE"), 1)

    MOI.optimize!(model)

    @test MOI.get(model, MOI.RawStatusString()) isa String

    solution3 = MOI.get(model, MOI.VariablePrimal(), x)
    computed_obj_value3 = profit' * solution3
    obtained_obj_value3 = MOI.get(model, MOI.ObjectiveValue())::Float64
    @test isapprox(
        obtained_obj_value3,
        computed_obj_value3;
        rtol = rtol,
        atol = atol,
    )
    @test isapprox(9945.0, computed_obj_value3; rtol = rtol, atol = atol)
end

function test_multiple_modifications()
    model = Xpress.Optimizer(; OUTPUTLOG = 0)

    x = MOI.add_variables(model, 3)

    saf = MOI.ScalarAffineFunction(
        [
            MOI.ScalarAffineTerm(1.0, x[1]),
            MOI.ScalarAffineTerm(1.0, x[2]),
            MOI.ScalarAffineTerm(1.0, x[3]),
        ],
        0.0,
    )
    ci1 = MOI.add_constraint(model, saf, MOI.LessThan(1.0))
    ci2 = MOI.add_constraint(model, saf, MOI.LessThan(2.0))

    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        saf,
    )

    fc1 = MOI.get(model, MOI.ConstraintFunction(), ci1)
    @test MOI.coefficient.(fc1.terms) == [1.0, 1.0, 1.0]
    fc2 = MOI.get(model, MOI.ConstraintFunction(), ci2)
    @test MOI.coefficient.(fc2.terms) == [1.0, 1.0, 1.0]
    obj = MOI.get(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
    )
    @test MOI.coefficient.(obj.terms) == [1.0, 1.0, 1.0]

    changes_cis = [
        MOI.ScalarCoefficientChange(MOI.VariableIndex(1), 4.0)
        MOI.ScalarCoefficientChange(MOI.VariableIndex(1), 0.5)
        MOI.ScalarCoefficientChange(MOI.VariableIndex(3), 2.0)
    ]
    MOI.modify(model, [ci1, ci2, ci2], changes_cis)

    fc1 = MOI.get(model, MOI.ConstraintFunction(), ci1)
    @test MOI.coefficient.(fc1.terms) == [4.0, 1.0, 1.0]
    fc2 = MOI.get(model, MOI.ConstraintFunction(), ci2)
    @test MOI.coefficient.(fc2.terms) == [0.5, 1.0, 2.0]

    changes_obj = [
        MOI.ScalarCoefficientChange(MOI.VariableIndex(1), 4.0)
        MOI.ScalarCoefficientChange(MOI.VariableIndex(2), 10.0)
        MOI.ScalarCoefficientChange(MOI.VariableIndex(3), 2.0)
    ]
    MOI.modify(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        changes_obj,
    )

    obj = MOI.get(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
    )
    @test MOI.coefficient.(obj.terms) == [4.0, 10.0, 2.0]
end

function infeasible_problem()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    MOI.set(model, MOI.RawOptimizerAttribute("MOI_POST_SOLVE"), false)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    f = 1.0 * x[1] + 1.0 * x[2]
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    c1 = MOI.add_constraint(model, 1.0 * x[1], MOI.GreaterThan(5.0))
    c2 = MOI.add_constraint(model, 1.0 * x[1], MOI.LessThan(2.0))
    c3 = MOI.add_constraint(model, 1.0 * x[2], MOI.GreaterThan(10.0))
    MOI.optimize!(model)
    return x, [c1, c2, c3], model
end

function test_name_pass_empty()
    model = Xpress.Optimizer()
    Xpress._pass_names_to_solver(model)
    @test Xpress._get_variable_names(model) == String[]
    @test Xpress._get_constraint_names(model) == String[]
    return
end

function test_name_pass_very_long_variable()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    MOI.set(model, MOI.VariableName(), x, "abc"^64)
    @test_logs (:warn,) Xpress._pass_names_to_solver(model)
    @test Xpress._get_variable_names(model) == ["C1"]
    return
end

function test_name_pass_very_long_constraint()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, 1.0 * x, MOI.EqualTo(0.0))
    MOI.set(model, MOI.ConstraintName(), c, "abc"^64)
    @test_logs (:warn,) Xpress._pass_names_to_solver(model)
    @test Xpress._get_constraint_names(model) == ["R1"]
    return
end

function test_name_constraints()
    variables, constraints, model = infeasible_problem()
    MOI.set(model, MOI.VariableName(), variables, ["x1", "x2"])
    MOI.set(model, MOI.ConstraintName(), constraints[1], "constraint1")
    MOI.set(model, MOI.ConstraintName(), constraints[2], "constraint2")
    MOI.set(model, MOI.ConstraintName(), constraints[3], "constraint3")
    Xpress._pass_names_to_solver(model)
    variable_names = Xpress._get_variable_names(model)
    constraint_names = Xpress._get_constraint_names(model)
    @test variable_names == ["x1", "x2"]
    @test constraint_names == ["constraint1", "constraint2", "constraint3"]
    return
end

function test_name_constraints_with_the_same_name()
    variables, constraints, model = infeasible_problem()
    MOI.set(model, MOI.VariableName(), variables, ["x1", "x2"])
    MOI.set(model, MOI.ConstraintName(), constraints[1], "same")
    MOI.set(model, MOI.ConstraintName(), constraints[2], "same")
    MOI.set(model, MOI.ConstraintName(), constraints[3], "constraint3")
    @test_logs (:warn,) Xpress._pass_names_to_solver(model)
    variable_names = Xpress._get_variable_names(model)
    constraint_names = Xpress._get_constraint_names(model)
    @test variable_names == ["x1", "x2"]
    @test constraint_names == ["same", "R2", "constraint3"] ||
          constraint_names == ["R1", "same", "constraint3"]
    return
end

function test_name_variables_with_the_same_name()
    variables, constraints, model = infeasible_problem()
    MOI.set(model, MOI.VariableName(), variables, ["x1", "x1"])
    MOI.set(model, MOI.ConstraintName(), constraints[1], "constraint1")
    MOI.set(model, MOI.ConstraintName(), constraints[2], "constraint2")
    MOI.set(model, MOI.ConstraintName(), constraints[3], "constraint3")
    @test_logs (:warn,) Xpress._pass_names_to_solver(model)
    variable_names = Xpress._get_variable_names(model)
    constraint_names = Xpress._get_constraint_names(model)
    @test variable_names == ["x1", "C2"]
    @test constraint_names == ["constraint1", "constraint2", "constraint3"]
    return
end

function test_name_empty_names()
    variables, constraints, model = infeasible_problem()
    Xpress._pass_names_to_solver(model)
    variable_names = Xpress._get_variable_names(model)
    constraint_names = Xpress._get_constraint_names(model)
    @test variable_names == ["C1", "C2"]
    @test constraint_names == ["R1", "R2", "R3"]
    return
end

function test_dummy_nlp()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer(; OUTPUTLOG = 0)
    x = MOI.add_variables(model, 2)
    c = [1.0, 2.0]
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(c, x), 0.0),
    )

    MOI.set(model, MOI.VariableName(), x, ["x1", "x2"])

    Xpress._pass_variable_names_to_solver(model)

    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)

    b1 = MOI.add_constraint.(model, x, MOI.GreaterThan(0.0))
    b1 = MOI.add_constraint.(model, x, MOI.LessThan(10.0))

    c1 = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], x), 0.0),
        MOI.EqualTo(0.0),
    )

    c3 = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([0.0, 1.0], x), 0.0),
        MOI.GreaterThan(10.0),
    )

    MOI.optimize!(model)

    x_sol = MOI.get.(model, MOI.VariablePrimal(), x)
    @test x_sol == [0.0, 10.0]

    ret =
        Xpress.Lib.XPRSnlpchgformulastring(model.inner, Cint(0), "- 5 * x1 - 3")
    @test ret == 0
    ret = Xpress.Lib.XPRSnlpchgformulastring(model.inner, Cint(0), "- 3.14")
    @test ret == 0

    solvestatus = Ref{Cint}(0)
    solstatus = Ref{Cint}(0)
    ret = Xpress.Lib.XPRSoptimize(model.inner, "", solvestatus, solstatus)
    @test ret == 0

    xx = Array{Float64}(undef, 2)
    slack = Array{Float64}(undef, 2)
    duals = Array{Float64}(undef, 2)
    djs = Array{Float64}(undef, 2)
    ret = Xpress.Lib.XPRSgetnlpsol(model.inner, xx, slack, duals, djs)
    @test ret == 0
    @test xx == [3.14, 10]
    @test slack == [0, 0]

    ret = Xpress.Lib.XPRSnlpchgformulastring(
        model.inner,
        Cint(0),
        "- 0.5 * x1 - 3",
    )
    @test ret == 0

    # to optimize NLPs we need: XPRSoptimize
    solvestatus = Ref{Cint}(0)
    solstatus = Ref{Cint}(0)
    ret = Xpress.Lib.XPRSoptimize(model.inner, "", solvestatus, solstatus)
    @test ret == 0

    # to get solution values from NLP we need: XPRSgetnlpsol
    xx = Array{Float64}(undef, 2)
    slack = Array{Float64}(undef, 2)
    duals = Array{Float64}(undef, 2)
    djs = Array{Float64}(undef, 2)
    ret = Xpress.Lib.XPRSgetnlpsol(model.inner, xx, slack, duals, djs)
    @test ret == 0
    @test xx == [6, 10]
    @test slack == [0, 0]

    return nothing
end

function test_multiple_modifications2()
    model = Xpress.Optimizer(; OUTPUTLOG = 0)

    x = MOI.add_variable(model)

    c = MOI.add_constraint(model, x, MOI.GreaterThan(1.0))

    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        2.0 * x,
    )

    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)

    MOI.optimize!(model)

    @test MOI.get(model, MOI.VariablePrimal(), x) == 1.0

    @test MOI.get(model, MOI.ConstraintDual(), c) == 2.0
    @test MOI.get(model, Xpress.ReducedCost(), x) == 2.0

    return
end

function callback_simple_model()
    model = Xpress.Optimizer(;
        PRESOLVE = 0,
        CUTSTRATEGY = 0,
        HEUREMPHASIS = 0,
        HEURSTRATEGY = 0,
        SYMMETRY = 0,
        OUTPUTLOG = 0,
    )
    MOI.Utilities.loadfromstring!(
        model,
        """
    variables: x, y
    maxobjective: y
    c1: x in Integer()
    c2: y in Integer()
    c3: x in Interval(0.0, 2.5)
    c4: y in Interval(0.0, 2.5)
""",
    )
    x = MOI.get(model, MOI.VariableIndex, "x")
    y = MOI.get(model, MOI.VariableIndex, "y")
    return model, x, y
end

function callback_knapsack_model()
    model = Xpress.Optimizer(;
        OUTPUTLOG = 0,
        HEURSTRATEGY = 0, # before v41
        HEUREMPHASIS = 0,
        CUTSTRATEGY = 0,
        PRESOLVE = 0,
        MIPPRESOLVE = 0,
        PRESOLVEOPS = 0,
        MIPTHREADS = 1,
        THREADS = 1,
    )
    MOI.set(model, MOI.NumberOfThreads(), 2)
    N = 30
    x = MOI.add_variables(model, N)
    MOI.add_constraints(model, x, MOI.ZeroOne())
    MOI.set.(model, MOI.VariablePrimalStart(), x, 0.0)
    item_weights, item_values = abs.(cos.(1:N)), abs.(sin.(1:N))
    MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(item_weights, x), 0.0),
        MOI.LessThan(10.0),
    )
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(item_values, x), 0.0),
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    return model, x, item_weights
end

function test_lazy_constraint_callback_lazy_constraint()
    model, x, y = callback_simple_model()
    global lazy_called = false
    MOI.set(
        model,
        MOI.LazyConstraintCallback(),
        cb_data -> begin
            global lazy_called = true
            x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
            y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
            status = MOI.get(
                model,
                MOI.CallbackNodeStatus(cb_data),
            )::MOI.CallbackNodeStatusCode
            if round.(Int, [x_val, y_val]) ≈ [x_val, y_val]
                atol = 1e-6
                @test status == MOI.CALLBACK_NODE_STATUS_INTEGER
            else
                @test status == MOI.CALLBACK_NODE_STATUS_FRACTIONAL
            end
            @test MOI.supports(model, MOI.LazyConstraint(cb_data))
            if y_val - x_val > 1 + 1e-6
                MOI.submit(
                    model,
                    MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([-1.0, 1.0], [x, y]),
                        0.0,
                    ),
                    MOI.LessThan{Float64}(1.0),
                )
            elseif y_val + x_val > 3 + 1e-6
                MOI.submit(
                    model,
                    MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
                        0.0,
                    ),
                    MOI.LessThan{Float64}(3.0),
                )
            end
        end,
    )
    @test MOI.supports(model, MOI.LazyConstraintCallback())
    MOI.optimize!(model)
    @test lazy_called
    @test MOI.get(model, MOI.VariablePrimal(), x) == 1
    @test MOI.get(model, MOI.VariablePrimal(), y) == 2
    return
end

function test_lazy_constraint_callback_OptimizeInProgress()
    model, x, y = callback_simple_model()
    MOI.set(
        model,
        MOI.LazyConstraintCallback(),
        cb_data -> begin
            @test_throws(
                MOI.OptimizeInProgress(MOI.VariablePrimal()),
                MOI.get(model, MOI.VariablePrimal(), x)
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveValue()),
                MOI.get(model, MOI.ObjectiveValue())
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveBound()),
                MOI.get(model, MOI.ObjectiveBound())
            )
        end,
    )
    MOI.optimize!(model)
    return
end

function test_lazy_constraint_callback_HeuristicSolution()
    model, x, y = callback_simple_model()
    cb = nothing
    MOI.set(
        model,
        MOI.LazyConstraintCallback(),
        cb_data -> begin
            cb = cb_data
            MOI.submit(model, MOI.HeuristicSolution(cb_data), [x], [2.0])
        end,
    )
    @test_throws(
        MOI.InvalidCallbackUsage(
            MOI.LazyConstraintCallback(),
            MOI.HeuristicSolution(cb),
        ),
        MOI.optimize!(model)
    )
    return
end

function test_user_cut_callback_UserCut()
    model, x, item_weights = callback_knapsack_model()
    global user_cut_submitted = false
    MOI.set(
        model,
        MOI.UserCutCallback(),
        cb_data -> begin
            terms = MOI.ScalarAffineTerm{Float64}[]
            accumulated = 0.0
            for (i, xi) in enumerate(x)
                if MOI.get(model, MOI.CallbackVariablePrimal(cb_data), xi) > 0.0
                    push!(terms, MOI.ScalarAffineTerm(1.0, xi))
                    accumulated += item_weights[i]
                end
            end
            @test MOI.supports(model, MOI.UserCut(cb_data))
            if accumulated > 10.0
                MOI.submit(
                    model,
                    MOI.UserCut(cb_data),
                    MOI.ScalarAffineFunction{Float64}(terms, 0.0),
                    MOI.LessThan{Float64}(length(terms) - 1),
                )
                global user_cut_submitted = true
            end
        end,
    )
    @test MOI.supports(model, MOI.UserCutCallback())
    MOI.optimize!(model)
    @test user_cut_submitted
    return
end

function test_user_cut_callback_HeuristicSolution()
    model, x, item_weights = callback_knapsack_model()
    cb = nothing
    MOI.set(
        model,
        MOI.UserCutCallback(),
        cb_data -> begin
            cb = cb_data
            MOI.submit(model, MOI.HeuristicSolution(cb_data), [x[1]], [0.0])
        end,
    )
    @test_throws(
        MOI.InvalidCallbackUsage(
            MOI.UserCutCallback(),
            MOI.HeuristicSolution(cb),
        ),
        MOI.optimize!(model)
    )
    return
end

function test_heuristic_callback_HeuristicSolution()
    model, x, item_weights = callback_knapsack_model()
    global callback_called = false
    MOI.set(
        model,
        MOI.HeuristicCallback(),
        cb_data -> begin
            x_vals = MOI.get.(model, MOI.CallbackVariablePrimal(cb_data), x)
            status = MOI.get(
                model,
                MOI.CallbackNodeStatus(cb_data),
            )::MOI.CallbackNodeStatusCode
            if round.(Int, x_vals) ≈ x_vals
                atol = 1e-6
                @test status == MOI.CALLBACK_NODE_STATUS_INTEGER
            else
                @test status == MOI.CALLBACK_NODE_STATUS_FRACTIONAL
            end
            @test MOI.supports(model, MOI.HeuristicSolution(cb_data))
            @test MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                x,
                floor.(x_vals),
            ) == MOI.HEURISTIC_SOLUTION_UNKNOWN
            global callback_called = true
        end,
    )
    @test MOI.supports(model, MOI.HeuristicCallback())
    MOI.optimize!(model)
    @test callback_called
    return
end

function test_heuristic_callback_LazyConstraint()
    model, x, item_weights = callback_knapsack_model()
    cb = nothing
    MOI.set(
        model,
        MOI.HeuristicCallback(),
        cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(1.0, x), 0.0),
                MOI.LessThan(5.0),
            )
        end,
    )
    @test_throws(
        MOI.InvalidCallbackUsage(
            MOI.HeuristicCallback(),
            MOI.LazyConstraint(cb),
        ),
        MOI.optimize!(model)
    )
    return
end

function test_heuristic_callback_UserCut()
    model, x, item_weights = callback_knapsack_model()
    cb = nothing
    MOI.set(
        model,
        MOI.HeuristicCallback(),
        cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.UserCut(cb_data),
                MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(1.0, x), 0.0),
                MOI.LessThan(5.0),
            )
        end,
    )
    @test_throws(
        MOI.InvalidCallbackUsage(MOI.HeuristicCallback(), MOI.UserCut(cb)),
        MOI.optimize!(model)
    )
    return
end

function test_callback_function_OptimizeInProgress()
    model, x, y = callback_simple_model()
    MOI.set(
        model,
        Xpress.CallbackFunction(),
        (cb_data) -> begin
            @test_throws(
                MOI.OptimizeInProgress(MOI.VariablePrimal()),
                MOI.get(model, MOI.VariablePrimal(), x)
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveValue()),
                MOI.get(model, MOI.ObjectiveValue())
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveBound()),
                MOI.get(model, MOI.ObjectiveBound())
            )
        end,
    )
    @test MOI.supports(model, Xpress.CallbackFunction())
    MOI.optimize!(model)
    return
end

function test_callback_function_invalid()
    model, x, y = callback_simple_model()
    MOI.set(model, Xpress.CallbackFunction(), cb_data -> nothing)
    MOI.set(model, MOI.LazyConstraintCallback(), cb_data -> nothing)
    @test_throws(
        ErrorException(
            "Cannot use Xpress.CallbackFunction as well as " *
            "MOI.AbstractCallbackFunction",
        ),
        MOI.optimize!(model),
    )
    return
end

function test_callback_function_LazyConstraint()
    model, x, y = callback_simple_model()
    cb_calls = Int32[]
    global generic_lazy_called = false
    function callback_function(cb_data)
        push!(cb_calls, 1)
        Xpress.get_cb_solution(model, cb_data.model)
        x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
        y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
        if y_val - x_val > 1 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                MOI.ScalarAffineFunction{Float64}(
                    MOI.ScalarAffineTerm.([-1.0, 1.0], [x, y]),
                    0.0,
                ),
                MOI.LessThan{Float64}(1.0),
            )
        elseif y_val + x_val > 3 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                MOI.ScalarAffineFunction{Float64}(
                    MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
                    0.0,
                ),
                MOI.LessThan{Float64}(3.0),
            )
        end
    end
    MOI.set(model, Xpress.CallbackFunction(), callback_function)
    MOI.optimize!(model)
    @test MOI.get(model, MOI.VariablePrimal(), x) == 1
    @test MOI.get(model, MOI.VariablePrimal(), y) == 2
    @test length(cb_calls) > 0
    return
end

function test_callback_function_UserCut()
    model, x, item_weights = callback_knapsack_model()
    user_cut_submitted = false
    cb_calls = Int32[]
    MOI.set(
        model,
        Xpress.CallbackFunction(),
        (cb_data) -> begin
            push!(cb_calls)

            if Xpress.get_control_or_attribute(
                cb_data.model,
                "XPRS_CALLBACKCOUNT_OPTNODE",
            ) > 1
                return
            end
            Xpress.get_cb_solution(model, cb_data.model)
            terms = MOI.ScalarAffineTerm{Float64}[]
            accumulated = 0.0
            for (i, xi) in enumerate(x)
                if MOI.get(model, MOI.CallbackVariablePrimal(cb_data), xi) > 0.0
                    push!(terms, MOI.ScalarAffineTerm(1.0, xi))
                    accumulated += item_weights[i]
                end
            end
            if accumulated > 10.0
                MOI.submit(
                    model,
                    MOI.UserCut(cb_data),
                    MOI.ScalarAffineFunction{Float64}(terms, 0.0),
                    MOI.LessThan{Float64}(length(terms) - 1),
                )
                user_cut_submitted = true
            end
            return
        end,
    )
    MOI.optimize!(model)
    @test user_cut_submitted
    return
end

function test_callback_function_HeuristicSolution()
    model, x, item_weights = callback_knapsack_model()
    callback_called = false
    cb_calls = Int32[]
    MOI.set(
        model,
        Xpress.CallbackFunction(),
        (cb_data) -> begin
            if Xpress.get_control_or_attribute(
                cb_data.model,
                "XPRS_CALLBACKCOUNT_OPTNODE",
            ) > 1
                return
            end
            Xpress.get_cb_solution(model, cb_data.model)
            x_vals =
                MOI.get.(model, MOI.CallbackVariablePrimal(cb_data), x)
            @test MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                x,
                floor.(x_vals),
            ) == MOI.HEURISTIC_SOLUTION_UNKNOWN
            callback_called = true
            return
        end,
    )
    MOI.optimize!(model)
    @test callback_called
    return
end

function test_callback_CallbackNodeStatus()
    model, x, item_weights = callback_knapsack_model()
    global unknown_reached = false
    MOI.set(
        model,
        Xpress.CallbackFunction(),
        (cb_data) -> begin
            if MOI.get(model, MOI.CallbackNodeStatus(cb_data)) ==
               MOI.CALLBACK_NODE_STATUS_UNKNOWN
                global unknown_reached = true
            end
        end,
    )
    MOI.optimize!(model)
    @test unknown_reached
    return
end

function test_callback_lazy_constraint_dual_reductions()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variables(model, 3)
    MOI.add_constraint.(model, x, MOI.GreaterThan(0.0))
    MOI.add_constraint.(model, x[1:2], MOI.Integer())
    MOI.add_constraint(
        model,
        1.0 * x[1] + 1.0 * x[2] - 1.0 * x[3],
        MOI.EqualTo(0.0),
    )
    MOI.add_constraint(model, 1.0 * x[1] + 1.0 * x[2], MOI.LessThan(220.0))
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.0 * x[3]
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    function lazy_flow_constraints(cb_data)
        x_val = MOI.get.(model, MOI.CallbackVariablePrimal(cb_data), x)
        if x_val[1] + x_val[2] > 10
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                1.0 * x[1] + 1.0 * x[2],
                MOI.LessThan(10.0),
            )
        end
    end
    MOI.set(model, MOI.LazyConstraintCallback(), lazy_flow_constraints)
    MOI.optimize!(model)
    x_val = MOI.get(model, MOI.VariablePrimal(), x)
    @test x_val[1] + x_val[2] <= 10.0 + 1e-4
    @test x_val[1] + x_val[2] ≈ x_val[3]
    return
end

function test_callback_preintsol()
    model, x, y = callback_simple_model()
    data = [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]
    function foo(cb::Xpress.CallbackData)
        cb.data[1] = 98
        cols = Xpress.get_control_or_attribute(cb.model, "XPRS_COLS")
        rows = Xpress.get_control_or_attribute(cb.model, "XPRS_ROWS")
        Xpress.get_control_or_attribute(cb.model, "XPRS_BESTBOUND")
        ans_variable_primal = Vector{Float64}(undef, Int(cols))
        ans_linear_primal = Vector{Float64}(undef, Int(cols))
        Xpress.Lib.XPRSgetlpsol(
            cb.model,
            ans_variable_primal,
            ans_linear_primal,
            C_NULL,
            C_NULL,
        )
        return
    end
    func_ptr, data_ptr = Xpress.set_callback_preintsol!(model.inner, foo, data)
    @test data[1] == 1
    MOI.optimize!(model)
    @test data[1] == 98
    @test func_ptr isa Ptr{Cvoid}
    return
end

mutable struct DispatchModel
    optimizer::MOI.AbstractOptimizer
    g::Vector{MOI.VariableIndex}
    Df::MOI.VariableIndex
    c_limit_lower::Any
    c_limit_upper::Any
    c_demand::Any
end

function GenerateModel_VariableIndex()
    d = 45.0
    I = 3
    g_sup = [10.0, 20.0, 30.0]
    c_g = [1.0, 3.0, 5.0]
    c_Df = 10.0
    model = Xpress.Optimizer(; PRESOLVE = 0, logfile = "outputXpress_SV.log")
    g = MOI.add_variables(model, I)
    Df = MOI.add_variable(model)
    c_limit_inf = MOI.add_constraint.(model, g, MOI.GreaterThan(0.0))
    push!(c_limit_inf, MOI.add_constraint(model, Df, MOI.GreaterThan(0.0)))
    c_limit_sup = MOI.add_constraint.(model, g, MOI.LessThan.(g_sup))
    c_demand = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.(ones(I + 1), [g; Df]),
            0.0,
        ),
        MOI.EqualTo(d),
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    obj = sum(c_g .* g) + c_Df * Df
    MOI.set(model, MOI.ObjectiveFunction{typeof(obj)}(), obj)
    MOI.optimize!(model)
    return DispatchModel(model, g, Df, c_limit_inf, c_limit_sup, c_demand)
end

function GenerateModel_ScalarAffineFunction()
    d = 45.0
    I = 3
    g_sup = [10.0, 20.0, 30.0]
    c_g = [1.0, 3.0, 5.0]
    c_Df = 10.0
    model = Xpress.Optimizer(; PRESOLVE = 0, logfile = "outputXpress_SAF.log")
    g = MOI.add_variables(model, I)
    Df = MOI.add_variable(model)
    c_limit_inf = MOI.add_constraint.(model, 1.0 .* g, MOI.GreaterThan(0.0))
    push!(
        c_limit_inf,
        MOI.add_constraint(model, 1.0 * Df, MOI.GreaterThan(0.0)),
    )
    c_limit_sup = MOI.add_constraint.(model, 1.0 .* g, MOI.LessThan.(g_sup))
    c_demand = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(
            MOI.ScalarAffineTerm.(ones(I + 1), [g; Df]),
            0.0,
        ),
        MOI.EqualTo(d),
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    obj = sum(c_g .* g) + c_Df * Df
    MOI.set(model, MOI.ObjectiveFunction{typeof(obj)}(), obj)
    MOI.optimize!(model)
    return DispatchModel(model, g, Df, c_limit_inf, c_limit_sup, c_demand)
end

function Forward(model::DispatchModel, ϵ::Float64 = 1.0)
    @test MOI.is_set_by_optimize(Xpress.ForwardSensitivityOutputVariable())
    variables = [model.g; model.Df]
    primal = MOI.get.(model.optimizer, MOI.VariablePrimal(), variables)
    MOI.set(
        model.optimizer,
        Xpress.ForwardSensitivityInputConstraint(),
        model.c_demand,
        ϵ,
    )
    dual =
        MOI.get.(
            model.optimizer,
            Xpress.ForwardSensitivityOutputVariable(),
            variables,
        )
    return vcat(primal, dual)
end

function Backward(model::DispatchModel, ϵ::Float64 = 1.0)
    @test MOI.is_set_by_optimize(Xpress.BackwardSensitivityOutputConstraint())
    variables = [model.g; model.Df]
    primal = MOI.get.(model.optimizer, MOI.VariablePrimal(), variables)
    dual = zeros(length(variables))
    for (i, xi) in enumerate(variables)
        MOI.set(
            model.optimizer,
            Xpress.BackwardSensitivityInputVariable(),
            xi,
            ϵ,
        )
        dual[i] = MOI.get(
            model.optimizer,
            Xpress.BackwardSensitivityOutputConstraint(),
            model.c_demand,
        )
        MOI.set(
            model.optimizer,
            Xpress.BackwardSensitivityInputVariable(),
            xi,
            0.0,
        )
    end
    return vcat(primal, dual)
end

function test_variable_index_forward()
    model = GenerateModel_VariableIndex()
    @test Forward(model) == [10.0, 20.0, 15.0, 0.0, 0.0, 0.0, 1.0, 0.0]
    return
end

function test_BackwardSensitivityOutputConstraint_error()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.add_constraint(model, x, MOI.ZeroOne())
    c = MOI.add_constraint(model, 0.5 * x, MOI.EqualTo(0.0))
    attr = Xpress.BackwardSensitivityOutputConstraint()
    err = ErrorException("Model not optimized. Cannot get sensitivities.")
    @test_logs (:warn,) @test_throws(err, MOI.get(model, attr, c))
    MOI.optimize!(model)
    err =
        ErrorException("Backward sensitivity cache not initiliazed correctly.")
    @test_logs (:warn,) @test_throws(err, MOI.get(model, attr, c))
    return
end

function test_ForwardSensitivityOutputVariable_error()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.add_constraint(model, x, MOI.ZeroOne())
    attr = Xpress.ForwardSensitivityOutputVariable()
    err = ErrorException("Model not optimized. Cannot get sensitivities.")
    @test_logs (:warn,) @test_throws(err, MOI.get(model, attr, x))
    MOI.optimize!(model)
    err = ErrorException("Forward sensitivity cache not initiliazed correctly.")
    @test_logs (:warn,) @test_throws(err, MOI.get(model, attr, x))
    return
end

function test_variable_index_backward()
    model = GenerateModel_VariableIndex()
    @test Backward(model) == [10.0, 20.0, 15.0, 0.0, 0.0, 0.0, 1.0, 0.0]
    return
end

function test_scalar_affine_index_forward()
    model = GenerateModel_ScalarAffineFunction()
    @test Forward(model) == [10.0, 20.0, 15.0, 0.0, 0.0, 0.0, 1.0, 0.0]
    return
end

function test_scalar_affine_index_backward()
    model = GenerateModel_ScalarAffineFunction()
    @test Backward(model) == [10.0, 20.0, 15.0, 0.0, 0.0, 0.0, 1.0, 0.0]
    return
end

function test_supports_raw_optimizer_attribute()
    model = Xpress.Optimizer()
    @test MOI.supports(model, MOI.RawOptimizerAttribute("PRESOLVE"))
    @test MOI.supports(model, MOI.RawOptimizerAttribute("XPRS_PRESOLVE"))
    @test !MOI.supports(model, MOI.RawOptimizerAttribute("PSLV"))
    return
end

function test_unsupported_raw_optimizer_attribute()
    model = Xpress.Optimizer()
    attr = MOI.RawOptimizerAttribute("PSLV")
    err = MOI.UnsupportedAttribute{typeof(attr)}
    @test_throws err MOI.get(model, attr)
    @test_throws err MOI.set(model, attr, false)
    return
end

function test_special_moi_attributes()
    model = Xpress.Optimizer()
    for name in (
        "logfile",
        "MOI_POST_SOLVE",
        "MOI_IGNORE_START",
        "MOI_WARNINGS",
        "MOI_SOLVE_MODE",
        "XPRESS_WARNING_WINDOWS",
    )
        attr = MOI.RawOptimizerAttribute(name)
        @test MOI.supports(model, attr)
        value = MOI.get(model, attr)
        MOI.set(model, attr, value)
        @test MOI.get(model, attr) == value
    end
    return
end

function test_callback_function_nothing()
    model, x, y = callback_simple_model()
    function callback_function(cb_data)
        Xpress.get_cb_solution(model, cb_data.model)
        x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
        y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
        if y_val - x_val > 1 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                1.0 * y - 1.0 * x,
                MOI.LessThan{Float64}(1.0),
            )
        elseif y_val + x_val > 3 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                1.0 * x + 1.0 * y,
                MOI.LessThan{Float64}(3.0),
            )
        end
    end
    MOI.set(model, Xpress.CallbackFunction(), callback_function)
    MOI.optimize!(model)
    @test MOI.get(model, MOI.VariablePrimal(), x) ≈ 1
    @test MOI.get(model, MOI.VariablePrimal(), y) ≈ 2
    # Now drop the callback and re-solve
    MOI.set(model, Xpress.CallbackFunction(), nothing)
    MOI.optimize!(model)
    x_val = MOI.get(model, MOI.VariablePrimal(), x)
    y_val = MOI.get(model, MOI.VariablePrimal(), y)
    # It should violate the solution
    @test y_val - x_val > 1 || y_val + x_val > 3
    return
end

function test_callback_function_replace()
    model, x, y = callback_simple_model()
    function callback_function(cb_data)
        Xpress.get_cb_solution(model, cb_data.model)
        x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
        y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
        if y_val - x_val > 1 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                1.0 * y - 1.0 * x,
                MOI.LessThan{Float64}(1.0),
            )
        elseif y_val + x_val > 3 + 1e-6
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                1.0 * x + 1.0 * y,
                MOI.LessThan{Float64}(3.0),
            )
        end
    end
    MOI.set(model, Xpress.CallbackFunction(), callback_function)
    MOI.optimize!(model)
    @test MOI.get(model, MOI.VariablePrimal(), x) ≈ 1
    @test MOI.get(model, MOI.VariablePrimal(), y) ≈ 2
    # Now drop the callback and re-solve
    MOI.set(model, Xpress.CallbackFunction(), cb_data -> nothing)
    MOI.optimize!(model)
    x_val = MOI.get(model, MOI.VariablePrimal(), x)
    y_val = MOI.get(model, MOI.VariablePrimal(), y)
    # It should violate the solution
    @test y_val - x_val > 1 || y_val + x_val > 3
    return
end

function test_add_constraints_scalar_function_constant_not_zero()
    model = Xpress.Optimizer()
    x = MOI.add_variables(model, 2)
    f, s = 1.0 .* x .+ 2.0, MOI.EqualTo.([0.0, 0.0])
    @test_throws(
        MOI.ScalarFunctionConstantNotZero{Float64,eltype(f),eltype(s)},
        MOI.add_constraints(model, f, s),
    )
    return
end

function test_quadratic_scalar_function_constant_not_zero()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    f, s = 1.0 * x * x + 2.0, MOI.EqualTo(0.0)
    @test_throws(
        MOI.ScalarFunctionConstantNotZero{Float64,typeof(f),typeof(s)},
        MOI.add_constraint(model, f, s),
    )
    return
end

function test_is_valid_variable()
    model = Xpress.Optimizer()
    for set in (
        MOI.ZeroOne(),
        MOI.Integer(),
        MOI.LessThan(0.0),
        MOI.EqualTo(0.0),
        MOI.GreaterThan(0.0),
    )
        x = MOI.add_variable(model)
        c = MOI.add_constraint(model, x, set)
        @test MOI.is_valid(model, c)
        d = typeof(c)(-1)
        @test !MOI.is_valid(model, d)
        @test_throws MOI.InvalidIndex Xpress._info(model, d)
    end
    return
end

function test_SettingVariableIndexNotAllowed()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, x, MOI.Integer())
    y = MOI.add_variable(model)
    @test_throws(
        MOI.SettingVariableIndexNotAllowed(),
        MOI.set(model, MOI.ConstraintFunction(), c, y),
    )
    return
end

function test_VariableIndex_Integer()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, x, MOI.Integer())
    @test MOI.is_valid(model, c)
    @test MOI.get(model, MOI.ConstraintSet(), c) == MOI.Integer()
    MOI.delete(model, c)
    @test !MOI.is_valid(model, c)
    @test_throws MOI.InvalidIndex MOI.get(model, MOI.ConstraintSet(), c)
    return
end

function test_add_constraints_invalid()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    @test_throws(
        ErrorException("Number of functions does not equal number of sets."),
        MOI.add_constraints(model, [1.0 * x], MOI.EqualTo{Float64}[]),
    )
    return
end

function test_solution_attributes()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, x, MOI.Integer())
    @test MOI.get(model, MOI.ResultCount()) == 0
    MOI.optimize!(model)
    @test MOI.get(model, MOI.BarrierIterations()) == 0
    @test MOI.get(model, MOI.SimplexIterations()) == 0
    @test MOI.get(model, MOI.NodeCount()) == 0
    @test isnan(MOI.get(model, MOI.RelativeGap()))
    return
end

function test_RawSolver()
    model = Xpress.Optimizer()
    @test MOI.get(model, MOI.RawSolver()) == model.inner
    return
end

function test_ReducedCost()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.add_constraint(model, x, MOI.GreaterThan(2.0))
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    f = 2.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    MOI.optimize!(model)
    @test MOI.is_set_by_optimize(Xpress.ReducedCost())
    @test MOI.attribute_value_type(Xpress.ReducedCost()) == Float64
    @test MOI.get(model, Xpress.ReducedCost(), x) == 2.0
    @test_throws(
        MOI.ResultIndexBoundsError,
        MOI.get(model, Xpress.ReducedCost(2), x),
    )
    return
end

function test_write_to_file()
    model = Xpress.Optimizer()
    MOI.write_to_file(model, "model.mps")
    @test occursin("ENDATA", read("model.mps", String))
    rm("model.mps")
    MOI.write_to_file(model, "model.lp")
    @test occursin("Subject To", read("model.lp", String))
    rm("model.lp")
    return
end

function test_modify_different_sparsity()
    model = Xpress.Optimizer()
    x = MOI.add_variables(model, 2)
    c = MOI.add_constraint(model, 1.0 * x[1], MOI.EqualTo(0.0))
    @test ≈(MOI.get(model, MOI.ConstraintFunction(), c), 1.0 * x[1])
    MOI.set(model, MOI.ConstraintFunction(), c, 1.0 * x[2])
    @test ≈(MOI.get(model, MOI.ConstraintFunction(), c), 1.0 * x[2])
    MOI.set(model, MOI.ConstraintFunction(), c, 2.0 * x[2])
    @test ≈(MOI.get(model, MOI.ConstraintFunction(), c), 2.0 * x[2])
    return
end

function test_ListOfConstraintIndices()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, 1.0 * x, MOI.LessThan(0.0))
    F, S = MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64}
    G = MOI.ScalarQuadraticFunction{Float64}
    @test MOI.get(model, MOI.ListOfConstraintIndices{F,S}()) == [c]
    @test isempty(MOI.get(model, MOI.ListOfConstraintIndices{G,S}()))
    return
end

function test_ListOfConstraintTypesPresent()
    model = Xpress.Optimizer()
    sets = (
        MOI.LessThan(0.0),
        MOI.GreaterThan(0.0),
        MOI.EqualTo(0.0),
        MOI.Interval(0.0, 1.0),
        MOI.Integer(),
        MOI.ZeroOne(),
        MOI.Semicontinuous(2.0, 3.0),
        MOI.Semiinteger(2.0, 5.0),
    )
    for (i, set) in enumerate(sets)
        _ = MOI.add_constrained_variable(model, set)
        ret = MOI.get(model, MOI.ListOfConstraintTypesPresent())
        @test (MOI.VariableIndex, typeof(set)) in ret
        @test length(ret) == i
    end
    return
end

function test_ListOfConstraintTypesPresent_vector()
    model = Xpress.Optimizer()
    sets = (
        MOI.SecondOrderCone(3),
        MOI.RotatedSecondOrderCone(3),
        MOI.SOS1([1.0, 2.0, 3.0]),
        MOI.SOS2([1.0, 2.0, 3.0]),
    )
    for (i, set) in enumerate(sets)
        _ = MOI.add_constrained_variables(model, set)
        ret = MOI.get(model, MOI.ListOfConstraintTypesPresent())
        @test (MOI.VectorOfVariables, typeof(set)) in ret
        @test length(ret) == i
    end
    return
end

function test_ListOfConstraintTypesPresent_ScalarQuadraticFunction()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    set = MOI.LessThan(1.0)
    MOI.add_constraint(model, 1.0 * x * x, set)
    ret = MOI.get(model, MOI.ListOfConstraintTypesPresent())
    @test (MOI.ScalarQuadraticFunction{Float64}, typeof(set)) in ret
    return
end

function test_ListOfConstraintTypesPresent_Indicator()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    z, _ = MOI.add_constrained_variable(model, MOI.ZeroOne())
    f = MOI.Utilities.operate(vcat, Float64, 1.0 * x, z)
    set = MOI.Indicator{MOI.ACTIVATE_ON_ONE}(MOI.EqualTo(0.0))
    MOI.add_constraint(model, f, set)
    ret = MOI.get(model, MOI.ListOfConstraintTypesPresent())
    @test (MOI.VectorAffineFunction{Float64}, typeof(set)) in ret
    return
end

function test_indicator_invalid()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    z, _ = MOI.add_constrained_variable(model, MOI.ZeroOne())
    f = MOI.Utilities.operate(vcat, Float64, 1.0 * z + x, z)
    s = MOI.Indicator{MOI.ACTIVATE_ON_ONE}(MOI.EqualTo(0.0))
    @test_throws(
        ErrorException(
            "There should be exactly one term in output_index 1, found 2",
        ),
        MOI.add_constraint(model, f, s),
    )
    return
end

function test_name_to_constraint()
    model = Xpress.Optimizer()
    MOI.Utilities.loadfromstring!(
        model,
        """
        variables: t, u, x, y, z, a, b, c
        z in ZeroOne()
        c0: [x, y] in SOS2([1.0, 2.0])
        c1: [x, y] in SOS1([1.0, 2.0])
        [x, y] in SOS1([1.0, 2.0])
        c2: 1.0 * t >= 0.0
        c3: 1.0 * x * x <= 3.0
        c4: [t, u, x, y] in RotatedSecondOrderCone(4)
        c5: [a, b, c] in SecondOrderCone(3)
        c6: [z, 1.0 * x] in Indicator{ACTIVATE_ON_ONE}(EqualTo(0.0))
        d: 1.0 * u >= 0.0
        d: 2.0 * u >= 0.0
        d2: 1.0 * u >= 0.0
        d2: [x, y] in SOS1([1.0, 2.0])
        """,
    )
    @test MOI.get(model, MOI.ConstraintIndex, "foo") === nothing
    @test_throws ErrorException MOI.get(model, MOI.ConstraintIndex, "d")
    @test_throws ErrorException MOI.get(model, MOI.ConstraintIndex, "d2")
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c0"),
        MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.SOS2{Float64}},
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c1"),
        MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.SOS1{Float64}},
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c2"),
        MOI.ConstraintIndex{
            MOI.ScalarAffineFunction{Float64},
            MOI.GreaterThan{Float64},
        },
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c3"),
        MOI.ConstraintIndex{
            MOI.ScalarQuadraticFunction{Float64},
            MOI.LessThan{Float64},
        },
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c4"),
        MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.RotatedSecondOrderCone},
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c5"),
        MOI.ConstraintIndex{MOI.VectorOfVariables,MOI.SecondOrderCone},
    )
    @test isa(
        MOI.get(model, MOI.ConstraintIndex, "c6"),
        MOI.ConstraintIndex{
            MOI.VectorAffineFunction{Float64},
            MOI.Indicator{MOI.ACTIVATE_ON_ONE,MOI.EqualTo{Float64}},
        },
    )
    return
end

function test_show()
    model = Xpress.Optimizer()
    @test sprint(show, model) == sprint(show, model.inner)
    return
end

function test_empty_constraint_attributes()
    model = Xpress.Optimizer()
    x, c = MOI.add_constrained_variable(model, MOI.GreaterThan(0.0))
    F, S = MOI.VariableIndex, MOI.GreaterThan{Float64}
    ret = MOI.get(model, MOI.ListOfConstraintAttributesSet{F,S}())
    @test ret == MOI.AbstractConstraintAttribute[]
    return
end

function test_copy_to()
    src = MOI.Utilities.Model{Float64}()
    MOI.Utilities.loadfromstring!(
        src,
        """
        variables: x, y
        minobjective: 2.0 * x + y + 3.0
        c1: x >= 0.0
        c2: [x, y] in SOS1([1.0, 2.0])
        """,
    )
    model = Xpress.Optimizer()
    index_map = MOI.copy_to(model, src)
    ret = MOI.get(model, MOI.ListOfConstraintTypesPresent())
    @test (MOI.VectorOfVariables, MOI.SOS1{Float64}) in ret
    @test (MOI.VariableIndex, MOI.GreaterThan{Float64}) in ret
    @test MOI.get(model, MOI.NumberOfVariables()) == 2
    @test MOI.get(model, MOI.ObjectiveSense()) == MOI.MIN_SENSE
    return
end

function test_existing_lower()
    for set in (MOI.Semiinteger(3.0, 5.0), MOI.Semicontinuous(3.0, 5.0))
        model = Xpress.Optimizer()
        x = MOI.add_variable(model)
        MOI.add_constraint(model, x, set)
        @test_throws(
            MOI.LowerBoundAlreadySet{typeof(set),MOI.GreaterThan{Float64}},
            MOI.add_constraint(model, x, MOI.GreaterThan(0.0)),
        )
        @test_throws(
            MOI.UpperBoundAlreadySet{typeof(set),MOI.LessThan{Float64}},
            MOI.add_constraint(model, x, MOI.LessThan(0.0)),
        )
    end
    return
end

function test_delete_less_than_zeroone()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c_l = MOI.add_constraint(model, x, MOI.GreaterThan(0.0))
    c_u = MOI.add_constraint(model, x, MOI.LessThan(1.0))
    c_b = MOI.add_constraint(model, x, MOI.ZeroOne())
    MOI.delete(model, c_u)
    @test MOI.is_valid(model, c_l)
    @test !MOI.is_valid(model, c_u)
    @test MOI.is_valid(model, c_b)
    return
end

function test_delete_greater_than_zeroone()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c_l = MOI.add_constraint(model, x, MOI.GreaterThan(0.0))
    c_u = MOI.add_constraint(model, x, MOI.LessThan(1.0))
    c_b = MOI.add_constraint(model, x, MOI.ZeroOne())
    MOI.delete(model, c_l)
    @test !MOI.is_valid(model, c_l)
    @test MOI.is_valid(model, c_u)
    @test MOI.is_valid(model, c_b)
    return
end

function test_delete_interval_zeroone()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    c_i = MOI.add_constraint(model, x, MOI.Interval(0.0, 1.0))
    c_b = MOI.add_constraint(model, x, MOI.ZeroOne())
    MOI.delete(model, c_i)
    @test !MOI.is_valid(model, c_i)
    @test MOI.is_valid(model, c_b)
    return
end

function test_error_binary_bad_bounds()
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    MOI.add_constraint(model, x, MOI.Interval(0.2, 0.9))
    @test_throws(
        ErrorException("The problem is infeasible"),
        MOI.add_constraint(model, x, MOI.ZeroOne()),
    )
    return
end

function test_set_fixed_bound_of_soc()
    model = Xpress.Optimizer()
    x, _ = MOI.add_constrained_variables(model, MOI.SecondOrderCone(3))
    c = MOI.add_constraint(model, x[1], MOI.EqualTo(1.0))
    for set in (MOI.EqualTo(2.0), MOI.EqualTo(-1.0), MOI.EqualTo(-2.0))
        MOI.set(model, MOI.ConstraintSet(), c, set)
        @test MOI.get(model, MOI.ConstraintSet(), c) == set
    end
    return
end

function test_set_lower_bound_of_soc()
    model = Xpress.Optimizer()
    x, _ = MOI.add_constrained_variables(model, MOI.SecondOrderCone(3))
    c = MOI.add_constraint(model, x[1], MOI.GreaterThan(1.0))
    for value in (2.0, -1.0, -2.0, 2.0)
        set = MOI.GreaterThan(value)
        MOI.set(model, MOI.ConstraintSet(), c, set)
        @test MOI.get(model, MOI.ConstraintSet(), c) == set
    end
    return
end

function test_soc_dimension_mismatch()
    model = Xpress.Optimizer()
    f = MOI.VectorOfVariables(MOI.add_variables(model, 2))
    for s in (MOI.SecondOrderCone(3), MOI.RotatedSecondOrderCone(4))
        @test_throws(
            ErrorException(
                "Dimension of $(s) does not match number of terms in $(f)",
            ),
            MOI.add_constraint(model, f, s),
        )
    end
    return
end

function test_soc_already_exists()
    model = Xpress.Optimizer()
    x, _ = MOI.add_constrained_variables(model, MOI.SecondOrderCone(3))
    y = MOI.add_variables(model, 2)
    f = MOI.VectorOfVariables([x[1]; y])
    @test_throws(
        ErrorException(
            "Variable $(x[1]) already belongs a to SOC or RSOC constraint",
        ),
        MOI.add_constraint(model, f, MOI.SecondOrderCone(3)),
    )
    @test_throws(
        ErrorException(
            "Variable $(x[1]) already belongs a to SOC or RSOC constraint",
        ),
        MOI.add_constraint(model, f, MOI.RotatedSecondOrderCone(3)),
    )
    return
end

function test_min_variable_constraint_dual()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x, c = MOI.add_constrained_variable(model, MOI.LessThan(1.0))
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    f = -2.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    MOI.optimize!(model)
    @test ≈(MOI.get(model, MOI.ConstraintDual(), c), -2.0)
    return
end

function test_unbounded_primal_certificate()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    f = 2.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    MOI.optimize!(model)
    @test MOI.get(model, MOI.ResultCount()) == 1
    @test MOI.get(model, MOI.PrimalStatus()) == MOI.INFEASIBILITY_CERTIFICATE
    @test MOI.get(model, MOI.DualStatus()) == MOI.NO_SOLUTION
    @test MOI.get(model, MOI.VariablePrimal(), x) ≈ -1.0
    return
end

function test_constraint_basis_status()
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    c = MOI.add_constraint(model, 2.0 * x, MOI.EqualTo(1.0))
    MOI.optimize!(model)
    @test MOI.get(model, MOI.ConstraintBasisStatus(), c) == MOI.NONBASIC
    return
end

function test_conflict_col_type_char()
    for set in (
        MOI.LessThan(-1.0),
        MOI.EqualTo(1.0),
        MOI.GreaterThan(1.0),
        MOI.Interval(1.0, 2.0),
        MOI.Semicontinuous(3.0, 5.0),
        MOI.Semiinteger(3.0, 5.0),
        MOI.Integer(),
    )
        model = Xpress.Optimizer()
        MOI.set(model, MOI.Silent(), true)
        x = MOI.add_variable(model)
        a = MOI.add_constraint(model, 1.0 * x, MOI.EqualTo(-0.5))
        b = MOI.add_constraint(model, x, set)
        _, c = MOI.add_constrained_variable(model, set)
        MOI.optimize!(model)
        MOI.compute_conflict!(model)
        attr = MOI.ConstraintConflictStatus()
        @test MOI.get(model, attr, a) == MOI.IN_CONFLICT
        @test MOI.get(model, attr, b) == MOI.IN_CONFLICT
        @test MOI.get(model, attr, c) == MOI.NOT_IN_CONFLICT
    end
    return
end

function test_conflict_zeroone()
    for (value, ret) in (-0.5 => MOI.MAYBE_IN_CONFLICT, 0.5 => MOI.IN_CONFLICT)
        model = Xpress.Optimizer()
        MOI.set(model, MOI.Silent(), true)
        x = MOI.add_variable(model)
        a = MOI.add_constraint(model, 1.0 * x, MOI.EqualTo(value))
        b = MOI.add_constraint(model, x, MOI.ZeroOne())
        _, c = MOI.add_constrained_variable(model, MOI.ZeroOne())
        MOI.optimize!(model)
        MOI.compute_conflict!(model)
        attr = MOI.ConstraintConflictStatus()
        @test MOI.get(model, attr, a) == MOI.IN_CONFLICT
        @test MOI.get(model, attr, b) == ret
        @test MOI.get(model, attr, c) == MOI.NOT_IN_CONFLICT
    end
    return
end

function test_conflict_infeasible_bounds()
    model = Xpress.Optimizer()
    x = MOI.add_variables(model, 2)
    c0 = MOI.add_constraint(model, x[1], MOI.GreaterThan(2.0))
    c1 = MOI.add_constraint(model, x[2], MOI.GreaterThan(2.0))
    c2 = MOI.add_constraint(model, x[2], MOI.LessThan(1.0))
    MOI.compute_conflict!(model)
    @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
    attr = MOI.ConstraintConflictStatus()
    @test MOI.get(model, attr, c0) == MOI.NOT_IN_CONFLICT
    @test MOI.get(model, attr, c1) == MOI.IN_CONFLICT
    @test MOI.get(model, attr, c2) == MOI.IN_CONFLICT
    return
end

function test_nlp_constraint_log()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    t = MOI.add_variable(model)
    MOI.add_constraint(model, x, MOI.LessThan(2.0))
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.0 * t
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    g = MOI.ScalarNonlinearFunction(
        :-,
        Any[MOI.ScalarNonlinearFunction(:log, Any[x]), t],
    )
    c = MOI.add_constraint(model, g, MOI.GreaterThan(0.0))
    MOI.optimize!(model)
    F, S = MOI.ScalarNonlinearFunction, MOI.GreaterThan{Float64}
    @test MOI.supports_constraint(model, F, S)
    @test (F, S) in MOI.get(model, MOI.ListOfConstraintTypesPresent())
    @test c in MOI.get(model, MOI.ListOfConstraintIndices{F,S}())
    x_val = MOI.get(model, MOI.VariablePrimal(), x)
    t_val = MOI.get(model, MOI.VariablePrimal(), t)
    @test MOI.get(model, MOI.RawStatusString()) ==
          "1 Solution found ( XSLP_NLPSTATUS_SOLUTION) - no interruption - the solve completed normally"
    @test ≈(x_val, 2.0; atol = 1e-6)
    @test ≈(t_val, log(x_val); atol = 1e-6)
    @test ≈(MOI.get(model, MOI.ObjectiveValue()), t_val; atol = 1e-6)
    return
end

function test_nlp_constraint_unsupported_nonlinear_operator()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    x = MOI.add_variable(model)
    f = MOI.ScalarNonlinearFunction(:foo, Any[x])
    @test_throws(
        MOI.UnsupportedNonlinearOperator(:foo),
        MOI.add_constraint(model, f, MOI.GreaterThan(0.0)),
    )
    return
end

function test_nlp_constraint_unary_negation()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    g = MOI.ScalarNonlinearFunction(:-, Any[x])
    MOI.add_constraint(model, g, MOI.GreaterThan(-2.0))
    MOI.optimize!(model)
    @test ≈(MOI.get(model, MOI.VariablePrimal(), x), 2.0; atol = 1e-3)
    @test ≈(MOI.get(model, MOI.ObjectiveValue()), 2.0; atol = 1e-3)
    return
end

function test_nlp_constraint_scalar_affine_function()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.2 * x + 1.3
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    g = MOI.ScalarNonlinearFunction(:-, Any[1.5 * x + 2.0])
    MOI.add_constraint(model, g, MOI.GreaterThan(-6.0))
    MOI.optimize!(model)
    @test ≈(MOI.get(model, MOI.VariablePrimal(), x), 2 + 2 / 3; atol = 1e-3)
    @test ≈(MOI.get(model, MOI.ObjectiveValue()), 4.5; atol = 1e-3)
    return
end

function test_nlp_constraint_product()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    g = MOI.ScalarNonlinearFunction(:*, Any[x, 2.0, x])
    MOI.add_constraint(model, g, MOI.LessThan(3.0))
    MOI.optimize!(model)
    @test ≈(MOI.get(model, MOI.VariablePrimal(), x), sqrt(3 / 2); atol = 1e-3)
    @test ≈(MOI.get(model, MOI.ObjectiveValue()), sqrt(3 / 2); atol = 1e-3)
    return
end

function test_nlp_get_constraint_by_name()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    g = MOI.ScalarNonlinearFunction(:*, Any[x, 2.0, x])
    c = MOI.add_constraint(model, g, MOI.LessThan(3.0))
    MOI.set(model, MOI.ConstraintName(), c, "c")
    d = MOI.get(model, MOI.ConstraintIndex, "c")
    @test d == c
    return
end

function test_nlp_constraint_delete()
    if !Xpress._supports_nonlinear()
        return
    end
    model = Xpress.Optimizer()
    MOI.set(model, MOI.Silent(), true)
    x = MOI.add_variable(model)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    f = 1.0 * x
    MOI.set(model, MOI.ObjectiveFunction{typeof(f)}(), f)
    g_bad = MOI.ScalarNonlinearFunction(:exp, Any[x])
    c_bad = MOI.add_constraint(model, g_bad, MOI.GreaterThan(20.0))
    g = MOI.ScalarNonlinearFunction(:*, Any[x, 2.0, x])
    MOI.add_constraint(model, g, MOI.LessThan(3.0))
    @test MOI.is_valid(model, c_bad)
    MOI.delete(model, c_bad)
    @test !MOI.is_valid(model, c_bad)
    MOI.optimize!(model)
    @test ≈(MOI.get(model, MOI.VariablePrimal(), x), sqrt(3 / 2); atol = 1e-3)
    @test ≈(MOI.get(model, MOI.ObjectiveValue()), sqrt(3 / 2); atol = 1e-3)
    return
end

end  # TestMOIWrapper

TestMOIWrapper.runtests()

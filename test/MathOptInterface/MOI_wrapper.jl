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

function test_Basic_Parameters()
    optimizer = Xpress.Optimizer(OUTPUTLOG = 0)
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("logfile")) == ""
    optimizer = Xpress.Optimizer(OUTPUTLOG = 0, logfile = "output.log")
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("logfile")) == "output.log"
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 100) === nothing
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 3600.0) === nothing

    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP")) == 0.0001
    MOI.set(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP"), 0.123)
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MIPRELSTOP")) == 0.123

    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME")) == ""
    MOI.set(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME"), "qwerty")
    @test MOI.get(optimizer, MOI.RawOptimizerAttribute("MPSOBJNAME")) == "qwerty"

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

    optimizer = Xpress.Optimizer(OUTPUTLOG = 0)
    model = MOI.Bridges.full_bridge_optimizer(optimizer, Float64)
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(atol = 1e-3, rtol = 1e-3),
        exclude = String[
            # tested with PRESOLVE=0 below
            "_SecondOrderCone_",
            "test_constraint_PrimalStart_DualStart_SecondOrderCone",
            "_RotatedSecondOrderCone_",
            "_GeometricMeanCone_",
            # Xpress cannot handle nonconvex quadratic constraint
            "test_quadratic_nonconvex_",
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

function test_Binaryfixing()
    @testset "Binary Equal to 1" begin
        T = Float64
        config = MOI.Test.Config(atol = 1e-3, rtol = 1e-3)
        model = Xpress.Optimizer(OUTPUTLOG = 0)
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
        config = MOI.Test.Config(atol = 1e-3, rtol = 1e-3)
        model = Xpress.Optimizer(OUTPUTLOG = 0)
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
        model = Xpress.Optimizer(OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
        x, c1 = MOI.add_constrained_variable(model, MOI.ZeroOne())
        c2 = MOI.add_constraint(
            model,
            MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(one(T), [x]), zero(T)),
            MOI.EqualTo(T(0.5)),
        )
        MOI.optimize!(model)
        @test MOI.get(model, MOI.TerminationStatus()) == MOI.INFEASIBLE
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.CONFLICT_FOUND
        zeroone_conflict = MOI.get(model, MOI.ConstraintConflictStatus(), c1)
        @test zeroone_conflict == MOI.MAYBE_IN_CONFLICT ||
              zeroone_conflict == MOI.IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.IN_CONFLICT
    end
    for warning in [true, false]
        @testset "Variable bounds" begin
            model = Xpress.Optimizer(OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
            MOI.set(model, MOI.RawOptimizerAttribute("MOI_WARNINGS"), warning)
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

    @testset "Two conflicting constraints (GreaterThan, LessThan)" begin
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

    @testset "Two conflicting constraints (EqualTo)" begin
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

    @testset "Variables outside conflict" begin
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

    @testset "No conflict" begin
        model = Xpress.Optimizer(OUTPUTLOG = 0)
        x = MOI.add_variable(model)
        c1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(1.0))
        c2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.LessThan(2.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.COMPUTE_CONFLICT_NOT_CALLED
        @test_throws ErrorException MOI.get(model, MOI.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        MOI.compute_conflict!(model)
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.NO_CONFLICT_EXISTS
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.NOT_IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.NOT_IN_CONFLICT
    end
end

# Xpress can only obtain primal and dual rays without presolve. Check more on
# https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSgetprimalray.html
function test_Farkas_Dual_Min()
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

function test_Farkas_Dual_Min_Interval()
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

function test_Farkas_Dual_Min_Equalto()
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

function test_Farkas_Dual_Min_2()
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

function test_Farkas_Dual_Max()
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

function test_Farkas_Dual_Max_2()
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
        677, 460, 752, 852, 580, 116, 457, 121, 454, 870,
        443, 196, 411, 539, 348, 187, 771, 127, 338, 527,
        932, 961,  48, 135, 367, 998, 363, 153, 921, 578,
        311, 560, 293, 258, 474, 884, 162, 136, 479, 289,
        813, 139, 795, 825, 945, 750, 462, 659, 270,  34,
        758, 865, 238, 367, 444, 116,  69, 894, 584,  96,
         29, 199, 712, 703, 856, 692, 396, 409, 603, 632,
        479, 848, 822, 248, 424, 978, 738, 655, 210, 173,
        731, 100, 889, 195, 245, 329, 446,  47, 235,  25,
        254, 150, 520, 665, 391, 907, 123, 826, 959, 176
    ]
    profit = weight .- (5.0,)
    capacity = 10000.0
    model = Xpress.Optimizer(
        OUTPUTLOG    = 0,
        HEURSTRATEGY = 0,
        CUTSTRATEGY  = 0,
        PRESOLVE     = 0,
        MIPPRESOLVE  = 0,
        PRESOLVEOPS  = 0,
    )
    # The variables: x[1:100], Bin
    x, _ = MOI.add_constrained_variables(model, fill(MOI.ZeroOne(), 100))
    # The objective function: maximize sum(profit' * x)
    objf = MOI.ScalarAffineFunction(
        MOI.ScalarAffineTerm.(profit, x), 0.0
    )
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        objf,
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    # The capacity constraint: sum(weight' * x) <= capacity
    MOI.add_constraint(
        model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(
            weight, x), 0.0
        ),
        MOI.LessThan(capacity)
    )

    # FIRST RUN: get the optimal value. Check that the optimal
    # value was not discovered at the root node.
    MOI.optimize!(model)

    solution = MOI.get(model, MOI.VariablePrimal(), x)
    computed_obj_value = profit' * solution
    obtained_obj_value = MOI.get(model, MOI.ObjectiveValue()) :: Float64
    @test isapprox(
        obtained_obj_value, computed_obj_value; rtol = rtol, atol = atol
    )
    @test isapprox(9945.0, computed_obj_value; rtol = rtol, atol = atol)

    node_solution_was_found = MOI.get(model, MOI.RawOptimizerAttribute("MIPSOLNODE"))

    @test node_solution_was_found > 1

    # SECOND RUN: run without MIP-start and only searching the first node.
    # Should give a worse solution than the previous one.
    MOI.set(model, MOI.RawOptimizerAttribute("MAXNODE"), 1)

    MOI.optimize!(model)

    # One node may not be enough to even get any solution.
    if MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT
        solution2 = MOI.get(model, MOI.VariablePrimal(), x)
        computed_obj_value2 = profit' * solution2
        obtained_obj_value2 = MOI.get(model, MOI.ObjectiveValue()) :: Float64
        @test isapprox(
            obtained_obj_value2, computed_obj_value2; rtol = rtol, atol = atol
        )
        # There should be at least one unit of difference.
        @test obtained_obj_value1 > obtained_obj_value2 + 0.5
    end

    # THIRD RUN: run with MIP-start and searching only the root node.
    # Should find the optimal solution impossible to get in one node.
    MOI.set(model, MOI.VariablePrimalStart(), x, solution)

    # This postsolve is necessary because of an unrelated bug. Apparently,
    # if Xpress is stopped because MAXNODE and has no feasible solution,
    # then MOI.optimize! will not call postsolve over it, however calling
    # postsolve is necessary otherwise a new call to MOI.optimize will
    # trigger error 707 ("707 Error: Function cannot be called during the
    # global search, except in callbacks.").
    Xpress.postsolve(model.inner)

    MOI.optimize!(model)

    solution3 = MOI.get(model, MOI.VariablePrimal(), x)
    computed_obj_value3 = profit' * solution3
    obtained_obj_value3 = MOI.get(model, MOI.ObjectiveValue()) :: Float64
    @test isapprox(
        obtained_obj_value3, computed_obj_value3; rtol = rtol, atol = atol
    )
    @test isapprox(9945.0, computed_obj_value3; rtol = rtol, atol = atol)
end

function test_multiple_modifications()
    model = Xpress.Optimizer(OUTPUTLOG = 0)

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

end

TestMOIWrapper.runtests()

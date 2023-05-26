module TestMOIWrapper

using Xpress
using MathOptInterface
using JuMP
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
            "_nonlinear_hs071_NLPBlockDual",
            "_nonlinear_objective",
            "_nonlinear_objective_and_moi_objective_test",
            "_nonlinear_without_objective",
            "_nlp1",
            "_nlp2",
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
            "_GeometricMeanCone_",
            
        ]
    )
    return
end

function test_runtests_nlp()

    optimizer = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    model = MOI.Bridges.full_bridge_optimizer(optimizer, Float64)
    MOI.set(model, MOI.Silent(), true)
    MOI.Test.runtests(
        model,
        MOI.Test.Config(atol = 0.2, rtol = 0.2, optimal_status = MOI.LOCALLY_SOLVED),
        include = String[
            # tested with PRESOLVE=0 below
            "_nonlinear_hs071_NLPBlockDual",
            "_nonlinear_objective",
            "_nonlinear_objective_and_moi_objective_test",
            "_nonlinear_without_objective",
        ],
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
        HEUREMPHASIS = 0,
        CUTSTRATEGY  = 0,
        PRESOLVE     = 0,
        MIPPRESOLVE  = 0,
        PRESOLVEOPS  = 0,
        # USERSOLHEURISTIC = 1,
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

    # @show MOI.get(model, MOI.TerminationStatus())
    # @show MOI.get(model, MOI.PrimalStatus())
    # @show MOI.get(model, MOI.RawStatusString())

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

function infeasible_problem()
    c = [1.0, 1.0]

    optimizer = Xpress.Optimizer(OUTPUTLOG = 0);
    MOI.set(optimizer, MOI.RawOptimizerAttribute("MOI_POST_SOLVE"), false);

    x = MOI.add_variables(optimizer, 2);

    MOI.set(
        optimizer,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(c, x), 0.0),
    );

    MOI.set(optimizer, MOI.ObjectiveSense(), MOI.MIN_SENSE);

    c1 = MOI.add_constraint(
        optimizer,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], x), 0.0),
        MOI.GreaterThan(5.0),
    );

    c2 = MOI.add_constraint(
        optimizer,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], x), 0.0),
        MOI.LessThan(2.0),
    );

    c3 = MOI.add_constraint(
        optimizer,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([0.0, 1.0], x), 0.0),
        MOI.GreaterThan(10.0),
    );

    MOI.optimize!(optimizer);

    variables = x
    constraints = [c1, c2, c3]

    return variables, constraints, optimizer
end

function test_name_constraints()

    # create problem
    variables, constraints, optimizer = infeasible_problem();
    
    # name variables and constraints
    MOI.set(optimizer, MOI.VariableName(), variables, ["x1", "x2"]);
    MOI.set(optimizer, MOI.ConstraintName(), constraints[1], "constraint1");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[2], "constraint2");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[3], "constraint3");

    # name inner model
    Xpress._pass_names_to_solver(optimizer);

    # check names
    variable_names = Xpress._get_variable_names(optimizer)
    constraint_names = Xpress._get_constraint_names(optimizer)

    @test length(variable_names) == 2
    @test length(constraint_names) == 3

    @test variable_names[1] == "x1"
    @test variable_names[2] == "x2"
    @test constraint_names[1] == "constraint1"
    @test constraint_names[2] == "constraint2"
    @test constraint_names[3] == "constraint3"

    return nothing
end

function test_name_constraints_with_the_same_name()

    # create problem
    variables, constraints, optimizer = infeasible_problem();
    
    # name variables and constraints
    MOI.set(optimizer, MOI.VariableName(), variables, ["x1", "x2"]);
    MOI.set(optimizer, MOI.ConstraintName(), constraints[1], "same");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[2], "same");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[3], "constraint3");

    # name inner model
    Xpress._pass_names_to_solver(optimizer);

    # check names
    variable_names = Xpress._get_variable_names(optimizer)
    constraint_names = Xpress._get_constraint_names(optimizer)

    @test variable_names[1] == "x1"
    @test variable_names[2] == "x2"
    @test ((constraint_names[1] == "same" && constraint_names[2] == "R2") ||
        (constraint_names[2] == "same" && constraint_names[1] == "R1"))
    @test constraint_names[3] == "constraint3"

    return nothing
end

function test_name_variables_with_the_same_name()

    # create problem
    variables, constraints, optimizer = infeasible_problem();
    
    # name variables and constraints
    MOI.set(optimizer, MOI.VariableName(), variables, ["x1", "x1"]);
    MOI.set(optimizer, MOI.ConstraintName(), constraints[1], "constraint1");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[2], "constraint2");
    MOI.set(optimizer, MOI.ConstraintName(), constraints[3], "constraint3");

    # name inner model
    Xpress._pass_names_to_solver(optimizer);

    # check names
    variable_names = Xpress._get_variable_names(optimizer)
    constraint_names = Xpress._get_constraint_names(optimizer)

    @test variable_names[1] == "x1"
    @test variable_names[2] == "C2"
    @test constraint_names[1] == "constraint1"
    @test constraint_names[2] == "constraint2"
    @test constraint_names[3] == "constraint3"

    return nothing
end

function test_name_empty_names()

    # create problem
    variables, constraints, optimizer = infeasible_problem();

    # name inner model
    Xpress._pass_names_to_solver(optimizer);

    # check names
    variable_names = Xpress._get_variable_names(optimizer)
    constraint_names = Xpress._get_constraint_names(optimizer)

    @test variable_names[1] == "C1"
    @test variable_names[2] == "C2"
    @test constraint_names[1] == "R1"
    @test constraint_names[2] == "R2"
    @test constraint_names[3] == "R3"

    return nothing
end

function test_dummy_nlp()
    model = Xpress.Optimizer(OUTPUTLOG = 1);
    x = MOI.add_variables(model, 2);
    c = [1.0, 2.0]
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(c, x), 0.0),
    );

    MOI.set(model, MOI.VariableName(), x, ["x1", "x2"])
    Xpress._pass_variable_names_to_solver(model)

    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE);

    b1 = MOI.add_constraint.(
        model,
        x,
        MOI.GreaterThan(0.0),
    )
    b1 = MOI.add_constraint.(
        model,
        x,
        MOI.LessThan(10.0),
    )

    c1 = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 0.0], x), 0.0),
        MOI.EqualTo(0.0),
    );

    c3 = MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([0.0, 1.0], x), 0.0),
        MOI.GreaterThan(10.0),
    );

    MOI.optimize!(model);

    @show x_sol = MOI.get.(model, MOI.VariablePrimal(), x)
    @test x_sol == [0.0, 10.0]

    ret = Xpress.Lib.XPRSnlpchgformulastring(model.inner, Cint(0), "- 3.14")
    @test ret == 0
    # ret = Xpress.Lib.XPRSwriteprob(model.inner, "testmat.mat", "");
    # @test ret == 0



    solvestatus = Ref{Cint}(0)
    solstatus = Ref{Cint}(0)
    ret = Xpress.Lib.XPRSoptimize(model.inner, "", solvestatus, solstatus)
    @test ret == 0
    # @show solvestatus
    # @show solstatus

    xx = Array{Float64}(undef, 2)
    slack = Array{Float64}(undef, 2)
    duals = Array{Float64}(undef, 2)
    djs = Array{Float64}(undef, 2)
    ret = Xpress.Lib.XPRSgetnlpsol(model.inner, xx, slack, duals, djs)
    @test ret == 0
    @test xx == [3.14, 10] 
    @test slack == [0, 0]
    # @show duals
    # @show djs

    # note that we do not need to pass names to the solver
    # we can simply use the default name: C<one based index>
    # so that the first variable is C1
    # however we must be careful because the user might have passed the names
    # so, in a second step, we need to use them or empty them 
    ret = Xpress.Lib.XPRSnlpchgformulastring(model.inner, Cint(0), "- 0.5 * x1 - 3")
    @test ret == 0
    # ret = Xpress.Lib.XPRSwriteprob(model.inner, "testmat.mat", "");
    # @test ret == 0

    # to optimize NLPs we need: XPRSoptimize 
    solvestatus = Ref{Cint}(0)
    solstatus = Ref{Cint}(0)
    ret = Xpress.Lib.XPRSoptimize(model.inner, "", solvestatus, solstatus)
    @test ret == 0
    # @show solvestatus
    # @show solstatus

    # to get solution values from NLP we need: XPRSgetnlpsol
    xx = Array{Float64}(undef, 2)
    slack = Array{Float64}(undef, 2)
    duals = Array{Float64}(undef, 2)
    djs = Array{Float64}(undef, 2)
    ret = Xpress.Lib.XPRSgetnlpsol(model.inner, xx, slack, duals, djs)
    @test ret == 0
    @test xx == [6, 10] 
    @test slack == [0, 0]
    # @show duals
    # @show djs

    # we will also need these:
    # XPRSnlpchgobjformulastring - to consider NL objectives
    # XPRSnlpsetinitval - to pass initial values IF the problem is NLP
    # XPRSnlpgetformularows - to check if there are previous formulas from a]
    #    previous solve.
    #    This wil be used in 2 ways:
    #        1 - to check if the current problem is NLP
    #        2 - to get indices from previous formulas to delete them
    # XPRSnlpdelformulas - to delete formulas from constraints
    # XPRSnlpdelobjformula - to delete formulas from objective
    # XPRSnlpgetobjformulastring - just to debug, possible not necessay since
    #    we can use the file write
    # XPRSnlpgetformulastring - same as above

    # We alredy read statuses from MIP and LP separately
    # we will use some of the following to read the NLP statuses
    # so that we can fill MOI´s data: PrimalStatus, DualStatus and TerminationStatus
    # and RawStatusString
    # NLPSOLSTATUS
    # NLPSTOPSTATUS
    # NLPSTATUS

    return nothing
end

function test_optimize_lp()

    model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))

    @variable(model,x[i=1:2])
    set_lower_bound(x[1],0.0)
    set_lower_bound(x[2],0.0)
    set_upper_bound(x[2],3.0)
    @NLobjective(model, Min, 12x[1]  + 20x[2])
    @NLconstraint(model, c1, 6x[1] + 8x[2] >= 100)
    @NLconstraint(model, c2, 7x[1]  + 12x[2] >= 120)
    optimize!(model)
    
    k=collect(keys(model.moi_backend.optimizer.model.variable_info))
    @test MOI.get(model.moi_backend.optimizer.model, MOI.VariableName(), k) == ["x1", "x2"]

    @test model.moi_backend.optimizer.model.termination_status == OPTIMAL::TerminationStatusCode
    @test model.moi_backend.optimizer.model.primal_status == FEASIBLE_POINT::ResultStatusCode
    @test model.moi_backend.optimizer.model.dual_status == FEASIBLE_POINT::ResultStatusCode

    @test objective_value(model) == 205.00000000000003
    @test value(x[1]) == 14.999999999999993
    @test value(x[2]) == 1.2500000000000053
    @test dual(c1) == 0.25000000000000167
    @test dual(c2) == 1.4999999999999987

end

function test_delete_constraints()

    model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))

    @variable(model,x[i=1:2])
    set_lower_bound(x[1],0.0)
    set_lower_bound(x[2],0.0)
    set_upper_bound(x[2],3.0)
    @NLobjective(model, Min, 12x[1]  + 20x[2])
    @NLconstraint(model, c1, 6x[1] + 8x[2] >= 100)
    @NLconstraint(model, c2, 7x[1]  + 12x[2] >= 120)
    optimize!(model)
    optimize!(model)

    @test length(model.moi_backend.optimizer.model.nlp_constraint_info) == 2
    @test length(model.moi_backend.optimizer.model.affine_constraint_info) == 2

end

function test_change_objective()

    model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))

    @variable(model,x[i=1:2])
    set_lower_bound(x[1],0.0)
    set_lower_bound(x[2],0.0)
    set_upper_bound(x[2],3.0)
    @NLobjective(model, Min, 12x[1]  + 20x[2])
    @NLconstraint(model, c1, 6x[1] + 8x[2] >= 100)
    optimize!(model)

    obj_1=objective_value(model)

    @NLconstraint(model, c2, 7x[1]  + 12x[2] >= 120)

    optimize!(model)

    obj_2=objective_value(model)

    @test obj_1 != obj_2

end

function test_formula_string()

    model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))

    @variable(model,x[i=1:2])
    set_lower_bound(x[1],0.0)
    set_lower_bound(x[2],0.0)
    set_upper_bound(x[2],3.0)
    @NLobjective(model, Min, 12x[1]  + 20x[2])
    @NLconstraint(model, c1, 6x[1] + 8x[2] >= 100)
    @NLconstraint(model, c2, 7x[1]  + 12x[2] >= 120)
    optimize!(model)
    
    buffer = Array{Cchar}(undef, 80)
    buffer_p = pointer(buffer)
    out = Cstring(buffer_p)
    ret=Xpress.Lib.XPRSnlpgetformulastring(model.moi_backend.optimizer.model.inner, Cint(0), out , 80)
    @test ret == 0
    version = unsafe_string(out)::String
    @test version == "6 * x1 + 8 * x2 - 100"

    buffer = Array{Cchar}(undef, 80)
    buffer_p = pointer(buffer)
    out = Cstring(buffer_p)
    ret=Xpress.Lib.XPRSnlpgetformulastring(model.moi_backend.optimizer.model.inner, Cint(1), out , 80)
    @test ret == 0
    version = unsafe_string(out)::String
    @test version == "7 * x1 + 12 * x2 - 120"

    buffer = Array{Cchar}(undef, 80)
    buffer_p = pointer(buffer)
    out = Cstring(buffer_p)
    ret=Xpress.Lib.XPRSnlpgetobjformulastring(model.moi_backend.optimizer.model.inner, out , 80)
    @test ret == 0
    version = unsafe_string(out)::String
    @test version == "12 * x1 + 20 * x2"

end

function test_optimize_nlp()

    model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))
    @variable(model,x[i=1:4])
    set_start_value(x[1],2.1)
    set_start_value(x[2],2.2)
    set_start_value(x[3],2.3)
    set_start_value(x[4],2.4)
    set_lower_bound(x[1],1.1)
    set_lower_bound(x[2],1.2)
    set_lower_bound(x[3],1.3)
    set_lower_bound(x[4],1.4)
    set_upper_bound(x[1],5.1)
    set_upper_bound(x[2],5.2)
    set_upper_bound(x[3],5.3)
    set_upper_bound(x[4],5.4)
    @NLconstraint(model, c1, (x[1]*x[2]*x[3]*x[4])>=25.0)
    @NLconstraint(model, c2, (x[1]^2)+(x[2]^2)+(x[3]^2)+(x[4]^2)==40.0)
    @NLobjective(model,Min,x[1]*x[4]*(x[1]+x[2]+x[3])+x[3])
    optimize!(model)
    
    k=collect(keys(model.moi_backend.optimizer.model.variable_info))
    @test MOI.get(model.moi_backend.optimizer.model, MOI.VariableName(), k) == ["x1", "x2", "x3", "x4"]

    @test model.moi_backend.optimizer.model.termination_status == LOCALLY_SOLVED::TerminationStatusCode
    @test model.moi_backend.optimizer.model.primal_status == FEASIBLE_POINT::ResultStatusCode

    @test objective_value(model) == 17.649399912766466
    @test value(x[1]) == 1.1
    @test value(x[2]) == 5.2
    @test value(x[3]) == 3.128897603451363
    @test value(x[4]) == 1.4
    @test dual(c1) == 0.0
    @test dual(c2) == 0.40583391082953174

end

function test_nlp1()
    m = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))
    ub = [6,4]
    @variable(m, 0 ≤ x[i=1:2] ≤ ub[i])

    @NLconstraint(m, x[1]*x[2] ≤ 4)

    @NLobjective(m, Min, -x[1] - x[2])

    optimize!(m)

    @test_broken isapprox(value(x[1]), 6, rtol=1e-6)
    @test_broken isapprox(value(x[2]), 2/3, rtol=2e-6)
    @test_broken isapprox(objective_value(m), -20/3, rtol=1e-6)

end

function test_nlp2()
    m = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))
    ub = [9.422, 5.9023, 267.417085245]
    @variable(m, 0 ≤ x[i=1:3] ≤ ub[i])

    @NLconstraints(m, begin
        250 + 30x[1] -  6x[1]^2 == x[3]
        300 + 20x[2] - 12x[2]^2 == x[3]
        150 + 0.5*(x[1]+x[2])^2 == x[3]
    end)

    @objective(m, Min, -x[3])

    optimize!(m)

    @test_broken isapprox(value(x[1]), 6.2934300, rtol=1e-6)
    @test_broken isapprox(value(x[2]), 3.8218391, rtol=1e-6)
    @test_broken isapprox(value(x[3]), 201.1593341, rtol=1e-5)
    @test_broken isapprox(objective_value(m), -201.1593341, rtol=1e-6)

end 

end

TestMOIWrapper.runtests()

using Xpress
using MathOptInterface
using Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

const MOIT = MOI.Test
const MOIU = MOI.Utilities

const OPTIMIZER = Xpress.Optimizer(OUTPUTLOG = 0)
const OPTIMIZER_2 = Xpress.Optimizer(OUTPUTLOG = 0)

# Xpress can only obtain primal and dual rays without presolve. Check more on
# https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSgetprimalray.html

const BRIDGED_OPTIMIZER = MOI.Bridges.full_bridge_optimizer(
    OPTIMIZER, Float64)
const BRIDGED_CERTIFICATE_OPTIMIZER =
    MOI.Bridges.full_bridge_optimizer(
        Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0), Float64)

const CONFIG = MOIT.TestConfig()
const CONFIG_LOW_TOL = MOIT.TestConfig(atol = 1e-3, rtol = 1e-3)

@testset "MOI interface" begin
    optimizer = Xpress.Optimizer(OUTPUTLOG = 0)
    @test MOI.get(optimizer, MOI.RawParameter("logfile")) == ""
    optimizer = Xpress.Optimizer(OUTPUTLOG = 0, logfile = "output.log")
    @test MOI.get(optimizer, MOI.RawParameter("logfile")) == "output.log"
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 100) === nothing
    @test MOI.set(optimizer, MOI.TimeLimitSec(), 3600.0) === nothing

    @test MOI.get(optimizer, Xpress.RealControl("MIPRELSTOP")) == 0.0001
    MOI.set(optimizer, Xpress.RealControl("MIPRELSTOP"), 0.123)
    @test MOI.get(optimizer, Xpress.RealControl("MIPRELSTOP")) == 0.123

    @test MOI.get(optimizer, Xpress.StringControl("MPSOBJNAME")) == ""
    MOI.set(optimizer, Xpress.StringControl("MPSOBJNAME"), "qwerty")
    @test MOI.get(optimizer, Xpress.StringControl("MPSOBJNAME")) == "qwerty"

    @test MOI.get(optimizer, Xpress.IntegerControl("PRESOLVE")) == 1
    MOI.set(optimizer, Xpress.IntegerControl("PRESOLVE"), 3)
    @test MOI.get(optimizer, Xpress.IntegerControl("PRESOLVE")) == 3

    @show MOI.get(optimizer, Xpress.StringAttribute("XPRESSVERSION"))
    @test MOI.get(optimizer, Xpress.StringAttribute("MATRIXNAME")) == ""
    @test MOI.get(optimizer, Xpress.RealAttribute("SUMPRIMALINF")) == 0.0
    @test MOI.get(optimizer, Xpress.IntegerAttribute("NAMELENGTH")) == 8
end

@testset "SolverName" begin
    @test MOI.get(OPTIMIZER, MOI.SolverName()) == "Xpress"
end

@testset "supports_default_copy_to" begin
    @test MOIU.supports_default_copy_to(OPTIMIZER, true)
end

@testset "Unit Tests Constraints" begin
    MOIT.basic_constraint_tests(OPTIMIZER, CONFIG)
end

@testset "Unit Tests" begin
    MOIT.unittest(BRIDGED_OPTIMIZER, CONFIG, #= excludes =# String[
        # TODO: fix errors
        # does not work with caching optimizer
        "delete_soc_variables",

        # These tests fail due to tolerance issues; tested below.
        "solve_qcp_edge_cases",
        "solve_qp_edge_cases",
        "solve_qp_zero_offdiag",
            
        # These tests require extra parameters to obtain certificates.
        "solve_farkas_equalto_upper",
        "solve_farkas_equalto_lower",
        "solve_farkas_lessthan",
        "solve_farkas_greaterthan",
        "solve_farkas_interval_upper",
        "solve_farkas_interval_lower",
        "solve_farkas_variable_lessthan",
        "solve_farkas_variable_lessthan_max",
       ],
    )
    # certificates
    MOIT.solve_farkas_equalto_upper(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_equalto_lower(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_lessthan(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_greaterthan(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_interval_upper(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_interval_lower(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_variable_lessthan(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    MOIT.solve_farkas_variable_lessthan_max(BRIDGED_CERTIFICATE_OPTIMIZER,CONFIG)
    # tolerance
    MOIT.solve_qcp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.solve_qp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.solve_qp_zero_offdiag(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    # MOIT.delete_soc_variables(OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.modificationtest(BRIDGED_OPTIMIZER, CONFIG)
end

@testset "Linear tests" begin
    MOIT.contlineartest(
        BRIDGED_OPTIMIZER,
        MOIT.TestConfig(
            basis = true,
            infeas_certificates = false
        ), [
            # These tests require extra parameters to obtain certificates.
            "linear8a", "linear8b", "linear8c","linear12",
        ]
    )
    MOIT.linear8atest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.linear8btest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.linear8ctest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.linear12test(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
end

@testset "Quadratic tests" begin
    MOIT.contquadratictest(
        BRIDGED_OPTIMIZER,
        MOIT.TestConfig(atol = 1e-3, rtol = 1e-3),
        [
            # Xpress does NOT support ncqcp.
            "ncqcp",
        ]
    )
end

@testset "Conic tests" begin
    MOIT.lintest(BRIDGED_OPTIMIZER, CONFIG, [
        # These tests require extra parameters to obtain certificates.
        "lin3", "lin4"
    ])
    MOIT.lin3test(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.lin4test(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.soctest(BRIDGED_OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3), ["soc3"])
    MOIT.soc3test(
        BRIDGED_OPTIMIZER,
        MOIT.TestConfig(duals = false, infeas_certificates = false, atol = 1e-3)
    )
    MOIT.rsoctest(BRIDGED_OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3), ["rotatedsoc3"])
    MOIT.rotatedsoc3test(BRIDGED_OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-2))
    MOIT.geomeantest(BRIDGED_OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3))
end

@testset "Integer Linear tests" begin
    MOIT.intlineartest(BRIDGED_OPTIMIZER, CONFIG)
end

@testset "ModelLike tests" begin
    @testset "default_objective_test" begin
        MOIT.default_objective_test(OPTIMIZER)
    end

    @testset "default_status_test" begin
        MOIT.default_status_test(OPTIMIZER)
    end

    @testset "nametest" begin
        MOIT.nametest(BRIDGED_OPTIMIZER)
    end

    @testset "validtest" begin
        MOIT.validtest(OPTIMIZER)
    end

    @testset "emptytest" begin
        MOIT.emptytest(BRIDGED_OPTIMIZER)
    end

    @testset "orderedindicestest" begin
        MOIT.orderedindicestest(OPTIMIZER)
    end

    @testset "copytest" begin
        BRIDGED_OPTIMIZER_2 = MOI.Bridges.full_bridge_optimizer(
            OPTIMIZER_2, Float64
        )
        MOIT.copytest(BRIDGED_OPTIMIZER, BRIDGED_OPTIMIZER_2)
    end
end

@testset "IIS tests" begin
    for warning in [true, false]
        @testset "Variable bounds" begin
            model = Xpress.Optimizer(OUTPUTLOG = 0, DEFAULTALG = 3, PRESOLVE = 0)
            MOI.set(model, MOI.RawParameter("MOIWarnings"), warning)
            x = MOI.add_variable(model)
            c1 = MOI.add_constraint(model, MOI.SingleVariable(x), MOI.GreaterThan(2.0))
            c2 = MOI.add_constraint(model, MOI.SingleVariable(x), MOI.LessThan(1.0))

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
        @test MOI.get(model, MOI.ConflictStatus()) == MOI.NO_CONFLICT_FOUND
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c1) == MOI.NOT_IN_CONFLICT
        @test MOI.get(model, MOI.ConstraintConflictStatus(), c2) == MOI.NOT_IN_CONFLICT
    end
end

@testset "test_farkas_dual_min" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.SingleVariable}(),
        MOI.SingleVariable(x[1]),
    )
    clb = MOI.add_constraint.(
        model, MOI.SingleVariable.(x), MOI.GreaterThan(0.0)
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

@testset "test_farkas_dual_min_interval" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.SingleVariable}(),
        MOI.SingleVariable(x[1]),
    )
    clb = MOI.add_constraint.(
        model, MOI.SingleVariable.(x), MOI.Interval(0.0, 10.0)
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

@testset "test_farkas_dual_min_equalto" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.SingleVariable}(),
        MOI.SingleVariable(x[1]),
    )
    clb = MOI.add_constraint.(model, MOI.SingleVariable.(x), MOI.EqualTo(0.0))
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

@testset "test_farkas_dual_min_ii" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MIN_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(
        model, MOI.SingleVariable.(x), MOI.LessThan(0.0)
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

@testset "test_farkas_dual_max" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.SingleVariable}(),
        MOI.SingleVariable(x[1]),
    )
    clb = MOI.add_constraint.(
        model, MOI.SingleVariable.(x), MOI.GreaterThan(0.0)
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

@testset "test_farkas_dual_max_ii" begin
    model = Xpress.Optimizer(OUTPUTLOG = 0, PRESOLVE = 0)
    x = MOI.add_variables(model, 2)
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction([MOI.ScalarAffineTerm(-1.0, x[1])], 0.0),
    )
    clb = MOI.add_constraint.(
        model, MOI.SingleVariable.(x), MOI.LessThan(0.0)
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

@testset "Delete equality constraint in binary variable" begin
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
        MOI.SingleVariable(v[1]),
        MOI.Interval(0.0, 5.0),
    )
    vc2 = MOI.add_constraint(
        model,
        MOI.SingleVariable(v[2]),
        MOI.Interval(0.0, 10.0),
    )
    vc3 = MOI.add_constraint(model, MOI.SingleVariable(v[2]), MOI.Integer())
    vc4 = MOI.add_constraint(model, MOI.SingleVariable(v[3]), MOI.ZeroOne())

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
    vc5 = MOI.add_constraint(model, MOI.SingleVariable(v[3]), MOI.EqualTo(z_value))

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
    vc4 = MOI.add_constraint(model, MOI.SingleVariable(v[3]), MOI.ZeroOne())

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

@testset "Binary Variables Infeasibility" begin
    atol = rtol = 1e-6
    model = Xpress.Optimizer(OUTPUTLOG = 0)
    v = MOI.add_variable(model)

    infeas_err = ErrorException("The problem is infeasible")
    vc1 = MOI.add_constraint(model, MOI.SingleVariable(v), MOI.ZeroOne())
    @test_throws infeas_err vc2 = MOI.add_constraint(
        model,
        MOI.SingleVariable(v),
        MOI.GreaterThan(2.0),
    )
    @test_throws infeas_err vc3 = MOI.add_constraint(
        model,
        MOI.SingleVariable(v),
        MOI.LessThan(-1.0),
        )
    @test_throws infeas_err vc4 = MOI.add_constraint(
        model,
        MOI.SingleVariable(v),
        MOI.Interval(-1.0,-0.5),
    )
    @test_throws infeas_err vc5 = MOI.add_constraint(
        model,
        MOI.SingleVariable(v),
        MOI.EqualTo(2.0),
    )
end

@testset "MIP Start testing" begin
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
        MIPPRESOLVE  = 0
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

    node_solution_was_found = MOI.get(model, Xpress.IntegerAttribute("MIPSOLNODE"))
    node_solution_was_found = MOI.get(model, MOI.RawParameter("MIPSOLNODE"))

    @test node_solution_was_found > 1

    # SECOND RUN: run without MIP-start and only searching the first node.
    # Should give a worse solution than the previous one.
    MOI.set(model, MOI.RawParameter("MAXNODE"), 1)

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


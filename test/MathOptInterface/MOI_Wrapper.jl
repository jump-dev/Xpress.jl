using Xpress
using MathOptInterface
using Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

const MOIT = MOI.Test
const MOIU = MOI.Utilities

const OPTIMIZER = Xpress.Optimizer(OUTPUTLOG = 0)
const OPTIMIZER_2 = Xpress.Optimizer(OUTPUTLOG = 0)

include("../SemiContInt/semicontint.jl")

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
       ],
    )
    MOIT.solve_qcp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.solve_qp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
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
            "linear8a", "linear8b", "linear8c",
            # TODO: This requires an infeasiblity certificate for a variable bound.
            "linear12",
        ]
    )
    MOIT.linear8atest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.linear8btest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)
    MOIT.linear8ctest(BRIDGED_CERTIFICATE_OPTIMIZER, CONFIG)

    MOIT.linear12test(
        BRIDGED_OPTIMIZER, MOIT.TestConfig(infeas_certificates = false)
    )
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

@testset "SemiContInt" begin
    semiconttest(BRIDGED_OPTIMIZER, CONFIG)
    semiinttest(BRIDGED_OPTIMIZER, CONFIG)
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
    @testset "Variable bounds (ScalarAffine)" begin
        model = Xpress.Optimizer()
        x = MOI.add_variable(model)
        c1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(2.0))
        c2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.LessThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMIZE_NOT_CALLED
        @test_throws ErrorException MOI.get(model, Xpress.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        Xpress.compute_conflict(model)
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMAL
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c1) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c2) == true
    end

    @testset "Two conflicting constraints (GreaterThan, LessThan)" begin
        model = Xpress.Optimizer()
        x = MOI.add_variable(model)
        y = MOI.add_variable(model)
        b1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(0.0))
        b2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0), MOI.GreaterThan(0.0))
        cf1 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]), 0.0)
        c1 = MOI.add_constraint(model, cf1, MOI.LessThan(-1.0))
        cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]), 0.0)
        c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMIZE_NOT_CALLED
        @test_throws ErrorException MOI.get(model, Xpress.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        # Two possible IISes: b1, b2, c1 OR b2, c1, c2
        Xpress.compute_conflict(model)
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMAL
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b1) in [true, false]
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b2) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c1) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c2) in [true, false]
    end

    @testset "Two conflicting constraints (EqualTo)" begin
        model = Xpress.Optimizer()
        x = MOI.add_variable(model)
        y = MOI.add_variable(model)
        b1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(0.0))
        b2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [y]), 0.0), MOI.GreaterThan(0.0))
        cf1 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]), 0.0)
        c1 = MOI.add_constraint(model, cf1, MOI.EqualTo(-1.0))
        cf2 = MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0, -1.0], [x, y]), 0.0)
        c2 = MOI.add_constraint(model, cf2, MOI.GreaterThan(1.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMIZE_NOT_CALLED
        @test_throws ErrorException MOI.get(model, Xpress.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        # Two possible IISes: b1, b2, c1 OR b2, c1, c2
        Xpress.compute_conflict(model)
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMAL
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b1) in [true, false]
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b2) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c1) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c2) in [true, false]
    end

    @testset "Variables outside conflict" begin
        model = Xpress.Optimizer()
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
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMIZE_NOT_CALLED
        @test_throws ErrorException MOI.get(model, Xpress.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        Xpress.compute_conflict(model)
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMAL
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b1) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b2) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), b3) == false
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c1) == true
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c2) == false
    end

    @testset "No conflict" begin
        model = Xpress.Optimizer()
        x = MOI.add_variable(model)
        c1 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.GreaterThan(1.0))
        c2 = MOI.add_constraint(model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.([1.0], [x]), 0.0), MOI.LessThan(2.0))

        # Getting the results before the conflict refiner has been called must return an error.
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.OPTIMIZE_NOT_CALLED
        @test_throws ErrorException MOI.get(model, Xpress.ConstraintConflictStatus(), c1)

        # Once it's called, no problem.
        Xpress.compute_conflict(model)
        @test MOI.get(model, Xpress.ConflictStatus()) == MOI.INFEASIBLE
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c1) == false
        @test MOI.get(model, Xpress.ConstraintConflictStatus(), c2) == false
    end
end

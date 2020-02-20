using Xpress
using MathOptInterface
using Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

const MOIT = MOI.Test
const MOIU = MOI.Utilities

const OPTIMIZER = Xpress.Optimizer()
const OPTIMIZER_2 = Xpress.Optimizer()
# Xpress can only obtain primal arrays without presolve
# Check more on https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSgetprimalray.html
const CERTIFICATE_OPTIMIZER = Xpress.Optimizer(PRESOLVE = 0)
const BRIDGED_OPTIMIZER = MOI.Bridges.full_bridge_optimizer(
    Xpress.Optimizer(), Float64)
const BRIDGED_CERTIFICATE_OPTIMIZER =
    MOI.Bridges.full_bridge_optimizer(CERTIFICATE_OPTIMIZER, Float64)

const CONFIG = MOIT.TestConfig()
const CONFIG_LOW_TOL = MOIT.TestConfig(atol = 1e-3, rtol = 1e-3)

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
        "delete_soc_variables",

        # These tests fail due to tolerance issues; tested below.
        "solve_qcp_edge_cases",
        "solve_qp_edge_cases",
       ],
    )
    MOIT.solve_qcp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.solve_qp_edge_cases(BRIDGED_OPTIMIZER, CONFIG_LOW_TOL)
    MOIT.modificationtest(BRIDGED_OPTIMIZER, CONFIG)
end

SIMPLE_CONFIG = MOIT.TestConfig(basis = false, infeas_certificates=false)

@testset "Linear tests" begin
    @testset "Default Solver"  begin
        MOIT.contlineartest(BRIDGED_OPTIMIZER, MOIT.TestConfig(
        basis = false, # TODO change to true
        ), [
            # "linear1",
            # "linear2",
            # "linear3",
            # "linear4",
            # "linear5",
            # "linear6",
            # "linear7",
            # These tests require extra parameters to be set.
            "linear8a", "linear8b", "linear8c",
            # "linear9",
            # "linear10",
            # "linear10b",
            # "linear11",
            "linear12", # TODO: This requires an infeasiblity certificate for a variable bound.
            # "linear13",
            # "linear14",
            # "linear15",
            # "partial_start",
        ])
    end
    @testset "Certificates" begin
        MOIT.linear8atest(BRIDGED_CERTIFICATE_OPTIMIZER, MOIT.TestConfig())
        MOIT.linear8btest(BRIDGED_CERTIFICATE_OPTIMIZER, MOIT.TestConfig())
        MOIT.linear8ctest(BRIDGED_CERTIFICATE_OPTIMIZER, MOIT.TestConfig())
    end
    @testset "No certificate" begin
        MOIT.linear12test(BRIDGED_CERTIFICATE_OPTIMIZER, 
            MOIT.TestConfig(infeas_certificates=false))
    end
end

@testset "Quadratic tests" begin
    MOIT.contquadratictest(BRIDGED_OPTIMIZER,
        MOIT.TestConfig(atol=1e-3, rtol=1e-3), [
        # "qp1",
        # "qp2",
        # "qp3",
        # "qcp1",
        # "qcp2",
        # "qcp3",
        # "qcp4",
        # "qcp5",
        "socp1",  # TODO: Xpress SHOULD support socp1
        "ncqcp",  # Xpress does NOT support ncqcp
    ])
end

@testset "Conic tests" begin
    # TODO enable certificates
    MOIT.lintest(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    # MOIT.soctest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3), ["soc3"])
    # MOIT.soc3test(
    #     OPTIMIZER,
    #     MOIT.TestConfig(duals = false, infeas_certificates = false, atol = 1e-3)
    # )
    # MOIT.rsoctest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3))
    # MOIT.geomeantest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3))
end

@testset "Integer Linear tests" begin
    MOIT.intlineartest(BRIDGED_OPTIMIZER, CONFIG, #= excludes =# [
        "indicator1",
        "indicator2",
        "indicator3",
        "indicator4",
    ])
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
            Xpress.Optimizer(), Float64
        )
        MOIT.copytest(BRIDGED_OPTIMIZER, BRIDGED_OPTIMIZER_2)
    end
end

using Xpress
using MathOptInterface
using Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

const MOIT = MOI.Test
const MOIU = MOI.Utilities

const OPTIMIZER = Xpress.Optimizer()
const OPTIMIZER_2 = Xpress.Optimizer()

include("../SemiContInt/semicontint.jl")

# Xpress can only obtain primal and dual rays without presolve. Check more on
# https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/XPRSgetprimalray.html

const CERTIFICATE_OPTIMIZER = Xpress.Optimizer(PRESOLVE = 0)
const BRIDGED_OPTIMIZER = MOI.Bridges.full_bridge_optimizer(
    Xpress.Optimizer(), Float64)
const BRIDGED_CERTIFICATE_OPTIMIZER =
    MOI.Bridges.full_bridge_optimizer(CERTIFICATE_OPTIMIZER, Float64)

const CONFIG = MOIT.TestConfig()
const CONFIG_LOW_TOL = MOIT.TestConfig(atol = 1e-3, rtol = 1e-3)

@testset "MOI interface" begin
    optimizer = Xpress.Optimizer(logfile = "output.log")
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

NO_BASIS_CONFIG = MOIT.TestConfig(basis = false)

@testset "Linear tests" begin
    MOIT.contlineartest(
        BRIDGED_OPTIMIZER,
        MOIT.TestConfig(
            # TODO: support basis attributes.
            basis = false,
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
    MOIT.lin3test(BRIDGED_CERTIFICATE_OPTIMIZER, NO_BASIS_CONFIG)
    MOIT.lin4test(BRIDGED_CERTIFICATE_OPTIMIZER, NO_BASIS_CONFIG)
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
            Xpress.Optimizer(), Float64
        )
        MOIT.copytest(BRIDGED_OPTIMIZER, BRIDGED_OPTIMIZER_2)
    end
end

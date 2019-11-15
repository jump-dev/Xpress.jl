using Xpress, MathOptInterface, Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

const MOIT = MOI.Test
const MOIU = MOI.Utilities

const OPTIMIZER = Xpress.Optimizer()
const OPTIMIZER_2 = Xpress.Optimizer()
const BRIDGED_OPTIMIZER = MOI.Bridges.full_bridge_optimizer(
    Xpress.Optimizer(), Float64)

const CONFIG = MOIT.TestConfig()

@testset "SolverName" begin
    @test MOI.get(OPTIMIZER, MOI.SolverName()) == "Xpress"
end

@testset "supports_default_copy_to" begin
    @test MOIU.supports_default_copy_to(OPTIMIZER, true)
end

@testset "Unit Tests Constraints" begin
    MOIT.basic_constraint_tests(OPTIMIZER, CONFIG;
            exclude = [
                # (MOI.SingleVariable, MOI.Integer),
                # (MOI.SingleVariable, MOI.EqualTo{Float64}),
                # (MOI.SingleVariable, MOI.Interval{Float64}),
                # (MOI.SingleVariable, MOI.GreaterThan{Float64}),
                # (MOI.SingleVariable, MOI.LessThan{Float64}),
                # (MOI.ScalarQuadraticFunction{Float64}, MOI.LessThan{Float64}),
                # (MOI.ScalarQuadraticFunction{Float64}, MOI.GreaterThan{Float64}),
                # (MOI.ScalarQuadraticFunction{Float64}, MOI.EqualTo{Float64}),
                # (MOI.ScalarQuadraticFunction{Float64}, MOI.Interval{Float64}),
                # (MOI.ScalarAffineFunction{Float64}, MOI.Interval{Float64}),
                #
                # (MOI.VectorOfVariables, MOI.Nonnegatives),
                # (MOI.VectorOfVariables, MOI.Nonpositives),
                # (MOI.VectorOfVariables, MOI.Zeros),
                # (MOI.VectorAffineFunction{Float64}, MOI.Nonnegatives),
                # (MOI.VectorAffineFunction{Float64}, MOI.Nonpositives),
                # (MOI.VectorAffineFunction{Float64}, MOI.Zeros),
                # (MOI.VectorOfVariables, MOI.SecondOrderCone),
                # (MOI.VectorOfVariables, MOI.RotatedSecondOrderCone),
                # (MOI.VectorOfVariables, MOI.GeometricMeanCone),
                # (MOI.VectorAffineFunction{Float64}, MOI.SecondOrderCone),
                # (MOI.VectorAffineFunction{Float64}, MOI.RotatedSecondOrderCone),
                # (MOI.VectorAffineFunction{Float64}, MOI.GeometricMeanCone),
            ]
        )
end

@testset "Unit Tests" begin
        MOIT.unittest(BRIDGED_OPTIMIZER, CONFIG, [
            "solve_qp_edge_cases",    # tested below
            "solve_qcp_edge_cases",    # tested below
            # TODO:
            "delete_soc_variables",
        ])
    #    MOIT.modificationtest(BRIDGED_OPTIMIZER, CONFIG)
end

SIMPLE_CONFIG = MOIT.TestConfig(basis = false, infeas_certificates=false)
@testset "First" begin
    MOIT.linear12test(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear15test(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear8btest(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear8ctest(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear8atest(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear3test(BRIDGED_OPTIMIZER, MOIT.TestConfig(basis = false, infeas_certificates=false))
    MOIT.linear9test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear14test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear4test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear1test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear2test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear10test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear5test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear11test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
    MOIT.linear6test(BRIDGED_OPTIMIZER, SIMPLE_CONFIG)
end

#= @show "end"
 exit(1)
@testset "Linear tests" begin
    @testset "Default Solver"  begin
        MOIT.contlineartest(BRIDGED_OPTIMIZER, MOIT.TestConfig(
        basis = false, # TODO change to true
        infeas_certificates=false # TODO remove this
        ), [
            # This requires an infeasiblity certificate for a variable bound.
            "linear12",

        ])
    end
    @testset "No certificate" begin
        MOIT.linear12test(BRIDGED_OPTIMIZER, MOIT.TestConfig(infeas_certificates=false))
    end
end

@testset "Quadratic tests" begin
    MOIT.contquadratictest(OPTIMIZER, MOIT.TestConfig(atol=1e-3, rtol=1e-3), [
        "ncqcp"  # Gurobi doesn't support non-convex problems.
    ])
end

@testset "Conic tests" begin
    MOIT.lintest(OPTIMIZER, CONFIG)
    MOIT.soctest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3), ["soc3"])
    MOIT.soc3test(
        OPTIMIZER,
        MOIT.TestConfig(duals = false, infeas_certificates = false, atol = 1e-3)
    )
    MOIT.rsoctest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3))
    MOIT.geomeantest(OPTIMIZER, MOIT.TestConfig(duals = false, atol=1e-3))
end

@testset "Integer Linear tests" begin
    MOIT.intlineartest(OPTIMIZER, CONFIG, [
        # Indicator sets not supported.
        "indicator1", "indicator2", "indicator3"
    ])
end

=#

@testset "ModelLike tests" begin
    @testset "default_objective_test" begin
        MOIT.default_objective_test(OPTIMIZER)
    end

    @testset "default_status_test" begin
        MOIT.default_status_test(OPTIMIZER)
    end

    @testset "nametest" begin
        # MOIT.nametest(OPTIMIZER)
    end

    @testset "validtest" begin
        MOIT.validtest(OPTIMIZER)
    end

    @testset "emptytest" begin
        # MOIT.emptytest(OPTIMIZER)
    end

    @testset "orderedindicestest" begin
        MOIT.orderedindicestest(OPTIMIZER)
    end
    @testset "copytest" begin
        # OPTIMIZER_2 = Xpress.Optimizer()
        # MOIT.copytest(OPTIMIZER, OPTIMIZER_2 )
    end
end



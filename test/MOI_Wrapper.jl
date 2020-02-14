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
const CONFIG_LOW_TOL = MOIT.TestConfig(atol = 1e-3, rtol = 1e-3)

@testset "SolverName" begin
    @test MOI.get(OPTIMIZER, MOI.SolverName()) == "Xpress"
end

@testset "supports_default_copy_to" begin
    @test MOIU.supports_default_copy_to(OPTIMIZER, true)
end

@testset "Unit Tests Constraints" begin
    MOIT.basic_constraint_tests(OPTIMIZER, CONFIG, delete = false) # TODO: remove `delete = false`
end

@testset "Unit Tests" begin
    MOIT.unittest(BRIDGED_OPTIMIZER, CONFIG, #= excludes =# [
        # "add_variable",
        # "add_variables",
        # "delete_nonnegative_variables",
        "delete_soc_variables", # TODO: fix errors
        # "delete_variable",
        # "delete_variables",
        # "feasibility_sense",
        # "get_objective_function",
        # "getconstraint",
        # "getvariable",
        # "max_sense",
        # "min_sense",
        # "number_threads",
        # "raw_status_string",
        # "silent",
        # "solve_affine_deletion_edge_cases",
        # "solve_affine_equalto",
        # "solve_affine_greaterthan",
        # "solve_affine_interval",
        # "solve_affine_lessthan",
        # "solve_blank_obj",
        # "solve_constant_obj",
        # "solve_duplicate_terms_obj",
        # "solve_duplicate_terms_scalar_affine",
        # "solve_duplicate_terms_vector_affine",
        # "solve_integer_edge_cases",
        # "solve_objbound_edge_cases",
        "solve_qcp_edge_cases", # fails due to tolerance
        "solve_qp_edge_cases", # fails due to tolerance
        # "solve_result_index",
        # "solve_single_variable_dual_max",
        # "solve_single_variable_dual_min",
        # "solve_singlevariable_obj",
        # "solve_time",
        # "solve_unbounded_model",
        # "solve_with_lowerbound",
        # "solve_with_upperbound",
        # "solve_zero_one_with_bounds_1",
        # "solve_zero_one_with_bounds_2",
        # "solve_zero_one_with_bounds_3",
        # "solver_name",
        # "time_limit_sec",
        # "update_dimension_nonnegative_variables",
        # "variablenames",
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
        infeas_certificates=false # TODO remove this
        ), [
            # "linear1",
            # "linear2",
            # "linear3",
            # "linear4",
            # "linear5",
            # "linear6",
            # "linear7",
            # "linear8a",
            # "linear8b",
            # "linear8c",
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
    @testset "No certificate" begin
        MOIT.linear12test(BRIDGED_OPTIMIZER, 
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
        #"knapsack",
        #"int1",
        #"int2",
        #"int3",
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
                                            Xpress.Optimizer(), Float64)
        MOIT.copytest(BRIDGED_OPTIMIZER, BRIDGED_OPTIMIZER_2 )
    end
end

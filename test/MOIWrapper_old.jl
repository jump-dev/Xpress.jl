#push!(Base.LOAD_PATH,joinpath(dirname(@__FILE__),"..",".."))

using Xpress, Test, MathOptInterface, MathOptInterface.Test

const MOI = MathOptInterface
const MOIT = MathOptInterface.Test

@testset "MathOptInterface" begin
    @testset "Unit Tests" begin
        config = MOIT.TestConfig()
        solver = Xpress.Optimizer()
        MOIT.basic_constraint_tests(solver, config;
            exclude = [
                (MOI.SingleVariable, MOI.Integer),
                (MOI.SingleVariable, MOI.EqualTo{Float64}),
                (MOI.SingleVariable, MOI.Interval{Float64}),
                (MOI.SingleVariable, MOI.GreaterThan{Float64}),
                (MOI.SingleVariable, MOI.LessThan{Float64}),
            ]
        )
        MOIT.unittest(solver, config, [
            "solve_qp_edge_cases",    # tested below
            "solve_qcp_edge_cases"    # tested below
        ])
        @testset "solve_qp_edge_cases" begin
                MOIT.solve_qp_edge_cases(solver,
                MOIT.TestConfig(atol=1e-2,rtol = 1e-2)
            )
        end
        @testset "solve_qcp_edge_cases" begin
                MOIT.solve_qcp_edge_cases(solver,
                MOIT.TestConfig(atol=1e-2,rtol = 1e-2)
            )
        end
    end

    @testset "Linear tests" begin
        linconfig = MOIT.TestConfig()
        solver = Xpress.Optimizer()
        MOIT.contlineartest(solver, linconfig, [
            "linear12","linear8a","linear8b","linear8c",
            # VariablePrimalStart not implemented.
            "partial_start"
        ])

        solver_nopresolve = Xpress.Optimizer(PRESOLVE = 0)
        MOIT.contlineartest(solver_nopresolve, linconfig, [
            "linear12",
            # VariablePrimalStart not implemented.
            "partial_start"
        ])

        linconfig_nocertificate = MOIT.TestConfig(infeas_certificates=false)
        MOIT.linear12test(solver, linconfig_nocertificate)
    end

    @testset "Quadratic tests" begin
        quadconfig = MOIT.TestConfig(atol=1e-5, rtol=1e-5, duals=false)
        solver = Xpress.Optimizer()
        MOIT.contquadratictest(solver, quadconfig)
    end

    @testset "Linear Conic tests" begin
        linconfig = MOIT.TestConfig()
        solver = Xpress.Optimizer()
        MOIT.lintest(solver, linconfig, ["lin3","lin4"])

        solver_nopresolve = Xpress.Optimizer(PRESOLVE=0)
        MOIT.lintest(solver_nopresolve, linconfig)
    end

    @testset "Integer Linear tests" begin
        intconfig = MOIT.TestConfig()
        solver = Xpress.Optimizer()
        MOIT.intlineartest(solver, intconfig, ["int2"])
    end

    @testset "ModelLike tests" begin
        intconfig = MOIT.TestConfig()
        solver = Xpress.Optimizer()
        MOIT.nametest(solver)
        @testset "validtest" begin
            MOIT.validtest(solver)
        end
        @testset "emptytest" begin
            MOIT.emptytest(solver)
        end
        @testset "orderedindicestest" begin
            MOIT.orderedindicestest(solver)
        end
        @testset "copytest" begin
            solver2 = Xpress.Optimizer()
            MOIT.copytest(solver,solver2)
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
end

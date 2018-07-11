#push!(Base.LOAD_PATH,joinpath(dirname(@__FILE__),"..",".."))

using Xpress, Base.Test, MathOptInterface, MathOptInterface.Test

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
            "solve_affine_interval",  # Interval constraints not wrapped
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
        MOIT.contlineartest(solver , linconfig, ["linear12","linear8a","linear8b","linear8c"])
        
        solver_nopresolve = Xpress.Optimizer(PRESOLVE = 0)
        MOIT.contlineartest(solver_nopresolve , linconfig, ["linear12"])

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
        MOIT.intlineartest(solver, intconfig)
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
            # MOIT.orderedindicestest(solver)
        end
        @testset "canaddconstrainttest" begin
            MOIT.canaddconstrainttest(solver, Float64, Complex{Float64})
        end
        @testset "copytest" begin
            solver2 = Xpress.Optimizer()
            MOIT.copytest(solver,solver2)
        end
    end
end
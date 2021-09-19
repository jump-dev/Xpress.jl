using Xpress
using MathOptInterface
using Random
using Test

const MOI = MathOptInterface

function callback_simple_model()
    model = Xpress.Optimizer(
        PRESOLVE = 0,
        CUTSTRATEGY = 0,
        HEURSTRATEGY = 0,
        SYMMETRY = 0,
        OUTPUTLOG = 0
    )

    MOI.Utilities.loadfromstring!(model, """
        variables: x, y
        maxobjective: y
        c1: x in Integer()
        c2: y in Integer()
        c3: x in Interval(0.0, 2.5)
        c4: y in Interval(0.0, 2.5)
    """)
    x = MOI.get(model, MOI.VariableIndex, "x")
    y = MOI.get(model, MOI.VariableIndex, "y")
    return model, x, y
end

function callback_knapsack_model()
    model = Xpress.Optimizer(
        PRESOLVE = 0,
        CUTSTRATEGY = 0,
        HEURSTRATEGY = 0,
        SYMMETRY = 0,
        OUTPUTLOG = 0
    )
    MOI.set(model, MOI.NumberOfThreads(), 2)

    N = 30
    x = MOI.add_variables(model, N)
    MOI.add_constraints(model, x, MOI.ZeroOne())
    MOI.set.(model, MOI.VariablePrimalStart(), x, 0.0)
    Random.seed!(1)
    item_weights, item_values = rand(N), rand(N)
    MOI.add_constraint(
        model,
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(item_weights, x), 0.0),
        MOI.LessThan(10.0)
    )
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(item_values, x), 0.0)
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    return model, x, item_weights
end

@testset "LazyConstraintCallback" begin
    @testset "LazyConstraint" begin
        model, x, y = callback_simple_model()
        global lazy_called = false
        MOI.set(model, MOI.LazyConstraintCallback(), cb_data -> begin
            global lazy_called = true
            x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
            y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
            status = MOI.get(model, MOI.CallbackNodeStatus(cb_data))::MOI.CallbackNodeStatusCode
            if round.(Int, [x_val, y_val]) ≈ [x_val, y_val] atol=1e-6
                @test status == MOI.CALLBACK_NODE_STATUS_INTEGER
            else
                @test status == MOI.CALLBACK_NODE_STATUS_FRACTIONAL
            end
            @test MOI.supports(model, MOI.LazyConstraint(cb_data))
            if y_val - x_val > 1 + 1e-6
                MOI.submit(
                    model,
                    MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([-1.0, 1.0], [x, y]),
                        0.0
                    ),
                    MOI.LessThan{Float64}(1.0)
                )
            elseif y_val + x_val > 3 + 1e-6
                MOI.submit(
                    model,
                    MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
                        0.0
                    ), MOI.LessThan{Float64}(3.0)
                )
            end
        end)
        @test MOI.supports(model, MOI.LazyConstraintCallback())
        MOI.optimize!(model)
        @test lazy_called
        @test MOI.get(model, MOI.VariablePrimal(), x) == 1
        @test MOI.get(model, MOI.VariablePrimal(), y) == 2
    end
    @testset "OptimizeInProgress" begin
        model, x, y = callback_simple_model()
        MOI.set(model, MOI.LazyConstraintCallback(), cb_data -> begin
            @test_throws(
                MOI.OptimizeInProgress(MOI.VariablePrimal()),
                MOI.get(model, MOI.VariablePrimal(), x)
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveValue()),
                MOI.get(model, MOI.ObjectiveValue())
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveBound()),
                MOI.get(model, MOI.ObjectiveBound())
            )
        end)
        MOI.optimize!(model)
    end

    @testset "HeuristicSolution" begin
        model, x, y = callback_simple_model()
        cb = nothing
        MOI.set(model, MOI.LazyConstraintCallback(), cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                [x],
                [2.0]
            )
        end)
        @test_throws(
            MOI.InvalidCallbackUsage(
                MOI.LazyConstraintCallback(),
                MOI.HeuristicSolution(cb)
            ),
            MOI.optimize!(model)
        )
   end
end

@testset "UserCutCallback" begin
    @testset "UserCut" begin
        model, x, item_weights = callback_knapsack_model()
        global user_cut_submitted = false
        MOI.set(model, MOI.UserCutCallback(), cb_data -> begin
            terms = MOI.ScalarAffineTerm{Float64}[]
            accumulated = 0.0
            for (i, xi) in enumerate(x)
                if MOI.get(model, MOI.CallbackVariablePrimal(cb_data), xi) > 0.0
                    push!(terms, MOI.ScalarAffineTerm(1.0, xi))
                    accumulated += item_weights[i]
                end
            end
            @test MOI.supports(model, MOI.UserCut(cb_data))
            if accumulated > 10.0
                MOI.submit(
                    model,
                    MOI.UserCut(cb_data),
                    MOI.ScalarAffineFunction{Float64}(terms, 0.0),
                    MOI.LessThan{Float64}(length(terms) - 1)
                )
                global user_cut_submitted = true
            end
        end)
        @test MOI.supports(model, MOI.UserCutCallback())
        MOI.optimize!(model)
        @test user_cut_submitted
    end
    @testset "HeuristicSolution" begin
        model, x, item_weights = callback_knapsack_model()
        cb = nothing
        MOI.set(model, MOI.UserCutCallback(), cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                [x[1]],
                [0.0]
            )
        end)
        @test_throws(
            MOI.InvalidCallbackUsage(
                MOI.UserCutCallback(),
                MOI.HeuristicSolution(cb)
            ),
            MOI.optimize!(model)
        )
    end
end

@testset "HeuristicCallback" begin
    @testset "HeuristicSolution" begin
        model, x, item_weights = callback_knapsack_model()
        global callback_called = false
        MOI.set(model, MOI.HeuristicCallback(), cb_data -> begin
            x_vals = MOI.get.(model, MOI.CallbackVariablePrimal(cb_data), x)
            status = MOI.get(model, MOI.CallbackNodeStatus(cb_data))::MOI.CallbackNodeStatusCode
            if round.(Int, x_vals) ≈ x_vals atol=1e-6
                @test status == MOI.CALLBACK_NODE_STATUS_INTEGER
            else
                @test status == MOI.CALLBACK_NODE_STATUS_FRACTIONAL
            end
            @test MOI.supports(model, MOI.HeuristicSolution(cb_data))
            @test MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                x,
                floor.(x_vals)
            ) == MOI.HEURISTIC_SOLUTION_UNKNOWN
            global callback_called = true
        end)
        @test MOI.supports(model, MOI.HeuristicCallback())
        MOI.optimize!(model)
        @test callback_called
    end
    @testset "LazyConstraint" begin
        model, x, item_weights = callback_knapsack_model()
        cb = nothing
        MOI.set(model, MOI.HeuristicCallback(), cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.LazyConstraint(cb_data),
                MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(1.0, x), 0.0),
                MOI.LessThan(5.0)
            )
        end)
        @test_throws(
            MOI.InvalidCallbackUsage(
                MOI.HeuristicCallback(),
                MOI.LazyConstraint(cb)
            ),
            MOI.optimize!(model)
        )
    end
    @testset "UserCut" begin
        model, x, item_weights = callback_knapsack_model()
        cb = nothing
        MOI.set(model, MOI.HeuristicCallback(), cb_data -> begin
            cb = cb_data
            MOI.submit(
                model,
                MOI.UserCut(cb_data),
                MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(1.0, x), 0.0),
                MOI.LessThan(5.0)
            )
        end)
        @test_throws(
            MOI.InvalidCallbackUsage(
                MOI.HeuristicCallback(),
                MOI.UserCut(cb)
            ),
            MOI.optimize!(model)
        )
    end
end

@testset "Xpress.CallbackFunction" begin
    @testset "OptimizeInProgress" begin
        model, x, y = callback_simple_model()
        MOI.set(model, Xpress.CallbackFunction(), (cb_data) -> begin
            @test_throws(
                MOI.OptimizeInProgress(MOI.VariablePrimal()),
                MOI.get(model, MOI.VariablePrimal(), x)
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveValue()),
                MOI.get(model, MOI.ObjectiveValue())
            )
            @test_throws(
                MOI.OptimizeInProgress(MOI.ObjectiveBound()),
                MOI.get(model, MOI.ObjectiveBound())
            )
        end)
        @test MOI.supports(model, Xpress.CallbackFunction())
        MOI.optimize!(model)
    end
    @testset "LazyConstraint" begin
        model, x, y = callback_simple_model()
        cb_calls = Int32[]
        global generic_lazy_called = false
        function callback_function(cb_data)
            push!(cb_calls, 1)
            Xpress.get_cb_solution(model, cb_data.model)
            x_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), x)
            y_val = MOI.get(model, MOI.CallbackVariablePrimal(cb_data), y)
            if y_val - x_val > 1 + 1e-6
                MOI.submit(model, MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([-1.0, 1.0], [x, y]),
                        0.0
                    ),
                    MOI.LessThan{Float64}(1.0)
                )
            elseif y_val + x_val > 3 + 1e-6
                MOI.submit(model, MOI.LazyConstraint(cb_data),
                    MOI.ScalarAffineFunction{Float64}(
                        MOI.ScalarAffineTerm.([1.0, 1.0], [x, y]),
                        0.0
                    ),
                    MOI.LessThan{Float64}(3.0)
                )
            end
        end
        MOI.set(model, Xpress.CallbackFunction(), callback_function)
        MOI.optimize!(model)
        @test MOI.get(model, MOI.VariablePrimal(), x) == 1
        @test MOI.get(model, MOI.VariablePrimal(), y) == 2
        @test length(cb_calls) > 0
    end
    @testset "UserCut" begin
        model, x, item_weights = callback_knapsack_model()
        user_cut_submitted = false
        cb_calls = Int32[]
        MOI.set(model, Xpress.CallbackFunction(), (cb_data) -> begin
            push!(cb_calls)
            if Xpress.getintattrib(cb_data.model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 1
                return
            end
            Xpress.get_cb_solution(model, cb_data.model)
            terms = MOI.ScalarAffineTerm{Float64}[]
            accumulated = 0.0
            for (i, xi) in enumerate(x)
                if MOI.get(model, MOI.CallbackVariablePrimal(cb_data), xi) > 0.0
                    push!(terms, MOI.ScalarAffineTerm(1.0, xi))
                    accumulated += item_weights[i]
                end
            end
            if accumulated > 10.0
                MOI.submit(
                    model,
                    MOI.UserCut(cb_data),
                    MOI.ScalarAffineFunction{Float64}(terms, 0.0),
                    MOI.LessThan{Float64}(length(terms) - 1)
                )
                user_cut_submitted = true
            end
            return
        end)
        MOI.optimize!(model)
        @test user_cut_submitted
    end
    @testset "HeuristicSolution" begin
        model, x, item_weights = callback_knapsack_model()
        callback_called = false
        cb_calls = Int32[]
        MOI.set(model, Xpress.CallbackFunction(), (cb_data) -> begin
            if Xpress.getintattrib(cb_data.model, Xpress.Lib.XPRS_CALLBACKCOUNT_OPTNODE) > 1
                return
            end
            Xpress.get_cb_solution(model, cb_data.model)
            x_vals = MOI.get.(model, MOI.CallbackVariablePrimal(cb_data), x)
            @test MOI.submit(
                model,
                MOI.HeuristicSolution(cb_data),
                x,
                floor.(x_vals)
            ) == MOI.HEURISTIC_SOLUTION_UNKNOWN
            callback_called = true
            return
        end)
        MOI.optimize!(model)
        @test callback_called
    end
end

@testset "Xpress.CallbackFunction.CallbackNodeStatus" begin
    model, x, item_weights = callback_knapsack_model()
    global unknown_reached = false
    MOI.set(model, Xpress.CallbackFunction(), (cb_data) -> begin
        if MOI.get(model, MOI.CallbackNodeStatus(cb_data)) == MOI.CALLBACK_NODE_STATUS_UNKNOWN
            global unknown_reached = true
        end
    end)
    MOI.optimize!(model)
    @test unknown_reached
end

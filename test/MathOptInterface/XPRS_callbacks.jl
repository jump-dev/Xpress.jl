using Xpress
using LinearAlgebra
using MathOptInterface

const MOI = MathOptInterface

function callback_simple_model(; OUTPUTLOG::Integer = 0)
    model = Xpress.Optimizer(
        PRESOLVE = 0,
        CUTSTRATEGY = 0,
        HEURSTRATEGY = 0,
        SYMMETRY = 0,
        OUTPUTLOG = OUTPUTLOG,
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

    return (model, x, y)
end

function foo(callback_data::Xpress.CallbackData)
    callback_data.data[1] += 1

    cols = Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_COLS)
    rows = Xpress.getintattrib(callback_data.node_model, Xpress.Lib.XPRS_ROWS)

    Xpress.getdblattrib(callback_data.node_model, Xpress.Lib.XPRS_BESTBOUND)

    ans_variable_primal = Vector{Float64}(undef, Int(cols))
    ans_linear_primal   = Vector{Float64}(undef, Int(cols))

    Xpress.Lib.XPRSgetlpsol(
        callback_data.node_model,
        ans_variable_primal,
        ans_linear_primal,
        C_NULL,
        C_NULL,
    )

    return nothing
end

function message_func(callback_data::Xpress.CallbackData)
    callback_data.data[5] = 2

    return nothing
end

@testset "Low-level Xpress Callback API" verbose = true begin

@testset "message" begin
    @testset "add_xprs_message_callback! + remove_xprs_message_callback!" begin
        let 
            model, x, y = callback_simple_model(; OUTPUTLOG = 1)

            MOI.set(model, Xpress.MessageCallback(), nothing)

            data = Matrix(1.0I, 3, 3)
            info = Xpress.add_xprs_message_callback!(model.inner, message_func, data)

            @test info.callback_ptr isa Ptr{Cvoid}
            @test info.data_wrapper isa Xpress.CallbackDataWrapper{Xpress.MessageCallbackData}

            @test data[5] == 1
            MOI.optimize!(model)
            @test data[5] == 2

            Xpress.remove_xprs_message_callback!(model.inner, info)

            data[5] = 1

            MOI.optimize!(model)
            @test data[5] == 1
        end
    end

    @testset "multiple entries" begin
        let 
            model, x, y = callback_simple_model()

            N = 3

            data = Matrix(1.0I, 3, 3)
            info = [
                Xpress.add_xprs_message_callback!(model.inner, foo, data)
                for _ = 1:N
            ]

            for i = 1:N
                @test info[i].callback_ptr isa Ptr{Cvoid}
                @test info[i].data_wrapper isa Xpress.CallbackDataWrapper{Xpress.MessageCallbackData}
            end

            @test data[1] == 1
            MOI.optimize!(model)
            @test data[1] == N + 1 broken = true # callback registered but not getting called

            for i = 1:N
                Xpress.remove_xprs_message_callback!(model.inner, info[i])
            end

            MOI.optimize!(model)
            @test data[1] == N + 1 broken = true # callback registered but not getting called
        end
    end
end

@testset "optnode" begin
    @testset "add_xprs_optnode_callback! + remove_xprs_optnode_callback!" begin
        let 
            model, x, y = callback_simple_model()

            data = Matrix(1.0I, 3, 3)
            info = Xpress.add_xprs_optnode_callback!(model.inner, foo, data)

            @test info.callback_ptr isa Ptr{Cvoid}
            @test info.data_wrapper isa Xpress.CallbackDataWrapper{Xpress.OptNodeCallbackData}

            @test data[1] == 1
            MOI.optimize!(model)
            @test data[1] == 2

            Xpress.remove_xprs_optnode_callback!(model.inner, info)

            MOI.optimize!(model)
            @test data[1] == 2
        end
    end

    @testset "multiple entries" begin
        let 
            model, x, y = callback_simple_model()

            N = 3

            data = Matrix(1.0I, 3, 3)
            info = [
                Xpress.add_xprs_optnode_callback!(model.inner, foo, data)
                for _ = 1:N
            ]

            for i = 1:N
                @test info[i].callback_ptr isa Ptr{Cvoid}
                @test info[i].data_wrapper isa Xpress.CallbackDataWrapper{Xpress.OptNodeCallbackData}
            end

            @test data[1] == 1
            MOI.optimize!(model)
            @test data[1] == N + 1

            for i = 1:N
                Xpress.remove_xprs_optnode_callback!(model.inner, info[i])
            end

            MOI.optimize!(model)
            @test data[1] == N + 1
        end
    end
end

@testset "preintsol" begin
    @testset "add_xprs_preintsol_callback! + remove_xprs_preintsol_callback!" begin
        let 
            model, x, y = callback_simple_model()

            data = Matrix(1.0I, 3, 3)
            info = Xpress.add_xprs_preintsol_callback!(model.inner, foo, data)

            @test info.callback_ptr isa Ptr{Cvoid}
            @test info.data_wrapper isa Xpress.CallbackDataWrapper{Xpress.PreIntSolCallbackData}

            @test data[1] == 1
            MOI.optimize!(model)
            @test data[1] == 2

            Xpress.remove_xprs_preintsol_callback!(model.inner, info)

            MOI.optimize!(model)
            @test data[1] == 2
        end
    end

    @testset "multiple entries" begin
        let 
            model, x, y = callback_simple_model()

            N = 3

            data = Matrix(1.0I, 3, 3)
            info = [
                Xpress.add_xprs_preintsol_callback!(model.inner, foo, data)
                for _ = 1:N
            ]

            for i = 1:N
                @test info[i].callback_ptr isa Ptr{Cvoid}
                @test info[i].data_wrapper isa Xpress.CallbackDataWrapper{Xpress.PreIntSolCallbackData}
            end

            @test data[1] == 1
            MOI.optimize!(model)
            @test data[1] == N + 1

            for i = 1:N
                Xpress.remove_xprs_preintsol_callback!(model.inner, info[i])
            end

            MOI.optimize!(model)
            @test data[1] == N + 1
        end
    end
end

end
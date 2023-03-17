using Xpress
using LinearAlgebra
using MathOptInterface

const MOI = MathOptInterface

function callback_simple_model()
    model = Xpress.Optimizer(
        PRESOLVE = 0,
        CUTSTRATEGY = 0,
        HEURSTRATEGY = 0,
        SYMMETRY = 0,
        OUTPUTLOG = 0,
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
    callback_data.data[1] = 98

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

    return
end

@testset "message" begin
    let 
        model, x, y = callback_simple_model()

        data = Matrix(1.0I, 3, 3)

        Xpress.set_xprs_message_callback!(model, foo, data)

        data_ptr = model.callback_info[:xprs_message].data_wrapper
        func_ptr = model.callback_info[:xprs_message].callback_ptr

        @test data[1] == 1
        MOI.optimize!(model)
        @test data[1] == 98 broken = true # callback registered but not getting called

        @test typeof(data_ptr) <: Xpress.CallbackDataWrapper{Xpress.MessageCallbackData}
        @test typeof(func_ptr) <: Ptr{Cvoid}
    end
end

@testset "optnode" begin
    let 
        model, x, y = callback_simple_model()

        data = Matrix(1.0I, 3, 3)

        Xpress.set_xprs_optnode_callback!(model, foo, data)

        data_ptr = model.callback_info[:xprs_optnode].data_wrapper
        func_ptr = model.callback_info[:xprs_optnode].callback_ptr

        @test data[1] == 1
        MOI.optimize!(model)
        @test data[1] == 98

        @test typeof(data_ptr) <: Xpress.CallbackDataWrapper{Xpress.OptNodeCallbackData}
        @test typeof(func_ptr) <: Ptr{Cvoid}
    end
end

@testset "preintsol" begin
    let 
        model, x, y = callback_simple_model()

        data = Matrix(1.0I, 3, 3)

        Xpress.set_xprs_preintsol_callback!(model, foo, data)

        data_ptr = model.callback_info[:xprs_preintsol].data_wrapper
        func_ptr = model.callback_info[:xprs_preintsol].callback_ptr

        @test data[1] == 1
        MOI.optimize!(model)
        @test data[1] == 98

        @test typeof(data_ptr) <: Xpress.CallbackDataWrapper{Xpress.PreIntSolCallbackData}
        @test typeof(func_ptr) <: Ptr{Cvoid}
    end
end
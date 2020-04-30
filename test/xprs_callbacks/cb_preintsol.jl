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

model,x,y = callback_simple_model()

show(model)

data = Matrix(1.0I, 3, 3)

function foo(data::Xpress.CallbackData)

    @show data.data[1] = 98

    @show data.model_root.ptr
    @show data.model.ptr
    
    @show cols = Xpress.getintattrib(data.model,Xpress.Lib.XPRS_COLS)
    @show rows = Xpress.getintattrib(data.model,Xpress.Lib.XPRS_ROWS)
    @show Xpress.getdblattrib(model.inner, Xpress.Lib.XPRS_BESTBOUND)

    ans_variable_primal = Vector{Float64}(undef,Int(cols))
    ans_linear_primal = Vector{Float64}(undef,Int(cols))

    Xpress.Lib.XPRSgetlpsol(data.model,
    ans_variable_primal,
    ans_linear_primal,
    C_NULL, C_NULL)

    @show maximum(ans_variable_primal)
    @show minimum(ans_variable_primal)

    nothing
end

Xpress.set_callback_preintsol!(model.inner, foo, data)

MOI.optimize!(model)

@show data
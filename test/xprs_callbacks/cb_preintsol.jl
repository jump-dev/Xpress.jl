# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Xpress
import MathOptInterface as MOI

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

model, x, y = callback_simple_model()

data = [1.0 0.0 0.0; 0.0 1.0 0.0; 0.0 0.0 1.0]

function foo(cb::Xpress.CallbackData)

    cb.data[1] = 98

    cols = Xpress.get_control_or_attribute(cb.model, Xpress.Lib.XPRS_COLS)
    rows = Xpress.get_control_or_attribute(cb.model, Xpress.Lib.XPRS_ROWS)
    Xpress.get_control_or_attribute(cb.model, Xpress.Lib.XPRS_BESTBOUND)

    ans_variable_primal = Vector{Float64}(undef,Int(cols))
    ans_linear_primal = Vector{Float64}(undef,Int(cols))

    Xpress.Lib.XPRSgetlpsol(cb.model,
        ans_variable_primal,
        ans_linear_primal,
        C_NULL, C_NULL)

    return
end

func_ptr, data_ptr = Xpress.set_callback_preintsol!(model.inner, foo, data)

@test data[1] == 1
MOI.optimize!(model)
@test data[1] == 98

@test typeof(data_ptr) <: Any
@test typeof(func_ptr) <: Ptr{Cvoid}

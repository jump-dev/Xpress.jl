using Xpress

NAME = "D:/Repositories/Xpress.jl/test/LPteste.lp"
NAME2 = "D:\\Repositories\\Xpress.jl\\test\\LPteste"

model = Xpress.Model()
Xpress.setparam!(model, Xpress.XPRS_CONTROLS_DICT[:OUTPUTLOG], 1)

Xpress.setlogfile(model, NAME2)

Xpress.read_model(model, NAME)

# Xpress.setparam!(model, Xpress.XPRS_CONTROLS_DICT[:THREADS], 1)
# Xpress.setparam!(model, Xpress.XPRS_CONTROLS_DICT[:CALLBACKFROMMASTERTHREAD], 1)


show(model)

data = eye(3,3)

function foo(data::Xpress.CallbackData)

    @show data.data[1] = 98

    println("fooooooooo")

    @show data.model_root.ptr_model
    @show data.model.ptr_model

    @show cols = num_vars(data.model)
    @show get_objval(data.model)

    x = Xpress.get_lp_solution(data.model)

    @show maximum(x)
    @show minimum(x)

    nothing
end

Xpress.set_callback_intsol!(model, foo, data)

Xpress.optimize(model)


@show data
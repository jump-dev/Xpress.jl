using Xpress

NAME = "D:/Repositories/Xpress.jl/test/LP2022_new.lp"

model = Xpress.Model()

Xpress.read_model(model, NAME)

show(model)

data = eye(3,3)

function foo(data::Xpress.CallbackData)

    show(data.model)

    data.data[1] = 98

    println("fooooooooo")


    @show cols = num_vars(data.model)
    @show get_objval(data.model)
    x = zeros(cols)
    # x, slack, dual, red = Xpress.get_complete_lp_solution(data.model)
    x = Xpress.get_lp_solution(data.model)

    @show maximum(x)
    @show minimum(x)

    nothing
end

Xpress.set_callback_intsol!(model, foo, data)

Xpress.optimize(model)


@show data
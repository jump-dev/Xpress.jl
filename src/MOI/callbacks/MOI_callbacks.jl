@doc raw"""
    XpressCallback <: MOI.AbstractCallback
"""
abstract type XpressCallback <: MOI.AbstractCallback end

MOI.supports(::Xpress.Optimizer, ::XpressCallback) = true

include("MOI_message.jl")
include("MOI_optnode.jl")
include("MOI_preintsol.jl")

include("MOI_heuristic.jl")
include("MOI_lazy_constraint.jl")
include("MOI_user_cut.jl")

function moi_generic_wrapper(model::Optimizer, callback_data::CallbackData)
    get_callback_solution!(model, callback_data.node_model)

    moi_heuristic_wrapper(model, callback_data)
    moi_lazy_constraint_wrapper(model, callback_data)
    moi_user_cut_wrapper(model, callback_data)

    return nothing
end

function set_moi_generic_callback!(model::Optimizer)
    remove_xprs_optnode_callback!(model)

    return add_xprs_optnode_callback!(
        model,
        (callback_data::CallbackData) -> moi_generic_wrapper(model, callback_data),
    )
end

# States
@enum(
    CallbackState,
    CS_NONE,
    CS_GENERIC,
    # MOI Callbacks
    CS_MOI_LAZY_CONSTRAINT,
    CS_MOI_USER_CUT,
    CS_MOI_HEURISTIC,
    # Xpress Callbacks
    CS_XPRS_OPTNODE,
    CS_XPRS_PREINTSOL,
    CS_XPRS_MESSAGE,
)

function callback_state end

function state_callback end

# Callback Types
@enum(
    CallbackType,
    # MathOptInteface
    CT_MOI_GENERIC, # temporary
    CT_MOI_HEURISTIC,
    CT_MOI_LAZY_CONSTRAINT,
    CT_MOI_USER_CUT,
    # Xpress
    CT_XPRS_OPTNODE,
    CT_XPRS_PREINTSOL,
    CT_XPRS_MESSAGE,
)

@doc raw"""
    CallbackData

!!! warn
    All subtypes from [`CallbackData`](@ref) must be mutable.
"""
abstract type CallbackData end

@doc raw"""
    GenericCallbackData <: CallbackData
"""
mutable struct GenericCallbackData <: CallbackData
    root_model::XpressProblem
    node_model::Union{XpressProblem,Nothing}
    data::Any

    function GenericCallbackData(root_model::XpressProblem, data::Any=nothing)
        return new(root_model, nothing, data)
    end
end

@doc raw"""
    CallbackDataWrapper{CD}

This struct is nothing but a way to inject the julia function provided by the user into the Xpress callback.
"""
mutable struct CallbackDataWrapper{CD<:CallbackData}
    func::Function
    data::CD

    function CallbackDataWrapper{CD}(root_model::XpressProblem, func::Function, data::Any) where {CD}
        return new(func, CD(root_model, data))
    end
end

function CallbackDataWrapper(root_model::XpressProblem, func::Function, data::Any=nothing)
    return CallbackDataWrapper{GenericCallbackData}(root_model, func, data)
end

Base.cconvert(::Type{Ptr{Cvoid}}, x::CallbackDataWrapper) = x

function Base.unsafe_convert(::Type{Ptr{Cvoid}}, x::CallbackDataWrapper)
    return pointer_from_objref(x)::Ptr{Cvoid}
end

@doc raw"""
    CallbackInfo
"""
struct CallbackInfo{CD<:CallbackData}
    callback_ptr::Union{Ptr{Cvoid},Nothing}
    data_wrapper::CallbackDataWrapper{CD}
end

@doc raw"""
    CallbackCutData
"""
mutable struct CallbackCutData
    submitted::Bool
    cut_ptrs::Vector{Xpress.Lib.XPRScut}

    function CallbackCutData(
        submitted::Bool=false,
        cut_ptrs::Vector{Xpress.Lib.XPRScut}=Vector{Xpress.Lib.XPRScut}(undef, 0)
    )
        return new(submitted, cut_ptrs)
    end
end

function Base.empty!(cut_data::CallbackCutData)
    cut_data.submitted = false
    empty!(cut_data.cut_ptrs)
    
    return cut_data
end

function Base.isempty(cut_data::CallbackCutData)
    return !cut_data.submitted && isempty(cut_data.cut_ptrs)
end

include("XPRS_callbacks.jl")

@doc raw"""
    CallbackTable

This structure is designed to store information about high-level callbacks,
that is, the one that are exposed to the user.
"""
mutable struct CallbackTable
    # MathOptInteface
    moi_heuristic::Union{Tuple{CallbackInfo{OptNodeCallbackData}},Nothing}
    moi_lazy_constraint::Union{Tuple{CallbackInfo{OptNodeCallbackData}},Nothing}
    moi_user_cut::Union{Tuple{CallbackInfo{OptNodeCallbackData}},Nothing}
    # Xpress
    xprs_message::Union{CallbackInfo{MessageCallbackData},Nothing}
    xprs_optnode::Union{CallbackInfo{OptNodeCallbackData},Nothing}
    xprs_preintsol::Union{CallbackInfo{PreIntSolCallbackData},Nothing}

    function CallbackTable()
        return new(
            nothing, nothing, nothing,
            nothing, nothing, nothing,
        )
    end
end

function Base.empty!(table::CallbackTable)
    table.moi_heuristic = nothing
    table.moi_lazy_constraint = nothing
    table.moi_user_cut = nothing
    table.xprs_message = nothing
    table.xprs_optnode = nothing
    table.xprs_preintsol = nothing

    return table
end

function Base.isempty(table::CallbackTable)
    return isnothing(table.moi_heuristic) &&
           isnothing(table.moi_lazy_constraint) &&
           isnothing(table.moi_user_cut) &&
           isnothing(table.xprs_message) &&
           isnothing(table.xprs_optnode) &&
           isnothing(table.xprs_preintsol)
end
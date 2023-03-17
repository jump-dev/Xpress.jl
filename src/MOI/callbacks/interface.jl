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
    node_model::Union{XpressProblem, Nothing}
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
end

@doc raw"""
    XpressCallback <: MOI.AbstractCallback
"""
abstract type XpressCallback <: MOI.AbstractCallback end

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
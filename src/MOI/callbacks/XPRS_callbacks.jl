@doc raw"""
    XpressCallback <: MOI.AbstractCallback
"""
abstract type XpressCallback <: MOI.AbstractCallback end

MOI.supports(::Xpress.Optimizer, ::XpressCallback) = true

include("XPRS_message.jl")
include("XPRS_optnode.jl")
include("XPRS_preintsol.jl")
struct XpressError <: Exception
    msg::String
end

function fixinfinity(val::Float64)
    if val == Inf
        return XPRS_PLUSINFINITY
    elseif val == -Inf
        return XPRS_MINUSINFINITY
    else
        return val
    end
end

function fixinfinity!(vals::Vector{Float64})
    map!(fixinfinity, vals, vals)
end



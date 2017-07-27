# Objectives

function MOI.setobjective!(m::XpressSolverInstance, sense::MOI.OptimizationSense, func::MOI.ScalarAffineFunction{R}) where R<:Real

    if func.constant != 0.0
        return error("nope")
    end

    nvars = num_vars(m.inner)
    obj = zeros(Float64, nvars)

    v = getcols(m, func.variables)

    for i in eachindex(v)
        obj[i] = func.coefficients[i]
    end

    set_obj!(m.inner, obj)

    s = sense == MOI.MaxSense ? :maximize : :minimize
    if sense == MOI.FeasibilitySense
        warn("FeasibilitySense not supported. Using MinSense")
    end
    set_sense!(m.inner, s)

    return nothing
end

function MOI.modifyobjective!(m::XpressSolverInstance, mod::MOI.ScalarCoefficientChange{Float64})
    set_objcoeffs!(m.inner, Cint[getcol(m, mod.variable)], Float64[mod.new_coefficient])
end

# """
#     modifyobjective!(m::AbstractSolverInstance, change::AbstractFunctionModification)
# Apply the modification specified by `change` to the objective function of `m`.
# To change the function completely, call `setobjective!` instead.
# ### Examples
# ```julia
# modifyobjective!(m, ScalarConstantChange(10.0))
# ```
# """
# function modifyobjective! end
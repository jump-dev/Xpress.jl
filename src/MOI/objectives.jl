# Objectives

function setobjective!(m::XpressSolverInstance, sense::MOI.OptimizationSense, func::MOI.ScalarAffineFunction{R}) where R<:Real

    if func.constant != 0.0
        return error("nope")
    end

    v = refs2inds(m, func.variables)
    set_objcoeffs!(m.inner, v, func.coefficients)

    s = sense == MOI.MaxSense ? :maximize : :minimize
    if sense == MOI.FeasibilitySense
        warn("FeasibilitySense not supported. Using MinSense")
    end
    set_sense!(m.inner, s)

    return nothing
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
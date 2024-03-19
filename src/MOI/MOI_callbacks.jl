# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

"""
    CallbackFunction()

Set a generic Xpress callback function.
"""

struct CallbackFunction <: MOI.AbstractCallback end

MOI.supports(::Optimizer, ::CallbackFunction) = true

function MOI.set(model::Optimizer, ::CallbackFunction, ::Nothing)
    if model.callback_data !== nothing
        Lib.XPRSremovecboptnode(model.inner, C_NULL, C_NULL)
        model.callback_data = nothing
    end
    model.has_generic_callback = false
    return
end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    if model.callback_data !== nothing
        Lib.XPRSremovecboptnode(model.inner, C_NULL, C_NULL)
        model.callback_data = nothing
    end
    model.has_generic_callback = true
    model.callback_data = set_callback_optnode!(
        model.inner,
        (cb_data) -> begin
            model.callback_state = CB_GENERIC
            f(cb_data)
            model.callback_state = CB_NONE
        end,
    )
    return
end

function get_cb_solution(model::Optimizer, model_inner::XpressProblem)
    reset_callback_cached_solution(model)
    Lib.XPRSgetlpsol(
        model_inner,
        model.callback_cached_solution.variable_primal,
        model.callback_cached_solution.linear_primal,
        model.callback_cached_solution.linear_dual,
        model.callback_cached_solution.variable_dual,
    )
    return
end

function _load_existing_cuts(model::Optimizer, cb_data::CallbackData)
    if isempty(model.cb_cut_data.cutptrs)
        return false
    end
    p_ncuts = Ref{Cint}(0)
    size = length(model.cb_cut_data.cutptrs)
    mcutptr = Vector{Lib.XPRScut}(undef, size)
    dviol = Vector{Cdouble}(undef, size)
    @checked Lib.XPRSgetcpcutlist(
        cb_data.model,
        1, # itype
        -1, # interp
        0.0, # delta
        p_ncuts,
        size,
        mcutptr,
        dviol,
    )
    @checked Lib.XPRSloadcuts(cb_data.model, 1, -1, p_ncuts[], mcutptr)
    return p_ncuts[] > 0
end

# ==============================================================================
#    MOI callbacks
# ==============================================================================

function default_moi_callback(model::Optimizer)
    return (cb_data) -> begin
        get_cb_solution(model, cb_data.model)
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            cb_count = @_invoke Lib.XPRSgetintattrib(
                cb_data.model,
                Lib.XPRS_CALLBACKCOUNT_OPTNODE,
                _,
            )::Int
            if cb_count > 1
                return
            end
            model.heuristic_callback(cb_data)
        end
        if model.user_cut_callback !== nothing
            model.callback_state = CB_USER_CUT
            if _load_existing_cuts(model, cb_data)
                return
            end
            cb_count = @_invoke Lib.XPRSgetintattrib(
                cb_data.model,
                Lib.XPRS_CALLBACKCOUNT_OPTNODE,
                _,
            )::Int
            if cb_count > 2
                return
            end
            model.user_cut_callback(cb_data)
        end
        if model.lazy_callback !== nothing
            model.callback_state = CB_LAZY
            if _load_existing_cuts(model, cb_data)
                return
            end
            model.lazy_callback(cb_data)
        end
    end
    return
end

function MOI.get(model::Optimizer, attr::MOI.CallbackNodeStatus{CallbackData})
    if !check_moi_callback_validity(model)
        return MOI.CALLBACK_NODE_STATUS_UNKNOWN
    end
    mip_infeas = @_invoke Lib.XPRSgetintattrib(
        attr.callback_data.model,
        Lib.XPRS_MIPINFEAS,
        _,
    )::Int
    if mip_infeas == 0
        return MOI.CALLBACK_NODE_STATUS_INTEGER
    end
    return MOI.CALLBACK_NODE_STATUS_FRACTIONAL
end

function MOI.get(
    model::Optimizer,
    ::MOI.CallbackVariablePrimal{CallbackData},
    x::MOI.VariableIndex,
)
    column = _info(model, x).column
    return model.callback_cached_solution.variable_primal[column]
end

function callback_exception(model::Optimizer, cb, err::Exception)
    model.cb_exception = err
    Lib.XPRSinterrupt(cb.callback_data.model, Lib.XPRS_STOP_USER)
    return
end

function _throw_if_invalid_state(model, cb, calling_state)
    if model.callback_state in (calling_state, CB_NONE, CB_GENERIC)
        return
    end
    attr = if model.callback_state == CB_HEURISTIC
        MOI.HeuristicCallback()
    elseif model.callback_state == CB_LAZY
        MOI.LazyConstraintCallback()
    else
        @assert model.callback_state == CB_USER_CUT
        MOI.UserCutCallback()
    end
    return callback_exception(model, cb, MOI.InvalidCallbackUsage(attr, cb))
end
# ==============================================================================
#    MOI.UserCutCallback  & MOI.LazyConstraint
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.UserCutCallback, cb::Function)
    MOI.set(model, MOI.RawOptimizerAttribute("MIPDUALREDUCTIONS"), 0)
    model.user_cut_callback = cb
    return
end

MOI.supports(::Optimizer, ::MOI.UserCutCallback) = true

MOI.supports(::Optimizer, ::MOI.UserCut{CallbackData}) = true

function MOI.submit(
    model::Optimizer,
    cb::MOI.UserCut{CallbackData},
    f::MOI.ScalarAffineFunction{Float64},
    s::Union{
        MOI.LessThan{Float64},
        MOI.GreaterThan{Float64},
        MOI.EqualTo{Float64},
    },
)
    model.cb_cut_data.submitted = true
    _throw_if_invalid_state(model, cb, CB_USER_CUT)
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)
    mindex = Vector{Lib.XPRScut}(undef, 1)
    @checked Lib.XPRSstorecuts(
        cb.callback_data.model,
        1,                          # ncuts
        2,                          # nodupl,
        Cint[1],                    # mtype
        [sense],                    # sensetype,
        [rhs - f.constant],         # drhs
        Cint[0, length(indices)],   # mstart
        mindex,
        Cint.(indices .- 1),        # mcols
        coefficients,
    )
    @checked Lib.XPRSloadcuts(cb.callback_data.model, 1, Cint(-1), 1, mindex)
    push!(model.cb_cut_data.cutptrs, mindex[1])
    return
end

# ==============================================================================
#    MOI.LazyConstraint
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.LazyConstraintCallback, cb::Function)
    MOI.set(model, MOI.RawOptimizerAttribute("MIPDUALREDUCTIONS"), 0)
    model.lazy_callback = cb
    return
end

MOI.supports(::Optimizer, ::MOI.LazyConstraintCallback) = true

function MOI.submit(
    model::Optimizer,
    cb::MOI.LazyConstraint{CallbackData},
    f::MOI.ScalarAffineFunction{Float64},
    s::Union{
        MOI.LessThan{Float64},
        MOI.GreaterThan{Float64},
        MOI.EqualTo{Float64},
    },
)
    model.cb_cut_data.submitted = true
    _throw_if_invalid_state(model, cb, CB_LAZY)
    indices, coefficients = _indices_and_coefficients(model, f)
    sense, rhs = _sense_and_rhs(s)
    mindex = Vector{Lib.XPRScut}(undef, 1)
    @checked Lib.XPRSstorecuts(
        cb.callback_data.model,
        1,                          # ncuts
        2,                          # nodupl,
        Cint[1],                    # mtype
        [sense],                    # sensetype,
        [rhs - f.constant],         # drhs
        Cint[0, length(indices)],   # mstart
        mindex,
        Cint.(indices .- 1),        # mcols
        coefficients,
    )
    @checked Lib.XPRSloadcuts(cb.callback_data.model, 1, Cint(-1), 1, mindex)
    push!(model.cb_cut_data.cutptrs, mindex[1])
    return
end

MOI.supports(::Optimizer, ::MOI.LazyConstraint{CallbackData}) = true

# ==============================================================================
#    MOI.HeuristicCallback
# ==============================================================================

function MOI.set(model::Optimizer, ::MOI.HeuristicCallback, cb::Function)
    model.heuristic_callback = cb
    return
end

MOI.supports(::Optimizer, ::MOI.HeuristicCallback) = true

function MOI.submit(
    model::Optimizer,
    cb::MOI.HeuristicSolution{CallbackData},
    variables::Vector{MOI.VariableIndex},
    values::MOI.Vector{Float64},
)
    _throw_if_invalid_state(model, cb, CB_HEURISTIC)
    nnz = length(variables)
    mipsolcol = if nnz == MOI.get(model, MOI.NumberOfVariables())
        C_NULL
    else
        Cint[_info(model, x).column - 1 for x in variables]
    end
    model_cb = cb.callback_data.model::XpressProblem
    @checked Lib.XPRSaddmipsol(model_cb, nnz, values, mipsolcol, C_NULL)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end

MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true

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
        ret = XPRSremovecboptnode(model, C_NULL, C_NULL)
        _check(model, ret)
        model.callback_data = nothing
    end
    model.has_generic_callback = false
    return
end

struct CallbackData
    model::XpressProblem
end

function _cboptnode(cbprob::XPRSprob, cbdata::Ptr{Cvoid}, ::Ptr{Cint})
    user_data = unsafe_pointer_to_objref(cbdata)::_CallbackUserData
    prob = XpressProblem(cbprob; finalize_env = false)
    user_data.callback(CallbackData(prob))
    return Cint(0)
end

function MOI.set(model::Optimizer, ::CallbackFunction, f::Function)
    MOI.set(model, CallbackFunction(), nothing)  # Clear any existing callback
    model.has_generic_callback = true
    function callback(cb_data::CallbackData)
        model.callback_state = CB_GENERIC
        try
            reenable_sigint(() -> f(cb_data))
        catch ex
            if ex isa InterruptException
                _ = XPRSinterrupt(model, XPRS_STOP_CTRLC)
            else
                model.cb_exception = ex
                _ = XPRSinterrupt(cb_data.model, XPRS_STOP_USER)
            end
        end
        model.callback_state = CB_NONE
        return
    end
    model.callback_data = _CallbackUserData(callback)
    cb = @cfunction(_cboptnode, Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cint}))
    ret = XPRSaddcboptnode(model, cb, model.callback_data, 0)
    _check(model, ret)
    # Disable calling the callback from anything other than the main thread
    ret = XPRSsetintcontrol(model, XPRS_CALLBACKFROMMAINTHREAD, 1)
    _check(model, ret)
    return
end

function get_cb_solution(model::Optimizer, model_inner::XpressProblem)
    model.callback_cached_solution = _reset_cached_solution(
        model.callback_cached_solution,
        length(model.variable_info),
        length(model.affine_constraint_info),
    )
    ret = XPRSgetlpsol(
        model_inner,
        model.callback_cached_solution.variable_primal,
        model.callback_cached_solution.linear_primal,
        model.callback_cached_solution.linear_dual,
        model.callback_cached_solution.variable_dual,
    )
    _check(model_inner, ret)
    return
end

function _load_existing_cuts(model::Optimizer, cb_data::CallbackData)
    if isempty(model.cb_cut_data.cutptrs)
        return false
    end
    p_ncuts = Ref{Cint}(0)
    size = length(model.cb_cut_data.cutptrs)
    mcutptr = Vector{XPRScut}(undef, size)
    dviol = Vector{Cdouble}(undef, size)
    ret = XPRSgetcpcutlist(
        cb_data.model,
        1, # itype
        -1, # interp
        0.0, # delta
        p_ncuts,
        size,
        mcutptr,
        dviol,
    )
    _check(model, ret)
    ret = XPRSloadcuts(cb_data.model, 1, -1, p_ncuts[], mcutptr)
    _check(model, ret)
    return p_ncuts[] > 0
end

# ==============================================================================
#    MOI callbacks
# ==============================================================================

function default_moi_callback(model::Optimizer)
    function default_callback(cb_data)
        # If we added a cut from the existing pool, it means that the current
        # solution violates a cut that we previously added but that has since
        # been deleted.
        #
        # TODO(odow): could we remove this? We don't enforce it for any other
        # solver.
        if _load_existing_cuts(model, cb_data)
            return
        end
        # Check if this callback has been called at this solution before and
        # exit. We should be called only once at each node.
        attr = XPRS_CALLBACKCOUNT_OPTNODE
        pInt = Ref{Cint}(0)
        ret = XPRSgetintattrib(cb_data.model, attr, pInt)
        _check(model, ret)
        if pInt[] > 1
            return
        end
        get_cb_solution(model, cb_data.model)
        if model.heuristic_callback !== nothing
            model.callback_state = CB_HEURISTIC
            model.heuristic_callback(cb_data)
        end
        if model.user_cut_callback !== nothing
            model.callback_state = CB_USER_CUT
            model.user_cut_callback(cb_data)
        end
        if model.lazy_callback !== nothing
            model.callback_state = CB_LAZY
            model.lazy_callback(cb_data)
        end
        return
    end
    return default_callback
end

function MOI.get(model::Optimizer, attr::MOI.CallbackNodeStatus{CallbackData})
    if !_check_moi_callback_validity(model)
        return MOI.CALLBACK_NODE_STATUS_UNKNOWN
    end
    pInt = Ref{Cint}(0)
    ret = XPRSgetintattrib(attr.callback_data.model, XPRS_MIPINFEAS, pInt)
    _check(model, ret)
    if pInt[] == 0
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
    model.cb_exception = MOI.InvalidCallbackUsage(attr, cb)
    _ = XPRSinterrupt(cb.callback_data.model, XPRS_STOP_USER)
    return
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
    mindex = Vector{XPRScut}(undef, 1)
    ret = XPRSstorecuts(
        cb.callback_data.model,
        1,                          # ncuts
        2,                          # nodupl,
        Cint[1],                    # mtype
        [sense],                    # sensetype,
        [rhs - f.constant],         # drhs
        Cint[0, length(indices)],   # mstart
        mindex,
        indices,                    # mcols
        coefficients,
    )
    _check(model, ret)
    ret = XPRSloadcuts(cb.callback_data.model, 1, Cint(-1), 1, mindex)
    _check(model, ret)
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
    mindex = Vector{XPRScut}(undef, 1)
    ret = XPRSstorecuts(
        cb.callback_data.model,
        1,                          # ncuts
        2,                          # nodupl,
        Cint[1],                    # mtype
        [sense],                    # sensetype,
        [rhs - f.constant],         # drhs
        Cint[0, length(indices)],   # mstart
        mindex,
        indices,                    # mcols
        coefficients,
    )
    _check(model, ret)
    ret = XPRSloadcuts(cb.callback_data.model, 1, Cint(-1), 1, mindex)
    _check(model, ret)
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
    ret = XPRSaddmipsol(model_cb, nnz, values, mipsolcol, C_NULL)
    _check(model, ret)
    return MOI.HEURISTIC_SOLUTION_UNKNOWN
end

MOI.supports(::Optimizer, ::MOI.HeuristicSolution{CallbackData}) = true

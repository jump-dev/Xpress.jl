@doc raw"""
    PreIntSolCallbackData
"""
mutable struct PreIntSolCallbackData <: CallbackData
    root_model::XpressProblem
    node_model::Union{XpressProblem,Nothing}

    data::Any

    cbprob::Union{Xpress.Lib.XPRSprob,Nothing}
    cbdata::Union{Ptr{Cvoid},Nothing}
    soltype::Union{Ptr{Cint},Nothing}
    p_reject::Union{Ptr{Cint},Nothing}
    p_cutoff::Union{Ptr{Cdouble},Nothing}

    function PreIntSolCallbackData(root_model::XpressProblem, data::Any = nothing)
        return new(
            root_model,
            nothing, # node_model
            data,
            nothing, # cprob
            nothing, # cbdata
            nothing, # soltype
            nothing, # p_reject
            nothing, # p_cutoff
        )
    end
end

@doc raw"""
    xprs_preintsol(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, soltype::Ptr{Cint}, p_reject::Ptr{Cint}, p_cutoff::Ptr{Cdouble})
"""
function xprs_preintsol(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, soltype::Ptr{Cint}, p_reject::Ptr{Cint}, p_cutoff::Ptr{Cdouble})
    data_wrapper = unsafe_pointer_to_objref(cbdata)::CallbackDataWrapper{PreIntSolCallbackData}

    # Update callback data
    data_wrapper.data.node_model = XpressProblem(cbprob; finalize_env = false)

    # Update function args
    data_wrapper.data.cbprob = cbprob
    data_wrapper.data.soltype = soltype
    data_wrapper.data.p_reject = p_reject
    data_wrapper.data.p_cutoff = p_cutoff

    # Call user-defined function
    data_wrapper.func(data_wrapper.data)

    return zero(Cint)
end

@doc raw"""
    add_xprs_preintsol_callback!(
        model::XpressProblem,
        callback::Function,
        data::Any=nothing,
        priority::Integer = 0,
    )

From the Xpress 40.01 Manual:

# `XPRSaddcbpreintsol`

## Purpose

Declares a user integer solution callback function, called when an integer solution is found by heuristics
or during the branch and bound search, but before it is accepted by the Optimizer. This callback function
will be called in addition to any integer solution callbacks already added by XPRSaddcbpreintsol.

## Synopsis

```c
int XPRS_CC XPRSaddcbpreintsol(
    XPRSprob prob,
    void (XPRS_CC *preintsol)(XPRSprob cbprob, void *cbdata, int soltype, int *p_reject, double *p_cutoff),
    void *data,
    int priority,
);
```

## Arguments

- `prob` The current problem.
- `preintsol` The callback function which takes five arguments, `cbprob`, `cbdata`, `soltype`, `p_reject` and `p_cutoff`, and has no return value. This function is called when an integer solution is found, but before the solution is accepted by the Optimizer, allowing the user to reject the solution.
- `cbprob` The problem passed to the callback function, `preintsol`.
- `cbdata` The user-defined data passed as data when setting up the callback with `XPRSaddcbpreintsol`.
- `soltype` The type of MIP solution that has been found: Set to 1 if the solution was found using a heuristic. Otherwise, it will be the global feasible solution to the current node of the global search.
    - 0 The continuous relaxation solution to the current node of the global search, which has been found to be global feasible.
    - 1 A MIP solution found by a heuristic.
    - 2 A MIP solution provided by the user.
    - 3 A solution resulting from refinement of primal or dual violations of a previous MIP solution.
- `p_reject` Set this to 1 if the solution should be rejected.
- `p_cutoff` The new cutoff value that the Optimizer will use if the solution is accepted. If the user changes `p_cutoff`, the new value will be used instead. The cutoff value will not be updated if the solution is rejected.
- `data` A user-defined data to be passed to the callback function, `preintsol`.
- `priority` An integer that determines the order in which callbacks of this type will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.
"""
function add_xprs_preintsol_callback!(model::XpressProblem, func::Function, data::Any=nothing, priority::Integer=0)
    callback_ptr = @cfunction(xprs_preintsol, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}))
    data_wrapper = CallbackDataWrapper{PreIntSolCallbackData}(model, func, data)

    Lib.XPRSaddcbpreintsol(
        model.ptr,
        callback_ptr,
        data_wrapper,
        Cint(priority),
    )

    return CallbackInfo{PreIntSolCallbackData}(callback_ptr, data_wrapper)
end

function remove_xprs_preintsol_callback!(model::XpressProblem)
    Lib.XPRSremovecbpreintsol(model, C_NULL, C_NULL)

    return nothing
end

function remove_xprs_preintsol_callback!(model::XpressProblem, info::CallbackInfo{CD}) where {CD <: CallbackData}
    Lib.XPRSremovecbpreintsol(model, info.callback_ptr, C_NULL)

    return nothing
end

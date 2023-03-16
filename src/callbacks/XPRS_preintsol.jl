struct PreIntSol <: XpressCallback end


@doc raw"""
    addcbpreintsol_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, soltype::Ptr{Cint}, p_reject::Ptr{Cint}, p_cutoff::Ptr{Cdouble})
"""
function addcbpreintsol_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, soltype::Ptr{Cint}, p_reject::Ptr{Cint}, p_cutoff::Ptr{Cdouble})
    node_model = XpressProblem(cbprob; finalize_env=false)
    user_callback_data = unsafe_pointer_to_objref(cbdata)::UserCallbackData
    callback_data = CallbackData(node_model, user_callback_data)

    user_callback_data.callback(callback_data)

    return zero(Cint)
end

@doc raw"""
    set_callback_preintsol!(
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
function set_callback_preintsol!(model::XpressProblem, callback::Function, data::Any=nothing, priority::Integer=0)
    callback_ptr = @cfunction(addcbpreintsol_wrapper, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}))
    user_callback_data = UserCallbackData(callback, model, data)

    Lib.XPRSaddcbpreintsol(
        model.ptr,          # XPRSprob prob
        callback_ptr,       # void (XPRS_CC * preintsol)(XPRSprob cbprob, void *cbdata, int soltype, int *p_reject, double *p_cutoff)
        user_callback_data, # void *data
        Cint(priority),     # int priority
    )

    # we need to keep a reference to the callback function
    # so that it isn't garbage collected
    return (callback_ptr, user_callback_data)
end

function remove_callback_preintsol!(model::XpressProblem)
    Lib.XPRSremovecbpreintsol(model.inner, C_NULL, C_NULL)
end
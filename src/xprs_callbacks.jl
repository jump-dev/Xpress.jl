export CallbackData

@doc raw"""
    CallbackData(
        root_model::XpressProblem,
        node_model::XpressProblem,
        data::Any,
        infeasible::Ptr{Cint},
    )

!!! warn
    No operations should be applied to `root_model`.
"""
mutable struct CallbackData
    root_model::XpressProblem # prob
    node_model::XpressProblem # cbprob
    data::Any                 # cbdata

    function CallbackData(
        root_model::XpressProblem,
        node_model::XpressProblem,
        data::Any,
    )
        return new(root_model, node_model, data)
    end
end

Base.broadcastable(x::CallbackData) = Ref(x)

@doc raw"""
    UserCallbackData(callback::Function, model::XpressProblem, data::Any)

This struct must be mutable.
"""
mutable struct UserCallbackData
    callback::Union{Function,Nothing} # optnode, preintsol, message...
    model::XpressProblem              # cbprob
    data::Any                         # cbdata
end

Base.cconvert(::Type{Ptr{Cvoid}}, x::UserCallbackData) = x

function Base.unsafe_convert(::Type{Ptr{Cvoid}}, x::UserCallbackData)
    return pointer_from_objref(x)::Ptr{Cvoid}
end

function CallbackData(node_model::XpressProblem, user_callback_data::UserCallbackData)
    return CallbackData(
        user_callback_data.model,
        node_model,
        user_callback_data.data,
    )
end

@doc raw"""
    addcboptnode_wrapper(
        cbprob::Lib.XPRSprob,
        cbdata::Ptr{Cvoid},
        p_infeasible::Ptr{Cint},
    )
"""
function addcboptnode_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, p_infeasible::Ptr{Cint}=C_NULL)
    node_model = XpressProblem(cbprob; finalize_env=false)
    user_callback_data = unsafe_pointer_to_objref(cbdata)::UserCallbackData
    callback_data = CallbackData(node_model, user_callback_data)

    user_callback_data.callback(callback_data)

    return zero(Cint)
end

@doc raw"""
    set_callback_optnode!(
        model::XpressProblem,
        callback::Function,
        data::Any = nothing,
        priority::Integer = 0,
    )

From the Xpress 40.01 Manual:

# `XPRSaddcboptnode`

## Purpose

Declares an optimal node callback function, called during the branch and bound search, after the LP
relaxation has been solved for the current node, and after any internal cuts and heuristics have been
applied, but before the Optimizer checks if the current node should be branched. This callback function
will be called in addition to any callbacks already added by XPRSaddcboptnode.

## Synopsis

```c
int XPRS_CC XPRSaddcboptnode(
    XPRSprob prob,
    void (XPRS_CC *optnode)(XPRSprob cbprob, void *cbdata, int *p_infeasible),
    void *data,
    int priority
);
```

## Arguments
- `prob` The current problem.
- `optnode` The callback function which takes three arguments, `cbprob`, `cbdata` and `p_infeasible`, and has no return value.
    - `cbprob` The problem passed to the callback function, `optnode`.
    - `cbdata` The user-defined data passed as data when setting up the callback with `XPRSaddcboptnode`.
    - `p_infeasible`` The feasibility status. If set to a nonzero value by the user, the current node will be declared infeasible.
- `data` A user-defined data to be passed to the callback function, `optnode`.
- `priority` An integer that determines the order in which multiple node-optimal callbacks will be invoked. The callback added with a higher priority will be called before a callback with a lower priority. Set to 0 if not required.

## Example
The following prints the optimal objective value of the node LP relaxations:

```c
XPRSaddcboptnode(prob,nodeOptimal,NULL,0);
XPRSmipoptimize(prob,"");
```

The callback function might resemble:

```c
void XPRS_CC nodeOptimal(XPRSprob prob, void *data, int *p_infeasible)
{
    int node;
    double objval;
    XPRSgetintattrib(prob, XPRS_CURRENTNODE, &node);
    printf("NodeOptimal: node number %d\n", node);
    XPRSgetdblattrib(prob, XPRS_LPOBJVAL, &objval);
    printf("\tObjective function value = %f\n", objval);
}
```

See the example depthfirst.c in the `examples/optimizer/c` folder.
"""
function set_callback_optnode!(model::XpressProblem, callback::Function, data::Any=nothing, priority::Integer=0)
    callback_ptr = @cfunction(addcboptnode_wrapper, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}))
    user_callback_data = UserCallbackData(callback, model, data)

    Lib.XPRSaddcboptnode(
        model.ptr,          # XPRSprob prob
        callback_ptr,       # void (XPRS_CC *optnode)(XPRSprob cbprob, void *cbdata, int *p_infeasible)
        user_callback_data, # void *data
        Cint(priority),     # int priority
    )

    # Keep a reference to the callback function to avoid garbage collection
    return (callback_ptr, user_callback_data)
end

@doc raw"""
    remove_callback_optnode!(model::XpressProblem)

From the Xpress 40.01 Manual:

# XPRSremovecboptnode

## Purpose
Removes a node-optimal callback function previously added by XPRSaddcboptnode. The specified callback function will no longer be called after it has been removed.

## Synopsis

```c
int XPRS_CC XPRSremovecboptnode(
    XPRSprob prob,
    void (XPRS_CC *optnode)(XPRSprob my_prob, void *my_object, int *feas),
    void *data
);
```

## Arguments
    - `prob` The current problem.
    - `optnode` The callback function to remove. If NULL then all node-optimal callback functions added with the given user-defined data value will be removed.
    - `data` The data value that the callback was added with. If NULL, then the data value will not be checked and all node-optimal callbacks with the function pointer optnode will be removed.
"""
function remove_callback_optnode!(model::XpressProblem)
    Lib.XPRSremovecboptnode(model.inner, C_NULL, C_NULL)
end

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

@doc raw"""
    addcbmessage_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, msg::Ptr{Cchar}, len::Cint, msgtype::Cint)
"""
function addcbmessage_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, msg::Ptr{Cchar}, msglen::Cint, msgtype::Cint)
    user_callback_data = unsafe_pointer_to_objref(cbdata)::UserCallbackData
    show_warning = user_callback_data.data::Bool

    if msgtype == 1
        #= Information =#
        println(unsafe_string(msg))
        return zero(Cint)
    elseif msgtype == 2
        #= Not used =#
        return zero(Cint)
    elseif msgtype == 3
        #= Warning =#
        if show_warning
            println(unsafe_string(msg))
        end
        return zero(Cint)
    elseif msgtype == 4
        #= Error =#
        return zero(Cint)
    else
        #= Exiting - buffers need flushing  =#
        flush(stdout)
        return zero(Cint)
    end
end

@doc raw"""
    set_callback_message!(model::XpressProblem, show_warning::Bool)
"""
function set_callback_message!(model::XpressProblem, show_warning::Bool, priority::Integer = 0)
    callback_ptr = @cfunction(addcbmessage_wrapper, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cchar}, Cint, Cint))
    user_callback_data = UserCallbackData(nothing, model, show_warning)

    Lib.XPRSaddcbmessage(
        model.ptr,          # XPRSprob prob
        callback_ptr,       # void (XPRS_CC *message)(XPRSprob cbprob, void *cbdata, const char *msg, int msglen, int msgtype)
        user_callback_data, # void *data
        Cint(priority)      # int priority
    )

    return (callback_ptr, user_callback_data)
end

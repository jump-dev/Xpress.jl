struct OptNodeCallback <: XpressCallback end

mutable struct OptNodeCallbackData <: CallbackData
    # models
    root_model::XpressProblem
    node_model::Union{XpressProblem, Nothing}

    # data
    data::Any
    
    # args
    cbprob::Union{Lib.XPRSprob, Nothing}
    # cbdata::Union{Ptr{Cvoid}, Nothing}
    p_infeasible::Union{Ptr{Cint}, Nothing}

    function OptNodeCallbackData(root_model::XpressProblem, data::Any = nothing)
        return new(
            root_model,
            nothing, # node_model
            data,
            nothing, # cbprob
            # nothing, # cbdata
            nothing, # p_infeasible
        )
    end
end

@doc raw"""
    xprs_optnode_wrapper(
        cbprob::Lib.XPRSprob,
        cbdata::Ptr{Cvoid},
        p_infeasible::Ptr{Cint},
    )
"""
function xprs_optnode_wrapper(cbprob::Lib.XPRSprob, cbdata::Ptr{Cvoid}, p_infeasible::Ptr{Cint}=C_NULL)
    data_wrapper = unsafe_pointer_to_objref(cbdata)::CallbackDataWrapper{OptNodeCallbackData}

    # Update callback data
    data_wrapper.data.node_model = XpressProblem(cbprob; finalize_env = false)

    # Update function args
    data_wrapper.data.cbprob = cbprob
    data_wrapper.data.p_infeasible = p_infeasible

    # Call user-defined function
    data_wrapper.func(data_wrapper.data)
    
    return zero(Cint)
end

@doc raw"""
    set_xprs_optnode_callback!(
        model::XpressProblem,
        callback::Function,
        data::Any = nothing,
        priority::Integer = 0,
    )

# Example

```julia
model = Model(Xpress.Optimizer)

MOI.set(
    model,
    Xpress.OptNodeCallback(),
    (callback_data::Xpress.OptNodeCallbackData) -> begin
        # The user should be able to access the arguments provided to the callback.
        # They also have the same type as in the C interface!
        callback_data.cbprob       # Xpress Problem C pointer
        # callback_data.cbdata     # This one is not available here, sorry.
        callback_data.p_infeasible # int pointer

        # Special cases are:
        callback_data.root_model # wrapped in a julia type
        callback_data.node_model # wrapped in a julia type
        callback_data.data       # This is cbdata's reference, not a pointer anymore!
    end
)
```

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
function set_xprs_optnode_callback!(model::Xpress.Optimizer, func::Function, data::Any=nothing, priority::Integer=0)
    callback_ptr = @cfunction(xprs_optnode_wrapper, Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}))
    data_wrapper = CallbackDataWrapper{OptNodeCallbackData}(model.inner, func, data)

    Lib.XPRSaddcboptnode(
        model.inner.ptr, # XPRSprob prob
        callback_ptr,    # void (XPRS_CC *optnode)(XPRSprob cbprob, void *cbdata, int *p_infeasible)
        data_wrapper,    # void *data
        Cint(priority),  # int priority
    )

    # Keep a reference to the callback function to avoid garbage collection
    # TODO: Handle reference-tracking properly
    model.callback_info[:xprs_optnode] = CallbackInfo{OptNodeCallbackData}(callback_ptr, data_wrapper)

    return nothing
end

@doc raw"""
    remove_xprs_optnode_callback!(model::XpressProblem)

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
function remove_xprs_optnode_callback!(model::Xpress.Optimizer)
    Lib.XPRSremovecboptnode(model.inner, C_NULL, C_NULL)

    model.callback_info[:xprs_optnode] = nothing

    return nothing
end

function MOI.set(model::Optimizer, ::OptNodeCallback, ::Nothing)
    if !isnothing(get(model.callback_info, :xprs_optnode, nothing))
        remove_xprs_optnode_callback!(model)
    end

    return nothing
end

function MOI.set(model::Optimizer, attr::OptNodeCallback, func::Function)
    # remove any existing callback definitions
    MOI.set(model, attr, nothing)

    set_xprs_optnode_callback!(model, func)

    return nothing
end

MOI.supports(::Optimizer, ::OptNodeCallback) = true

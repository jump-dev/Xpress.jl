function _invoke(f::Function, pos::Int, ::Type{Float64}, args...)
    out = Ref{Float64}(0.0) # should we use Cfloat here instead?

    args = collect(args)
    insert!(args, pos-1, out)

    r = f(args...)
    if r != 0 
        throw(XpressError(r, "Unable to invoke $f"))
    end
    return out[]
end

function _invoke(f::Function, pos::Int, ::Type{Int}, args...)
    out = Ref{Cint}(0)

    args = collect(args)
    insert!(args, pos-1, out)

    r = f(args...)
    if r != 0
        throw(XpressError(r, "Unable to invoke $f"))
    end
    return out[]
end

function _invoke(f::Function, pos::Int, ::Type{String}, args...)
    buffer = Array{Cchar}(undef, 1024)
    buffer_p = pointer(buffer)
    GC.@preserve buffer begin
        out = Cstring(buffer_p)
        args = collect(Any, args)
        insert!(args, pos-1, out)
        r = f(args...)
        if r != 0
            throw(XpressError(r, "Unable to invoke $f"))
        end
        return unsafe_string(out)
    end
end

"""
    @_invoke expr

Lets you invoke a lower level `Lib` function.
Xpress' library API expects the caller to pre-allocate memory.
Use this macro to minimize repetition and increase readability.

This macro expects syntax that mimics the call to the `Lib.function`.
The `_` argument must be used for all arguments where the `Lib.function` expects the caller to manage memory.
Additionally, the return type declaration must be used.

Examples:

    @_invoke Lib.XPRSgetversion(_)::String
    @_invoke Lib.XPRSgetbanner(_)::String
    @_invoke Lib.XPRSgetprobname(prob, _)::String

As an example of what @_invoke expands to:

```
julia> @macroexpand @_invoke Lib.XPRSgetversion(_)::String
:(_invoke(Lib.XPRSgetversion, Xpress.String))
```

"""
macro _invoke(expr)
    @assert expr.head == :(::) "macro argument must have return type declaration"

    # macro return type must be a valid type that exists in Xpress or Julia
    return_type = expr.args[2]

    f = expr.args[1]

    @assert f.head == :call "macro argument must have a function call"
    @assert :_ in f.args[2:end] "macro argument must have an underscore argument"

    # Remove all `_` arguments
    # TODO: note the positions and pass positions to the invoke function
    indices = findall(x->x==:_, f.args)
    filter!(x->x≠:_, f.args)

    # Call invoke function at macro call site instead
    pushfirst!(f.args, :(_invoke))

    f.args = esc.(f.args)

    # invoke function takes the position of return type as the first argument
    # invoke function takes the return type as the first argument
    # invoke function uses this argument to dispatch to the correct method
    if length(indices) == 1
        insert!(f.args, 3, return_type)
        insert!(f.args, 3, indices[1])
    else
        # TODO: Implement multiple return types
        error("Not implemented @_invoke macro for multiple `_`")
    end

    return f
end

function get_xpress_error_message(xprs_ptr)
    "(Unable to extract error message for $(typeof(xprs_ptr)).)"
end

"""
    @checked f(prob)

Lets you invoke a lower level `Lib` function and check that Xpress does not error.
Use this macro to minimize repetition and increase readability.

The first argument must be a object that can be cast into an Xpress pointer, e.g. `Ptr{XpressProblem}`.
This is passed to `get_xpress_error_message(xprs_ptr)` to get the error message.

Examples:

    @checked Lib.XPRSsetprobname(prob, name)

As an example of what @checked expands to:

```
julia> @macroexpand @checked Lib.XPRSsetprobname(prob, name)
quote
    r = Lib.XPRSsetprobname(prob, name)::Cint
    _check(prob, r)
end
```

"""
macro checked(expr)
    @assert expr.head == :call "Can only use @checked on function calls"
    @assert ( expr.args[1].head == :(.) ) && ( expr.args[1].args[1] == :Lib) "Can only use @checked on Lib.\$function"
    @assert length(expr.args) >= 2 "Lib.\$function must be contain atleast one argument and the first argument must be of type XpressProblem"
    f = replace(String(expr.args[1].args[2].value), "XPRS" => "")
    return esc(quote
        r = $(expr)::Cint
        _check($(expr.args[2]), r)::Nothing
    end)
end

function _check(prob, val::Cint)
    if val != 0
        e = get_xpress_error_message(prob)
        throw(XpressError(val, "Xpress internal error:\n\n$e.\n"))
    end
    return nothing
end
function invoke(f::Function, pos::Int, ::Type{String}, args...)

    out = Cstring(pointer(Array{Cchar}(undef, 1024)))

    args = Vector(args...)
    insert!(args, pos, out)

    r = f(args...)
    r != 0 && throw(XpressError("Unable to invoke $f"))

    s = unsafe_string(out)

    return s
end

"""
    @invoke expr

Lets you invoke a lower level `Lib` function.
Xpress' library API expects the caller to pre-allocate memory.
Use this macro to minimize repetition and increase readability.

This macro expects syntax that mimics the call to the `Lib.function`.
The `_` argument must be used for all arguments where the `Lib.function` expects the caller to manage memory.
Additionally, the return type declaration must be used.

Examples:

    @invoke Lib.XPRSgetversion(_)::String
    @invoke Lib.XPRSgetbanner(_)::String
    @invoke Lib.XPRSgetprobname(prob, _)::String

As an example of what @invoke expands to:

```
julia> @macroexpand @invoke Lib.XPRSgetversion(_)::String
:(invoke(Lib.XPRSgetversion, Xpress.String))
```

"""
macro invoke(expr)
    @assert expr.head == :(::) "macro argument must have return type declaration"

    # macro return type must be a valid type that exists in Xpress or Julia
    return_type = expr.args[2]

    f = expr.args[1]

    @assert f.head == :call "macro argument must have a function call"
    @assert :_ in f.args[2:end] "macro argument must have an underscore argument"

    # Remove all `_` arguments
    # TODO: note the positions and pass positions to the invoke function
    indices = findall(x->x≠:_, f.args)
    filter!(x->x≠:_, f.args)

    # Call invoke function at macro call site instead
    pushfirst!(f.args, :(invoke))

    # invoke function takes the position of return type as the first argument
    # invoke function takes the return type as the first argument
    # invoke function uses this argument to dispatch to the correct method
    if length(indices) == 1
        insert!(f.args, 3, return_type)
        insert!(f.args, 3, indices[1])
    else
        # TODO: Implement multiple return types
        error("Not implemented @invoke macro for multiple `_`")
    end

    return f
end


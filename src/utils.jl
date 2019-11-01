function invoke(f::Function, pos::Int, ::Type{Float64}, args...)
    out = Ref{Float64}(0.0) # should we use Cfloat here instead?

    args = collect(args)
    insert!(args, pos-1, out)

    r = f(args...)
    r != 0 ? throw(XpressError(r, "Unable to invoke $f")) : out[]
end

function invoke(f::Function, pos::Int, ::Type{Int}, args...)
    out = Ref{Cint}(0)

    args = collect(args)
    insert!(args, pos-1, out)

    r = f(args...)
    r != 0 ? throw(XpressError(r, "Unable to invoke $f")) : out[]
end

function invoke(f::Function, pos::Int, ::Type{String}, args...)
    out = Cstring(pointer(Array{Cchar}(undef, 1024)))

    args = collect(Any, args)
    insert!(args, pos-1, out)

    r = f(args...)
    r != 0 ? throw(XpressError(r, "Unable to invoke $f")) : unsafe_string(out)
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
    indices = findall(x->x==:_, f.args)
    filter!(x->x≠:_, f.args)

    # Call invoke function at macro call site instead
    pushfirst!(f.args, :(invoke))

    f.args = esc.(f.args)

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


macro checked(expr)
    @assert expr.head == :call "Can only use @checked on function calls"
    @assert ( expr.args[1].head == :(.) ) && ( expr.args[1].args[1] == :Lib) "Can only use @checked on Lib.\$function"
    f = replace(String(expr.args[1].args[2].value), "XPRS"=>"")
    return esc(quote
        r = $(expr)
        r != 0 ? throw(XpressError(r, "Unable to call $($f)")) : nothing
    end)
end

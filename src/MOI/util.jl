wrap_with_parens(x::String) = string("(", x, ")")

to_str(x) = string(x)

struct UnrecognizedExpressionException <: Exception
    exprtype::String
    expr
end

function to_str(c::Expr)
    if c.head == :comparison
        if length(c.args) == 3
            return join([to_str(c.args[1]), c.args[2], c.args[3]], " ")
        elseif length(c.args) == 5
            return join([c.args[1], c.args[2], to_str(c.args[3]),
                         c.args[4], c.args[5]], " ")
        else
            throw(UnrecognizedExpressionException("comparison", c))
        end
    elseif c.head == :call
        if c.args[1] in (:<=,:>=,:(==))
            if length(c.args) == 3
                return join([to_str(c.args[2]), to_str(c.args[1]), to_str(c.args[3])], " ")
            elseif length(c.args) == 5
                return join([to_str(c.args[1]), to_str(c.args[2]), to_str(c.args[3]), to_str(c.args[4]), to_str(c.args[5])], " ")
            else
                throw(UnrecognizedExpressionException("comparison", c))
            end
        elseif c.args[1] in (:+,:-,:*,:/)
            if all(d->isa(d, Real), c.args[2:end]) # handle unary case
                return wrap_with_parens(string(eval(c)))
            elseif c.args[1] == :- && length(c.args) == 2
                return wrap_with_parens(string("(-$(to_str(c.args[2])))"))
            else
                return wrap_with_parens(string(join([to_str(d) for d in c.args[2:end]], string(c.args[1]))))
            end
        elseif c.args[1] == :^
            if length(c.args) != 3
                throw(UnrecognizedExpressionException("function call", c))
            end
            if c.args[3] isa Real
                return wrap_with_parens(string(to_str(c.args[2]), c.args[1], c.args[3]))
            else
                # BARON does not support x^y natively for x,y variables. Instead
                # we transform to the equivalent expression exp(y * log(x)).
                return to_str(:( exp( $(c.args[3]) * log($(c.args[2])) ) ))
            end
        elseif c.args[1] in (:exp,:log)
            if length(c.args) != 2
                throw(UnrecognizedExpressionException("function call", c))
            end
            return wrap_with_parens(string(c.args[1], wrap_with_parens(to_str(c.args[2]))))
        elseif c.args[1] == :abs
            if length(c.args) != 2
                throw(UnrecognizedExpressionException("function call", c))
            end
            # BARON does not support abs(x) natively for variable x. Instead
            # we transform to the equivalent expression sqrt(x^2).
            return to_str(:( ( $(c.args[2])^2.0 )^(0.5) ))
        else
            throw(UnrecognizedExpressionException("function call", c))
        end
    elseif c.head == :ref
        if c.args[1] == :x
            idx = c.args[2]
            @assert isa(idx, Int)
            # TODO decide is use use defined names
            # might be messy becaus a use can call his variable "sin"
            return "x$idx"
        else
            throw(UnrecognizedExpressionException("reference", c))
        end
    end
end

verify_support(c) = c

function verify_support(c::Symbol)
    if c !== :NaN # blocks NaN and +/-Inf
        return c
    end
    error("Got NaN in a constraint or objective.")
end

function verify_support(c::Real)
    if isfinite(c) # blocks NaN and +/-Inf
        return c
    end
    error("Expected number but got $c")
end

function verify_support(c::Expr)
    if c.head == :comparison
        map(verify_support, c.args)
        return c
    end
    if c.head == :call
        if c.args[1] in (:+, :-, :*, :/, :exp, :log)
            return c
        elseif c.args[1] in (:<=, :>=, :(==))
            map(verify_support, c.args[2:end])
            return c
        elseif c.args[1] == :^
            @assert isa(c.args[2], Real) || isa(c.args[3], Real)
            return c
        else # TODO: do automatic transformation for x^y, |x|
            error("Unsupported expression $c")
        end
    end
    return c
end

to_expr(vi::MOI.VariableIndex) = :(x[$(vi.value)])

function to_expr(f::SAF)
    f = MOIU.canonical(f)
    if isempty(f.terms)
        return f.constant
    else
        linear_term_exprs = map(f.terms) do term
            :($(term.coefficient) * x[$(term.variable.value)])
        end
        expr = :(+($(linear_term_exprs...)))
        if !iszero(f.constant)
            push!(expr.args, f.constant)
        end
        return expr
    end
end

function to_expr(f::SQF)
    f = MOIU.canonical(f)
    linear_term_exprs = map(f.affine_terms) do term
        i = term.variable.value
        :($(term.coefficient) * x[$i])
    end
    quadratic_term_exprs = map(f.quadratic_terms) do term
        i = term.variable_1.value
        j = term.variable_2.value
        if i == j
            :($(term.coefficient / 2) * x[$i] * x[$j])
        else
            :($(term.coefficient) * x[$i] * x[$j])
        end
    end
    expr = :(+($(linear_term_exprs...), $(quadratic_term_exprs...)))
    if !iszero(f.constant)
        push!(expr.args, f.constant)
    end
    return expr
end

function set_lower_bound(info::Union{VariableInfo, ConstraintInfo}, value::Union{Number, Nothing})
    if value !== nothing
        info.lower_bound !== nothing && throw(ArgumentError("Lower bound has already been set"))
        info.lower_bound = value
    end
    return
end

function set_upper_bound(info::Union{VariableInfo, ConstraintInfo}, value::Union{Number, Nothing})
    if value !== nothing
        info.upper_bound !== nothing && throw(ArgumentError("Upper bound has already been set"))
        info.upper_bound = value
    end
    return
end

function set_bounds(info::Union{VariableInfo, ConstraintInfo}, set::MOI.EqualTo)
    set_lower_bound(info, set.value)
    set_upper_bound(info, set.value)
end

function set_bounds(info::Union{VariableInfo, ConstraintInfo}, set::MOI.GreaterThan)
    set_lower_bound(info, set.lower)
end

function set_bounds(info::Union{VariableInfo, ConstraintInfo}, set::MOI.LessThan)
    set_upper_bound(info, set.upper)
end

function set_bounds(info::Union{VariableInfo, ConstraintInfo}, set::MOI.Interval)
    set_lower_bound(info, set.lower)
    set_upper_bound(info, set.upper)
end

function check_variable_indices(model::Optimizer, index::VI)
    @assert 1 <= index.value <= length(model.inner.variable_info)
end

function check_variable_indices(model::Optimizer, f::SAF)
    for term in f.terms
        check_variable_indices(model, term.variable)
    end
end

function check_variable_indices(model::Optimizer, f::SQF)
    for term in f.affine_terms
        check_variable_indices(model, term.variable)
    end
    for term in f.quadratic_terms
        check_variable_indices(model, term.variable_1)
        check_variable_indices(model, term.variable_2)
    end
end

function find_variable_info(model::Optimizer, vi::VI)
    check_variable_indices(model, vi)
    model.inner.variable_info[vi.value]
end

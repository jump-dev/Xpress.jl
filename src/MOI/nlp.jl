MOI.supports(::Optimizer, ::MOI.NLPBlock) = true

function walk_and_strip_variable_index!(expr::Expr)
    for i in 1:length(expr.args)
        if expr.args[i] isa MOI.VariableIndex
            expr.args[i] = expr.args[i].value
        end
        walk_and_strip_variable_index!(expr.args[i])
    end
    return
end

walk_and_strip_variable_index!(not_expr) = nothing

function MOI.set(model::Optimizer, ::MOI.NLPBlock, nlp_data::MOI.NLPBlockData)
    if model.nlp_block_data !== nothing
        model.nlp_block_data = nothing
        # error("Nonlinear block already set; cannot overwrite. Create a new model instead.")
    end
    model.nlp_block_data = nlp_data

    nlp_eval = nlp_data.evaluator

    MOI.initialize(nlp_eval, [:ExprGraph])

    if nlp_data.has_objective
        # according to test: test_nonlinear_objective_and_moi_objective_test
        # from MOI 0.10.9, linear objectives are just ignores if the noliena exists
        # if model.inner.objective_expr !== nothing
            # error("Two objectives set: One linear, one nonlinear.")
        # end
        obj = verify_support(MOI.objective_expr(nlp_eval))
        walk_and_strip_variable_index!(obj)
        if obj == :NaN
            model.objective_expr = 0.0
            model.termination_status = MOI.INVALID_MODEL
        else
            model.objective_expr = obj
        end
        model.objective_type = NLP_OBJECTIVE
    else
        model.objective_expr = 0.0
    end

    for i in 1:length(nlp_data.constraint_bounds)
        expr = verify_support(MOI.constraint_expr(nlp_eval, i))
        lb = nlp_data.constraint_bounds[i].lower
        ub = nlp_data.constraint_bounds[i].upper
        @assert expr.head == :call
        if expr.args[1] == :(==)
            @assert lb == ub == expr.args[3]
        elseif expr.args[1] == :(<=)
            @assert lb == -Inf
            lb = nothing
            @assert ub == expr.args[3]
        elseif expr.args[1] == :(>=)
            @assert lb == expr.args[3]
            @assert ub == Inf
            ub = nothing
        else
            error("Unexpected expression $expr.")
        end
        expr = expr.args[2]
        walk_and_strip_variable_index!(expr)
        push!(model.nlp_constraint_info, Xpress.NLPConstraintInfo(expr, lb, ub, nothing))
    end
    return
end

# Converting expressions in strings adapted to chgformulastring and chgobjformulastring
wrap_with_parens(x::String) = string("( ", x, " )")

to_str(x) = string(x)

function to_str(c::Expr)
    if c.head == :comparison
        if length(c.args) == 3
            return join([to_str(c.args[1]), " ", c.args[2], " ", c.args[3]])
        elseif length(c.args) == 5
            return join([c.args[1], " ", c.args[2], " ", to_str(c.args[3]), " ",
                         c.args[4], " ", c.args[5]])
        else
            throw(UnrecognizedExpressionException("comparison", c))
        end
    elseif c.head == :call
        if c.args[1] in (:<=,:>=,:(==))
            if length(c.args) == 3
                return join([to_str(c.args[2]), " ", to_str(c.args[1]), " ", to_str(c.args[3])])
            elseif length(c.args) == 5
                return join([to_str(c.args[1]), " ", to_str(c.args[2]), " ", to_str(c.args[3]), " ", to_str(c.args[4]), " ", to_str(c.args[5])])
            else
                throw(UnrecognizedExpressionException("comparison", c))
            end
        elseif c.args[1] in (:+,:-,:*,:/)
            if all(d->isa(d, Real), c.args[2:end]) # handle unary case
                return wrap_with_parens(string(eval(c)))
            elseif c.args[1] == :- && length(c.args) == 2
                return wrap_with_parens(string("( - $(to_str(c.args[2])) )"))
            else
                return wrap_with_parens(string(join([to_str(d) for d in c.args[2:end]], join([" ",string(c.args[1]), " "]))))
            end
        elseif c.args[1] == :^
            if length(c.args) != 3
                throw(UnrecognizedExpressionException("function call", c))
            end 
            return wrap_with_parens(join([to_str(c.args[2]), " ",to_str(c.args[1]), " ",to_str(c.args[3])]))
        elseif c.args[1] in (:exp,:log,:sin,:cos,:abs,:tan,:sqrt)
            if length(c.args) != 2
                throw(UnrecognizedExpressionException("function call", c))
            end
            return wrap_with_parens(string(join([uppercase(string(c.args[1])), " "]), wrap_with_parens(to_str(c.args[2]))))
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

function set_lower_bound(info::NLPConstraintInfo, value::Union{Number, Nothing})
    if value !== nothing
        info.lower_bound !== nothing && throw(ArgumentError("Lower bound has already been set"))
        info.lower_bound = value
    end
    return
end

function set_upper_bound(info::NLPConstraintInfo, value::Union{Number, Nothing})
    if value !== nothing
        info.upper_bound !== nothing && throw(ArgumentError("Upper bound has already been set"))
        info.upper_bound = value
    end
    return
end

function set_bounds(info::NLPConstraintInfo, set::MOI.EqualTo)
    set_lower_bound(info, set.value)
    set_upper_bound(info, set.value)
end

function set_bounds(info::NLPConstraintInfo, set::MOI.GreaterThan)
    set_lower_bound(info, set.lower)
end

function set_bounds(info::NLPConstraintInfo, set::MOI.LessThan)
    set_upper_bound(info, set.upper)
end

function set_bounds(info::NLPConstraintInfo, set::MOI.Interval)
    set_lower_bound(info, set.lower)
    set_upper_bound(info, set.upper)
end

# Transforming NLconstraints in constraint sets used for affine functions creation in optimize!
function to_constraint_set(c::Xpress.NLPConstraintInfo)
    if c.lower_bound !== nothing || c.upper_bound !== nothing
        if c.upper_bound === nothing
            return [MOI.GreaterThan(c.lower_bound)]
        elseif c.lower_bound === nothing
            return [MOI.LessThan(c.upper_bound)]
        elseif c.lower_bound==c.upper_bound
            return [MOI.EqualTo(c.lower_bound)]
        else
            return MOI.GreaterThan(c.lower_bound), MOI.LessThan(c.upper_bound)
        end
    end
end

# The problem is Nonlinear if a NLPBlockData has been defined
function is_nlp(model)
    return model.nlp_block_data !== nothing
end

MOI.supports(::Optimizer, ::MOI.NLPBlockDual) = true

function MOI.get(model::Optimizer, attr::MOI.NLPBlockDual)
    MOI.check_result_index_bounds(model, attr)
    s = _dual_multiplier(model) 
    return s .*model.cached_solution.linear_dual[(1:length(model.nlp_constraint_info))]
end
# Xpress model attributes

############################################
#
#   Low level attribute getters
#
############################################
"""
    get_intattr(model::Model, ipar::Integer)

Return integer value corresponding to attribute with number `ipar`
"""
function get_intattr(model::Model, ipar::Integer)
    out = Array{Cint}(undef, 1)

    ret = @xprs_ccall(getintattrib, Cint,
                      (Ptr{Nothing}, Cint, Ptr{Cint}),
                      model.ptr_model, Cint(ipar), out)
    if ret != 0
        throw(XpressError(model, ret))
    end

    return convert(Cint, out[1])
end

"""
    get_dblattr(model::Model, ipar::Integer)

Return double value corresponding to attribute with number `ipar`
"""
function get_dblattr(model::Model, ipar::Integer)
    out = Array{Float64}(undef, 1)

    ret = @xprs_ccall(getdblattrib, Cint,
                      (Ptr{Nothing}, Cint, Ptr{Float64}),
                      model.ptr_model, Cint(ipar), out)
    if ret != 0
        throw(XpressError(model, convert(Int, ret)))
    end

    return out[1]::Float64
end

"""
    get_strattr(model::Model, ipar::Integer)

Return string value corresponding to attribute with number `ipar`
"""
function get_strattr(model::Model, ipar::Integer)
    out = zeros(Cchar,256)

    ret = @xprs_ccall(getstrattrib, Cint,
                      (Ptr{Nothing}, Cint, Ptr{Cchar}),
                      model.ptr_model, Cint(ipar), out)
    if ret != 0
        throw(XpressError(model, convert(Int, ret)))
    end

    return unsafe_string(pointer(out))
end



############################################
#
#   Macros for array definition
#
############################################

macro xprs_int_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_intattr(model, $(attrname))
end

macro xprs_dbl_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_dblattr(model, $(attrname))
end

macro xprs_str_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_strattr(model, $(attrname))
end


############################################
#
#   Model attributes
#
############################################

# basic attributes

@xprs_int_attr num_presolvedvars     XPRS_COLS
@xprs_int_attr num_presolvedconstrs  XPRS_ROWS
@xprs_int_attr num_sos      XPRS_SETS
@xprs_int_attr num_qconstrs XPRS_QCONSTRAINTS
@xprs_int_attr num_cnzs     XPRS_ELEMS
@xprs_int_attr num_qnzs     XPRS_QELEMS
@xprs_int_attr num_qcnzs    XPRS_QCELEMS

@xprs_int_attr num_intents  XPRS_MIPENTS

@xprs_int_attr num_setmembers XPRS_SETMEMBERS

@xprs_dbl_attr obj_sense    XPRS_OBJSENSE

@xprs_int_attr num_originalvars     XPRS_ORIGINALCOLS
@xprs_int_attr num_vars     XPRS_ORIGINALCOLS
@xprs_int_attr num_originalconstrs  XPRS_ORIGINALROWS
@xprs_int_attr num_constrs  XPRS_ORIGINALROWS

# derived attribute functions

"""
    num_linconstrs(model::Model)

Return the number of purely linear contraints in the Model
"""
num_linconstrs(model::Model) = num_constrs(model) - num_qconstrs(model)

"""
    model_sense(model::Model)

Return a symbol that encodes the objective function sense.
The output is either `:minimize` or `:maximize`
"""
model_sense(model::Model) = obj_sense(model) == XPRS_OBJ_MINIMIZE ? (:minimize) : (:maximize)

"""
    is_qcp(model::Model)

Return `true` if there are quadratic  constraints in the Model
"""
is_qcp(model::Model) = num_qconstrs(model) > 0

"""
    is_mip(model::Model)

Return `true` if there are integer entities in the Model
"""
is_mip(model::Model) = (num_intents(model)+num_sos(model)) > 0

"""
    is_qp(model::Model)

Return `true` if there are quadratic terms inthe objective in the Model
"""
is_qp(model::Model) = num_qnzs(model) > 0

"""
    model_type(model::Model)

Return a symbol enconding the type of the model.]
Options are: `:LP`, `:QP` and `:QCP`
"""
function model_type(model::Model)
    is_qp(model)  ? (:QP)  :
    is_qcp(model) ? (:QCP) : (:LP)
end


############################################
#
#   The show method for model
#
#   - Based on attributes
#
############################################

"""
    show(io::IO, model::Model)

Prints a simplified model description
"""
function Base.show(io::IO, model::Model)
    if model.ptr_model != C_NULL
        println(io, "Xpress Model:"     )# $(model_name(model))")
        if is_mip(model)
            println(io, "    type   : $(model_type(model)) (MIP)")
        else
            println(io, "    type   : $(model_type(model))")
        end
        println(io, "    sense  : $(model_sense(model))")
        println(io, "    number of variables             = $(num_vars(model))")
        println(io, "    number of linear constraints    = $(num_linconstrs(model))")
        println(io, "    number of quadratic constraints = $(num_qconstrs(model))")
        println(io, "    number of sos constraints       = $(num_sos(model))")
        println(io, "    number of non-zero coeffs       = $(num_cnzs(model))")
        println(io, "    number of non-zero qp objective terms  = $(num_qnzs(model))")
        println(io, "    number of non-zero qp constraint terms = $(num_qcnzs(model))")
        println(io, "    number of integer entities = $(num_intents(model))")
    else
        println(io, "Xpress Model: NULL")
    end
end


############################################
#
#   more setters and getters
#
############################################
"""
    set_sense!(model::Model, sense::Symbol)

Set the sense of the model.
Options are `:minimize` and `:maximize`
"""
function set_sense!(model::Model, sense::Symbol)
    v = sense == :maximize || sense == :Max ? XPRS_OBJ_MAXIMIZE :
        sense == :minimize || sense == :Min ? XPRS_OBJ_MINIMIZE :
        throw(ArgumentError("Invalid model sense."))

    set_sense!(model, v)

    return nothing
end
function set_sense!(model::Model, sense::Integer)

    ret = @xprs_ccall(chgobjsense, Cint, (
            Ptr{Nothing},    # model
            Cint          # sense
            ),
            model.ptr_model, Cint(sense))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end


"""
    set_objcoeffs!{I<:Integer,R<:Real}(model::Model, inds::Vector{I}, c::Vector{R})

Sets coefficients `c` given indices in `inds` in the objective function of `model`
"""
function set_objcoeffs!(model::Model, inds::Vector{I}, c::Vector{R}) where {I<:Integer,R<:Real}
    # n = num_vars(model)
    # _chklen(c,n)
    _chklen(inds, length(c))

    ret = @xprs_ccall(chgobj, Cint, (
        Ptr{Nothing},     # model
        Cint,          # nels
        Ptr{Cint}, # inds
        Ptr{Float64} # vals
        ),
        model.ptr_model, Cint(length(c)), ivec(inds) .- Cint(1), fvec(c))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
"""
    set_objcoeffs!{R<:Real}(model::Model, c::Vector{R})
    set_obj!(model, c)

Sets coefficients in the objective of the dirst `length(c)` all variables.
"""
set_objcoeffs!(model::Model, c::Vector{R}) where {R<:Real} = set_objcoeffs!(model, collect(1:length(c)), c)
set_obj!(model, c) = set_objcoeffs!(model,c)

"""
    get_lb!(model::Model, lb::Vector{Float64})

Return the lower bounds for all variables in the vector lb.
"""
function get_lb!(model::Model, lb::Vector{Float64}, colb::Integer, cole::Integer)

    _chklen(lb,cole-colb+1)

    ret = @xprs_ccall(getlb, Cint, (
        Ptr{Nothing},    # model
        Ptr{Float64},
        Cint,
        Cint
        ),
        model.ptr_model, lb, Cint(colb-1), Cint(cole-1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
function get_lb!(model::Model, lb::Vector{Float64})

    cols = num_vars(model)
    get_lb!(model, lb, 1, cols)

    return nothing
end

"""
    get_lb(model::Model)
    lowerbounds(model::Model)

Return vector of lowebounds with length equals to the number of variables in the model.
"""
function get_lb(model::Model, colb::Integer, cole::Integer)

    out = Array{Float64}(undef, cole-colb+1)

    get_lb!(model, out, colb, cole)

    return out
end
function get_lb(model::Model)

    cols = num_vars(model)
    out = Array{Float64}(undef, cols)

    get_lb!(model, out)

    return out
end
lowerbounds(model::Model) = get_lb(model)

"""
    get_ub!(model::Model, out::Vector{Float64})

Return the upper bounds for all variables in the vector out.
"""
function get_ub!(model::Model, out::Vector{Float64}, colb::Integer, cole::Integer)

    _chklen(out, cole-colb+1)

    ret = @xprs_ccall(getub, Cint, (
        Ptr{Nothing},    # model
        Ptr{Float64},
        Cint,
        Cint
        ),
        model.ptr_model, out, Cint(colb-1), Cint(cole-1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
function get_ub!(model::Model, ub::Vector{Float64})

    cols = num_vars(model)
    get_ub!(model, ub, 1, cols)

    return nothing
end


"""
    get_ub(model::Model)
    upperbounds(model::Model)
    get_ub(model::Model, colb::Integer, cole::Integer)

Return vector of upperbounds with length equals to the number of variables in the model.
"""
function get_ub(model::Model, colb::Integer, cole::Integer)

    out = Array{Float64}(undef, cole-colb+1)

    get_ub!(model, out, colb, cole)

    return out
end
function get_ub(model::Model)

    cols = num_vars(model)
    out = Array{Float64}(undef, cols)

    get_ub!(model, out)

    return out
end
upperbounds(model::Model) = get_ub(model)

"""
    get_obj!(model::Model, obj::Vector{Float64})

Return the upper bounds for all variables in the vector obj.
"""
function get_obj!(model::Model, obj::Vector{Float64})

    cols = num_vars(model)
    _chklen(obj,cols)

    ret = @xprs_ccall(getobj, Cint, (
        Ptr{Nothing},    # model
        Ptr{Float64},
        Cint,
        Cint
        ),
        model.ptr_model, obj, Cint(0), Cint(cols - 1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end

"""
    get_obj(model::Model)
    upperbounds(model::Model)

Return vector of objective coefficients with length equals to the number of variables in the model.
"""
function get_obj(model::Model)

    cols = num_vars(model)
    out = Array{Float64}(undef, cols)

    get_obj!(model, out)

    return out
end
objcoeffs(model::Model) = get_obj(model)


"""
    get_rhs!(model::Model, rhs::Vector{Float64})

Return the rhs for all constraints in the vector obj.
"""
function get_rhs!(model::Model, out::Vector{Float64}, rowb::Integer, rowe::Integer)

    _chklen(out, rowe-rowb+1)

    ret = @xprs_ccall(getrhs, Cint, (
        Ptr{Nothing},    # model
        Ptr{Float64},
        Cint,
        Cint
        ),
        model.ptr_model, out, Cint(rowb-1), Cint(rowe-1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
function get_rhs!(model::Model, out::Vector{Float64})

    rows = num_constrs(model)
    get_rhs!(model, out, 1, rows)

    return nothing
end

"""
    get_rhs(model::Model)

Return a vector of rhs with length equals to the number of variables in the model.
"""
function get_rhs(model::Model, rowb::Integer, rowe::Integer)

    out = Array{Float64}(undef, rowe-rowb+1)

    get_rhs!(model, out, rowb, rowe)

    return out
end
function get_rhs(model::Model)

    rows = num_constrs(model)
    out = Array{Float64}(undef, rows)

    get_rhs!(model, out)

    return out
end

"""
    get_rowtype!(model::Model, sense::Vector{Cchar})

Return the sense for all constraints in the vector sense of Cchar.
Options are XPRS_LEQ = 'L', XPRS_GEQ = 'G', XPRS_EQ = 'E'.
"""
function get_rowtype!(model::Model, sense::Vector{Cchar})

    rows = num_constrs(model)
    _chklen(sense,rows)

    ret = @xprs_ccall(getrowtype, Cint, (
        Ptr{Nothing},    # model
        Ptr{Cchar},
        Cint,
        Cint
        ),
        model.ptr_model, sense, Cint(0), Cint(rows.-1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end

"""
    get_rowtype(model::Model)

Return a vector of senses with length equals to the number of constraints in the model.
Options are XPRS_LEQ = 'L', XPRS_GEQ = 'G', XPRS_EQ = 'E'.
"""
function get_rowtype(model::Model)

    rows = num_constrs(model)
    out = Array{Cchar}(undef, rows)

    get_rowtype!(model, out)

    return out
end

const sense_map = Dict{Cchar, Symbol}(
    XPRS_LEQ => :<=,
    XPRS_GEQ => :>=,
    XPRS_EQ => :(==),
)

get_sense(model::Model) = map(x->sense_map[x], get_rowtype(model))


"""
    get_coltype!(model::Model, coltype::Vector{Cchar})

Return the type for all constraints in the vector coltype of Cchar.
Options are XPRS_CONTINUOUS = 'C', XPRS_INTEGER = 'I', XPRS_BINARY = 'B'.
"""
function get_coltype!(model::Model, coltype::Vector{Cchar})
    cols = num_vars(model)
    _chklen(coltype,cols)

    ret = @xprs_ccall(getcoltype, Cint, (
        Ptr{Nothing},    # model
        Ptr{Cchar},
        Cint,
        Cint
        ),
        model.ptr_model, coltype, 0, cols - Cint(1))

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end

"""
    get_coltype(model::Model)

Return a vector of type with length equals to the number of variables in the model.
Options are XPRS_CONTINUOUS = 'C', XPRS_INTEGER = 'I', XPRS_BINARY = 'B'.
"""
function get_coltype(model::Model)

    cols = num_vars(model)
    out = Array{Cchar}(undef, cols)

    get_coltype!(model, out)

    return out
end

function unsafe_chgbounds!(model::Model, len::Cint, inds::Vector{Cint}, btype::Vector{Cchar},  lb::Vector{Float64})

    ret = @xprs_ccall(chgbounds, Cint, (
        Ptr{Nothing},    # model
        Cint,
        Ptr{Cint},
        Ptr{Cchar},
        Ptr{Float64}
        ),
        model.ptr_model, len, inds, btype, lb)

    if ret != 0
        throw(XpressError(model))
    end
    return nothing
end
chgbounds!(model::Model, inds::Vector{Cint}, btype::Vector{Cchar},  lb::Vector{Float64}) = unsafe_chgbounds!(model, Cint(length(inds)), inds .- Cint(1), btype,  lb)

"""
    set_lb!{I<:Integer, R<:Real}(model::Model, inds::Vector{I}, lb::Vector{R})

Sets lower bounds `lb` given variable indices in `inds` of `model`

    set_lb!{R<:Real}(model::Model, lb::Vector{R})

Sets lower bounds to all variables up to `length(lb)`.
`length(lb)` must be smaller than the number of variables.
"""
function set_lb!(model::Model, inds::Vector{I}, lb::Vector{R}) where {I<:Integer, R<:Real}
    nbnds = length(inds)
    chgbounds!(model, ivec(inds), cvecx('L', nbnds),  fvec(lb))
    return nothing
end
function set_lb!(model::Model, lb::Vector{R}) where R<:Real
    cols = num_vars(model)
    _chklen(lb,cols)
    ind = inds32(cols)
    set_lb!(model, ind, lb)
    return nothing
end

"""
    set_ub!{I<:Integer, R<:Real}(model::Model, inds::Vector{I}, ub::Vector{R})

Sets upper bounds `ub` given variable indices in `inds` of `model`

    set_ub!{R<:Real}(model::Model, ub::Vector{R})

Sets upper bounds to all variables up to `length(ub)`.
`length(ub)` must be smaller than the number of variables.
"""
function set_ub!(model::Model, inds::Vector{I}, ub::Vector{R}) where {I<:Integer, R<:Real}
    nbnds = length(inds)
    chgbounds!(model, ivec(inds), cvecx('U', nbnds),  fvec(ub))
    return nothing
end
function set_ub!(model::Model, ub::Vector{R}) where R<:Real
    cols = num_vars(model)
    _chklen(ub,cols)
    ind = inds32(cols)
    set_ub!(model,ind,ub)
    return nothing
end


function unsafe_chgrhs!(model::Model, nels::Cint, inds::Vector{Cint}, rhs::Vector{Float64})
    ret = @xprs_ccall(chgrhs, Cint, (
        Ptr{Nothing},    # model
        Cint,
        Ptr{Cint},
        Ptr{Float64}
        ),
        model.ptr_model, nels, inds, rhs)

    if ret != 0
        throw(XpressError(model))
    end
    return nothing
end
chgrhs!(model::Model, inds::Vector{Cint}, rhs::Vector{Float64}) = unsafe_chgrhs!(model, Cint(length(inds)), inds .- Cint(1), rhs)

"""
    set_rhs!{I<:Integer, R<:Real}(model::Model, inds::Vector{I}, rhs::Vector{R})

Sets coefficients `rhs` given indices in `inds` in the rhs of `model`

    set_rhs!{R<:Real}(model::Model, lb::Vector{R})

Sets coefficients in the rhs of all constraints up to `length(rhs)`.
`length(rhs)` must be smaller than the number of constraints.
"""
function set_rhs!(model::Model, inds::Vector{I}, rhs::Vector{R}) where {I<:Integer, R<:Real}
    nels = length(inds)
    chgrhs!(model, ivec(inds), fvec(rhs))
    return nothing
end
function set_rhs!(model::Model, rhs::Vector{R}) where R<:Real
    rows = length(rhs)
    set_rhs!(model, inds32(rows), rhs)
end

"""
    set_rowtype!{I<:Integer}(model::Model, inds::Vector{I}, senses::Vector{Cchar})

Sets row type `senses` for given indices in `inds`

    set_rowtype!(model::Model, senses::Vector{Cchar})

Sets row type in all constraints up to `length(senses)`.
`length(senses)` must be smaller than the number of constraints.
"""
function set_rowtype!(model::Model, inds::Vector{I}, senses::Vector{Cchar}) where I<:Integer

    rows = length(senses)
    ret = @xprs_ccall(chgrowtype, Cint, (
        Ptr{Nothing},    # model
        Cint,
        Ptr{Cint},
        Ptr{Cchar}
        ),
        model.ptr_model, Cint(rows) , ivec(inds) .- Cint(1), cvec(senses) )

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
function set_rowtype!(model::Model, senses::Vector{Cchar})

    rows = length(senses)
    inds = inds32(rows)
    set_rowtype!(model, inds, senses)

    return nothing
end

"""
    set_constrLB!{R<:Real}(model::Model, lb::Vector{R})

Change constraints lower bounds up to `length(lb)`
"""
function set_constrLB!(model::Model, lb::Vector{R}) where R<:Real
    # should only work for liner constraints

    nlrows = num_linconstrs(model)
    lrows = get_lrows(model)[1:length(lb)]

    senses = get_rowtype(model)
    rhs    = get_rhs(model)
    sense_changed = false

    for i = 1:length(lrows)
        #if senses[lrows[i]] == XPRS_GEQ || senses[lrows[i]] == XPRS_EQ
            # Do nothing
        if senses[lrows[i]] == XPRS_LEQ
            if lb[i] != -Inf
                # LEQ constraint with non-NegInf LB implies a range
                if isapprox(lb[i], rhs[lrows[i]])
                    # seems to be an equality
                    senses[lrows[i]] = XPRS_EQ
                    sense_changed = true
                else
                    error("Tried to set LB != -Inf on a LEQ constraint (index $i)")
                end
            else
                lb[i] = rhs[lrows[i]]
            end
        end
    end
    if sense_changed
        set_rowtype!(model, senses)
    end
    set_rhs!(model, lrows, lb)
end

"""
    set_constrUB!{R<:Real}(model::Model, ub::Vector{R})

Change constraints upper bounds up to `length(ub)`
"""
function set_constrUB!(model::Model, ub::Vector{R}) where R<:Real

    nlrows = num_linconstrs(model)
    lrows = get_lrows(model)[1:length(ub)]

    senses = get_rowtype(model)
    rhs    = get_rhs(model)
    sense_changed = false
    for i = 1:length(lrows)
        #if senses[lrows[i]] == XPRS_LEQ || senses[lrows[i]] == XPRS_EQ
            # Do nothing
        if senses[lrows[i]] == XPRS_GEQ
            if ub[i] != Inf
                # GEQ constraint with non-PosInf UB implies a range
                if isapprox(ub[i], rhs[lrows[i]])
                    # seems to be an equality
                    senses[lrows[i]] = XPRS_EQ
                    sense_changed = true
                else
                    error("Tried to set UB != +Inf on a GEQ constraint (index $i)")
                end
            else
              ub[i] = rhs[lrows[i]]
            end
        end
    end
    if sense_changed
        set_rowtype!(model, senses)
    end
    set_rhs!(model, lrows, ub)
end

#=
    Objective interfacing functions
=#

function get_linear_objective!(x::Vector{Float64}, instance::Optimizer)
    obj = get_obj(instance.inner)
    @assert length(x) == length(obj)
    for i in 1:length(obj)
        x[i] = obj[i]
    end
end

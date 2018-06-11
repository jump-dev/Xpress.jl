function addcols(model::Model, mstart::Vector{Cint}, mrwind::Vector{Cint}, dmatval::Vector{Float64}, objx::Vector{Float64}, lb::Vector{Float64}, ub::Vector{Float64})
    fixinfinity!(lb)
    fixinfinity!(ub)

    newcols = Cint(length(lb))
    _chklen(ub, newcols)
    _chklen(objx, newcols)
    _chklen(mstart, newcols)
    newnz = Cint(length(dmatval))
    _chklen(mrwind, newnz)

    ret = @xprs_ccall(addcols, Cint, (
        Ptr{Void},    # model
        Cint,         # number of new cols
        Cint,         # number of nonzeros in added cols
        Ptr{Float64}, # coefs in objective
        Ptr{Cint},     # mstart ????
        Ptr{Cint},     # mrwind: row indexes of each col
        Ptr{Float64},      # elemnts values
        Ptr{Float64},      # lb
        Ptr{Float64}    # ub
        ),
        model.ptr_model, newcols, newnz, objx, mstart-Cint(1), mrwind-Cint(1), dmatval, lb, ub)
    if ret != 0
        throw(XpressError(model))
    end
    return nothing
end
function addcols(model::Model, objx::Vector{Float64}, lb::Vector{Float64}, ub::Vector{Float64})
    fixinfinity!(lb)
    fixinfinity!(ub)

    newcols = Cint(length(lb))
    _chklen(ub, newcols)
    _chklen(objx, newcols)

    ret = @xprs_ccall(addcols, Cint, (
        Ptr{Void},    # model
        Cint,         # number of new cols
        Cint,         # number of nonzeros in added cols
        Ptr{Float64}, # coefs in objective
        Ptr{Cint},     # mstart ????
        Ptr{Cint},     # mrwind: row indexes of each col
        Ptr{Float64},      # elemnts values
        Ptr{Float64},      # lb
        Ptr{Float64}    # ub
        ),
        model.ptr_model, newcols, Cint(0), objx, inds32(newcols)-Cint(1), C_NULL, C_NULL, lb, ub)
    if ret != 0
        throw(XpressError(model))
    end
    return nothing
end


"""
    add_var!(model::Model, mrwind::Vector, dmatval::Vector, objx::Real, lb::Real, ub::Real)
    add_var!(model::Model, vtype::Cchar, c::Real, lb::Real, ub::Real)
    add_var!(model::Model, objx::Real, lb::Real, ub::Real)
    add_var!(model::Model, vtype::Cchar, c::Real)

Add single variable with values in constraints (for column generation) value in objective `objx` with bounds `lb` and `ub`
"""
function add_var!(model::Model, nnz::Integer, mrwind::Vector, dmatval::Vector, objx::Real, lb::Real, ub::Real)

    add_var!(model::Model, mrwind::Vector, dmatval::Vector, objx::Real, lb::Real, ub::Real)
    return nothing
end
function add_var!(model::Model, mrwind::Vector, dmatval::Vector, objx::Real, lb::Real, ub::Real)
    addcols(model, Cint[1], ivec(mrwind), fvec(dmatval), fvec(objx), fvec(lb), fvec(ub))
    return nothing
end
function add_var!(model::Model, objx::Real, lb::Real, ub::Real)
    addcols(model, fvec(Float64(objx)), fvec(lb), fvec(ub))
    return nothing
end
function add_var!(model::Model, vtype::Cchar, c::Real, lb::Real, ub::Real)
    add_var!(model, c, lb, ub)
    if vtype == XPRS_INTEGER
        chgcoltype!(model, num_vars(model), XPRS_INTEGER)
    elseif vtype == XPRS_BINARY
        chgcoltype!(model, num_vars(model), XPRS_BINARY)
    end
    nothing
end
add_var!(model::Model, vtype::GChars, c::Real, lb::Real, ub::Real) = add_var!(model, cchar(vtype), Float64(c), Float64(lb), Float64(ub))
add_var!(model::Model, vtype::GChars, c::Real) = add_var!(model, vtype, c, XPRS_MINUSINFINITY, XPRS_PLUSINFINITY)

"""
    add_cvar!(model::Model, c::Real, lb::Real, ub::Real)
    add_cvar!(model::Model, c::Real)

Add continuous variable.
"""
add_cvar!(model::Model, c::Real, lb::Real, ub::Real) = add_var!(model, XPRS_CONTINUOUS, c, lb, ub)
add_cvar!(model::Model, c::Real) = add_cvar!(model, c, XPRS_MINUSINFINITY, XPRS_PLUSINFINITY)

"""
    add_bvar!(model::Model, c::Real)

Add binary variable
"""
add_bvar!(model::Model, c::Real) = add_var!(model, XPRS_BINARY, c, 0., 1.)

"""
    add_ivar!(model::Model, c::Real, lb::Real, ub::Real)
    add_ivar!(model::Model, c::Real)

Add integer variable
"""
add_ivar!(model::Model, c::Real, lb::Real, ub::Real) = add_var!(model, XPRS_INTEGER, c, lb, ub)
add_ivar!(model::Model, c::Real) = add_ivar!(model, c, XPRS_MINUSINFINITY, XPRS_PLUSINFINITY)

"""
    add_vars!(model::Model, vtypes::Vector{Cchar}, c::Vector, lb::Vector, ub::Vector)
    add_vars!(model::Model, vtypes::GCharOrVec, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}})

Add multiple variables at once
"""
function add_vars!(model::Model, vtypes::Vector{Cchar}, c::Vector, lb::Vector, ub::Vector)
    n = length(vtypes)
    _chklen(c,n)

    prev_cols = num_vars(model)
    addcols(model, c, lb, ub)

    for i in 1:n
        if vtypes[i] == XPRS_INTEGER
            chgcoltype!(model,prev_cols+i,XPRS_INTEGER)
        elseif vtypes[i] ==XPRS_BINARY
            chgcoltype!(model,prev_cols+i,XPRS_BINARY)
        end
    end
    nothing
end
function add_vars!(model::Model, vtypes::GChars, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}}) where T<:Real
    n = length(c)
    add_vars!(model, cvecx(vtypes, n), fvec(c), fvecx(lb, n), fvecx(ub, n))
end

"""
    add_cvars!(model::Model, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}})
    add_cvars!(model::Model, c::Vector)

Add multiple continuous variables at once.
"""
add_cvars!(model::Model, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}}) where {T<:Real} = add_vars!(model, XPRS_CONTINUOUS, c, lb, ub)
add_cvars!(model::Model, c::Vector) = add_cvars!(model, c, XPRS_MINUSINFINITY, XPRS_PLUSINFINITY)

"""
    add_bvars!(model::Model, c::Vector)

Add multiple binary variables at once.
"""
add_bvars!(model::Model, c::Vector) = add_vars!(model, XPRS_BINARY, c, 0, 1)

"""
    add_ivars!(model::Model, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}})
    add_ivars!(model::Model, c::Vector)

Add multiple integer variables at once.
"""
add_ivars!(model::Model, c::Vector, lb::Union{T,Vector{T}}, ub::Union{T,Vector{T}}) where {T<:Real} = add_vars!(model, XPRS_INTEGER, c, lb, ub)
add_ivars!(model::Model, c::Vector) = add_ivars!(model, XPRS_INTEGER, c, XPRS_MINUSINFINITY, XPRS_PLUSINFINITY) #

"""
    del_vars!{T<:Real}(model::Model, idx::T)
    del_vars!{T<:Real}(model::Model, idx::Vector{T})

Delete from models the varaible(s) `idx`
"""
del_vars!(model::Model, idx::T) where {T<:Real} = del_vars!(model, Cint[idx])
del_vars!(model::Model, idx::Vector{T}) where {T<:Real} = del_vars!(model, convert(Vector{Cint},idx))
function del_vars!(model::Model, idx::Vector{Cint})
    numdel = length(idx)
    ret = @xprs_ccall(delcols, Cint, (
                     Ptr{Void},
                     Cint,
                     Ptr{Cint}),
                     model, convert(Cint,numdel), idx-Cint(1))
    if ret != 0
        throw(XpressError(model))
    end
end

"""
    chgcoltype!(model::Model, colnum::Integer, vtype::Cchar)

Modify type of variable `colnum` to `vtype`.
Possible values for vtype are `XPRS_CONTINUOUS`, `XPRS_INTEGER` and `XPRS_BINARY`
"""
chgcoltype!(model::Model, colnum::Integer, vtype::Cchar) = chgcoltypes!(model, Cint[colnum], Cchar[vtype])

"""
    chgcoltypes!(model::Model, colnums::Vector{Integer}, vtypes::Vector{Cchar})
    chgcoltypes!(model::Model, colnums::Vector{Integer}, vtypes::Cchar)

Modify type of variables `colnums` to `vtypes`.
Possible values for vtypes are `XPRS_CONTINUOUS`, `XPRS_INTEGER` and `XPRS_BINARY`
"""
chgcoltypes!(model::Model, colnums::Vector{Integer}, vtypes::Cchar) = chgcoltypes!(model, colnums, cvecx(vtypes))
function chgcoltypes!(model::Model, colnums::Vector{I}, vtypes::Vector{Cchar}) where I<:Integer
    n = length(colnums)
    ret = @xprs_ccall(chgcoltype,Cint,(
        Ptr{Void},
        Cint,
        Ptr{Cint},
        Ptr{Cchar}),
        model.ptr_model, n, ivec(colnums-Cint(1)), vtypes )
    if 0 != ret
        throw(XpressError(model))
    end
    return nothing
end

"""
    chgsemilb!{I<:Integer, R<:Real}(model::Model, colnums::Vector{I}, lb::Vector{R})

Change values of semi continuous/integer variables `colnums` to `lb`
"""
function chgsemilb!(model::Model, colnums::Vector{I}, lb::Vector{R}) where {I<:Integer, R<:Real}
#int XPRS_CC XPRSchgglblimit(XPRSprob prob, int ncols, const int mindex[], const double dlimit[]);

    n=length(colnums)
    ret = @xprs_ccall(chgglblimit,Cint,(
        Ptr{Void},
        Cint,
        Ptr{Cint},
        Ptr{Float64}),
        model.ptr_model, n, ivec(colnums-1), fvec(lb))
    if 0 != ret
        throw(XpressError(model))
    end

end
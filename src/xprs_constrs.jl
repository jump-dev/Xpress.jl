## Add Linear constraints

function constrainttype(rel)
    if rel == Cchar('>') || rel == XPRS_GEQ
        return XPRS_GEQ
    elseif rel == Cchar('<') || rel == XPRS_LEQ
        return XPRS_LEQ
    end
    # elseif rel == Cchar('=')
    return XPRS_EQ
end

function add_constr!(model::Model, inds::Vector{Cint}, coeffs::Vector{Float64}, rel::Cchar, rhs::Float64)

    rel = constrainttype(rel)
    
    length(inds) == length(coeffs) || error("Inconsistent argument dimensions.")

    ret = @xprs_ccall(addrows, Cint,(
        Ptr{Void}, #prob
        Cint,    #number new rowws
        Cint, #number nonzeros
        Ptr{Cchar}, #cstr type
        Ptr{Float64}, # rhs
        Ptr{Float64}, # range (size new row)
        Ptr{Cint}, # start (size newrow)
        Ptr{Cint}, # ind (size new nz)
        Ptr{Float64} # val (size newnz)
        ),
        model.ptr_model, 1, length(inds), Cchar[rel], Float64[rhs], C_NULL, Cint[0], inds-Cint(1), coeffs
    )

    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end

"""
    add_constr!{I<:Integer,R<:Real}(model::Model, inds::Vector{I}, coeffs::Vector{R}, rel::GChars, rhs::Real)

Adds a single constraint  to the model.
"""
function add_constr!{I<:Integer,R<:Real}(model::Model, inds::Vector{I}, coeffs::Vector{R}, rel::GChars, rhs::Real)
    add_constr!(model, ivec(inds), fvec(coeffs), cchar(rel), Float64(rhs))
end

"""
    add_constr!(model::Model, coeffs::Vector, rel::GChars, rhs::Real)

Adds a constraint based on a dense vector os coefficients `coeffs` 
"""
function add_constr!(model::Model, coeffs::Vector, rel::GChars, rhs::Real)
    inds = find(coeffs)
    vals = coeffs[inds]
    add_constr!(model, inds, vals, rel, rhs)
end

"""
    add_constrs!(model::Model, cbeg::Vector, inds::Vector, coeffs::Vector, rel::GCharOrVec, rhs::Vector)

Adds multiple rows in sparse(not julia standard) form (see Xpress manual)

    add_constrs!(model::Model, A::CoeffMat, rel::GCharOrVec, b::Vector{Float64})

Adds multiple rows in dense or SparseMatrixCSC form (see Xpress manual)
"""
function add_constrs!(model::Model, cbegins::Vector{Cint}, inds::Vector{Cint}, coeffs::Vector{Float64}, rel::Vector{Cchar}, rhs::Vector{Float64})

    for i in 1:length(rel)
        rel[i] = constrainttype(rel[i])
    end

    m = length(cbegins)
    nnz = length(inds)
    (m == length(rel) == length(rhs) && nnz == length(coeffs)) || error("Inconsistent argument dimensions.")

    if m > 0
        ret = @xprs_ccall(addrows, Cint,(
            Ptr{Void}, #prob
            Cint,    #number new rowws
            Cint, #number nonzeros
            Ptr{Cchar}, #cstr type
            Ptr{Float64}, # rhs
            Ptr{Float64}, # range (size new row) - no range constraints
            Ptr{Cint}, # start (size newrow) - offsets of coefficientes by each new row
            Ptr{Cint}, # ind (size new nz)
            Ptr{Float64} # val (size newnz)
            ),
            model.ptr_model, m, nnz, rel, rhs, C_NULL, cbegins - Cint(1), inds - Cint(1), coeffs
        )

        if ret != 0
            throw(XpressError(model))
        end
    end
    nothing
end
function add_constrs!(model::Model, cbeg::Vector, inds::Vector, coeffs::Vector, rel::GCharOrVec, rhs::Vector)
    add_constrs!(model, ivec(cbeg), ivec(inds), fvec(coeffs), cvecx(rel, length(cbeg)), fvec(rhs))
end
function add_constrs!(model::Model, A::CoeffMat, rel::GCharOrVec, b::Vector{Float64})
    m, n = size(A)
    (m == length(b) && n == num_vars(model)) || error("Incompatible argument dimensions.")
    add_constrs_t!(model, transpose(A), rel, b)
end

"""
    add_constrs_t!(model::Model, At::SparseMatrixCSC{Float64}, rel::GCharOrVec, b::Vector)

add multiple constrints given in transpose sparse form.

    add_constrs_t!(model::Model, At::Matrix{Float64}, rel::GCharOrVec, b::Vector)


add multiple constrints given in transpose dense form.
"""
function add_constrs_t!(model::Model, At::SparseMatrixCSC{Float64}, rel::GCharOrVec, b::Vector)
    n, m = size(At)
    (m == length(b) && n == num_vars(model)) || error("Incompatible argument dimensions.")
    add_constrs!(model, At.colptr[1:At.n], At.rowval, At.nzval, rel, b)
end
function add_constrs_t!(model::Model, At::Matrix{Float64}, rel::GCharOrVec, b::Vector)
    n, m = size(At)
    (m == length(b) && n == num_vars(model)) || error("Incompatible argument dimensions.")
    add_constrs_t!(model, sparse(At), rel, b)
end

"""
    add_rangeconstr!(model::Model, inds::Vector, coeffs::Vector, lb::Real, ub::Real)
    
Adds single range constraint in sparse format

    add_rangeconstr!(model::Model, coeffs::Vector, lb::Real, ub::Real)

Adds single range constraint in dense format
"""
function add_rangeconstr!(model::Model, inds::IVec, coeffs::FVec, lb::Float64, ub::Float64)
    # b = ub
    r = ub - lb
    ret = @xprs_ccall(addrows, Cint,(
        Ptr{Void}, #prob
        Cint,    #number new rowws
        Cint, #number nonzeros
        Ptr{Cchar}, #cstr type
        Ptr{Float64}, # rhs
        Ptr{Float64}, # range (size new row)
        Ptr{Cint}, # start (size newrow)
        Ptr{Cint}, # ind (size new nz)
        Ptr{Float64} # val (size newnz)
        ),
        model.ptr_model, 1, length(inds), Cchar['R'], Float64[ub], Float64[r], Cint[0], inds-Cint(1), coeffs
    )
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end
function add_rangeconstr!(model::Model, inds::Vector, coeffs::Vector, lb::Real, ub::Real)
    add_rangeconstr!(model, ivec(inds), fvec(coeffs), Float64(lb), Float64(ub))
end
function add_rangeconstr!(model::Model, coeffs::Vector, lb::Real, ub::Real)
    inds = find(coeffs)
    vals = coeffs[inds]
    add_rangeconstr!(model, inds, vals, lb, ub)
end

"""
    add_rangeconstrs!(model::Model, cbeg::Vector, inds::Vector, coeffs::Vector, lb::Vector, ub::Vector)

Adds multiple rows in sparse(not julia standard) form (see Xpress manual)

    add_rangeconstrs!(model::Model, A::CoeffMat, lb::Vector, ub::Vector)

Adds multiple rows in dense or SparseMatrixCSC form (see Xpress manual)
"""
function add_rangeconstrs!(model::Model, cbegins::IVec, inds::IVec, coeffs::FVec, lb::FVec, ub::FVec)
    m = length(cbegins)
    nnz = length(inds)
    (m == length(lb) == length(ub) && nnz == length(coeffs)) || error("Incompatible argument dimensions.")

    if m > 0
        r = ub - lb
        ret = @xprs_ccall(addrows, Cint,(
            Ptr{Void}, #prob
            Cint,    #number new rowws
            Cint, #number nonzeros
            Ptr{Cchar}, #cstr type
            Ptr{Float64}, # rhs
            Ptr{Float64}, # range (size new row)
            Ptr{Cint}, # start (size newrow)
            Ptr{Cint}, # ind (size new nz)
            Ptr{Float64} # val (size newnz)
            ),
            model.ptr_model, m, nnz, cvecx( convert(Cchar,'R') , m), ub, r, cbegins-Cint(1), inds-Cint(1), coeffs
        )

        if ret != 0
            throw(XpressError(model))
        end
    end
    nothing
end
function add_rangeconstrs!(model::Model, cbeg::Vector, inds::Vector, coeffs::Vector, lb::Vector, ub::Vector)
    add_rangeconstrs!(model, ivec(cbeg), ivec(inds), fvec(coeffs), fvec(lb), fvec(ub))
end
function add_rangeconstrs!(model::Model, A::CoeffMat, lb::Vector, ub::Vector)
    m, n = size(A)
    (m == length(lb) == length(ub) && n == num_vars(model)) || error("Incompatible argument dimensions.")
    add_rangeconstrs_t!(model, transpose(A), lb, ub)
end

"""
    add_rangeconstrs_t!(model::Model, At::SparseMatrixCSC{Float64}, lb::Vector, ub::Vector)

add multiple constrints given in transpose sparse form.

    add_rangeconstrs_t!(model::Model, At::Matrix{Float64}, lb::Vector, ub::Vector)

add multiple constrints given in transpose dense form.
"""
function add_rangeconstrs_t!(model::Model, At::SparseMatrixCSC{Float64}, lb::Vector, ub::Vector)
    add_rangeconstrs!(model, At.colptr[1:At.n], At.rowval, At.nzval, lb, ub)
end

function add_rangeconstrs_t!(model::Model, At::Matrix{Float64}, lb::Vector, ub::Vector)
    add_rangeconstrs_t!(model, sparse(At), lb, ub)
end

"""
    get_constrmatrix(model::Model)

Return constraint matrix (A) in SparseMatrixCSC form.
"""
function get_constrmatrix(model::Model)
    nnz = num_cnzs(model)
    m = num_constrs(model)
    n = num_vars(model)
    numnzP = Array{Cint}( 1)
    cbeg = Array{Cint}( m+1)
    cind = Array{Cint}( nnz)
    cval = Array{Float64}( nnz)
    ret = @xprs_ccall(getrows, Cint, (
                     Ptr{Void},
                     Ptr{Cint},
                     Ptr{Cint},
                     Ptr{Float64},
                     Cint,
                     Ptr{Cint},
                     Cint,
                     Cint
                     ),
                     model.ptr_model, cbeg, cind, cval, nnz, numnzP, 0, m-Cint(1))
    if ret != 0
        throw(XpressError(model))
    end
    cbeg[end] = nnz
    I = Array{Int}( nnz)
    J = Array{Int}( nnz)
    V = Array{Float64}( nnz)
    for i in 1:length(cbeg)-1
        for j in (cbeg[i]+1):cbeg[i+1]
            I[j] = i
            J[j] = cind[j]+1
            V[j] = cval[j]
        end
    end
    return sparse(I, J, V, m, n)
end

"""
    add_sos!(model::Model, sostype::Symbol, idx::Vector{Cint}, weight::Vector{Float64})

Add SOS constraint of type `sostype`
Options are `:SOS1` and `:SOS2`
"""
add_sos!{I<:Integer, R<:Real}(model::Model, sostype::Symbol, idx::Vector{I}, weight::Vector{R}) = add_sos!(model, sostype, ivec(idx), fvec(weight))
function add_sos!(model::Model, sostype::Symbol, idx::Vector{Cint}, weight::Vector{Float64})
    ((nelem = length(idx)) == length(weight)) || error("Index and weight vectors of unequal length")
    (sostype == :SOS1) ? (typ = XPRS_SOS_TYPE1) : ( (sostype == :SOS2) ? (typ = XPRS_SOS_TYPE2) : error("Invalid SOS constraint type") )
    ret = @xprs_ccall(addsets, Cint, (
                     Ptr{Void},
                     Cint,
                     Cint,
                     Ptr{Cchar},
                     Ptr{Cint},
                     Ptr{Cint},
                     Ptr{Float64}
                     ),
                     model.ptr_model,
                     convert(Cint, 1),
                     convert(Cint, nelem),
                     Cchar[typ],
                     Cint[0,0],
                     convert(Vector{Cint}, idx-Cint(1)),
                     weight)
    if ret != 0
        throw(XpressError(model))
    end
end

"""
    del_constrs!{T<:Real}(model::Model, idx::Vector{T})

Delete constraintes indexed in `idx`
"""
del_constrs!{T<:Real}(model::Model, idx::T) = del_constrs!(model, Cint[idx])
del_constrs!{T<:Real}(model::Model, idx::Vector{T}) = del_constrs!(model, convert(Vector{Cint},idx))
function del_constrs!(model::Model, idx::Vector{Cint})
    numdel = length(idx)
    ret = @xprs_ccall(delrows, Cint, (
                     Ptr{Void},
                     Cint,
                     Ptr{Cint}),
                     model.ptr_model, convert(Cint,numdel), idx.-Cint(1))
    if ret != 0
        throw(XpressError(model))
    end
end

"""
    chg_coeffs!{T<:Real, S<:Real}(model::Model, cidx::Vector{T}, vidx::Vector{T}, val::Vector{S})

Change multiple coefficients of the `A` matrix given constraints `cidx`, variables `vidx` and values `val` 
"""
chg_coeffs!{T<:Real, S<:Real}(model::Model, cidx::T, vidx::T, val::S) = chg_coeffs!(model, Cint[cidx], Cint[vidx], val)
chg_coeffs!{T<:Real, S<:Real}(model::Model, cidx::Vector{T}, vidx::Vector{T}, val::Vector{S}) = chg_coeffs!(model, convert(Vector{Cint},cidx), convert(Vector{Cint},vidx), fvec(val))
function chg_coeffs!(model::Model, cidx::Vector{Cint}, vidx::Vector{Cint}, val::FVec)

    (length(cidx) == length(vidx) == length(val)) || error("Inconsistent argument dimensions.")

    numchgs = length(cidx)
    ret = @xprs_ccall(chgmcoef, Cint, (
                     Ptr{Void},
                     Cint,
                     Ptr{Cint},
                     Ptr{Cint},
                     Ptr{Float64}),
                     model, convert(Cint,numchgs), cidx-Cint(1), vidx-Cint(1), val)
    if ret != 0
        throw(XpressError(model))
    end
end 
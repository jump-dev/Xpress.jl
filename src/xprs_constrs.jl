## Add Linear constraints

# add single constraint

function add_constr!(model::Model, inds::IVec, coeffs::FVec, rel::Cchar, rhs::Float64)
    if rel == convert(Cchar,'>')
        rel = XPRS_GEQ
    elseif rel == convert(Cchar,'<')
        rel = XPRS_LEQ
    elseif rel == convert(Cchar,'=')
        rel = XPRS_EQ
    end

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
        model.ptr_model, 1, length(inds), Cchar[rel], Float64[rhs], C_NULL, Cint[0], inds-1, coeffs
    )

    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

function add_constr!(model::Model, inds::Vector, coeffs::Vector, rel::GChars, rhs::Real)
    add_constr!(model, ivec(inds), fvec(coeffs), cchar(rel), Float64(rhs))
end

function add_constr!(model::Model, coeffs::Vector, rel::GChars, rhs::Real)
    inds = find(coeffs)
    vals = coeffs[inds]
    add_constr!(model, inds, vals, rel, rhs)
end

# add multiple constraints

function add_constrs!(model::Model, cbegins::IVec, inds::IVec, coeffs::FVec, rel::CVec, rhs::FVec)

    for i in 1:length(rel)
        if rel[i] == convert(Cchar,'>')
            rel[i] = XPRS_GEQ
        elseif rel[i] == convert(Cchar,'<')
            rel[i] = XPRS_LEQ
        elseif rel[i] == convert(Cchar,'=')
            rel[i] = XPRS_EQ
        end
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
            Ptr{Float64}, # range (size new row)
            Ptr{Cint}, # start (size newrow)
            Ptr{Cint}, # ind (size new nz)
            Ptr{Float64} # val (size newnz)
            ),
            model.ptr_model, m, nnz, rel, rhs, C_NULL, cbegins - 1, inds - 1, coeffs
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

function add_constrs!(model::Model, A::CoeffMat, rel::GCharOrVec, b::Vector{Float64})
    m, n = size(A)
    (m == length(b) && n == num_vars(model)) || error("Incompatible argument dimensions.")
    add_constrs_t!(model, transpose(A), rel, b)
end


# add single range constraint

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
        model.ptr_model, 1, length(inds), Cchar['R'], Float64[ub], Float64[r], Cint[0], inds-1, coeffs
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


# add multiple range constraints

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
            model.ptr_model, m, nnz, cvecx( convert(Cchar,'R') , m), ub, r, cbegins-1, inds-1, coeffs
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

function add_rangeconstrs_t!(model::Model, At::SparseMatrixCSC{Float64}, lb::Vector, ub::Vector)
    add_rangeconstrs!(model, At.colptr[1:At.n], At.rowval, At.nzval, lb, ub)
end

function add_rangeconstrs_t!(model::Model, At::Matrix{Float64}, lb::Vector, ub::Vector)
    add_rangeconstrs_t!(model, sparse(At), lb, ub)
end

function add_rangeconstrs!(model::Model, A::CoeffMat, lb::Vector, ub::Vector)
    m, n = size(A)
    (m == length(lb) == length(ub) && n == num_vars(model)) || error("Incompatible argument dimensions.")

    add_rangeconstrs_t!(model, transpose(A), lb, ub)
end

# prepare macros for retrieving numvars and num cols and num NNZ


function get_constrmatrix(model::Model)
    nnz = num_cnzs(model)
    m = num_constrs(model)
    n = num_vars(model)
    numnzP = Array(Cint, 1)
    cbeg = Array(Cint, m+1)
    cind = Array(Cint, nnz)
    cval = Array(Float64, nnz)
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
                     model.ptr_model,
                     cbeg,
                     cind,
                     cval,
                     nnz,
                     numnzP,
                     0,
                     m-1)
    if ret != 0
        throw(XpressError(model))
    end
    cbeg[end] = nnz
    I = Array(Int, nnz)
    J = Array(Int, nnz)
    V = Array(Float64, nnz)
    for i in 1:length(cbeg)-1
        for j in (cbeg[i]+1):cbeg[i+1]
            I[j] = i
            J[j] = cind[j]+1
            V[j] = cval[j]
        end
    end
    return sparse(I, J, V, m, n)
end

function add_sos!(model::Model, sostype::Symbol, idx::Vector{Int}, weight::Vector{Cdouble})
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
                     convert(Vector{Cint}, idx-1),
                     weight)
    if ret != 0
        throw(XpressError(model))
    end
end

del_constrs!{T<:Real}(model::Model, idx::T) = del_constrs!(model, Cint[idx])
del_constrs!{T<:Real}(model::Model, idx::Vector{T}) = del_constrs!(model, convert(Vector{Cint},idx))
function del_constrs!(model::Model, idx::Vector{Cint})
    numdel = length(idx)
    ret = @xprs_ccall(delrows, Cint, (
                     Ptr{Void},
                     Cint,
                     Ptr{Cint}),
                     model.ptr_model, convert(Cint,numdel), idx.-1)
    if ret != 0
        throw(XpressError(model))
    end
end


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
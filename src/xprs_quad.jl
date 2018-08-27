# Quadratic terms (in objective) & constraints


"""
    add_qpterms!(model::Model, qr::Vector, qc::Vector, qv::Vector)
    add_qpterms!(model, H::SparseMatrixCSC{Float64})
    add_qpterms!(model, H::Matrix{Float64})

Add quadratic terms to the obejctive function
"""
function add_qpterms!(model::Model, qr::Vector{Cint}, qc::Vector{Cint}, qv::Vector{Float64})
    nnz = length(qr)
    (nnz == length(qc) == length(qv)) || error("Inconsistent argument dimensions.")
    if nnz > 0
        ret = @xprs_ccall(chgmqobj, Cint, (
            Ptr{Nothing},    # model
            Cint,         # nnz
            Ptr{Cint},    # qrow
            Ptr{Cint},    # qcol
            Ptr{Float64} # qval
            ),
            model.ptr_model, nnz, qr-Cint(1), qc-Cint(1), qv)

        if ret != 0
            throw(XpressError(model))
        end
    end
    nothing
end
function add_qpterms!(model::Model, qr::Vector, qc::Vector, qv::Vector)
    add_qpterms!(model, ivec(qr), ivec(qc), fvec(qv))
end
function add_qpterms!(model, H::SparseMatrixCSC{Float64}) # H must be symmetric
    n = num_vars(model)
    (H.m == n && H.n == n) || error("H must be an n-by-n symmetric matrix.")

    nnz_h = nnz(H)
    qr = Array{Cint}( nnz_h)
    qc = Array{Cint}( nnz_h)
    qv = Array{Float64}( nnz_h)
    k = 0

    colptr::Vector{Int} = H.colptr
    nzval::Vector{Float64} = H.nzval

    for i = 1 : n
        qi::Cint = convert(Cint, i)
        for j = colptr[i]:(colptr[i+1]-1)
            qj = convert(Cint, H.rowval[j])

            if qi < qj
                k += 1
                qr[k] = qi
                qc[k] = qj
                qv[k] = nzval[j]#*2
            elseif qi == qj
                k += 1
                qr[k] = qi
                qc[k] = qj
                qv[k] = nzval[j]# * 0.5
            end
        end
    end

    add_qpterms!(model, qr[1:k], qc[1:k], qv[1:k])
end
function add_qpterms!(model, H::Matrix{Float64}) # H must be symmetric
    n = num_vars(model)
    size(H) == (n, n) || error("H must be an n-by-n symmetric matrix.")

    nmax = round(Int,n * (n + 1) / 2)
    qr = Array{Cint}( nmax)
    qc = Array{Cint}( nmax)
    qv = Array{Float64}( nmax)
    k::Int = 0

    for i = 1 : n
        qi = convert(Cint, i)

        v = H[i,i]
        if v != 0.
            k += 1
            qr[k] = qi
            qc[k] = qi
            qv[k] = v# * 0.5
        end

        for j = i+1 : n
            v = H[j, i]
            if v != 0.
                k += 1
                qr[k] = qi
                qc[k] = convert(Cint, j)
                qv[k] = v#*2
            end
        end
    end

    add_qpterms!(model, qr[1:k], qc[1:k], qv[1:k])
end

"""
    add_diag_qpterms!(model, H::Vector)
    add_diag_qpterms!(model, hv::Real)

Add quadratic diagonal terms to the objective
"""
function add_diag_qpterms!(model, H::Vector)  # H stores only the diagonal element
    n = num_vars(model)
    n == length(H) || error("Incompatible dimensions.")
    q = [convert(Cint,1):convert(Cint,n)]
    add_qpterms!(model, q, q, fvec(h))
end
function add_diag_qpterms!(model, hv::Real)  # all diagonal elements are H
    n = num_vars(model)
    q = [convert(Cint,1):convert(Cint,n)]
    add_qpterms!(model, q, q, fill(float64(hv), n))
end

"""
    delq!(model::Model)

delete all quadritic terms formthe objective
"""
function delq!(model::Model)

    n = num_vars(model)
    k = n*(n+1)÷2

    qr = zeros(Int, k)
    qc = zeros(Int, k)
    qv = zeros(k)

    cont = 1
    for i in 1:n
        for j in i:n
            qr[cont] = i
            qc[cont] = j
            cont += 1
        end
    end

    add_qpterms!(model, qr, qc, qv)
end

"""
    getq(model::Model)

Get quadratic terms form the objective function
"""
function getq(model::Model)
    U = getq_upper(model)
    Q = (U+U')/2
    return sparse(Q)
end
function getq_upper(model::Model)
    I,J,V = getq_triplets_upper(model::Model)
    n = num_vars(model)
    return sparse(I,J,V,n,n)
end
function getq_triplets_upper(model::Model)
    nnz = num_qnzs(model)
    n = num_vars(model)
    nels = Array{Cint}( 1)
    nels[1] = nnz

    mstart = Array{Cint}( n+1)
    mclind = Array{Cint}( nnz)
    dobjval = Array{Float64}( nnz)

    ret = @xprs_ccall(getmqobj, Cint, (
        Ptr{Nothing},  # model
        Ptr{Cint},  # mstart
        Ptr{Cint},  # mclind
        Ptr{Float64},  # dobjval
        Cint, #size
        Ptr{Cint}, #nels
        Cint, #first
        Cint #last
        ),
        model.ptr_model,mstart,mclind,dobjval,nnz,nels,0,n-Cint(1))

    if ret != 0
        throw(XpressError(model))
    end
    triangle_nnz = convert(Int,nels[1])

    mstart[end] = triangle_nnz
    I = Array{Int}( triangle_nnz)
    J = Array{Int}( triangle_nnz)
    V = Array{Float64}( triangle_nnz)
    for i in 1:length(mstart)-1
        for j in (mstart[i]+1):mstart[i+1]
            I[j] = i
            J[j] = mclind[j]+1
            V[j] = dobjval[j]
        end
    end
    return I, J, V
end

"""
    add_qconstr!(model::Model, lind::Vector, lval::Vector, qr::Vector, qc::Vector,
    qv::Vector{Float64}, rel::GChars, rhs::Real)

Add quadratic contraint to the model
"""
function add_qconstr!(model::Model, lind::IVec, lval::FVec, qr::IVec, qc::IVec, qv::FVec, rel::Cchar, rhs::Float64)
    # in XPRESS quadratic matrices are added over existing linear constraints
    # ------------------------

    qnnz = length(qr)
    qnnz == length(qc) == length(qv) || error("Inconsistent argument dimensions.")

    lnnz = length(lind)
    lnnz == length(lval) || error("Inconsistent argument dimensions.")

    add_constr!(model, lind, lval, rel, rhs)
    m = num_constrs(model)

    if qnnz > 0
        ret = @xprs_ccall(addqmatrix, Cint, (
            Ptr{Nothing},    # model
            Cint,         # lin contraint o add matrix
            Cint,         # qnnz
            Ptr{Cint},    # qrow
            Ptr{Cint},    # qcol
            Ptr{Float64} # qval
            ),
            model.ptr_model, m-Cint(1), qnnz, qr.-Cint(1), qc.-Cint(1), qv)

        if ret != 0
            throw(XpressError(model))
        end
    end
    nothing
end
function add_qconstr!(model::Model, lind::Vector, lval::Vector, qr::Vector, qc::Vector,
    qv::Vector{Float64}, rel::GChars, rhs::Real)

    add_qconstr!(model, ivec(lind), fvec(lval), ivec(qr), ivec(qc), fvec(qv), cchar(rel), Float64(rhs))
end



"""
    get_qrows(model::Model)

get indices of quadratic rows
"""
function get_qrows(model::Model)
# int XPRS_CC XPRSgetqrows(XPRSprob prob, int * qmn, int qcrows[]);

    qmn = num_qconstrs(model)

    if qmn > 0

        qcrows = Array{Cint}( qmn)

        ret = @xprs_ccall(getqrows, Cint, (
            Ptr{Nothing},    # model
            Ptr{Cint},    # qmn
            Ptr{Cint}    # qcrows
            ),
            model.ptr_model, C_NULL, qcrows)

        if ret != 0
            throw(XpressError(model))
        end

        # for i in 1:length(qcrows)
        #     qcrows += 1
        # end
        return qcrows+1

    end

    return Cint[]

end

"""
    get_lrows(model::Model)

get indices of purely linear rows
"""
function get_lrows(model::Model)

    nrows = num_constrs(model)
    nlrows = num_linconstrs(model)
    nqrows = num_qconstrs(model)

    if nlrows == 0
        return Int[]
    end
    if nqrows == 0
        return collect(1:nlrows)
    end

    return setdiff(collect(1:nrows), get_qrows(model))
end

"""
    get_qrowmatrix(model::Model, row::Int)

Get matrix from quadratic row in CSC form
"""
function get_qrowmatrix(model::Model, row::Int)
    U = get_qrowmatrix_upper(model, row)
    Q = (U+U')/2
    return sparse(Q)
end
function get_qrowmatrix_upper(model::Model, row::Int)
    I,J,V = get_qrowmatrix_triplets_upper(model::Model, row::Int)
    n = num_vars(model)
    return sparse(I,J,V,n,n)
end
function get_qrowmatrix_triplets_upper(model::Model, row::Int)
#int XPRS_CC XPRSgetqrowqmatrixtriplets(XPRSprob prob, int irow, int *nqelem, int mqcol1[], int mqcol2[], double dqe[]);
    qrows = get_qrows(model)
    if row in qrows

        nqelem = Array{Cint}(1)
        ret = @xprs_ccall(getqrowqmatrixtriplets, Cint, (
            Ptr{Nothing},    # model
            Cint,
            Ptr{Cint},    # nqelem
            Ptr{Cint},    # mqcol1
            Ptr{Cint},    # mqcol2
            Ptr{Float64}    # dqe
            ),
            model.ptr_model, Cint(row-Cint(1)), nqelem, C_NULL, C_NULL, C_NULL)

        if ret != 0
            throw(XpressError(model))
        end

        mqcol1 = Array{Cint}( nqelem[1])
        mqcol2 = Array{Cint}( nqelem[1])
        dqe = Array{Float64}( nqelem[1])

        ret = @xprs_ccall(getqrowqmatrixtriplets, Cint, (
            Ptr{Nothing},    # model
            Cint,
            Ptr{Cint},    # nqelem
            Ptr{Cint},    # mqcol1
            Ptr{Cint},    # mqcol2
            Ptr{Float64}    # dqe
            ),
            model.ptr_model, Cint(row-Cint(1)), nqelem, mqcol1, mqcol2, dqe)

        if ret != 0
            throw(XpressError(model))
        end
        return mqcol1.+1, mqcol2.+1, dqe
    end
    return Cint[], Cint[], Float64[]
end
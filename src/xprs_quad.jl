# Quadratic terms (in objective) & constraints
#
# defini explicitelly SOCP?

function add_qpterms!(model::Model, qr::IVec, qc::IVec, qv::FVec)
    nnz = length(qr)
    (nnz == length(qc) == length(qv)) || error("Inconsistent argument dimensions.")


    if nnz > 0
        ret = @xprs_ccall(chgmqobj, Cint, (
            Ptr{Void},    # model
            Cint,         # nnz
            Ptr{Cint},    # qrow
            Ptr{Cint},    # qcol
            Ptr{Float64} # qval
            ),
            model.ptr_model, nnz, qr-1, qc-1, qv)

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
    qr = Array(Cint, nnz_h)
    qc = Array(Cint, nnz_h)
    qv = Array(Float64, nnz_h)
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
    qr = Array(Cint, nmax)
    qc = Array(Cint, nmax)
    qv = Array(Float64, nmax)
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
#= no existent analog : mus add a zeros matrix
function delq!(model::Model)
    ret = @grb_ccall(delq, Cint, (
        Ptr{Void},    # model
        ),
        model)

    if ret != 0
        throw(GurobiError(model.env, ret))
    end
end
=#
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




function getq(model::Model)
    Base.warn_once("getq retuns only lower triangular")
    nnz = num_qnzs(model)
    n = num_vars(model)
    nels = Array(Cint, 1)
    nels[1] = nnz

    mstart = Array(Cint, n+1)
    mclind = Array(Cint, nnz)
    dobjval = Array(Float64, nnz)

    ret = @xprs_ccall(getmqobj, Cint, (
        Ptr{Void},  # model
        Ptr{Cint},  # mstart
        Ptr{Cint},  # mclind
        Ptr{Float64},  # dobjval
        Cint, #size
        Ptr{Cint}, #nels
        Cint, #first
        Cint #last
        ),
        model.ptr_model,mstart,mclind,dobjval,nnz,nels,0,n-1)

    if ret != 0
        throw(XpressError(model))
    end
    triangle_nnz = convert(Int,nels[1])

    mstart[end] = triangle_nnz
    I = Array(Int, triangle_nnz)
    J = Array(Int, triangle_nnz)
    V = Array(Float64, triangle_nnz)
    for i in 1:length(mstart)-1
        for j in (mstart[i]+1):mstart[i+1]
            I[j] = i
            J[j] = mclind[j]+1
            V[j] = dobjval[j]
        end
    end
    return sparse(I, J, V, n, n)
end


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
            Ptr{Void},    # model
            Cint,         # lin contraint o add matrix
            Cint,         # qnnz
            Ptr{Cint},    # qrow
            Ptr{Cint},    # qcol
            Ptr{Float64} # qval
            ),
            model, m-1, qnnz, qr.-1, qc.-1, qv)

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



"indices of quadratic constraints rows"
function get_qrows(model::Model)
# int XPRS_CC XPRSgetqrows(XPRSprob prob, int * qmn, int qcrows[]);

    qmn = num_qconstrs(model)

    if qmn > 0

        qcrows = Array(Float64, qmn)

        ret = @xprs_ccall(getqrows, Cint, (
            Ptr{Void},    # model
            Ptr{Cint},    # qmn
            Ptr{Cint}    # qcrows
            ),
            model, C_NULL, qcrows)

        if ret != 0
            throw(XpressError(model))
        end

        return qcrows.+1

    end

    return Cint[]

end

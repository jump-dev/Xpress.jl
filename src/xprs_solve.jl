# Optimization and solution query
#
#
# OBS: in xpress all functions with LP in name
#      actually refer to CONTINUOUS optimization
#      LP, QP, QCQP, SOCP
#      as opposed to Integer programming

# use here ismip!
# function optimize(model::Model)
#     @assert model.ptr_model != C_NULL
#     ret = @xprs_ccall(:global, Cint, (Ptr{Void},), model.ptr_model)
#     if ret != 0
#         throw(XpressError(model))
#     end
#     nothing
# end
function optimize(model::Model)
    @assert model.ptr_model != C_NULL
    if is_mip(model)
        ret = @xprs_ccall(mipoptimize, Cint, (Ptr{Void},Ptr{Cchar}),
            model.ptr_model,C_NULL)
        if ret != 0
            throw(XpressError(model))
        end
    else
        ret = @xprs_ccall(lpoptimize, Cint, (Ptr{Void},Ptr{Cchar}),
            model.ptr_model,C_NULL)
        if ret != 0
            throw(XpressError(model))
        end
    end
    nothing
end

function computeIIS(model::Model)
    @assert model.ptr_model != C_NULL
    ret = @xprs_ccall(iisall, Cint, (Ptr{Void},), model.ptr_model)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end


#################################################
#
#  solution status and optimization info
#
#################################################

const status_symbols_lp = Dict(
    XPRS_LP_UNSTARTED         => :unstarted,
    XPRS_LP_OPTIMAL           => :optimal,
    XPRS_LP_INFEAS            => :infeasible,
    XPRS_LP_CUTOFF            => :cutoff,
    XPRS_LP_UNFINISHED        => :unfinished,
    XPRS_LP_UNBOUNDED         => :unbounded,
    XPRS_LP_CUTOFF_IN_DUAL    => :cutoff_in_dual,
    XPRS_LP_UNSOLVED          => :unsolved,
    XPRS_LP_NONCONVEX         => :nonconvex
)

const status_symbols_mip = Dict(
    XPRS_MIP_NOT_LOADED       => :mip_not_loaded,
    XPRS_MIP_LP_NOT_OPTIMAL   => :mip_lp_not_optimal,
    XPRS_MIP_LP_OPTIMAL       => :mip_lp_optimal,
    XPRS_MIP_NO_SOL_FOUND     => :mip_no_sol_found,
    XPRS_MIP_SOLUTION         => :mip_suboptimal,
    XPRS_MIP_INFEAS           => :mip_infeasible,
    XPRS_MIP_OPTIMAL          => :mip_optimal,
    XPRS_MIP_UNBOUNDED        => :mip_unbounded
)


@xprs_int_attr get_mip_status_code XPRS_MIPSTATUS
@xprs_int_attr get_lp_status_code XPRS_LPSTATUS

get_mip_status(model::Model) = status_symbols_mip[get_mip_status_code(model)]::Symbol
get_lp_status(model::Model) = status_symbols_lp[get_lp_status_code(model)]::Symbol

@xprs_int_attr get_sol_count XPRS_MIPSOLS
@xprs_int_attr get_node_count XPRS_NODES

@xprs_int_attr get_simplex_iter_count XPRS_SIMPLEXITER
@xprs_int_attr get_barrier_iter_count XPRS_BARITER

# objective
@xprs_dbl_attr get_lp_objval XPRS_LPOBJVAL
@xprs_dbl_attr get_mip_objval XPRS_MIPBESTOBJVAL
@xprs_dbl_attr get_mip_objval_last XPRS_MIPOBJVAL

@xprs_dbl_attr get_bardualobj XPRS_BARDUALOBJ
@xprs_dbl_attr get_barprimalobj XPRS_BARPRIMALOBJ

@xprs_dbl_attr get_bestbound XPRS_BESTBOUND

@xprs_dbl_attr get_objrhs XPRS_OBJRHS

#iis
@xprs_int_attr num_iis XPRS_NUMIIS

function get_objval(model::Model)
    if num_intents(model)+num_sos(model) > 0
        return get_mip_objval(model)
    else
        return get_lp_objval(model)
    end
end


type OptimInfo
    status_lp::Symbol
    status_mip::Symbol

    #time ??

    sol_count::Int
    node_count::Int

    simplex_iter_count::Int
    barrier_iter_count::Int

end

function get_optiminfo(model::Model)
    OptimInfo(
        get_lp_status(model),
        get_mip_status(model),

        #get_runtime(model),

        get_sol_count(model),
        get_node_count(model),

        get_simplex_iter_count(model),
        get_barrier_iter_count(model)
    )
end

function show(io::IO, s::OptimInfo)
    println(io, "Xpress Optimization Info")
    println(io, "    lp status    = $(s.status_lp)")
    println(io, "    mip status   = $(s.status_mip)")
    #println(io, "    runtime  = $(s.runtime)")
    println(io, "    # solutions     = $(s.sol_count)")
    println(io, "    # nodes         = $(s.node_count)")

    println(io, "    # simplex iters = $(s.simplex_iter_count)")
    println(io, "    # barrier iters = $(s.barrier_iter_count)")
end

#################################################
#
#  solution query
#
#################################################

function get_complete_lp_solution(model::Model)
    cols = num_vars(model)
    rows = num_constrs(model)

    x = Vector{Float64}(cols)
    slack = Vector{Float64}(rows)
    dual = Vector{Float64}(rows)
    red = Vector{Float64}(cols)

    ret = @xprs_ccall(getlpsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, x, slack, dual, red)
    if ret != 0
        throw(XpressError(model))
    end
    return x, slack, dual, red
end
function get_lp_solution(model::Model)
    cols = num_vars(model)

    x = Vector{Float64}(cols)

    ret = @xprs_ccall(getlpsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, x, C_NULL, C_NULL, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end
    return x
end
function get_lp_slack(model::Model)
    rows = num_constrs(model)

    slack = Vector{Float64}(rows)

    ret = @xprs_ccall(getlpsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, C_NULL, slack, C_NULL, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end
    return slack
end
function get_lp_dual(model::Model)
    rows = num_constrs(model)

    dual = Vector{Float64}(rows)

    ret = @xprs_ccall(getlpsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, C_NULL, C_NULL, dual, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end
    return dual
end
function get_lp_reducedcost(model::Model)
    cols = num_vars(model)

    red = Vector{Float64}(cols)

    ret = @xprs_ccall(getlpsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, C_NULL, C_NULL, C_NULL, red)
    if ret != 0
        throw(XpressError(model))
    end
    return red
end

## mip sol
function get_mip_solution(model::Model)
    cols = num_vars(model)

    x = Vector{Float64}(cols)

    ret = @xprs_ccall(getmipsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, x, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end
    return x
end
function get_mip_slack(model::Model)
    rows = num_constrs(model)

    slack = Vector{Float64}(rows)

    ret = @xprs_ccall(getmipsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, C_NULL, slack)
    if ret != 0
        throw(XpressError(model))
    end
    return slack
end

function get_solution(model::Model)
    if is_mip(model)
        return get_mip_solution(model)
    else
        return get_lp_solution(model)
    end
end
function get_slack(model::Model)
    if is_mip(model)
        return get_mip_slack(model)
    else
        return get_lp_slack(model)
    end
end
function get_dual(model::Model)
    if is_mip(model)
        error("Not possible to get MIP duals")
        return Float64[]
    else
        return get_lp_dual(model)
    end
end
function get_reducedcost(model::Model)
    if is_mip(model)
        error("Not possible to get MIP reduced costs")
        return Float64[]
    else
        return get_lp_reducedcost(model)
    end
end

#################################################
#
#  basis query
#
#################################################
const basicmap = Dict(
    0 => :NonbasicAtLower,#_or_SuperbasicAtZero,
    1 => :Basic,
    2 => :NonbasicAtUpper,
    3 => :Superbasic
)
const basicmap_rev = Dict(
    :NonbasicAtLower => Cint(0),#_or_SuperbasicAtZero,
    :Basic => Cint(1),
    :NonbasicAtUpper => Cint(2),
    :Superbasic => Cint(3)
)


function loadbasis(model::Model, x::Vector)#, status::Symbol = :unstarted, isnew::Vector{Bool} = [false])

    ncols = num_vars(model)
    nrows = num_constrs(model)

    length(x) != ncols && error("solution candidate size is different from the number of columns")

    cvals = Array(Cint, ncols)
    rvals = Array(Cint, nrows)

    # obtain situation of columns

    lb = get_lb(model)
    ub = get_ub(model)

    for i in 1:ncols
        if isapprox(x[i],lb[i])
            cvals[i] = basicmap_rev[:NonbasicAtLower]
        elseif isapprox(x[i],ub[i])
            cvals[i] = basicmap_rev[:NonbasicAtUpper]
        else
            cvals[i] = basicmap_rev[:Basic]
        end
    end

    # obtain situation of rows where: y = Ax

    A = get_constrmatrix(model) #A is sparse

    y = A*x

    senses = get_rowtype(model)
    rhs    = get_rhs(model)

    for j in 1:nrows
        if senses[j] == XPRS_EQ && isapprox(y[j], rhs[j])
            rvals[j] = basicmap_rev[:NonbasicAtLower]
        elseif senses[j] == XPRS_GEQ && isapprox(y[j], rhs[j])
            rvals[j] = basicmap_rev[:NonbasicAtLower]
        elseif senses[j] == XPRS_LEQ && isapprox(y[j], rhs[j])
            rvals[j] = basicmap_rev[:NonbasicAtUpper]
        else
            rvals[j] = basicmap_rev[:Basic]
        end
    end

    loadbasis(model, rvals, cvals)

    return nothing
end

function loadbasis(model::Model, rval::Vector{Symbol}, cval::Vector{Symbol})

    nrval = map(x->basicmap_rev[x], rval)
    ncval = map(x->basicmap_rev[x], cval)

    loadbasis(model, nrval, ncval)

    return nothing
end
function loadbasis(model::Model, rval::Vector{Cint}, cval::Vector{Cint})
# int XPRS_CC XPRSloadbasis(XPRSprob prob, const int rstatus[], const intcstatus[]);

    ret = @xprs_ccall(loadbasis, Cint,
        (Ptr{Void},
         Ptr{Cint},
         Ptr{Cint}
            ), model.ptr_model, rval, cval)
    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end
function get_basis(model::Model)
    cval = Array(Cint, num_vars(model))
    cbasis = Array(Symbol, num_vars(model))

    rval = Array(Cint, num_constrs(model))
    rbasis = Array(Symbol, num_constrs(model))

    ret = @xprs_ccall(getbasis, Cint,
        (Ptr{Void},
         Ptr{Cint},
         Ptr{Cint}
            ), model.ptr_model, rval, cval)
    if ret != 0
        throw(XpressError(model))
    end

    for it in 1:length(cval)
        cbasis[it] = basicmap[cval[it]]
    end

    for it in 1:length(rval)
        rbasis[it] = basicmap[rval[it]]
    end
    return cbasis, rbasis
end

#################################################
#
#  IIS query
#
#################################################

function get_iisdata(model::Model, num::Int)
# num is the number of THE IIS to be queried

    rows = Array(Cint,1)
    cols = Array(Cint,1)
    ret = @xprs_ccall(getbasis, Cint,
        (Ptr{Void},
            Cint,# num
         Ptr{Cint},# #row
         Ptr{Cint},# #cols
         Ptr{Cint},# rows set
         Ptr{Cint},# bounds set
         Ptr{Cchar},# cstr type
         Ptr{Cchar},# bnd type
         Ptr{Float64}, # duals
         Ptr{Float64}, # reduced
         Ptr{Cchar}, # isol rows
         Ptr{Cchar} #isol cols
            ), model.ptr_model, Cint(num), rows,
        cols,C_NULL,C_NULL,
        C_NULL,C_NULL,C_NULL,
        C_NULL,C_NULL,C_NULL,)

    if ret != 0
        throw(XpressError(model))
    end

    rows_set = Array(Cint, rows)
    cols_set = Array(Cint, cols)

    ret = @xprs_ccall(getbasis, Cint,
        (Ptr{Void},
            Cint,# num
         Ptr{Cint},# #row
         Ptr{Cint},# #cols
         Ptr{Cint},# rows set
         Ptr{Cint},# bounds set
         Ptr{Cchar},# cstr type
         Ptr{Cchar},# bnd type
         Ptr{Float64}, # duals
         Ptr{Float64}, # reduced
         Ptr{Cchar}, # isol rows
         Ptr{Cchar} #isol cols
            ), model.ptr_model, Cint(num), rows,
        cols,rows_set,cols_set,
        C_NULL,C_NULL,C_NULL,
        C_NULL,C_NULL,C_NULL,)

    if ret != 0
        throw(XpressError(model))
    end

    return rows_set, cols_set
end



#################################################
#
#  infeasibility & unboundedness
#
#################################################


function getdualray(model::Model)


    dray = Array(Float64, num_constrs(model))

    hasray = Array(Cint, 1)

    ret = @xprs_ccall(getdualray, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Cint}
            ), model.ptr_model, dray, hasray)
    if ret != 0
        throw(XpressError(model))
    end

    if hasray[1] == 0
        Base.warn("Xpress solver was unable to provide an infeasibility ray")
        return dray
    end

    return dray
end

function getprimalray(model::Model)


    pray = Array(Float64, num_vars(model))

    hasray = Array(Cint, 1)

    ret = @xprs_ccall(getprimalray, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Cint}
            ), model.ptr_model, pray, hasray)
    if ret != 0
        throw(XpressError(model))
    end

    if hasray[1] == 0
        Base.warn("Xpress solver was unable to provide an unboundedness ray")
        return pray
    end

    return pray
end

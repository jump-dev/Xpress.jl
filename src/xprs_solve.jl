# Optimization and solution query
#
#
# OBS: in xpress all functions with LP in name
#      actually refer to CONTINUOUS optimization
#      LP, QP, QCQP, SOCP
#      as opposed to Integer programming

"""
    optimize(model::Model)

Solve model
"""
function optimize(model::Model)
    @assert model.ptr_model != C_NULL
    if is_mip(model)
        mipoptimize(model)
    else
        lpoptimize(model)
    end
    nothing
end

"""
    lpoptimize(model::Model)

Solve models ignoring integrality.
Quadratic terms are NOT ignored.
"""
function lpoptimize(model::Model, flags::String="")
    @assert model.ptr_model != C_NULL
    tic()
    ret = @xprs_ccall(lpoptimize, Cint, (Ptr{Void},Ptr{UInt8}),
        model.ptr_model, flags)
    model.time = toq()
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

function mipoptimize(model::Model, flags::String="")
    @assert model.ptr_model != C_NULL
    tic()
    ret = @xprs_ccall(mipoptimize, Cint, (Ptr{Void},Ptr{UInt8}),
        model.ptr_model, flags)
    model.time = toq()
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

"""
    computeIIS(model::Model)

compute all ISS
"""
function computeIIS(model::Model)
    @assert model.ptr_model != C_NULL
    ret = @xprs_ccall(iisall, Cint, (Ptr{Void},), model.ptr_model)
    if ret != 0
        throw(XpressError(model))
    end
    nothing
end

function loaddelayedrows{I<:Integer}(model::Model, mrows::Array{I})
    nrows = length(mrows)
    @assert model.ptr_model != C_NULL
    ret = @xprs_ccall(loaddelayedrows, Cint, (Ptr{Void},Cint,Ptr{Cint}),
        model.ptr_model,nrows,convert(Vector{Cint},mrows-1))
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

# Unstarted (XPRS_LP_UNSTARTED).
# Optimal (XPRS_LP_OPTIMAL).
# Infeasible (XPRS_LP_INFEAS).
# Objective worse than cutoff (XPRS_LP_CUTOFF).
# Unfinished (XPRS_LP_UNFINISHED).
# Unbounded (XPRS_LP_UNBOUNDED).
# Cutoff in dual (XPRS_LP_CUTOFF_IN_DUAL).
# Problem is unsolved (XPRS_LP_UNSOLVED).
# Problem contains quadratic data, which is not convex (XPRS_LP_NONCONVEX).

@enum LP_Status LP_Unstarted LP_Optimal LP_Infeasible LP_CutOff LP_Unfinished LP_Unbounded LP_CutOffInDual LP_Unsolved LP_NonConvex LP_Unknown

function get_lp_status2(model::Model)
    code = get_lp_status_code(model)
    if code == XPRS_LP_UNSTARTED
        return LP_Unstarted
    elseif code == XPRS_LP_OPTIMAL
        return LP_Optimal
    elseif code == XPRS_LP_INFEAS
        return LP_Infeasible
    elseif code == XPRS_LP_CUTOFF
        return LP_CutOff
    elseif code == XPRS_LP_UNFINISHED
        return LP_Unfinished
    elseif code == XPRS_LP_UNBOUNDED
        return LP_Unbounded
    elseif code == XPRS_LP_CUTOFF_IN_DUAL
        return LP_CutOffInDual
    elseif code == XPRS_LP_UNSOLVED
        return LP_Unsolved
    elseif code == XPRS_LP_NONCONVEX
        return LP_NonConvex
    end
    return LP_Unknown
end

# XPRS_MIP_NOT_LOADED Problem has not been loaded.
# XPRS_MIP_LP_NOT_OPTIMAL Global search incomplete - the initial continuous relaxation has not been solved and no integer solution has been found.
# XPRS_MIP_LP_OPTIMAL Global search incomplete - the initial continuous relaxation has been solved and no integer solution has been found.
# XPRS_MIP_NO_SOL_FOUND Global search incomplete - no integer solution found.
# XPRS_MIP_SOLUTION Global search incomplete - an integer solution has been found.
# XPRS_MIP_INFEAS Global search complete - no integer solution found.
# XPRS_MIP_OPTIMAL Global search complete - integer solution found.
# XPRS_MIP_UNBOUNDED Global search incomplete - the initial continuous relaxation was found to be unbounded. A solution may have been found.

@enum MIP_Status MIP_NotLoaded MIP_LPNotOptimal MIP_LPOptimal MIP_NoSolFound MIP_Solution MIP_Infeasible MIP_Optimal MIP_Unbounded MIP_Unknown

function get_mip_status2(model::Model)
    code = get_mip_status_code(model)
    if code == XPRS_MIP_NOT_LOADED
        return MIP_NotLoaded
    elseif code == XPRS_MIP_LP_NOT_OPTIMAL
        return MIP_LPNotOptimal
    elseif code == XPRS_MIP_LP_OPTIMAL
        return MIP_LPOptimal
    elseif code == XPRS_MIP_NO_SOL_FOUND
        return MIP_NoSolFound
    elseif code == XPRS_MIP_SOLUTION
        return MIP_Solution
    elseif code == XPRS_MIP_INFEAS
        return MIP_Infeasible
    elseif code == XPRS_MIP_OPTIMAL
        return MIP_Optimal
    elseif code == XPRS_MIP_UNBOUNDED
        return MIP_Unbounded
    end
    return MIP_Unknown
end


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


mutable struct OptimInfo
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

"""
    get_lp_solution(model::Model)

return a vector with primal variable solutions
"""
function get_lp_solution(model::Model)
    cols = num_vars(model)
    x = Vector{Float64}(cols)
    get_lp_solution!(model, x)
    return x
end

"""
    get_lp_solution!(model::Model, x::Vector{Float64})

return a vector with primal variable solutions - inplace
"""
function get_lp_solution!(model::Model, x::Vector{Float64})
    _chklen(x, num_vars(model))
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
    return nothing
end


"""
    get_lp_slack(model::Model)

return a vector of slack values for rows (some srt of constraint primal solution)
"""
function get_lp_slack(model::Model)
    rows = num_constrs(model)
    slack = Vector{Float64}(rows)
    get_lp_slack!(model, slack)
    return slack
end

"""
    get_lp_slack!(model::Model, slack::Vector{Float64})

return a vector of slack values for rows (some srt of constraint primal solution) - inplace
"""
function get_lp_slack!(model::Model, slack::Vector{Float64})
    _chklen(slack, num_constrs(model))
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
    return nothing
end
function get_lp_slack_lin!(model::Model, place::Vector{Float64})
    if num_qconstrs(model) > 0
        _chklen(place, num_linconstrs(model))

        slack = zeros(num_constrs(model))
        get_lp_slack!(model, slack)

        lrows = get_lrows(model)
        _chklen(lrows, num_linconstrs(model))

        for i in eachindex(lrows)
            place[i] = slack[lrows[i]]
        end
    else
        get_lp_slack!(model, place)
    end

    return nothing
end

"""
    get_lp_dual(model::Model)

Return a vector of constraint dual solution
"""
function get_lp_dual(model::Model)
    rows = num_constrs(model)

    dual = Vector{Float64}(rows)

    get_lp_dual!(model, dual)
    return dual
end

"""
    get_lp_dual!(model::Model, dual::Vector{Float64})

Return a vector of constraint dual solution - inplace
"""
function get_lp_dual!(model::Model, dual::Vector{Float64})
    rows = num_constrs(model)
    _chklen(dual, rows)
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
    return nothing
end
function get_lp_dual_lin!(model::Model, place::Vector{Float64})
    if num_qconstrs(model) > 0
        _chklen(place, num_linconstrs(model))

        dual = zeros(num_constrs(model))
        get_lp_dual!(model, dual)

        lrows = get_lrows(model)
        _chklen(lrows, num_linconstrs(model))

        for i in eachindex(lrows)
            place[i] = dual[lrows[i]]
        end
    else
        get_lp_dual!(model, place)
    end

    return nothing
end

"""
    get_lp_reducedcost(model::Model)

Return a vector of variable reduced cost (dual solution)
"""
function get_lp_reducedcost(model::Model)
    cols = num_vars(model)

    red = Vector{Float64}(cols)

    get_lp_reducedcost!(model, red)
    return red
end

"""
    get_lp_reducedcost!(model::Model, red::Vector{Float64})

Return a vector of variable reduced cost (dual solution) - inplace
"""
function get_lp_reducedcost!(model::Model, red::Vector{Float64})
    cols = num_vars(model)

    _chklen(red, cols)

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
    return nothing
end

## mip sol
"""
    get_mip_solution(model::Model)

Return a vector of variable primal solutions
"""
function get_mip_solution(model::Model)
    cols = num_vars(model)

    x = Vector{Float64}(cols)

    get_mip_solution!(model, x)
    return x
end

"""
    get_mip_solution!(model::Model, x::Vector{Float64})

Return a vector of variable primal solutions - inplace
"""
function get_mip_solution!(model::Model, x::Vector{Float64})
    cols = num_vars(model)

    _chklen(x, cols)

    ret = @xprs_ccall(getmipsol, Cint,
        (Ptr{Void},
         Ptr{Float64},
         Ptr{Float64}
            ), model.ptr_model, x, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end
    return nothing
end

"""
    get_mip_slack(model::Model)

Return a vector of constraint primal solutions (slacks)
"""
function get_mip_slack(model::Model)
    rows = num_constrs(model)

    slack = Vector{Float64}(rows)

    get_mip_slack!(model, slack)
    return slack
end

"""
    get_mip_slack!(model::Model, slack::Vector{Float64})

Return a vector of constraint primal solutions (slacks) - inplace
"""
function get_mip_slack!(model::Model, slack::Vector{Float64})
    rows = num_constrs(model)
    _chklen(slack, rows)
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

function get_mip_slack_lin!(model::Model, place::Vector{Float64})
    if num_qconstrs(model) > 0
        _chklen(place, num_linconstrs(model))

        slack = zeros(num_constrs(model))
        get_mip_slack!(model, slack)

        lrows = get_lrows(model)
        _chklen(lrows, num_linconstrs(model))

        for i in eachindex(lrows)
            place[i] = slack[lrows[i]]
        end
    else
        get_mip_slack!(model, place)
    end
end

"""
    get_solution!(model::Model, x::Vector{Float64})

Return a vector of variable primal solution - inplace
"""
function get_solution!(model::Model, x::Vector{Float64})
    if is_mip(model)
        return get_mip_solution!(model,x)
    else
        return get_lp_solution!(model,x)
    end
end

"""
    get_solution(model::Model)

Return a vector of variable primal solution
"""
function get_solution(model::Model)
    if is_mip(model)
        return get_mip_solution(model)
    else
        return get_lp_solution(model)
    end
end

"""
    get_slack!(model::Model, slack::Vector{Float64})

Return a vector of constraints slacks - inplace

    get_slack(model::Model)

Return a vector of constraints slacks
"""
function get_slack!(model::Model, slack::Vector{Float64})
    if is_mip(model)
        return get_mip_slack!(model, slack)
    else
        return get_lp_slack!(model, slack)
    end
end
function get_slack(model::Model)
    if is_mip(model)
        return get_mip_slack(model)
    else
        return get_lp_slack(model)
    end
end
function get_slack_lin!(model::Model, slack::Vector{Float64})
    if is_mip(model)
        return get_mip_slack_lin!(model, slack)
    else
        return get_lp_slack_lin!(model, slack)
    end
end

"""
    get_dual!(model::Model, dual::Vector{Float64})

Return a vector of constraint dual solutions
"""
function get_dual!(model::Model, dual::Vector{Float64})
    if is_mip(model)
        error("Not possible to get MIP duals")
        return Float64[]
    else
        return get_lp_dual!(model,dual)
    end
end
function get_dual_lin!(model::Model, dual::Vector{Float64})
    if is_mip(model)
        error("Not possible to get MIP duals")
        return Float64[]
    else
        return get_lp_dual_lin!(model,dual)
    end
end

"""
    get_dual(model::Model)

Return a vector of constraint dual solutions
"""
function get_dual(model::Model)
    if is_mip(model)
        error("Not possible to get MIP duals")
        return Float64[]
    else
        return get_lp_dual(model)
    end
end

"""
    get_reducedcost!(model::Model, red::Vector{Float64})

Return a vector of variable dual solution
"""
function get_reducedcost!(model::Model, red::Vector{Float64})
    if is_mip(model)
        error("Not possible to get MIP reduced costs")
        return Float64[]
    else
        return get_lp_reducedcost!(model, red)
    end
end

"""
    get_reducedcost(model::Model)

Return a vector of variable dual solution
"""
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

"""
    loadbasis(model::Model, x::Vector)

Load basis to a problem in form of primal solutions

    loadbasis(model::Model, rval::Vector{Symbol}, cval::Vector{Symbol})

Load basis to a problem in terms of basicness description
Variables and constraints ca be: `Basic`, `NonBasicAtLower`, `NonBasicAtUpper` and `Superbasic`
"""
function loadbasis(model::Model, x::Vector)#, status::Symbol = :unstarted, isnew::Vector{Bool} = [false])

    ncols = num_vars(model)
    nrows = num_constrs(model)

    length(x) != ncols && error("solution candidate size is different from the number of columns")

    cvals = Array{Cint}( ncols)
    rvals = Array{Cint}( nrows)

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
    cval = Array{Cint}( num_vars(model))
    cbasis = Array{Symbol}( num_vars(model))

    rval = Array{Cint}( num_constrs(model))
    rbasis = Array{Symbol}( num_constrs(model))

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

    rows = Array{Cint}(1)
    cols = Array{Cint}(1)
    ret = @xprs_ccall(getiisdata, Cint,
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

    rows_set = Array{Cint}( rows[1])
    cols_set = Array{Cint}( cols[1])

    ret = @xprs_ccall(getiisdata, Cint,
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

    return rows_set + 1, cols_set + 1
end



#################################################
#
#  infeasibility & unboundedness
#
#################################################

function hasdualray(model::Model)::Bool

    hasray = Array{Cint}( 1)

    ret = @xprs_ccall(getdualray, Cint,
        (Ptr{Void},
            Ptr{Float64},
            Ptr{Cint}
            ), model.ptr_model, C_NULL, hasray)
    if ret != 0
        throw(XpressError(model))
    end

    if hasray[1] == 0
        return false
    else
        return true
    end
end

function getdualray!(model::Model, ray::Vector{Float64})

    @assert length(ray) == num_constrs(model)

    hasray = Array{Cint}(1)

    ret = @xprs_ccall(getdualray, Cint,
        (Ptr{Void},
            Ptr{Float64},
            Ptr{Cint}
            ), model.ptr_model, ray, hasray)
    if ret != 0
        throw(XpressError(model))
    end
    return hasray[1] != 0
end

function getdualray(model::Model)

    dray = Array{Float64}( num_constrs(model))

    if !getdualray!(model, dray)
        Base.warn("Xpress solver was unable to provide an infeasibility ray")
        return dray
    end

    return dray
end

function hasprimalray(model::Model)::Bool

    hasray = Array{Cint}( 1)

    ret = @xprs_ccall(getprimalray, Cint,
        (Ptr{Void},
            Ptr{Float64},
            Ptr{Cint}
            ), model.ptr_model, C_NULL, hasray)
    if ret != 0
        throw(XpressError(model))
    end

    if hasray[1] == 0
        return false
    else
        return true
    end
end

function getprimalray!(model::Model, ray::Vector{Float64})

    @assert length(ray) == num_vars(model)

    hasray = Array{Cint}( 1)

    ret = @xprs_ccall(getprimalray, Cint,
        (Ptr{Void},
            Ptr{Float64},
            Ptr{Cint}
            ), model.ptr_model, ray, hasray)
    if ret != 0
        throw(XpressError(model))
    end
    return hasray[1] != 0
end

function getprimalray(model::Model)

    pray = Array{Float64}( num_vars(model))

    if !getprimalray!(model, pray)
        Base.warn("Xpress solver was unable to provide an unboundedness ray")
        return pray
    end

    return pray
end

function repairweightedinfeasibility(model::Model, scode::Vector{Cint}, lrp::Vector{Float64}, grp::Vector{Float64}, lbp::Vector{Float64}, ubp::Vector{Float64}, phase2::Cchar = Cchar('f'), delta::Float64=0.001, flags::String="")
# int XPRS_CC XPRSrepairweightedinfeas(XPRSprob prob, int *scode, const double lrp[], const double grp[], const double lbp[], const double ubp[], char phase2, double delta, const char *optflags)
    ret = @xprs_ccall(repairweightedinfeas, Cint,
        (Ptr{Void},
         Ptr{Cint},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Ptr{Float64},
         Cchar,
         Float64,
         Ptr{UInt8}),
        model.ptr_model, scode, lrp, grp, lbp, ubp, phase2, delta, flags)
    if ret != 0
        throw(XpressError(model))
    end

    return nothing
end

"""
    repairweightedinfeasibility(model::Model, lrp::Vector{Float64}, grp::Vector{Float64}, lbp::Vector{Float64}, ubp::Vector{Float64}; phase2::Cchar = Cchar('f'), delta::Float64=0.001, flags::String="")
    repairweightedinfeasibility(model::Model, phase2::Cchar = Cchar('f'), delta::Float64=0.001, flags::String="")

Repair infeasibility tool
"""
repairweightedinfeasibility(model::Model, lrp::Vector{Float64}, grp::Vector{Float64}, lbp::Vector{Float64}, ubp::Vector{Float64}; phase2::Cchar = Cchar('f'), delta::Float64=0.001, flags::String="") = repairweightedinfeasibility(model::Model, lrp::Vector{Float64}, grp::Vector{Float64}, lbp::Vector{Float64}, ubp::Vector{Float64}, phase2, delta, flags)

function repairweightedinfeasibility(model::Model, lrp::Vector{Float64}, grp::Vector{Float64}, lbp::Vector{Float64}, ubp::Vector{Float64}, phase2::Cchar, delta::Float64, flags::String)

    cols = num_vars(model)
    rows = num_constrs(model)

    _chklen(rows, lrp)
    _chklen(rows, grp)
    _chklen(cols, lbp)
    _chklen(cols, ubp)

    scode = zeros(Cint,1)

    repairweightedinfeasibility(model, scode, lrp, grp, lbp, ubp, phase2, delta, flags)

    return scode[1]
end

function repairweightedinfeasibility(model::Model, phase2::Cchar = Cchar('f'), delta::Float64=0.001, flags::String="")
    cols = num_vars(model)
    rows = num_constrs(model)
    lrp = ones(rows)
    grp = ones(rows)
    lbp = ones(cols)
    ubp = ones(cols)

    return repairweightedinfeasibility(model, lrp, grp, lbp, ubp, phase2, delta, flags)
end

@xprs_int_attr stopstatus XPRS_STOPSTATUS

@enum StopStatus StopNone StopTimeLimit StopControlC StopNodeLimit StopIterLimit StopMIPGap StopSolLimit StopUser StopUnknown

function get_stopstatus(m::Model)
    ss = stopstatus(m)

    if ss == XPRS_STOP_NONE
        return StopNone
    elseif ss == XPRS_STOP_TIMELIMIT
        return StopTimeLimit
    elseif ss == XPRS_STOP_CTRLC
        return StopControlC
    elseif ss == XPRS_STOP_NODELIMIT
        return StopNodeLimit
    elseif ss == XPRS_STOP_ITERLIMIT
        return StopIterLimit
    elseif ss == XPRS_STOP_MIPGAP
        return StopMIPGap
    elseif ss == XPRS_STOP_SOLLIMIT
        return StopSolLimit
    elseif ss == XPRS_STOP_USER
        return StopUser
    end

    return StopUnknown
end

# XpressMathOptInterface
# Standardized MILP interface
const MOI = MathOptInterface

export XpressSolver
struct XpressSolver <: MOI.AbstractSolver
    options
end
XpressSolver(;kwargs...) = XpressSolver(kwargs)

mutable struct XpressSolverInstance <: MOI.AbstractSolverInstance
    inner::Model

    loaded::Bool

    # Variables

    last_variable_reference::UInt64
    variable_mapping::Vector{Int}
    # to be added
    newvariables::Vector{MOI.VariableReference}
    # to be removed
    deadvariables::Vector{MOI.VariableReference}

    # Constraints

    last_constraint_reference::UInt64
    constraint_mapping::Dict{Tuple{DataType,DataType}, Vector{MOI.ConstraintRef}}
    # to be added
    newconstraints::Dict{Tuple{DataType,DataType},Vector{Tuple{MOI.ConstraintRef, AbstractFunction, AbstractSet}}}
    # new_SA_LE::Vector{MOI.ConstraintRef}
    # new_SA_GE::Vector{MOI.ConstraintRef}
    # new_SA_EQ::Vector{MOI.ConstraintRef}
  
    # to be removed
    deadconstraints::Vector{MOI.ConstraintRef}

    # modification



    # CPLEX
    last_variable_reference::UInt64
    variable_mapping::Dict{MOI.VariableReference, Int}
    last_constraint_reference::UInt64
    constraint_mapping::Dict{MOI.ConstraintRef, Any}

    # Callbacks

    # lazycb
    # cutcb
    # heuristiccb
    # infocb

    # Options
    options
end
function XpressSolverInstance(;options...)
   m = XpressSolverInstance(Model(), 0, Dict{MOI.VariableReference, Int}(), 0, Dict{MOI.ConstraintRef, Any}(), options)
   for (name,value) in options
       setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
   end
   return m
end

MOI.SolverInstance(s::Xpressolver) = XpressSolverInstance(s.options)

# function copy(m::XpressSolverInstance)
#     m.cutcb == nothing || Base.warn_once("Callbacks can't be copied, cut callback ignored")
#     m.heuristiccb == nothing || Base.warn_once("Callbacks can't be copied, heuristic callback ignored")
#     m.infocb == nothing || Base.warn_once("Callbacks can't be copied, info callback ignored")
#     m.lazycb == nothing || Base.warn_once("Callbacks can't be copied, lazy callback ignored")
#     return XpressMathProgModel(copy(m.inner),
#                                 nothing,
#                                 nothing,
#                                 nothing, 
#                                 nothing, 
#                                 deepcopy(m.options))
# end

# Supported problems
const SUPPORTED_OBJECTIVES = [
    MOI.ScalarAffineFunction{Float64},
    MOI.ScalarQuadraticFunction{Float64}
    ]
const SUPPORTED_CONSTRAINTS = [
    (MOI.ScalarAffineFunction{Float64}, MOI.EqualsTo{Float64}),
    (MOI.ScalarAffineFunction{Float64}, MOI.LessThan{Float64}),
    (MOI.ScalarAffineFunction{Float64}, MOI.GreaterThan{Float64}),

    # (MOI.VectorAffineFunction{Float64}, MOI.Nonpositve),
    # (MOI.VectorAffineFunction{Float64}, MOI.Nonnegative),
    # (MOI.VectorAffineFunction{Float64}, MOI.EqualTo),

    # (MOI.ScalarQuadraticFunction{Float64}, MOI.EqualsTo{Float64}),
    # (MOI.ScalarQuadraticFunction{Float64}, MOI.LessThan{Float64}),
    # (MOI.ScalarQuadraticFunction{Float64}, MOI.GreaterThan{Float64}),

    # (MOI.VectorQuadraticFunction{Float64}, MOI.Nonpositve),
    # (MOI.VectorQuadraticFunction{Float64}, MOI.Nonnegative),
    # (MOI.VectorQuadraticFunction{Float64}, MOI.EqualTo),

    (MOI.SingleVariable, MOI.EqualsTo{Float64}),
    (MOI.SingleVariable, MOI.LessThan{Float64}),
    (MOI.SingleVariable, MOI.GreaterThan{Float64}),
    (MOI.SingleVariable, MOI.Interval{Float64}),

    (MOI.SingleVariable, MOI.Integer),
    (MOI.SingleVariable, MOI.ZeroOne),
    # (MOI.SingleVariable, MOI.SemiContinous{Float64}),
    # (MOI.SingleVariable, MOI.SemiInteger{Float64}),
    # (MOI.VectorOfVariables, MOI.SOS1{Float64}),
    # (MOI.VectorOfVariables, MOI.SOS2{Float64}),
    ]
function MOI.supportsproblem(s::XpressSolver, objective_type, constraint_types)
    if !(objective_type in SUPPORTED_OBJECTIVES)
        return false
    end
    for c in constraint_types
        if !(c in SUPPORTED_CONSTRAINTS)
            return false
        end
    end
    return true
end

function load!(m::XpressSolverInstance) 
    # Variables

    # a)delete
    # verify vars to remove
    # remove
    # shift reference vector
    # b) add
    # add new variables and plug the refs (use sizehint)
    # delete local variable data
    # c) modify - technically is a constraint
    # Variable bounds and types

    # Constraints by type

    # a) delete
    # b) add
    # build sparse matrix
    # add a block of constraints
    # c) modify
    # Constrs RHS
    # Constrs mods (coeffs)

    # fix quadratics
    # later...

    # Not Lazy
    # objective
    # changes? -not supported
    # other attributes
end
function optimize!(m::XpressSolverInstance) 
    load!(m)
    optimize(m.inner)

    return nothing
end

free!(m::XpressSolverInstance) = free_model(m.onner)

"""
    writeproblem(m::AbstractSolverInstance, filename::String)
Writes the current problem data to the given file.
Supported file types are solver-dependent.
"""
writeproblem(m::XpressSolverInstance, filename::Compat.ASCIIString, flags::Compat.ASCIIString="") = write_model(m.inner, filenameg, flags)


#####################
#####################
#####################
#####################
#####################
#####################
#####################



function setparameters!(m::XpressMathProgModel; mpboptions...)
    for (optname, optval) in mpboptions
        if optname == :TimeLimit
            setparam!(m.inner, XPRS_MAXTIME, round(Cint, optval) )
        elseif optname == :Silent
            if optval == true
                setparam!(m.inner, XPRS_OUTPUTLOG, 0)
            end
        else
            error("Unrecognized parameter $optname")
        end
    end
end

loadproblem!(m::Model, filename::Compat.ASCIIString) = read_model(m.inner, filename)

function loadproblem!(m::XpressMathProgModel, A, collb, colub, obj, rowlb, rowub, sense)
    # throw away old model
    #env = m.inner.env
    #m.inner.finalize_env = false
    free_model(m.inner)

    m.inner = Model()

    for (name,value) in m.options
        setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
    end

    add_cvars!(m.inner, float(obj), float(collb), float(colub))

    neginf = typemin(eltype(rowlb))
    posinf = typemax(eltype(rowub))

    # check if we have any range constraints
    # to properly support these, we will need to keep track of the
    # slack variables automatically added by gurobi.
    rangeconstrs = sum((rowlb .!= rowub) .& (rowlb .> neginf) .& (rowub .< posinf))
    if rangeconstrs > 0 
        warn("Julia Xpress interface doesn't properly support range (two-sided) constraints.")
        add_rangeconstrs!(m.inner, float(A), float(rowlb), float(rowub))
    else
        b = Array{Float64}(length(rowlb))
        senses = Array{Cchar}(length(rowlb))
        for i in 1:length(rowlb)
            if rowlb[i] == rowub[i]
                senses[i] = XPRS_EQ#'='
                b[i] = rowlb[i]
            elseif rowlb[i] > neginf
                senses[i] = XPRS_GEQ#'>'
                b[i] = rowlb[i]
            else
                @assert rowub[i] < posinf
                senses[i] = XPRS_LEQ#'<'
                b[i] = rowub[i]
            end
        end
        add_constrs!(m.inner, float(A), senses, b)
    end

    setsense!(m,sense)
    return nothing
end

writeproblem(m::XpressMathProgModel, filename:: Compat.ASCIIString) = write_model(m.inner, filename)

getvarLB(m::XpressMathProgModel)     = get_lb(m.inner)
setvarLB!(m::XpressMathProgModel, l) = set_lb!(m.inner,l)

getvarUB(m::XpressMathProgModel)     = get_ub(m.inner)
setvarUB!(m::XpressMathProgModel, u) = set_ub!(m.inner,u)

function getconstrLB(m::XpressMathProgModel)
    sense = get_rowtype(m.inner)
    ret   = get_rhs(m.inner)
    for i = 1:num_constrs(m.inner)
        if sense[i] == XPRS_GEQ || sense[i] == XPRS_EQ
            # Do nothing
        else
            # LEQ constraint, so LB is -Inf
            ret[i] = -Inf
        end
     end
     return ret
end

function getconstrUB(m::XpressMathProgModel)
    sense = get_rowtype(m.inner)
    ret   = get_rhs(m.inner)
    for i = 1:num_constrs(m.inner)
        if sense[i] == XPRS_LEQ || sense[i] == XPRS_EQ
            # Do nothing
        else
            # GEQ constraint, so UB is +Inf
            ret[i] = +Inf
        end
    end
    return ret
end

setconstrLB!(m::XpressMathProgModel, lb) = set_constrLB!(m.inner,lb)
setconstrUB!(m::XpressMathProgModel, ub) = set_constrUB!(m.inner,ub)

getobj(m::XpressMathProgModel)     = get_obj(m.inner)
setobj!(m::XpressMathProgModel, c) = set_obj!(m.inner,c)

addvar!(m::XpressMathProgModel, constridx, constrcoef, l, u, objcoef) = add_var!(m.inner, length(constridx), constridx, float(constrcoef), float(objcoef), float(l), float(u))
addvar!(m::XpressMathProgModel, l, u, objcoef) = add_cvar!(m.inner, float(objcoef), float(l), float(u))

delvars!(m::XpressMathProgModel, idx) = del_vars!(m.inner, idx)

function addconstr!(m::XpressMathProgModel, varidx, coef, lb, ub)
    if lb == -Inf
        # <= constraint
        add_constr!(m.inner, varidx, coef, XPRS_LEQ, ub)
    elseif ub == +Inf
        # >= constraint
        add_constr!(m.inner, varidx, coef, XPRS_GEQ, lb)
    elseif lb == ub
        # == constraint
        add_constr!(m.inner, varidx, coef, XPRS_EQ, lb)
    else
        # Range constraint
        error("Adding range constraints not supported yet.")
    end
end

delconstrs!(m::XpressMathProgModel, idx) = del_constrs!(m.inner, idx)
changecoeffs!(m::XpressMathProgModel, cidx, vidx, val) = chg_coeffs!(m.inner, cidx, vidx, val)

getconstrmatrix(m::XpressMathProgModel) = get_constrmatrix(m.inner)

function setsense!(m::XpressMathProgModel, sense)
    if sense == :Min
        set_sense!(m.inner, :minimize)
    elseif sense == :Max
        set_sense!(m.inner, :maximize)
    else
        error("Unrecognized objective sense $sense")
    end
end

function getsense(m::XpressMathProgModel)
    if model_sense(m.inner) == :maximize
        return :Max
    else
        return :Min
    end
end

numvar(m::XpressMathProgModel)    = num_vars(m.inner)
numconstr(m::XpressMathProgModel) = num_constrs(m.inner)
numlinconstr(m::XpressMathProgModel) = num_constrs(m.inner) - num_qconstrs(m.inner)
numquadconstr(m::XpressMathProgModel) = num_qconstrs(m.inner)

optimize!(m::XpressMathProgModel) = optimize(m.inner)

function status(m::XpressMathProgModel)
  is_mip(m.inner) ? s = get_mip_status(m.inner) : s = get_lp_status(m.inner)

  if s == :optimal
    return :Optimal
  elseif s == :infeasible
    return :Infeasible
  elseif s == :unbounded
    return :Unbounded
  elseif s == :cutoff
    return :CutOff
  elseif s == :unfinished
    return :Unfinished
  elseif s == :cutoff_in_dual
    return :CutOff_In_Dual
  elseif s == :unsolved
    return :Unsolved
  elseif s == :nonconvex
    return :Nonconvex
  #mip
  elseif s == :mip_optimal
    return :Optimal
  elseif s == :mip_infeasible
    return :Infeasible
  elseif s == :mip_unbounded
    return :Unbounded
  elseif s == :mip_not_loaded
    return :Unfinished
  elseif s == :mip_lp_not_optimal
    return :Unfinished
  elseif s == :mip_lp_optimal
    return :Unfinished
  elseif s == :mip_no_sol_found
    return :Unfinished
  elseif s == :mip_suboptimal
    return :Unfinished
#old
  elseif s == :iteration_limit || s == :node_limit || s == :time_limit || s == :solution_limit
    return :UserLimit
  elseif s == :numeric
    return :Numeric
  elseif s == :suboptimal
    return :Suboptimal # not very useful status
  elseif s == :interrupted # ended by user?
    return :UserLimit
  else
    error("Unrecognized solution status: $s")
  end
end

getobjval(m::XpressMathProgModel)   = get_objval(m.inner)
getobjbound(m::XpressMathProgModel) = get_bestbound(m.inner) #get_objbound(m.inner)
getsolution(m::XpressMathProgModel) = get_solution(m.inner)

function getconstrsolution(m::XpressMathProgModel)
    rows = num_constrs(m.inner)
    sense = get_rowtype(m.inner)
    rhs   = get_rhs(m.inner)
    slack = get_slack(m.inner)
    ret   = zeros(rows)
    for i = 1:rows
        if sense[i] == XPRS_EQ
            # Must be equal to RHS if feasible
            ret[i] = rhs[i]
        else
            # Slack variable is non-negative for <= constraints, and non-positive for >= constraints
            ret[i] = rhs[i] - slack[i]
        end
    end
    return ret
end

function getreducedcosts(m::XpressMathProgModel)
    if is_qcp(m.inner) #&& get_int_param(m.inner.env, "QCPDual") == 0
        return get_reducedcost(m.inner)
        #return fill(NaN, num_vars(m.inner))
    else
        return get_reducedcost(m.inner)
    end
end

function getconstrduals(m::XpressMathProgModel)
    if is_qcp(m.inner) #&& get_int_param(m.inner.env, "QCPDual") == 0

        nlrows = num_linconstrs(m.inner)
        nqrows = num_qconstrs(m.inner)

        lduals = Array{Float64}( nlrows)

        qrows = get_qrows(m.inner)

        duals = get_dual(m.inner)

        pos_lr = 1
        pos_qr = 1
        for r = 1:length(duals)

            if r != qrows[pos_qr]
                lduals[pos_lr] = duals[r]
                pos_lr += 1
            else
                if pos_qr < nqrows
                    pos_qr += 1
                end
            end
        end

        return lduals
        #return fill(NaN, num_constrs(m.inner))
    else
        return get_dual(m.inner)
    end
end

function getquadconstrduals(m::XpressMathProgModel)
    if is_qcp(m.inner) #&& get_int_param(m.inner.env, "QCPDual") == 0

        #nlrows = num_linconstrs(m.inner)
        nqrows = num_qconstrs(m.inner)

        qduals = Array{Float64}( nqrows)

        qrows = get_qrows(m.inner)

        duals = get_dual(m.inner)

        pos_qr = 1
        for r = 1:length(duals)

            if r == qrows[pos_qr]
                qduals[pos_qr] = duals[r]
                pos_qr += 1
            end
            if pos_qr > nqrows
                break
            end
        end

        return qduals
        #return fill(NaN, num_qconstrs(m.inner))
    else
        return Float64[]
    end
end


getinfeasibilityray(m::XpressMathProgModel) = getdualray(m.inner)
getunboundedray(m::XpressMathProgModel) = getprimalray(m.inner)

getbasis(m::XpressMathProgModel) = get_basis(m.inner)

getrawsolver(m::XpressMathProgModel) = m.inner

const var_type_map = Dict{Cchar,Symbol}(
  convert(Cchar, 'C') => :Cont,
  convert(Cchar, 'B') => :Bin,
  convert(Cchar, 'I') => :Int,
  convert(Cchar, 'S') => :SemiCont,
  convert(Cchar, 'R') => :SemiInt
)

const rev_var_type_map = Dict{Symbol,Cchar}(
  :Cont => Cchar('C'),
  :Bin => Cchar('B'),
  :Int => Cchar('I'),
  :SemiCont => Cchar('S'),
  :SemiInt => Cchar('R')
)

function setvartype!(m::XpressMathProgModel, vartype::Vector{Symbol})

    # dealing with semi continuous lower bounds
    # see issue #2
    semivars = false
    if :SemiInt in vartype
        semivars = true
    end
    if :SemiCont in vartype
        semivars = true
    end

    # do this to make sure we deal with new columns
    ind = collect( 1:length(vartype) )

    nvartype = map(x->rev_var_type_map[x], vartype)

    lb = semivars ? getvarLB(m) : Float64[] # for semi vars

    chgcoltypes!(m.inner, ind, nvartype )

    if semivars

        semi_col = Int[]
        semi_lb = Float64[]

        for i in 1:length(vartype)
            if vartype[i] == :SemiCont || vartype[i] == :SemiInt
                push!(semi_col, i)
                push!(semi_lb, lb[i])
            end
        end

        chgsemilb!(m.inner, semi_col, semi_lb)
    end

    nothing
end

function getvartype(m::XpressMathProgModel)
    ret = get_coltype(m.inner)
    return map(x->var_type_map[x], ret)
end

setwarmstart!(m::XpressMathProgModel, v) = loadbasis(m.inner, v)
addsos1!(m::XpressMathProgModel, idx, weight) = add_sos!(m.inner, :SOS1, idx, weight)
addsos2!(m::XpressMathProgModel, idx, weight) = add_sos!(m.inner, :SOS2, idx, weight)

# QCQP

function setquadobj!(m::XpressMathProgModel, rowidx, colidx, quadval)
    delq!(m.inner)

    # xpress only accept one input per matrix slot
    k = ones(Bool,length(rowidx)) #replicates holder (they are falses)
    for i in 1:length(rowidx), j in (i+1):length(rowidx)
        if ( rowidx[i] == rowidx[j] && colidx[i] == colidx[j] ) || ( rowidx[i] == colidx[j] && colidx[i] == rowidx[j] )
            quadval[i] += quadval[j]
            quadval[j] = 0.0
            rowidx[j] = -1
            colidx[j] = -1
            k[j] = false
        end
    end

    scaledvals = similar(quadval)
    for i in 1:length(rowidx)
        if rowidx[i] == colidx[i]
            # rescale from matrix format to "terms" format
            scaledvals[i] = quadval[i] #/ 2
        else
            scaledvals[i] = quadval[i]#*2
        end
    end
    add_qpterms!(m.inner, rowidx[k], colidx[k], scaledvals[k])

    return nothing
end

function addquadconstr!(m::XpressMathProgModel, linearidx, linearval, quadrowidx, quadcolidx, quadval, sense, rhs)
    # xpress only accept one input per matrix slot
    k = ones(Bool,length(quadrowidx)) #replicates holder (they are falses)
    for i in 1:length(quadrowidx), j in (i+1):length(quadrowidx)
        if ( quadrowidx[i] == quadrowidx[j] && quadcolidx[i] == quadcolidx[j] ) || ( quadrowidx[i] == quadcolidx[j] && quadcolidx[i] == quadrowidx[j] )
            quadval[i] += quadval[j]
            quadval[j] = 0.0
            #rowidx[j] = -1
            #colidx[j] = -1
            k[j] = false
        end
    end

    for i in 1:length(quadrowidx)
        if quadrowidx[i] != quadcolidx[i]
            quadval[i] = quadval[i]/2
        end
    end

    add_qconstr!(m.inner, linearidx, linearval, quadrowidx, quadcolidx, quadval, sense, rhs)
    return nothing
end

getsolvetime(m::XpressMathProgModel) = m.time
getnodecount(m::XpressMathProgModel) = get_node_count(m.inner)
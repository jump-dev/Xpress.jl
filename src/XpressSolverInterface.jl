# XpressMathProgInterface
# Standardized MILP interface

export XpressSolver

type XpressMathProgModel <: AbstractLinearQuadraticModel
    inner::Model

    lazycb
    cutcb
    heuristiccb
    infocb

    options
end
function XpressMathProgModel(;options...)

   m = XpressMathProgModel(Model(), nothing, nothing, nothing, nothing, options)

   for (name,value) in options
       setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
   end
   return m
end


immutable XpressSolver <: AbstractMathProgSolver
    options
end
XpressSolver(;kwargs...) = XpressSolver(kwargs)
LinearQuadraticModel(s::XpressSolver) = XpressMathProgModel(;s.options...)
ConicModel(s::XpressSolver) = LPQPtoConicBridge(LinearQuadraticModel(s))

supportedcones(m::XpressSolver) = [:Free, :Zero, :NonNeg, :NonPos, :SOC, :SOCRotated]

loadproblem!(m::XpressMathProgModel, filename:: Compat.ASCIIString) = read_model(m.inner, filename)

function updatemodel!(m::XpressMathProgModel)
end
# = Base.warn_once("Model update not necessary for Xpress.")
function update_model!(m::XpressMathProgModel)
end
# = Base.warn_once("Model update not necessary for Xpress.")

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
  rangeconstrs = any((rowlb .!= rowub) & (rowlb .> neginf) & (rowub .< posinf))
  if rangeconstrs
      warn("Julia Xpress interface doesn't properly support range (two-sided) constraints.")
      add_rangeconstrs!(m.inner, float(A), float(rowlb), float(rowub))
  else
      b = Array(Float64,length(rowlb))
      senses = Array(Cchar,length(rowlb))
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

function addvar!(m::XpressMathProgModel, constridx, constrcoef, l, u, objcoef)

    add_var!(m.inner, length(constridx), constridx, float(constrcoef), float(objcoef), float(l), float(u))
end
function addvar!(m::XpressMathProgModel, l, u, objcoef)

    add_cvar!(m.inner, float(objcoef), float(l), float(u))
end

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

function optimize!(m::XpressMathProgModel)
    # set callbacks if present
    #if m.lazycb != nothing || m.cutcb != nothing || m.heuristiccb != nothing || m.infocb != nothing
    #    setmathprogcallback!(m)
    #end
    #if m.lazycb != nothing
    #  setparam!(m.inner, "LazyConstraints", 1)
    #end
    optimize(m.inner)
end

#fix status
# add mip outputs
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

        lduals = Array(Float64, nlrows)

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

        qduals = Array(Float64, nqrows)

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

const var_type_map = Dict(
  convert(Cchar, 'C') => :Cont,
  convert(Cchar, 'B') => :Bin,
  convert(Cchar, 'I') => :Int,
  convert(Cchar, 'S') => :SemiCont,
  convert(Cchar, 'R') => :SemiInt
)

const rev_var_type_map = Dict(
  :Cont => 'C',
  :Bin => 'B',
  :Int => 'I',
  :SemiCont => 'S',
  :SemiInt => 'R'
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

    nvartype = map(x->Cchar(rev_var_type_map[x]), vartype)

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

    map(x->var_type_map[x], ret)
end

function setwarmstart!(m::XpressMathProgModel, v::Vector)

    loadbasis(m.inner, v)

end

addsos1!(m::XpressMathProgModel, idx, weight) = add_sos!(m.inner, :SOS1, idx, weight)
addsos2!(m::XpressMathProgModel, idx, weight) = add_sos!(m.inner, :SOS2, idx, weight)

# QCQP

function setquadobj!(m::XpressMathProgModel, rowidx, colidx, quadval)
    delq!(m.inner)

    # xpress only accept one input per matrix slot
    k = ones(Bool,length(rowidx)) #replicates holder (they are falses)
    for i in 1:length(rowidx), j in (i+1):length(rowidx)
      if rowidx[i] == rowidx[j] && colidx[i] == colidx[j]
        quadval[i] += quadval[j]
        quadval[j] = 0.0
        #rowidx[j] = -1
        #colidx[j] = -1
        k[j] = false
      end
    end
    scaledvals = similar(quadval)
    for i in 1:length(rowidx)
      if rowidx[i] == colidx[i]
        # rescale from matrix format to "terms" format
        scaledvals[i] = quadval[i] #/ 2
      else
        scaledvals[i] = quadval[i]*2
      end
    end
    add_qpterms!(m.inner, rowidx[k], colidx[k], scaledvals[k])

end

function addquadconstr!(m::XpressMathProgModel, linearidx, linearval, quadrowidx, quadcolidx, quadval, sense, rhs)

    add_qconstr!(m.inner, linearidx, linearval, quadrowidx, quadcolidx, quadval, sense, rhs)
end


#getsolvetime(m::XpressMathProgModel) = get_runtime(m.inner)
getnodecount(m::XpressMathProgModel) = get_node_count(m.inner)



# Callbacks

#=
setlazycallback!(m::XpressMathProgModel,f) = (m.lazycb = f)
setcutcallback!(m::XpressMathProgModel,f) = (m.cutcb = f)
setheuristiccallback!(m::XpressMathProgModel,f) = (m.heuristiccb = f)
setinfocallback!(m::XpressMathProgModel,f) = (m.infocb = f)

type GurobiCallbackData <: MathProgCallbackData
    cbdata::CallbackData
    state::Symbol
    where::Cint
    sol::Vector{Float64}  # Used for heuristic callbacks
#    model::XpressMathProgModel # not needed?
end

function cbgetmipsolution(d::GurobiCallbackData)
    @assert d.state == :MIPSol
    return cbget_mipsol_sol(d.cbdata, d.where)
end

function cbgetmipsolution(d::GurobiCallbackData,output)
    @assert d.state == :MIPSol
    return cbget_mipsol_sol(d.cbdata, d.where, output)
end

function cbgetlpsolution(d::GurobiCallbackData)
    @assert d.state == :MIPNode
    return cbget_mipnode_rel(d.cbdata, d.where)
end

function cbgetlpsolution(d::GurobiCallbackData, output)
    @assert d.state == :MIPNode
    return cbget_mipnode_rel(d.cbdata, d.where, output)
end


# TODO: macro for these getters?
function cbgetobj(d::GurobiCallbackData)
    if d.state == :MIPNode
        return cbget_mipnode_objbst(d.cbdata, d.where)
    elseif d.state == :MIPInfo
        return cbget_mip_objbst(d.cbdata, d.where)
    elseif d.state == :MIPSol
        error("Gurobi does not implement cbgetobj when state == MIPSol")
        # https://groups.google.com/forum/#!topic/gurobi/Az_X6Ag-y6k
        # https://github.com/JuliaOpt/MathProgBase.jl/issues/23
        # A complex workaround is possible but hasn't been implemented.
        # return cbget_mipsol_objbst(d.cbdata, d.where)
    else
        error("Unrecognized callback state $(d.state)")
    end
end

function cbgetbestbound(d::GurobiCallbackData)
    if d.state == :MIPNode
        return cbget_mipnode_objbnd(d.cbdata, d.where)
    elseif d.state == :MIPSol
        return cbget_mipsol_objbnd(d.cbdata, d.where)
    elseif d.state == :MIPInfo
        return cbget_mip_objbnd(d.cbdata, d.where)
    else
        error("Unrecognized callback state $(d.state)")
    end
end

function cbgetexplorednodes(d::GurobiCallbackData)
    if d.state == :MIPNode
        return cbget_mipnode_nodcnt(d.cbdata, d.where)
    elseif d.state == :MIPSol
        return cbget_mipsol_nodcnt(d.cbdata, d.where)
    elseif d.state == :MIPInfo
        return cbget_mip_nodcnt(d.cbdata, d.where)
    else
        error("Unrecognized callback state $(d.state)")
    end
end

# returns :MIPNode :MIPSol :Other
cbgetstate(d::GurobiCallbackData) = d.state

function cbaddcut!(d::GurobiCallbackData,varidx,varcoef,sense,rhs)
    @assert d.state == :MIPNode
    cbcut(d.cbdata, convert(Vector{Cint}, varidx), float(varcoef), sense, float(rhs))
end

function cbaddlazy!(d::GurobiCallbackData,varidx,varcoef,sense,rhs)
    @assert d.state == :MIPNode || d.state == :MIPSol
    cblazy(d.cbdata, convert(Vector{Cint}, varidx), float(varcoef), sense, float(rhs))
end

function cbaddsolution!(d::GurobiCallbackData)
    # Gurobi doesn't support adding solutions on MIPSol.
    # TODO: support this anyway
    @assert d.state == :MIPNode
    cbsolution(d.cbdata, d.sol)
    # "Wipe" solution back to GRB_UNDEFINIED
    for i in 1:length(d.sol)
        d.sol[i] = 1e101  # GRB_UNDEFINED
    end
end

function cbsetsolutionvalue!(d::GurobiCallbackData,varidx,value)
    d.sol[varidx] = value
end

# breaking abstraction, define our low-level callback to eliminatate
# a level of indirection

function mastercallback(ptr_model::Ptr{Void}, cbdata::Ptr{Void}, where::Cint, userdata::Ptr{Void})

    model = unsafe_pointer_to_objref(userdata)::XpressMathProgModel
    grbrawcb = CallbackData(cbdata,model.inner)
    if where == CB_MIPSOL
        state = :MIPSol
        grbcb = GurobiCallbackData(grbrawcb, state, where, [0.0])
        if model.lazycb != nothing
            ret = model.lazycb(grbcb)
            if ret == :Exit
                terminate(model.inner)
            end
        end
    elseif where == CB_MIPNODE
        state = :MIPNode
        # skip callback if node is reported to be cut off or infeasible --
        # nothing to do.
        # TODO: users may want this information
        status = cbget_mipnode_status(grbrawcb, where)
        if status != 2
            return convert(Cint,0)
        end
        grbcb = GurobiCallbackData(grbrawcb, state, where, [0.0])
        if model.cutcb != nothing
            ret = model.cutcb(grbcb)
            if ret == :Exit
                terminate(model.inner)
            end
        end
        if model.heuristiccb != nothing
            grbcb.sol = fill(1e101, numvar(model))  # GRB_UNDEFINED
            ret = model.heuristiccb(grbcb)
            if ret == :Exit
                terminate(model.inner)
            end
        end
        if model.lazycb != nothing
            ret = model.lazycb(grbcb)
            if ret == :Exit
                terminate(model.inner)
            end
        end
    elseif where == CB_MIP
        state = :MIPInfo
        grbcb = GurobiCallbackData(grbrawcb, state, where, [0.0])
        if model.infocb != nothing
            ret = model.infocb(grbcb)
            if ret == :Exit
                terminate(model.inner)
            end
        end
    end
    return convert(Cint,0)
end

# User callback function should be of the form:
# callback(cbdata::MathProgCallbackData)
# return :Exit to indicate an error

function setmathprogcallback!(model::XpressMathProgModel)

    @windows_only WORD_SIZE == 64 || error("Callbacks not currently supported on Win32. Use 64-bit Julia with 64-bit Gurobi.")
    grbcallback = cfunction(mastercallback, Cint, (Ptr{Void}, Ptr{Void}, Cint, Ptr{Void}))
    ret = @grb_ccall(setcallbackfunc, Cint, (Ptr{Void}, Ptr{Void}, Any), model.inner.ptr_model, grbcallback, model)
    if ret != 0
        throw(GurobiError(model.env, ret))
    end
    nothing
end
=#

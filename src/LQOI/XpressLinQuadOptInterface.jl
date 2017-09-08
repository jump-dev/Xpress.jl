# abstract type LinQuadSolver <: MOI.AbstractSolver end
# struct LinQuadSolver <: MOI.AbstractSolver
#     mipstart_effortlevel::Cint
#     logfile::String
#     options
# end

export XpressSolver
struct XpressSolver <: LQOI.LinQuadSolver
    options
end
function XpressSolver(;kwargs...)
    return XpressSolver(kwargs)
end

mutable struct XpressSolverInstance <: LQOI.LinQuadSolverInstance

    # TODO
    # env

    inner::Model

    obj_is_quad::Bool

    last_variable_reference::UInt64
    variable_mapping::Dict{MOI.VariableReference, Int}
    variable_references::Vector{MOI.VariableReference}

    variable_primal_solution::Vector{Float64}
    variable_dual_solution::Vector{Float64}

    last_constraint_reference::UInt64
    constraint_mapping::ConstraintMapping

    constraint_primal_solution::Vector{Float64}
    constraint_dual_solution::Vector{Float64}

    qconstraint_primal_solution::Vector{Float64}
    qconstraint_dual_solution::Vector{Float64}

    objective_constant::Float64

    termination_status::MOI.TerminationStatusCode
    primal_status::MOI.ResultStatusCode
    dual_status::MOI.ResultStatusCode
    primal_result_count::Int
    dual_result_count::Int

    solvetime::Float64
end

function MOI.XpressSolverInstance(s::XpressSolver)
    # env = Env()
    # lqs_setparam!(env, lqs_PARAM_SCRIND, 1) # output logs to stdout by default
    # for (name,value) in s.options
    #     lqs_setparam!(env, string(name), value)
    # end
    csi = XpressSolverInstance(
        Model(), #TODO
        false,
        0,
        Dict{MOI.VariableReference, Int}(),
        MOI.VariableReference[],
        Float64[],
        Float64[],
        0,
        ConstraintMapping(),
        Float64[],
        Float64[],
        Float64[],
        Float64[],
        0.0,
        MOI.OtherError, # not solved
        MOI.UnknownResultStatus,
        MOI.UnknownResultStatus,
        0,
        0,
        0.0
    )
    # for (name,value) in s.options
    #     setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
    # end
    # csi.inner.mipstart_effort = s.mipstart_effortlevel
    # if s.logfile != ""
    #     lqs_setlogfile!(env, s.logfile)
    # end
    return csi
end

#=
    inner wrapper
=#

#=
    Main
=#

# LinQuadSolver # Abstract type
# done above

# lqs_setparam!(env, name, val)
# TODO fix this one
lqs_setparam!(m::XpressSolverInstance, name, val) = setparam!(m.inner, XPRS_CONTROLS_DICT[name], val)

# lqs_setlogfile!(env, path)
# TODO fix this one
lqs_setlogfile!(m::XpressSolverInstance, path) = setlogfile(m.inner, filename::Compat.ASCIIString)

# lqs_getprobtype(m)
# TODO - consider removing, apparently useless

#=
    Constraints
=#

cintvec(v::Vector) = convert(Vector{Int32}, v)
cdoublevec(v::Vector) = convert(Vector{Float64}, v)

# lqs_chgbds!(m, colvec, valvec, sensevec)
lqs_chgbds!(m::Model, colvec, valvec, sensevec) = chgbounds!(m, colvec, sensevec, valvec)

# lqs_getlb(m, col)
lqs_getlb(m::Model, col) = get_lb(m, col, col)[1]
# lqs_getub(m, col)
lqs_getub(m::Model, col) = get_ub(m, col, col)[1]

# lqs_getnumrows(m)
lqs_getnumrows(m::Model) = num_linconstrs(m)

# lqs_addrows!(m, rowvec, colvec, coefvec, sensevec, rhsvec)
lqs_addrows!(m::Model, rowvec, colvec, coefvec, sensevec, rhsvec) = add_constrs!(model::Model, rowvec, colvec, coefvec, sensevec, rhsvec)

# lqs_getrhs(m, rowvec)
lqs_getrhs(m::Model, row) = get_rhs(m, row, row)

# colvec, coef = lqs_getrows(m, rowvec)
# TODO improve
function lqs_getrows(m::Model, idx)
    A = get_rows(m.inner, idx, idx)'
    return A.rowval, A.nzval
end

# lqs_getcoef(m, row, col) #??
# TODO improve
function lqs_getcoef(m::Model, row, col) #??
    A = get_rows(m.inner, row, row)'
    cols = A.rowval
    vals = A.nzval

    pos = findfirst(cols, col)
    if pos > 0
        return vals[pos]
    else
        return 0.0
    end
end

# lqs_chgcoef!(m, row, col, coef)
lqs_chgcoef!(m::Model, row, col, coef) = chg_coeffs!(m, row, col, coef)

# lqs_delrows!(m, row, row)
lqs_delrows!(m::Model, rowbeg, rowend) = del_constrs!(m, cintvec(collect(rowbeg:rowend))) 

# lqs_chgctype!(m, colvec, typevec)
# TODO fix types
lqs_chgctype!(m::Model, colvec, typevec) = chgcoltypes!(m, colvec, typevec)

# lqs_chgsense!(m, rowvec, sensevec)
# TODO fix types
lqs_chgsense!(m::Model, rowvec, sensevec) = set_rowtype!(m, rowvec, sensevec)

# TODO - later
# lqs_addsos(m, colvec, valvec, typ)
# lqs_delsos(m, idx, idx)
# lqs_getsos(m, idx)

# TODO - later
# lqs_getnumqconstrs(m)
# lqs_addqconstr(m, cols,coefs,rhs,sense, I,J,V)

# TODO - later
# lqs_chgrngval # later

#=
    Objective
=#

# lqs_copyquad(m, intvec,intvec, floatvec) #?
function lqs_copyquad(m::Model, intvec, intvec, floatvec) end

# lqs_chgobj(m, colvec,coefvec)
lqs_chgobj!(m::Model, colvec, coefvec) = set_objcoeffs!(m, colvec, coefvec)

# lqs_chgobjsen(m, symbol)
lqs_chgobjsen!(m::Model, symbol) = set_sense!(m, s) 

# lqs_getobj(m)
lqs_getobj(m::Model) = get_obj(m)

#=
    Variables
=#

# lqs_getnumcols(m)
lqs_getnumcols(m::Model) = num_vars(m)

# lqs_newcols!(m, int)
lqs_newcols!(m::Model, int) = add_cvars!(m, zeros(int))

# lqs_delcols!(m, col, col)
lqs_delcols!(m::Model, col, col2) = del_vars!(m, col)

# TODO - later
# lqs_addmipstarts(m, colvec, valvec)


#=
    Solve
=#

# lqs_mipopt!(m)
lqs_mipopt!(m::Model) = mipoptimize(m)

# lqs_qpopt!(m)
lqs_qpopt!(m::Model) = lqs_lpopt!(m)

# lqs_lpopt!(m)
lqs_lpopt!(m::Model) = lpoptimize(m)

# lqs_getstat(m)
# complex TODO
function lqs_getstat(m::Model) 
    if is_mip(m)
        return get_lp_status(m)
    else
        return get_mip_status(m)
    end
end

# lqs_solninfo(m) # complex
# complex TODO
function lqs_solninfo(m::Model) 
    warn("Fix lqs_solninfo")
    return :what, :basic, 1, 0
end

# lqs_getx!(m, place)
lqs_getx!(m::Model, place) = get_solution!(m, place)

# lqs_getax!(m, place)
lqs_getax!(m::Model, place) = get_slack!(m, place)

# lqs_getdj!(m, place)
lqs_getdj!(m::Model, place) = get_reducedcost!(m, place)

# lqs_getpi!(m, place)
lqs_getpi!(m::Model, place) = get_dual!(m, place)

# lqs_getobjval(m)
lqs_getobjval(m::Model) = get_objval(m)

# lqs_getbestobjval(m)
lqs_getbestobjval(m::Model) = get_mip_objval(m)

# lqs_getmiprelgap(m)
function lqs_getmiprelgap(m::Model)
    L = get_mip_objval(m)
    U = get_bestbound(m)
    return abs(U-L)/U
end

# lqs_getitcnt(m)
lqs_getitcnt(m::Model)  = get_simplex_iter_count(m)

# lqs_getbaritcnt(m)
lqs_getbaritcnt(m::Model) = get_barrier_iter_count(m)

# lqs_getnodecnt(m)
lqs_getnodecnt(m::Model) = get_node_count(m)

# lqs_termination_status_map(m) # = TERMINATION_STATUS_MAP
lqs_termination_status_map(m::Model) = TERMINATION_STATUS_MAP

const TERMINATION_STATUS_MAP = Dict(
    :unstarted        => MOI.OtherError, # TODO
    :optimal          => MOI.Success,
    :infeasible       => MOI.InfeasibleNoResult, # TODO improve
    :cutoff           => MOI.OtherError, # TODO
    :unfinished       => MOI.OtherError, # TODO
    :unbounded        => MOI.UnboundedNoResult, # TODO improve
    :cutoff_in_dual   => MOI.OtherError, # TODO
    :unsolved         => MOI.OtherError, # TODO
    :nonconvex        => MOI.InvalidSolverInstance # TODO
    :mip_not_loaded     => MOI.OtherError, # TODO
    :mip_lp_not_optimal => MOI.OtherError, # TODO improve
    :mip_lp_optimal     => MOI.OtherError, # TODO improve
    :mip_no_sol_found   => MOI.InfeasibleNoResult, # TODO improve
    :mip_suboptimal     => MOI.AlmostSuccess, #TODO
    :mip_infeasible     => MOI.InfeasibleNoResult, # TODO improve
    :mip_optimal        => MOI.Success,
    :mip_unbounded      => MOI.UnboundedNoResult # TODO improve
)

# lqs_sol_basic(m) #
lqs_sol_basic(m::Model) = :basic

# lqs_sol_nonbasic(m)
lqs_sol_nonbasic(m::Model) = :nonbasic

# lqs_sol_primal(m)
lqs_sol_primal(m::Model) = :primal

# lqs_sol_none(m)
lqs_sol_none(m::Model) = :none

# TODO - later
# lqs_dualopt(m)
# lqs_dualfarkas(m, place)
# lqs_getray(m, place)


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
    constraint_mapping::LQOI.ConstraintMapping

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

function MOI.SolverInstance(s::XpressSolver)
    # env = Env()
    # LQOI.lqs_setparam!(env, LQOI.lqs_PARAM_SCRIND, 1) # output logs to stdout by default
    # for (name,value) in s.options
    #     LQOI.lqs_setparam!(env, string(name), value)
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
        LQOI.ConstraintMapping(),
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
    #     LQOI.lqs_setlogfile!(env, s.logfile)
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

# LQOI.lqs_setparam!(env, name, val)
# TODO fix this one
LQOI.lqs_setparam!(m::XpressSolverInstance, name, val) = setparam!(m.inner, XPRS_CONTROLS_DICT[name], val)

# LQOI.lqs_setlogfile!(env, path)
# TODO fix this one
LQOI.lqs_setlogfile!(m::XpressSolverInstance, path) = setlogfile(m.inner, filename::Compat.ASCIIString)

# LQOI.lqs_getprobtype(m)
# TODO - consider removing, apparently useless

#=
    Constraints
=#

cintvec(v::Vector) = convert(Vector{Int32}, v)
cdoublevec(v::Vector) = convert(Vector{Float64}, v)

# LQOI.lqs_chgbds!(m, colvec, valvec, sensevec)
LQOI.lqs_chgbds!(m::Model, colvec, valvec, sensevec) = chgbounds!(m, cintvec(colvec), sensevec, valvec)

# LQOI.lqs_getlb(m, col)
LQOI.lqs_getlb(m::Model, col) = get_lb(m, col, col)[1]
# LQOI.lqs_getub(m, col)
LQOI.lqs_getub(m::Model, col) = get_ub(m, col, col)[1]

# LQOI.lqs_getnumrows(m)
LQOI.lqs_getnumrows(m::Model) = num_linconstrs(m)

# LQOI.lqs_addrows!(m, rowvec, colvec, coefvec, sensevec, rhsvec)
LQOI.lqs_addrows!(m::Model, rowvec, colvec, coefvec, sensevec, rhsvec) = add_constrs!(m::Model, rowvec, colvec, coefvec, sensevec, rhsvec)

# LQOI.lqs_getrhs(m, rowvec)
LQOI.lqs_getrhs(m::Model, row) = get_rhs(m, row, row)[1]  

# colvec, coef = LQOI.lqs_getrows(m, rowvec)
# TODO improve
function LQOI.lqs_getrows(m::Model, idx)
    A = get_rows(m, idx, idx)'
    return A.rowval-1, A.nzval
end

# LQOI.lqs_getcoef(m, row, col) #??
# TODO improve
function LQOI.lqs_getcoef(m::Model, row, col) #??
    A = get_rows(m, row, row)'
    cols = A.rowval
    vals = A.nzval

    pos = findfirst(cols, col)
    if pos > 0
        return vals[pos]
    else
        return 0.0
    end
end

# LQOI.lqs_chgcoef!(m, row, col, coef)
# TODO SPLIT THIS ONE
function LQOI.lqs_chgcoef!(m::Model, row, col, coef) 
    if row == 0
        set_objcoeffs!(m, Int32[col], Float64[coef])
    elseif col == 0
        set_rhs!(m, Int32[row], Float64[coef])
    else
        chg_coeffs!(m, row, col, coef)
    end
end

# LQOI.lqs_delrows!(m, row, row)
LQOI.lqs_delrows!(m::Model, rowbeg, rowend) = del_constrs!(m, cintvec(collect(rowbeg:rowend))) 

# LQOI.lqs_chgctype!(m, colvec, typevec)
# TODO fix types
LQOI.lqs_chgctype!(m::Model, colvec, typevec) = chgcoltypes!(m, colvec, typevec)

# LQOI.lqs_chgsense!(m, rowvec, sensevec)
# TODO fix types
LQOI.lqs_chgsense!(m::Model, rowvec, sensevec) = set_rowtype!(m, rowvec, sensevec)

const VAR_TYPE_MAP = Dict{Symbol,Cchar}(
    :CONTINUOUS => Cchar('C'),
    :INTEGER => Cchar('I'),
    :BINARY => Cchar('B')
)
LQOI.lqs_vartype_map(m::XpressSolverInstance) = VAR_TYPE_MAP

# LQOI.lqs_addsos(m, colvec, valvec, typ)
LQOI.lqs_addsos!(m::Model, colvec, valvec, typ) = add_sos!(m, typ, colvec, valvec)
# LQOI.lqs_delsos(m, idx, idx)
LQOI.lqs_delsos!(m::Model, idx1, idx2) = del_sos!(m, cintvec(collect(idx1:idx2)))

const SOS_TYPE_MAP = Dict{Symbol,Symbol}(
    :SOS1 => :SOS1,#Cchar('1'),
    :SOS2 => :SOS2#Cchar('2')
)
LQOI.lqs_sertype_map(m::XpressSolverInstance) = SOS_TYPE_MAP

# TODO - later
# LQOI.lqs_getsos(m, idx)
function LQOI.lqs_getsos(m::Model, idx)
    A, types = get_sos_matrix(m::Model)
    @show A
    @show line = A[idx,:] #sparse vec
    @show cols = line.nzind
    @show vals = line.nzval
    @show typ = types[idx] == Cchar('1') ? :SOS1 : :SOS2
    return cols, vals, typ
end
# TODO - later
# LQOI.lqs_getnumqconstrs(m)
# LQOI.lqs_addqconstr(m, cols,coefs,rhs,sense, I,J,V)

# LQOI.lqs_chgrngval
LQOI.lqs_chgrngval!(m::Model, rows, vals) = chg_rhsrange!(m, cintvec(rows), -vals)

const CTR_TYPE_MAP = Dict{Symbol,Cchar}(
    :RANGE => Cchar('R'),
    :LOWER => Cchar('L'),
    :UPPER => Cchar('U'),
    :EQUALITY => Cchar('E')
)
LQOI.lqs_ctrtype_map(m::XpressSolverInstance) = CTR_TYPE_MAP

#=
    Objective
=#

# LQOI.lqs_copyquad(m, intvec,intvec, floatvec) #?
function LQOI.lqs_copyquad(m::Model, intvec, intvec2, floatvec) end

# LQOI.lqs_chgobj(m, colvec,coefvec)
function LQOI.lqs_chgobj!(m::Model, colvec, coefvec) 
    nvars = num_vars(m)
    obj = zeros(Float64, nvars)

    for i in eachindex(colvec)
        obj[i] = coefvec[i]
    end

    set_obj!(m, obj)
    nothing
end

# LQOI.lqs_chgobjsen(m, symbol)
# TODO improve minimax
function LQOI.lqs_chgobjsen!(m::Model, symbol)
    if symbol == :Min
        set_sense!(m, :minimize)
    else
        set_sense!(m, :maximize)
    end
end
    

# LQOI.lqs_getobj(m)
LQOI.lqs_getobj(m::Model) = get_obj(m)

# lqs_getobjsen(m)
function LQOI.lqs_getobjsen(m::Model)
    s = model_sense(m)
    if s == :maximize
        return MOI.MaxSense
    else
        return MOI.MinSense
    end
end

#=
    Variables
=#

# LQOI.lqs_getnumcols(m)
LQOI.lqs_getnumcols(m::Model) = num_vars(m)

# LQOI.lqs_newcols!(m, int)
LQOI.lqs_newcols!(m::Model, int) = add_cvars!(m, zeros(int))

# LQOI.lqs_delcols!(m, col, col)
LQOI.lqs_delcols!(m::Model, col, col2) = del_vars!(m, col)

# TODO - later
# LQOI.lqs_addmipstarts(m, colvec, valvec)


#=
    Solve
=#

# LQOI.lqs_mipopt!(m)
LQOI.lqs_mipopt!(m::Model) = mipoptimize(m)

# LQOI.lqs_qpopt!(m)
LQOI.lqs_qpopt!(m::Model) = LQOI.lqs_lpopt!(m)

# LQOI.lqs_lpopt!(m)
LQOI.lqs_lpopt!(m::Model) = lpoptimize(m)

# LQOI.lqs_getstat(m)
# complex TODO
function LQOI.lqs_getstat(m::Model) 
    if is_mip(m)
        return get_mip_status(m)
    else
        return get_lp_status(m)
    end
end

# LQOI.lqs_solninfo(m) # complex
# complex TODO
function LQOI.lqs_solninfo(m::Model) 
    warn("Fix LQOI.lqs_solninfo")
    if is_mip(m)
        return :what, :primal, 1, 0
    else
        return :what, :basic, 1, 1
    end
end

# LQOI.lqs_getx!(m, place)
LQOI.lqs_getx!(m::Model, place) = get_solution!(m, place)

# LQOI.lqs_getax!(m, place)
function LQOI.lqs_getax!(m::Model, place)
    get_slack!(m, place)
    rhs = get_rhs(m)
    for i in eachindex(place)
        place[i] = -place[i]+rhs[i]
    end
    nothing
end
# LQOI.lqs_getdj!(m, place)
LQOI.lqs_getdj!(m::Model, place) = get_reducedcost!(m, place)

# LQOI.lqs_getpi!(m, place)
LQOI.lqs_getpi!(m::Model, place) = get_dual!(m, place)

# LQOI.lqs_getobjval(m)
LQOI.lqs_getobjval(m::Model) = get_objval(m)

# LQOI.lqs_getbestobjval(m)
LQOI.lqs_getbestobjval(m::Model) = get_mip_objval(m)

# LQOI.lqs_getmiprelgap(m)
function LQOI.lqs_getmiprelgap(m::Model)
    L = get_mip_objval(m)
    U = get_bestbound(m)
    return abs(U-L)/U
end

# LQOI.lqs_getitcnt(m)
LQOI.lqs_getitcnt(m::Model)  = get_simplex_iter_count(m)

# LQOI.lqs_getbaritcnt(m)
LQOI.lqs_getbaritcnt(m::Model) = get_barrier_iter_count(m)

# LQOI.lqs_getnodecnt(m)
LQOI.lqs_getnodecnt(m::Model) = get_node_count(m)

const TERMINATION_STATUS_MAP = Dict(
    :unstarted        => MOI.OtherError, # TODO
    :optimal          => MOI.Success,
    :infeasible       => MOI.InfeasibleNoResult, # TODO improve
    :cutoff           => MOI.OtherError, # TODO
    :unfinished       => MOI.OtherError, # TODO
    :unbounded        => MOI.UnboundedNoResult, # TODO improve
    :cutoff_in_dual   => MOI.OtherError, # TODO
    :unsolved         => MOI.OtherError, # TODO
    :nonconvex        => MOI.InvalidSolverInstance, # TODO
    :mip_not_loaded     => MOI.OtherError, # TODO
    :mip_lp_not_optimal => MOI.OtherError, # TODO improve
    :mip_lp_optimal     => MOI.OtherError, # TODO improve
    :mip_no_sol_found   => MOI.InfeasibleNoResult, # TODO improve
    :mip_suboptimal     => MOI.AlmostSuccess, #TODO
    :mip_infeasible     => MOI.InfeasibleNoResult, # TODO improve
    :mip_optimal        => MOI.Success,
    :mip_unbounded      => MOI.UnboundedNoResult # TODO improve
)
# LQOI.lqs_termination_status_map(m) # = TERMINATION_STATUS_MAP
LQOI.lqs_termination_status_map(m::XpressSolverInstance) = TERMINATION_STATUS_MAP

# LQOI.lqs_sol_basic(m) #
LQOI.lqs_sol_basic(m::XpressSolverInstance) = :basic

# LQOI.lqs_sol_nonbasic(m)
LQOI.lqs_sol_nonbasic(m::XpressSolverInstance) = :nonbasic

# LQOI.lqs_sol_primal(m)
LQOI.lqs_sol_primal(m::XpressSolverInstance) = :primal

# LQOI.lqs_sol_none(m)
LQOI.lqs_sol_none(m::XpressSolverInstance) = :none

# TODO - later
# LQOI.lqs_dualopt(m)
# LQOI.lqs_dualfarkas(m, place)
# LQOI.lqs_getray(m, place)


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

    LQOI.@LinQuadSolverInstanceBase
    
end

function MOI.SolverInstance(s::XpressSolver)

    env = nothing
    m = XpressSolverInstance(
        (LQOI.@LinQuadSolverInstanceBaseInit)...,
    )
    for (name,value) in s.options
        setparam!(m.inner, XPRS_CONTROLS_DICT[name], value)
    end
    # csi.inner.mipstart_effort = s.mipstart_effortlevel
    # if s.logfile != ""
    #     LQOI.lqs_setlogfile!(env, s.logfile)
    # end
    return m
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

# LQOI.lqs_getsos(m, idx)
# TODO improve getting processes
function LQOI.lqs_getsos(m::Model, idx)
    A, types = get_sos_matrix(m::Model)
    line = A[idx,:] #sparse vec
    cols = line.nzind
    vals = line.nzval
    typ = types[idx] == Cchar('1') ? :SOS1 : :SOS2
    return cols, vals, typ
end

# LQOI.lqs_getnumqconstrs(m)
LQOI.lqs_getnumqconstrs(m::Model) = num_qconstrs(m)

# LQOI.lqs_addqconstr(m, cols,coefs,rhs,sense, I,J,V)
LQOI.lqs_addqconstr!(m::Model, cols,coefs,rhs,sense, I,J,V) = add_qconstr!(m, cols, coefs, I, J, V, sense, rhs)

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
function LQOI.lqs_copyquad!(m::Model, I, J, V)
    delq!(m)
    add_qpterms!(m, I, J, V)
    return nothing
end

# LQOI.lqs_chgobj(m, colvec,coefvec)
function LQOI.lqs_chgobj!(m::Model, colvec, coefvec) 
    nvars = num_vars(m)
    obj = zeros(Float64, nvars)

    for i in eachindex(colvec)
        obj[colvec[i]] = coefvec[i]
    end

    set_obj!(m, obj)
    nothing
end

# LQOI.lqs_chgobjsen(m, symbol)
# TODO improve min max names
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

# LQOI.lqs_addmipstarts(m, colvec, valvec)
function LQOI.lqs_addmipstarts!(m::Model, colvec, valvec) 
    x = zeros(num_vars(m))
    for i in eachindex(colvec)
        x[colvec[i]] = valvec[i]
    end
    loadbasis(m, x)
end
#=
    Solve
=#

# LQOI.lqs_mipopt!(m)
LQOI.lqs_mipopt!(m::Model) = mipoptimize(m)

# LQOI.lqs_qpopt!(m)
LQOI.lqs_qpopt!(m::Model) = LQOI.lqs_lpopt!(m)

# LQOI.lqs_lpopt!(m)
LQOI.lqs_lpopt!(m::Model) = lpoptimize(m)

# LQOI.lqs_terminationstatus(m)
function LQOI.lqs_terminationstatus(model::XpressSolverInstance)
    m = model.inner 
    stat_lp = get_lp_status2(m)
    if is_mip(m)
        stat_mip = get_mip_status2(m)
        if stat_mip == MIP_NotLoaded
            return MOI.OtherError
        elseif stat_mip == MIP_LPNotOptimal
            # MIP search incomplete but there is no linear sol
            # return MOI.OtherError
            return MOI.InfeasibleOrUnbounded
        elseif stat_mip == MIP_NoSolFound
            # MIP search incomplete but there is no integer sol
            other = xprsmoi_stopstatus(m)
            if other == MOI.OtherError
                return MOI.SlowProgress#OtherLimit
            else 
                return other
            end

        elseif stat_mip == MIP_Solution
            # MIP search incomplete but there is a solution
            other = xprsmoi_stopstatus(m)
            if other == MOI.OtherError
                return MOI.OtherLimit
            else 
                return other
            end

        elseif stat_mip == MIP_Infeasible
            if hasdualray(m)
                return MOI.Success
            else
                return MOI.InfeasibleNoResult
            end
        elseif stat_mip == MIP_Optimal
            return MOI.Success
        elseif stat_mip == MIP_Unbounded
            if hasprimalray(m)
                return MOI.Success
            else
                return MOI.UnboundedNoResult
            end
        end
        return MOI.OtherError
    else
        if stat_lp == LP_Unstarted
            return MOI.OtherError
        elseif stat_lp == LP_Optimal
            return MOI.Success
        elseif stat_lp == LP_Infeasible
            if hasdualray(m)
                return MOI.Success
            else
                return MOI.InfeasibleNoResult
            end
        elseif stat_lp == LP_CutOff
            return MOI.ObjectiveLimit
        elseif stat_lp == LP_Unfinished
            return xprsmoi_stopstatus(m)
        elseif stat_lp == LP_Unbounded
            if hasprimalray(m)
                return MOI.Success
            else
                return MOI.UnboundedNoResult
            end
        elseif stat_lp == LP_CutOffInDual
            return MOI.ObjectiveLimit
        elseif stat_lp == LP_Unsolved
            return MOI.OtherError
        elseif stat_lp == LP_NonConvex
            return MOI.InvalidInstance
        end
        return MOI.OtherError
    end
end

function xprsmoi_stopstatus(m::Model)
    ss = get_stopstatus(m)
    if ss == StopTimeLimit
        return MOI.TimeLimit
    elseif ss == StopControlC
        return MOI.Interrupted
    elseif ss == StopNodeLimit
        # should not be here
        warn("should not be here")
        return MOI.NodeLimit
    elseif ss == StopIterLimit
        return MOI.IterationLimit
    elseif ss == StopMIPGap
        return MOI.ObjectiveLimit
    elseif ss == StopSolLimit
        return MOI.SolutionLimit
    elseif ss == StopUser
        return MOI.Interrupted
    end
    return MOI.OtherError
end

function LQOI.lqs_primalstatus(model::XpressSolverInstance)
    m = model.inner
    if is_mip(m)
        stat_mip = get_mip_status2(m)
        if stat_mip in [MIP_Solution,MIP_Optimal]
            return MOI.FeasiblePoint
        elseif MIP_Infeasible && hasdualray(m)
            return MOI.InfeasibilityCertificate
        elseif MIP_Unbounded && hasprimalray(m)
            return MOI.InfeasibilityCertificate
        elseif stat_mip in [MIP_LPOptimal, MIP_NoSolFound]
            return MOI.InfeasiblePoint
        end
        return MOI.UnknownResultStatus
    else
        stat_lp = get_lp_status2(m)
        if stat_lp == LP_Optimal
            return MOI.FeasiblePoint
        elseif stat_lp == LP_Unbounded && hasprimalray(m)
            return MOI.InfeasibilityCertificate
        # elseif stat_lp == LP_Infeasible
        #     return MOI.InfeasiblePoint - xpress wont return
        # elseif cutoff//cutoffindual ???
        else
            return MOI.UnknownResultStatus
        end
    end
end
function LQOI.lqs_dualstatus(model::XpressSolverInstance)
    m = model.inner    
    if is_mip(m)
        return MOI.UnknownResultStatus
    else
        stat_lp = get_lp_status2(m)
        if stat_lp == LP_Optimal
            return MOI.FeasiblePoint
        elseif stat_lp == LP_Infeasible && hasdualray(m)
            return MOI.InfeasibilityCertificate
        # elseif stat_lp == LP_Unbounded
        #     return MOI.InfeasiblePoint - xpress wont return
        # elseif cutoff//cutoffindual ???
        else
            return MOI.UnknownResultStatus
        end
    end
end


# LQOI.lqs_getx!(m, place)
LQOI.lqs_getx!(m::Model, place) = get_solution!(m, place)

# LQOI.lqs_getax!(m, place)
function LQOI.lqs_getax!(m::Model, place)
    get_slack_lin!(m, place)
    rhs = get_rhs(m)
    for i in eachindex(place)
        place[i] = -place[i]+rhs[i]
    end
    nothing
end
# LQOI.lqs_getdj!(m, place)
LQOI.lqs_getdj!(m::Model, place) = get_reducedcost!(m, place)

# LQOI.lqs_getpi!(m, place)
LQOI.lqs_getpi!(m::Model, place) = get_dual_lin!(m, place)

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

# LQOI.lqs_dualfarkas(m, place)
LQOI.lqs_dualfarkas!(m::Model, place) = getdualray!(m, place)

# LQOI.lqs_getray(m, place)
LQOI.lqs_getray!(m::Model, place) = getprimalray!(m, place)


MOI.free!(m::XpressSolverInstance) = free_model(m.onner)

"""
    writeproblem(m::AbstractSolverInstance, filename::String)
Writes the current problem data to the given file.
Supported file types are solver-dependent.
"""
MOI.writeproblem(m::XpressSolverInstance, filename::Compat.ASCIIString, flags::Compat.ASCIIString="") = write_model(m.inner, filename, flags)
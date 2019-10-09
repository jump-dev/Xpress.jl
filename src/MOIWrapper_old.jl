const XPR = Xpress
using LinQuadOptInterface
const LQOI = LinQuadOptInterface
const MOI = LQOI.MOI

const SUPPORTED_OBJECTIVES = [
    LQOI.SinVar,
    LQOI.Linear,
    LQOI.Quad
]

const SUPPORTED_CONSTRAINTS = [
    (LQOI.Linear, LQOI.EQ),
    (LQOI.Linear, LQOI.LE),
    (LQOI.Linear, LQOI.GE),
    (LQOI.Linear, LQOI.IV),
    (LQOI.Quad, LQOI.EQ),
    (LQOI.Quad, LQOI.LE),
    (LQOI.Quad, LQOI.GE),
    (LQOI.SinVar, LQOI.EQ),
    (LQOI.SinVar, LQOI.LE),
    (LQOI.SinVar, LQOI.GE),
    (LQOI.SinVar, LQOI.IV),
    (LQOI.SinVar, MOI.ZeroOne),
    (LQOI.SinVar, MOI.Integer),
    (LQOI.VecVar, LQOI.SOS1),
    # (LQOI.VecVar, LQOI.SOS2),
    # (LQOI.SinVar, MOI.Semicontinuous{Float64}),
    # (LQOI.SinVar, MOI.Semiinteger{Float64}),
    (LQOI.VecVar, MOI.Nonnegatives),
    (LQOI.VecVar, MOI.Nonpositives),
    (LQOI.VecVar, MOI.Zeros),
    (LQOI.VecLin, MOI.Nonnegatives),
    (LQOI.VecLin, MOI.Nonpositives),
    (LQOI.VecLin, MOI.Zeros)
]

mutable struct Optimizer <: LQOI.LinQuadOptimizer
    LQOI.@LinQuadOptimizerBase(Model)
    params::Dict{Any,Any}
    l_rows::Vector{Int}
    q_rows::Vector{Int}
    conflict::Union{Nothing, IISData}
    Optimizer(::Nothing) = new()
end

LQOI.LinearQuadraticModel(::Type{Optimizer}, env) = XPR.Model()

function Optimizer(; kwargs...)
    env = nothing
    m = Optimizer(nothing)
    m.params = Dict{Any,Any}()
    MOI.empty!(m)
    for (name,value) in kwargs
        m.params[name] = value
        XPR.setparam!(m.inner, XPR.XPRS_CONTROLS_DICT[name], value)
    end
    m.conflict = nothing
    return m
end

function MOI.empty!(m::Optimizer)
    MOI.empty!(m,nothing)
    # m.constraint_primal_solution = m.qconstraint_primal_solution
    # m.constraint_dual_solution = m.qconstraint_dual_solution
    m.l_rows = Int[]
    m.q_rows = Int[]
    m.conflict = nothing
    for (name,value) in m.params
        XPR.setparam!(m.inner, XPR.XPRS_CONTROLS_DICT[name], value)
    end
end

LQOI.supported_constraints(s::Optimizer) = SUPPORTED_CONSTRAINTS
LQOI.supported_objectives(s::Optimizer) = SUPPORTED_OBJECTIVES

backend_type(m::Optimizer, ::MOI.GreaterThan{T}) where T = Cchar('G')
backend_type(m::Optimizer, ::MOI.LessThan{T}) where T    = Cchar('L')
backend_type(m::Optimizer, ::MOI.EqualTo{T}) where T     = Cchar('E')
# Implemented separately
# backend_type(m::Optimizer, ::MOI.Interval{T}) where T    = Cchar('R')

backend_type(m::Optimizer, ::MOI.Zeros)        = Cchar('E')
backend_type(m::Optimizer, ::MOI.Nonpositives) = Cchar('L')
backend_type(m::Optimizer, ::MOI.Nonnegatives) = Cchar('G')

#=
    not in LinQuad
=#

setparam!(instance::Optimizer, name, val) = XPR.setparam!(instance.inner, XPR.XPRS_CONTROLS_DICT[name], val)

setlogfile!(instance::Optimizer, path) = XPR.setlogfile(instance.inner, path::String)

cintvec(v::Vector) = convert(Vector{Int32}, v)

#=
    Constraints
=#

LQOI.change_variable_bounds!(instance::Optimizer, colvec, valvec, sensevec) = XPR.chgbounds!(instance.inner, cintvec(colvec), sensevec, valvec)

LQOI.get_variable_lowerbound(instance::Optimizer, col) = XPR.get_lb(instance.inner, col, col)[1]
LQOI.get_variable_upperbound(instance::Optimizer, col) = XPR.get_ub(instance.inner, col, col)[1]

LQOI.get_number_linear_constraints(instance::Optimizer) = XPR.num_linconstrs(instance.inner)

LQOI.get_number_quadratic_constraints(instance::Optimizer) = XPR.num_qconstrs(instance.inner)

# function LQOI.shift_references_after_delete_quadratic!(instance::Optimizer, row)
#     LQOI.shift_references_after_delete_quadratic_base!(instance, row)
#     LQOI.shift_references_after_delete_affine_base!(instance, row)
# end
# function LQOI.shift_references_after_delete_affine!(instance::Optimizer, row)
#     LQOI.shift_references_after_delete_quadratic_base!(instance, row)
#     LQOI.shift_references_after_delete_affine_base!(instance, row)
# end

function LQOI.add_linear_constraints!(instance::Optimizer, A::LQOI.CSRMatrix{Float64}, sensevec, rhsvec)
    newrows = length(rhsvec)
    rows = XPR.num_constrs(instance.inner)
    addedrows = collect((rows+1):(rows+newrows))
    # quadind
    append!(instance.l_rows,addedrows)
    XPR.add_constrs!(instance.inner, A.row_pointers, A.columns, A.coefficients, sensevec, rhsvec)
end

function LQOI.add_ranged_constraints!(instance::Optimizer, A::LQOI.CSRMatrix{Float64}, lowerbound, upperbound)
    newrows = length(lowerbound)
    rows = XPR.num_constrs(instance.inner)
    addedrows = collect((rows+1):(rows+newrows))
    # quadind
    append!(instance.l_rows,addedrows)
    sensevec = fill(Cchar('E'),newrows)
    XPR.add_constrs!(instance.inner, A.row_pointers, A.columns, A.coefficients, sensevec, upperbound)
    XPR.chg_rhsrange!(instance.inner, cintvec(addedrows), upperbound .- lowerbound)
end

function LQOI.modify_ranged_constraints!(instance::Optimizer, rows::Vector{Int}, lowerbound::Vector{Float64}, upperbound::Vector{Float64})
    # quadind
    _rows = instance.l_rows[rows]
    XPR.set_rhs!(instance.inner, _rows, upperbound)
    XPR.chg_rhsrange!(instance.inner, cintvec(_rows), upperbound .- lowerbound)
end

function LQOI.get_rhs(instance::Optimizer, row)
    # quadind
    _row = instance.l_rows[row]
    return XPR.get_rhs(instance.inner, _row, _row)[1]
end
function LQOI.get_quadratic_rhs(instance::Optimizer, row)
    # quadind
    _row = instance.q_rows[row]
    return XPR.get_rhs(instance.inner, _row, _row)[1]
end

function LQOI.get_range(instance::Optimizer, row)
    # quadind
    _row = instance.l_rows[row]
    ub = XPR.get_rhs(instance.inner, _row, _row)[1]
    r = XPR.get_rhsrange(instance.inner, _row, _row)[1]
    return ub .- r, ub
end

# TODO improve
function LQOI.get_linear_constraint(instance::Optimizer, row)
    # quadind
    _row = instance.l_rows[row]
    A = sparse(XPR.get_rows(instance.inner, _row, _row)')
    return rowvals(A), nonzeros(A)
end

function LQOI.get_quadratic_constraint(instance::Optimizer, row)
    # quadind
    _row = instance.q_rows[row]
    A = sparse(XPR.get_rows(instance.inner, _row, _row)')
    Q = XPR.get_qrowmatrix(instance.inner, _row)
    return rowvals(A), nonzeros(A), Q
end

# notin LQOI
# TODO improve
function getcoef(instance::Optimizer, row, col)
    # quadind
    _row = instance.l_rows[row]
    A = sparse(XPR.get_rows(instance.inner, _row, _row)')
    cols = rowvals(A)
    vals = nonzeros(A)

    pos = findfirst(cols, col)
    if pos > 0
        return vals[pos]
    else
        return 0.0
    end
end

function LQOI.change_matrix_coefficient!(instance::Optimizer, row, col, coef)
    # quadind
    _row = instance.l_rows[row]
    XPR.chg_coeffs!(instance.inner, _row, col, coef)
end

function LQOI.change_objective_coefficient!(instance::Optimizer, col, coef)
    XPR.set_objcoeffs!(instance.inner, Int32[col], Float64[coef])
end
function LQOI.change_rhs_coefficient!(instance::Optimizer, row, coef)
    # quadind
    _row = instance.l_rows[row]
    XPR.set_rhs!(instance.inner, Int32[_row], Float64[coef])
end
function LQOI.delete_linear_constraints!(instance::Optimizer, rowbeg, rowend)
    _rows = instance.l_rows[collect(rowbeg:rowend)]
    XPR.del_constrs!(instance.inner, cintvec(_rows))
    for i in rowend:-1:rowbeg
        val = instance.l_rows[i]
        deleteat!(instance.l_rows,i)
        for j in eachindex(instance.l_rows)
            if instance.l_rows[j] > val
                instance.l_rows[j] -= 1
            end
        end
    end
end
function LQOI.delete_quadratic_constraints!(instance::Optimizer, rowbeg, rowend)
    _rows = instance.q_rows[collect(rowbeg:rowend)]
    XPR.del_constrs!(instance.inner, cintvec(_rows))
    for i in rowend:-1:rowbeg
        val = instance.q_rows[i]
        deleteat!(instance.q_rows,i)
        for j in eachindex(instance.q_rows)
            if instance.q_rows[j] > val
                instance.q_rows[j] -= 1
            end
        end
    end
end
LQOI.change_variable_types!(instance::Optimizer, colvec, typevec) = XPR.chgcoltypes!(instance.inner, colvec, typevec)

function LQOI.change_linear_constraint_sense!(instance::Optimizer, rowvec, sensevec)
    _rows = instance.l_rows[rowvec]
    XPR.set_rowtype!(instance.inner, _rows, sensevec)
end
LQOI.add_sos_constraint!(instance::Optimizer, colvec, valvec, typ) = XPR.add_sos!(instance.inner, typ, colvec, valvec)

LQOI.delete_sos!(instance::Optimizer, idx1, idx2) = XPR.del_sos!(instance.inner, cintvec(collect(idx1:idx2)))

# TODO improve getting processes
function LQOI.get_sos_constraint(instance::Optimizer, idx)
    A, types = XPR.get_sos_matrix(instance.inner)
    line = A[idx,:] #sparse vec
    cols = line.nzind
    vals = line.nzval
    typ = types[idx] == Cchar('1') ? :SOS1 : :SOS2
    return cols, vals, typ
end

function LQOI.add_quadratic_constraint!(instance::Optimizer, cols, coefs, rhs, sense, I, J, V)
    @assert length(I) == length(J) == length(V)
    XPR.add_qconstr!(instance.inner, cols, coefs, I, J, V/2, sense, rhs)
    push!(instance.q_rows, num_constrs(instance.inner))
end

#=
    Objective
=#

function LQOI.set_quadratic_objective!(instance::Optimizer, I, J, V)
    @assert length(I) == length(J) == length(V)
    XPR.delq!(instance.inner)
    XPR.add_qpterms!(instance.inner, I, J, V)
    return nothing
end

function LQOI.set_linear_objective!(instance::Optimizer, colvec, coefvec)
    nvars = XPR.num_vars(instance.inner)
    obj = zeros(Float64, nvars)

    for i in eachindex(colvec)
        obj[colvec[i]] += coefvec[i]
    end

    XPR.set_obj!(instance.inner, obj)
    nothing
end

function LQOI.change_objective_sense!(instance::Optimizer, symbol)
    if symbol == :min
        XPR.set_sense!(instance.inner, :minimize)
    else
        XPR.set_sense!(instance.inner, :maximize)
    end
end

function LQOI.get_linear_objective!(instance::Optimizer, x::Vector{Float64})
    obj = XPR.get_obj(instance.inner)
    @assert length(x) == length(obj)
    for i in 1:length(obj)
        x[i] = obj[i]
    end
end

function LQOI.get_quadratic_terms_objective(instance::Optimizer)
    Q = XPR.getq(instance.inner)
    return Q
end

function LQOI.get_objectivesense(instance::Optimizer)
    s = XPR.model_sense(instance.inner)
    if s == :maximize
        return MOI.MaxSense
    else
        return MOI.MinSense
    end
end

#=
    Variables
=#

LQOI.get_number_variables(instance::Optimizer) = XPR.num_vars(instance.inner)

LQOI.add_variables!(instance::Optimizer, int) = XPR.add_cvars!(instance.inner, zeros(int))

LQOI.delete_variables!(instance::Optimizer, col, col2) = XPR.del_vars!(instance.inner, col)

# LQOI.lqs_addmipstarts(m, colvec, valvec)
function LQOI.add_mip_starts!(instance::Optimizer, colvec, valvec)
    x = zeros(XPR.num_vars(instance.inner))
    for i in eachindex(colvec)
        x[colvec[i]] = valvec[i]
    end
    XPR.loadbasis(instance.inner, x)
end

#=
    Solve
=#

LQOI.solve_mip_problem!(instance::Optimizer) = XPR.mipoptimize(instance.inner)

LQOI.solve_quadratic_problem!(instance::Optimizer) = LQOI.solve_linear_problem!(instance)

LQOI.solve_linear_problem!(instance::Optimizer) = XPR.lpoptimize(instance.inner)

function LQOI.get_termination_status(instance::Optimizer)
    stat_lp = XPR.get_lp_status2(instance.inner)
    if XPR.is_mip(instance.inner)
        stat_mip = XPR.get_mip_status2(instance.inner)
        if stat_mip == XPR.MIP_NotLoaded
            return MOI.OTHER_ERROR
        elseif stat_mip == XPR.MIP_LPNotOptimal
            # MIP search incomplete but there is no linear sol
            return MOI.OTHER_ERROR
        elseif stat_mip == XPR.MIP_NoSolFound
            # MIP search incomplete but there is no integer sol
            other = xprsmoi_stopstatus(instance.inner)
            if other == MOI.OTHER_ERROR
                return MOI.SLOW_PROGRESS#OtherLimit
            else
                return other
            end

        elseif stat_mip == XPR.MIP_Solution
            # MIP search incomplete but there is a solution
            other = xprsmoi_stopstatus(instance.inner)
            if other == MOI.OTHER_ERROR
                return MOI.OTHER_LIMIT
            else
                return other
            end

        elseif stat_mip == XPR.MIP_Infeasible
            return MOI.INFEASIBLE
        elseif stat_mip == XPR.MIP_Optimal
            return MOI.OPTIMAL
        elseif stat_mip == XPR.MIP_Unbounded
            return MOI.DUAL_INFEASIBLE
        end
        return MOI.OTHER_ERROR
    else
        if stat_lp == XPR.LP_Unstarted
            return MOI.OTHER_ERROR
        elseif stat_lp == XPR.LP_Optimal
            return MOI.OPTIMAL
        elseif stat_lp == XPR.LP_Infeasible
            return MOI.INFEASIBLE
        elseif stat_lp == XPR.LP_CutOff
            return MOI.OBJECTIVE_LIMIT
        elseif stat_lp == XPR.LP_Unfinished
            return xprsmoi_stopstatus(instance.inner)
        elseif stat_lp == XPR.LP_Unbounded
            return MOI.DUAL_INFEASIBLE
        elseif stat_lp == XPR.LP_CutOffInDual
            return MOI.OBJECTIVE_LIMIT
        elseif stat_lp == XPR.LP_Unsolved
            return MOI.OTHER_ERROR
        elseif stat_lp == XPR.LP_NonConvex
            return MOI.INVALID_MODEL
        end
        return MOI.OTHER_ERROR
    end
end

function xprsmoi_stopstatus(instance::Model)
    ss = XPR.get_stopstatus(instance)
    if ss == XPR.StopTimeLimit
        return MOI.TIME_LIMIT
    elseif ss == XPR.StopControlC
        return MOI.INTERRUPTED
    elseif ss == XPR.StopNodeLimit
        # should not be here
        @warn("should not be here")
        return MOI.NODE_LIMIT
    elseif ss == XPR.StopIterLimit
        return MOI.ITERATION_LIMIT
    elseif ss == XPR.StopMIPGap
        return MOI.OBJECTIVE_LIMIT
    elseif ss == XPR.StopSolLimit
        return MOI.SOLUTION_LIMIT
    elseif ss == XPR.StopUser
        return MOI.INTERRUPTED
    end
    return MOI.OTHER_ERROR
end

function LQOI.get_primal_status(instance::Optimizer)
    if XPR.is_mip(instance.inner)
        stat_mip = XPR.get_mip_status2(instance.inner)
        if stat_mip in [XPR.MIP_Solution, XPR.MIP_Optimal]
            return MOI.FEASIBLE_POINT
        elseif stat_mip == XPR.MIP_Unbounded && XPR.hasprimalray(instance.inner)
            return MOI.INFEASIBILITY_CERTIFICATE
        elseif stat_mip in [XPR.MIP_LPOptimal, XPR.MIP_NoSolFound]
            return MOI.INFEASIBLE_POINT
        end
        return MOI.NO_SOLUTION
    else
        stat_lp = XPR.get_lp_status2(instance.inner)
        if stat_lp == XPR.LP_Optimal
            return MOI.FEASIBLE_POINT
        elseif stat_lp == XPR.LP_Unbounded && XPR.hasprimalray(instance.inner)
            return MOI.INFEASIBILITY_CERTIFICATE
        # elseif stat_lp == LP_Infeasible
        #     return MOI.InfeasiblePoint - xpress wont return
        # elseif cutoff//cutoffindual ???
        else
            return MOI.NO_SOLUTION
        end
    end
end

function LQOI.get_dual_status(instance::Optimizer)
    if XPR.is_mip(instance.inner)
        return MOI.NO_SOLUTION
    else
        stat_lp = XPR.get_lp_status2(instance.inner)
        if stat_lp == XPR.LP_Optimal
            return MOI.FEASIBLE_POINT
        elseif stat_lp == XPR.LP_Infeasible && XPR.hasdualray(instance.inner)
            return MOI.INFEASIBILITY_CERTIFICATE
        # elseif stat_lp == LP_Unbounded
        #     return MOI.InfeasiblePoint - xpress wont return
        # elseif cutoff//cutoffindual ???
        else
            return MOI.NO_SOLUTION
        end
    end
end

LQOI.get_variable_primal_solution!(instance::Optimizer, place) = XPR.get_solution!(instance.inner, place)

function LQOI.get_linear_primal_solution!(instance::Optimizer, place)
    if num_qconstrs(instance.inner) == 0
        XPR.get_slack_lin!(instance.inner, place)
        rhs = XPR.get_rhs(instance.inner)
        for i in eachindex(place)
            place[i] = -place[i]+rhs[i]
        end
        return nothing
    else
        XPR.get_slack_lin!(instance.inner, place)
        rhs = XPR.get_rhs(instance.inner)
        lrows = XPR.get_lrows(instance.inner)
        for (i,v) in enumerate(lrows)
            place[i] = -place[i]+rhs[v]
        end
    end
    nothing
end

function LQOI.get_quadratic_primal_solution!(instance::Optimizer, place)
    if num_qconstrs(instance.inner) == 0
        return nothing
    else
        qrows = XPR.get_qrows(instance.inner)
        newplace = zeros(num_constrs(instance.inner))
        XPR.get_slack!(instance.inner, newplace)
        rhs = XPR.get_rhs(instance.inner)
        for (i,v) in enumerate(qrows)
            place[i] = -newplace[v]+rhs[v]
        end
    end
    nothing
end

LQOI.get_variable_dual_solution!(instance::Optimizer, place) = XPR.get_reducedcost!(instance.inner, place)

LQOI.get_linear_dual_solution!(instance::Optimizer, place) = XPR.get_dual_lin!(instance.inner, place)

function LQOI.get_quadratic_dual_solution!(instance::Optimizer, place)
    if num_qconstrs(instance.inner) == 0
        return nothing
    else
        qrows = XPR.get_qrows(instance.inner)
        newplace = zeros(num_constrs(instance.inner))
        XPR.get_dual!(instance.inner, newplace)
        for (i,v) in enumerate(qrows)
            place[i] = newplace[v]
        end
    end
end

LQOI.get_objective_value(instance::Optimizer) = XPR.get_objval(instance.inner)

function LQOI.get_objective_bound(instance::Optimizer)
    if XPR.is_mip(instance.inner)
        return XPR.get_bestbound(instance.inner)+LQOI.get_constant_objective(instance)
    else
        return XPR.get_objval(instance.inner)+LQOI.get_constant_objective(instance)
    end
end
function LQOI.get_relative_mip_gap(instance::Optimizer)
    L = XPR.get_mip_objval(instance.inner)
    U = XPR.get_bestbound(instance.inner)
    return abs(U-L)/U
end

LQOI.get_iteration_count(instance::Optimizer)  = XPR.get_simplex_iter_count(instance.inner)

LQOI.get_barrier_iterations(instance::Optimizer) = XPR.get_barrier_iter_count(instance.inner)

LQOI.get_node_count(instance::Optimizer) = XPR.get_node_count(instance.inner)

LQOI.get_farkas_dual!(instance::Optimizer, place) = XPR.getdualray!(instance.inner, place)

LQOI.get_unbounded_ray!(instance::Optimizer, place) = XPR.getprimalray!(instance.inner, place)


finalize(m::Optimizer) = XPR.free_model(m.inner)

function MOI.write_to_file(instance::Optimizer, lp_file_name::String)
    flags = ""
    if endswith(lp_file_name, ".lp")
        flags = "l"
    end
    XPR.write_model(instance.inner, filename, flags)
end

"""
    compute_conflict(model::Optimizer)

Compute a minimal subset of the constraints and variables that keep the model
infeasible.

See also `Xpress.ConflictStatus` and `Xpress.ConstraintConflictStatus`.

Note that if `model` is modified after a call to `compute_conflict`, the
conflict is not purged, and any calls to the above attributes will return values
for the original conflict without a warning.
"""
function compute_conflict(model::Optimizer)
    model.conflict = getfirstiis(model.inner)
    return
end

function _ensure_conflict_computed(model::Optimizer)
    if model.conflict === nothing
        error("Cannot access conflict status. Call `Xpress.compute_conflict(model)` first. " *
              "In case the model is modified, the computed conflict will not be purged.")
    end
end

"""
    ConflictStatus()

Return an `MOI.TerminationStatusCode` indicating the status of the last computed conflict.

If a minimal conflict is found, it will return `MOI.OPTIMAL`. If the problem is feasible, it will
return `MOI.INFEASIBLE`. If `compute_conflict` has not been called yet, it will return
`MOI.OPTIMIZE_NOT_CALLED`.
"""
struct ConflictStatus <: MOI.AbstractModelAttribute  end
MOI.is_set_by_optimize(::ConflictStatus) = true

function MOI.get(model::Optimizer, ::ConflictStatus)
    if model.conflict === nothing
        return MOI.OPTIMIZE_NOT_CALLED
    elseif model.conflict.stat == 0
        return MOI.OPTIMAL
    elseif model.conflict.stat == 1
        return MOI.INFEASIBLE
    else
        return MOI.OTHER_LIMIT
    end
end

function MOI.supports(::Optimizer, ::ConflictStatus)
    return true
end

"""
    ConstraintConflictStatus()

A Boolean constraint attribute indicating whether the constraint participates in the last computed conflict.
"""
struct ConstraintConflictStatus <: MOI.AbstractConstraintAttribute end
MOI.is_set_by_optimize(::ConstraintConflictStatus) = true

function MOI.get(model::Optimizer, ::ConstraintConflictStatus, index::MOI.ConstraintIndex{<:MOI.ScalarAffineFunction, <:Union{LQOI.LE, LQOI.GE, LQOI.EQ}})
    _ensure_conflict_computed(model)
    return (model[index] - 1) in model.conflict.miisrow
end

function MOI.supports(::Optimizer, ::ConstraintConflictStatus, ::Type{MOI.ConstraintIndex{<:MOI.ScalarAffineFunction, <:Union{LQOI.LE, LQOI.GE, LQOI.EQ}}})
    return true
end

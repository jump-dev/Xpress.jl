struct XpressError <: Exception
    errorcode::Int
    msg::String
end

function Base.showerror(io::IO, err::XpressError)
    print(io, "XpressError($(err.errorcode)): ")
    if err.errorcode == 1
        print(io, "Bad input encountered.")
    elseif err.errorcode == 2
        print(io, "Bad or corrupt file - unrecoverable.")
    elseif err.errorcode == 4
        print(io, "Memory error.")
    elseif err.errorcode == 8
        print(io, "Corrupt use.")
    elseif err.errorcode == 16
        print(io, "Program error.")
    elseif err.errorcode == 32
        print(io, "Subroutine not completed successfully, possibly due to invalid argument.")
    elseif err.errorcode == 128
        print(io, "Too many users.")
    else
        print(io, "Unrecoverable error.")
    end
    print(io, " $(err.msg)")
end

function fixinfinity(val::Float64)
    if val == Inf
        return Xpress.Lib.XPRS_PLUSINFINITY
    elseif val == -Inf
        return Xpress.Lib.XPRS_MINUSINFINITY
    else
        return val
    end
end

function fixinfinity!(vals::Vector{Float64})
    map!(fixinfinity, vals, vals)
end

"""
    Xpress.CWrapper

abstract type Xpress.CWrapper
"""
abstract type CWrapper end

Base.unsafe_convert(T::Type{Ptr{Nothing}}, t::CWrapper) = (t.ptr == C_NULL) ? throw(XpressError(255, "Received null pointer in CWrapper. Something must be wrong.")) : t.ptr

mutable struct XpressProblem <: CWrapper
    ptr::Lib.XPRSprob
    callback::Vector{Any}
    time::Float64
    function XpressProblem()
        ref = Ref{Lib.XPRSprob}()
        createprob(ref)
        ptr = ref[]
        @assert ptr != C_NULL "Failed to create XpressProblem. Received null pointer from Xpress C interface."
        p = new(ptr, Any[], 0.0)
        atexit(() -> destroyprob(p))
        return p
    end
end

addcolnames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 2)
addrownames(prob::XpressProblem, names::Vector{String}) = addnames(prob, names, 1)

"""
    getcontrol(prob::XpressProblem, control::Integer)

Get parameter of any type
"""
function getcontrol(prob::XpressProblem, control::Integer)
    # TODO: this function is not type stable
    if convert(Int, control) in XPRS_INT_CONTROLS
        return getintcontrol(prob, control)
    elseif convert(Int, control) in XPRS_DBL_CONTROLS
        return getdblcontrol(prob, control)
    elseif convert(Int, control) in XPRS_STR_CONTROLS
        return getstrcontrol(prob, control)
    else
        error("Unrecognized parameter number: $(control).")
    end
end
getcontrol(prob::XpressProblem, control::Symbol) = getcontrol(prob, getproperty(Lib, control))

"""
    setparam!(prob::XpressProblem, control::Symbol, val::Any)
    setparam!(prob::XpressProblem, control::Integer, val::Any)

Set parameter of any type
"""
setcontrol!(prob::XpressProblem, control::Symbol, val::Any) = setcontrol!(prob, getproperty(Lib, control), val::Any)
setcontrol!(prob::XpressProblem, control::Integer, val::Any) = setcontrol!(prob, Cint(control), val::Any)
function setcontrol!(prob::XpressProblem, control::Cint, val::Any)
    if convert(Int, control) in XPRS_INT_CONTROLS
        if isinteger(val)
            setintcontrol(prob, control, convert(Int, val))
        else
            error("Expected and integer and got $val")
        end
    elseif convert(Int, control) in XPRS_DBL_CONTROLS
        setdblcontrol(prob, control, val)
    elseif convert(Int, control) in XPRS_STR_CONTROLS
        setstrcontrol(prob, control, val)
    else
        error("Unrecognized parameter number: $(control).")
    end
end

"""
    setparams!(prob::XpressProblem;args...)

Set multiple parameters of any type
"""
function setcontrols!(prob::XpressProblem; args...)
    for (control,val) in args
        setcontrols!(prob, getproperty(Lib, param), val)
    end
end

XPRS_STR_CONTROLS = [
                        Lib.XPRS_MPSRHSNAME,
                        Lib.XPRS_MPSOBJNAME,
                        Lib.XPRS_MPSRANGENAME,
                        Lib.XPRS_MPSBOUNDNAME,
                        Lib.XPRS_OUTPUTMASK,
                    ]

XPRS_DBL_CONTROLS = [
                        Lib.XPRS_MATRIXTOL
                        Lib.XPRS_PIVOTTOL
                        Lib.XPRS_FEASTOL
                        Lib.XPRS_OUTPUTTOL
                        Lib.XPRS_SOSREFTOL
                        Lib.XPRS_OPTIMALITYTOL
                        Lib.XPRS_ETATOL
                        Lib.XPRS_RELPIVOTTOL
                        Lib.XPRS_MIPTOL
                        Lib.XPRS_MIPTOLTARGET
                        Lib.XPRS_MIPADDCUTOFF
                        Lib.XPRS_MIPABSCUTOFF
                        Lib.XPRS_MIPRELCUTOFF
                        Lib.XPRS_PSEUDOCOST
                        Lib.XPRS_PENALTY
                        Lib.XPRS_BIGM
                        Lib.XPRS_MIPABSSTOP
                        Lib.XPRS_MIPRELSTOP
                        Lib.XPRS_CROSSOVERACCURACYTOL
                        Lib.XPRS_BAROBJSCALE
                        Lib.XPRS_BARRHSSCALE
                        Lib.XPRS_CHOLESKYTOL
                        Lib.XPRS_BARGAPSTOP
                        Lib.XPRS_BARDUALSTOP
                        Lib.XPRS_BARPRIMALSTOP
                        Lib.XPRS_BARSTEPSTOP
                        Lib.XPRS_ELIMTOL
                        Lib.XPRS_PERTURB
                        Lib.XPRS_MARKOWITZTOL
                        Lib.XPRS_MIPABSGAPNOTIFY
                        Lib.XPRS_MIPRELGAPNOTIFY
                        Lib.XPRS_PPFACTOR
                        Lib.XPRS_REPAIRINDEFINITEQMAX
                        Lib.XPRS_BARGAPTARGET
                        Lib.XPRS_SBEFFORT
                        Lib.XPRS_HEURDIVERANDOMIZE
                        Lib.XPRS_HEURSEARCHEFFORT
                        Lib.XPRS_CUTFACTOR
                        Lib.XPRS_EIGENVALUETOL
                        Lib.XPRS_INDLINBIGM
                        Lib.XPRS_TREEMEMORYSAVINGTARGET
                        Lib.XPRS_GLOBALFILEBIAS
                        Lib.XPRS_INDPRELINBIGM
                        Lib.XPRS_RELAXTREEMEMORYLIMIT
                        Lib.XPRS_MIPABSGAPNOTIFYOBJ
                        Lib.XPRS_MIPABSGAPNOTIFYBOUND
                        Lib.XPRS_PRESOLVEMAXGROW
                        Lib.XPRS_HEURSEARCHTARGETSIZE
                        Lib.XPRS_CROSSOVERRELPIVOTTOL
                        Lib.XPRS_CROSSOVERRELPIVOTTOLSAFE
                        Lib.XPRS_DETLOGFREQ
                        Lib.XPRS_MAXIMPLIEDBOUND
                        Lib.XPRS_FEASTOLTARGET
                        Lib.XPRS_OPTIMALITYTOLTARGET
                        Lib.XPRS_PRECOMPONENTSEFFORT
                    ]

XPRS_INT_CONTROLS = [
                        Lib.XPRS_EXTRAROWS
                        Lib.XPRS_EXTRACOLS
                        Lib.XPRS_LPITERLIMIT
                        Lib.XPRS_LPLOG
                        Lib.XPRS_SCALING
                        Lib.XPRS_PRESOLVE
                        Lib.XPRS_CRASH
                        Lib.XPRS_PRICINGALG
                        Lib.XPRS_INVERTFREQ
                        Lib.XPRS_INVERTMIN
                        Lib.XPRS_MAXNODE
                        Lib.XPRS_MAXTIME
                        Lib.XPRS_MAXMIPSOL
                        Lib.XPRS_DEFAULTALG
                        Lib.XPRS_VARSELECTION
                        Lib.XPRS_NODESELECTION
                        Lib.XPRS_BACKTRACK
                        Lib.XPRS_MIPLOG
                        Lib.XPRS_KEEPNROWS
                        Lib.XPRS_MPSECHO
                        Lib.XPRS_MAXPAGELINES
                        Lib.XPRS_OUTPUTLOG
                        Lib.XPRS_BARSOLUTION
                        Lib.XPRS_CACHESIZE
                        Lib.XPRS_CROSSOVER
                        Lib.XPRS_BARITERLIMIT
                        Lib.XPRS_CHOLESKYALG
                        Lib.XPRS_BAROUTPUT
                        Lib.XPRS_CSTYLE
                        Lib.XPRS_EXTRAMIPENTS
                        Lib.XPRS_REFACTOR
                        Lib.XPRS_BARTHREADS
                        Lib.XPRS_KEEPBASIS
                        Lib.XPRS_VERSION
                        Lib.XPRS_BIGMMETHOD
                        Lib.XPRS_MPSNAMELENGTH
                        Lib.XPRS_PRESOLVEOPS
                        Lib.XPRS_MIPPRESOLVE
                        Lib.XPRS_MIPTHREADS
                        Lib.XPRS_BARORDER
                        Lib.XPRS_BREADTHFIRST
                        Lib.XPRS_AUTOPERTURB
                        Lib.XPRS_DENSECOLLIMIT
                        Lib.XPRS_CALLBACKFROMMASTERTHREAD
                        Lib.XPRS_MAXMCOEFFBUFFERELEMS
                        Lib.XPRS_REFINEOPS
                        Lib.XPRS_LPREFINEITERLIMIT
                        Lib.XPRS_MIPREFINEITERLIMIT
                        Lib.XPRS_DUALIZEOPS
                        Lib.XPRS_PRESORT
                        Lib.XPRS_PREPERMUTE
                        Lib.XPRS_PREPERMUTESEED
                        Lib.XPRS_MAXMEMORY
                        Lib.XPRS_CUTFREQ
                        Lib.XPRS_SYMSELECT
                        Lib.XPRS_SYMMETRY
                        Lib.XPRS_LPTHREADS
                        Lib.XPRS_MIQCPALG
                        Lib.XPRS_QCCUTS
                        Lib.XPRS_QCROOTALG
                        Lib.XPRS_ALGAFTERNETWORK
                        Lib.XPRS_TRACE
                        Lib.XPRS_MAXIIS
                        Lib.XPRS_CPUTIME
                        Lib.XPRS_COVERCUTS
                        Lib.XPRS_GOMCUTS
                        Lib.XPRS_MPSFORMAT
                        Lib.XPRS_CUTSTRATEGY
                        Lib.XPRS_CUTDEPTH
                        Lib.XPRS_TREECOVERCUTS
                        Lib.XPRS_TREEGOMCUTS
                        Lib.XPRS_CUTSELECT
                        Lib.XPRS_TREECUTSELECT
                        Lib.XPRS_DUALIZE
                        Lib.XPRS_DUALGRADIENT
                        Lib.XPRS_SBITERLIMIT
                        Lib.XPRS_SBBEST
                        Lib.XPRS_MAXCUTTIME
                        Lib.XPRS_ACTIVESET
                        Lib.XPRS_BARINDEFLIMIT
                        Lib.XPRS_HEURSTRATEGY
                        Lib.XPRS_HEURFREQ
                        Lib.XPRS_HEURDEPTH
                        Lib.XPRS_HEURMAXSOL
                        Lib.XPRS_HEURNODES
                        Lib.XPRS_LNPBEST
                        Lib.XPRS_LNPITERLIMIT
                        Lib.XPRS_BRANCHCHOICE
                        Lib.XPRS_BARREGULARIZE
                        Lib.XPRS_SBSELECT
                        Lib.XPRS_LOCALCHOICE
                        Lib.XPRS_LOCALBACKTRACK
                        Lib.XPRS_DUALSTRATEGY
                        Lib.XPRS_L1CACHE
                        Lib.XPRS_HEURDIVESTRATEGY
                        Lib.XPRS_HEURSELECT
                        Lib.XPRS_BARSTART
                        Lib.XPRS_BARNUMSTABILITY
                        Lib.XPRS_BARORDERTHREADS
                        Lib.XPRS_EXTRASETS
                        Lib.XPRS_FEASIBILITYPUMP
                        Lib.XPRS_PRECOEFELIM
                        Lib.XPRS_PREDOMCOL
                        Lib.XPRS_HEURSEARCHFREQ
                        Lib.XPRS_HEURDIVESPEEDUP
                        Lib.XPRS_SBESTIMATE
                        Lib.XPRS_BARCORES
                        Lib.XPRS_MAXCHECKSONMAXTIME
                        Lib.XPRS_MAXCHECKSONMAXCUTTIME
                        Lib.XPRS_HISTORYCOSTS
                        Lib.XPRS_ALGAFTERCROSSOVER
                        Lib.XPRS_LINELENGTH
                        Lib.XPRS_MUTEXCALLBACKS
                        Lib.XPRS_BARCRASH
                        Lib.XPRS_HEURDIVESOFTROUNDING
                        Lib.XPRS_HEURSEARCHROOTSELECT
                        Lib.XPRS_HEURSEARCHTREESELECT
                        Lib.XPRS_MPS18COMPATIBLE
                        Lib.XPRS_ROOTPRESOLVE
                        Lib.XPRS_CROSSOVERDRP
                        Lib.XPRS_FORCEOUTPUT
                        Lib.XPRS_DETERMINISTIC
                        Lib.XPRS_PREPROBING
                        Lib.XPRS_EXTRAQCELEMENTS
                        Lib.XPRS_EXTRAQCROWS
                        Lib.XPRS_TREEMEMORYLIMIT
                        Lib.XPRS_TREECOMPRESSION
                        Lib.XPRS_TREEDIAGNOSTICS
                        Lib.XPRS_MAXGLOBALFILESIZE
                        Lib.XPRS_REPAIRINFEASMAXTIME
                        Lib.XPRS_IFCHECKCONVEXITY
                        Lib.XPRS_PRIMALUNSHIFT
                        Lib.XPRS_REPAIRINDEFINITEQ
                        Lib.XPRS_MAXLOCALBACKTRACK
                        Lib.XPRS_USERSOLHEURISTIC
                        Lib.XPRS_FORCEPARALLELDUAL
                        Lib.XPRS_BACKTRACKTIE
                        Lib.XPRS_BRANCHDISJ
                        Lib.XPRS_MIPFRACREDUCE
                        Lib.XPRS_CONCURRENTTHREADS
                        Lib.XPRS_MAXSCALEFACTOR
                        Lib.XPRS_HEURTHREADS
                        Lib.XPRS_THREADS
                        Lib.XPRS_HEURBEFORELP
                        Lib.XPRS_PREDOMROW
                        Lib.XPRS_BRANCHSTRUCTURAL
                        Lib.XPRS_QUADRATICUNSHIFT
                        Lib.XPRS_BARPRESOLVEOPS
                        Lib.XPRS_QSIMPLEXOPS
                        Lib.XPRS_CONFLICTCUTS
                        Lib.XPRS_PREPROTECTDUAL
                        Lib.XPRS_CORESPERCPU
                        Lib.XPRS_SLEEPONTHREADWAIT
                        Lib.XPRS_PREDUPROW
                        Lib.XPRS_CPUPLATFORM
                        Lib.XPRS_BARALG
                        Lib.XPRS_TREEPRESOLVE
                        Lib.XPRS_TREEPRESOLVE_KEEPBASIS
                        Lib.XPRS_TREEPRESOLVEOPS
                        Lib.XPRS_LPLOGSTYLE
                        Lib.XPRS_RANDOMSEED
                        Lib.XPRS_TREEQCCUTS
                        Lib.XPRS_PRELINDEP
                        Lib.XPRS_DUALTHREADS
                        Lib.XPRS_PREOBJCUTDETECT
                        Lib.XPRS_PREBNDREDQUAD
                        Lib.XPRS_PREBNDREDCONE
                        Lib.XPRS_PRECOMPONENTS
                        Lib.XPRS_MAXMIPTASKS
                        Lib.XPRS_MIPTERMINATIONMETHOD
                        Lib.XPRS_PRECONEDECOMP
                        Lib.XPRS_HEURSEARCHROOTCUTFREQ
                        Lib.XPRS_EXTRAELEMS
                        Lib.XPRS_EXTRAPRESOLVE
                        Lib.XPRS_EXTRASETELEMS
                    ]

# TODO list attributes by type


n_variables(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_COLS)
n_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ROWS)
n_special_ordered_sets(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_SETS)
n_quadratic_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_QCONSTRAINTS)
n_non_zero_elements(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ELEMS)
n_quadratic_elements(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_QELEMS)
n_quadratic_row_coefficients(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_QCELEMS)
n_entities(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_MIPENTS)
n_setmembers(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_SETMEMBERS)

n_original_variables(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALCOLS)
n_original_constraints(prob::XpressProblem) = getintattrib(prob, Lib.XPRS_ORIGINALROWS)

objective_sense(prob::XpressProblem) = getdblattrib(prob, Lib.XPRS_OBJSENSE) == Lib.XPRS_OBJ_MINIMIZE ? :minimize : :maximize

# derived attribute functions

"""
    n_linear_constraints(prob::XpressProblem)
Return the number of purely linear contraints in the XpressProblem
"""
n_linear_constraints(prob::XpressProblem) = n_constraints(prob) - n_quadratic_constraints(prob)

"""
    is_qcp(prob::XpressProblem)
Return `true` if there are quadratic constraints in the XpressProblem
"""
is_quadratic_constraints(prob::XpressProblem) = n_quadratic_constraints(prob) > 0

"""
    is_mip(prob::XpressProblem)
Return `true` if there are integer entities in the XpressProblem
"""
is_mixedinteger(prob::XpressProblem) = (n_entities(prob) + n_special_ordered_sets(prob)) > 0

"""
    is_qp(prob::XpressProblem)
Return `true` if there are quadratic terms in the objective in the XpressProblem
"""
is_quadratic_objective(prob::XpressProblem) = n_quadratic_elements(prob) > 0

"""
    problem_type(prob::XpressProblem)
Return a symbol enconding the type of the problem.]
Options are: `:LP`, `:QP` and `:QCP`
"""
function problem_type(prob::XpressProblem)
    is_quadratic_constraints(prob) ? (:QCP) :
    is_quadratic_objective(prob)  ? (:QP)  : (:LP)
end

"""
    show(io::IO, prob::XpressProblem)
Prints a simplified problem description
"""
function Base.show(io::IO, prob::XpressProblem)
    println(io, "Xpress Problem:"     )
    if is_mixedinteger(prob)
    println(io, "    type   : $(problem_type(prob)) (MIP)")
    else
    println(io, "    type   : $(problem_type(prob))")
    end
    println(io, "    sense  : $(objective_sense(prob))")
    println(io, "    number of variables                    = $(n_variables(prob))")
    println(io, "    number of linear constraints           = $(n_linear_constraints(prob))")
    println(io, "    number of quadratic constraints        = $(n_quadratic_constraints(prob))")
    println(io, "    number of sos constraints              = $(n_special_ordered_sets(prob))")
    println(io, "    number of non-zero coeffs              = $(n_non_zero_elements(prob))")
    println(io, "    number of non-zero qp objective terms  = $(n_quadratic_elements(prob))")
    println(io, "    number of non-zero qp constraint terms = $(n_quadratic_row_coefficients(prob))")
    println(io, "    number of integer entities             = $(n_entities(prob))")
end


"""
    delq!(model::Model)

delete all quadritic terms formthe objective
"""
function delq!(prob::XpressProblem)

    n = n_variables(prob)
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

    Xpress.chgmqobj(prob, qr, qc, qv)
end

const MIPSTATUS_STRING = Dict{Int,String}(
    Xpress.Lib.XPRS_MIP_NOT_LOADED => "0 Problem has not been loaded ( XPRS_MIP_NOT_LOADED).",
    Xpress.Lib.XPRS_MIP_LP_NOT_OPTIMAL => "1 Global search incomplete - the initial continuous relaxation has not been solved and no integer solution has been found ( XPRS_MIP_LP_NOT_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_LP_OPTIMAL => "2 Global search incomplete - the initial continuous relaxation has been solved and no integer solution has been found ( XPRS_MIP_LP_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_NO_SOL_FOUND => "3 Global search incomplete - no integer solution found ( XPRS_MIP_NO_SOL_FOUND).",
    Xpress.Lib.XPRS_MIP_SOLUTION => "4 Global search incomplete - an integer solution has been found ( XPRS_MIP_SOLUTION).",
    Xpress.Lib.XPRS_MIP_INFEAS => "5 Global search complete - no integer solution found ( XPRS_MIP_INFEAS).",
    Xpress.Lib.XPRS_MIP_OPTIMAL => "6 Global search complete - integer solution found ( XPRS_MIP_OPTIMAL).",
    Xpress.Lib.XPRS_MIP_UNBOUNDED => "7 Global search incomplete - the initial continuous relaxation was found to be unbounded. A solution may have been found ( XPRS_MIP_UNBOUNDED).",
)

function mip_solve_complete(stat)
    stat in [Xpress.Lib.XPRS_MIP_INFEAS, Xpress.Lib.XPRS_MIP_OPTIMAL]
end
function mip_solve_stopped(stat)
    stat in [Xpress.Lib.XPRS_MIP_INFEAS, Xpress.Lib.XPRS_MIP_OPTIMAL]
end

const LPSTATUS_STRING = Dict{Int,String}(
    Xpress.Lib.XPRS_LP_UNSTARTED => "0 Unstarted ( XPRS_LP_UNSTARTED).",
    Xpress.Lib.XPRS_LP_OPTIMAL => "1 Optimal ( XPRS_LP_OPTIMAL).",
    Xpress.Lib.XPRS_LP_INFEAS => "2 Infeasible ( XPRS_LP_INFEAS).",
    Xpress.Lib.XPRS_LP_CUTOFF => "3 Objective worse than cutoff ( XPRS_LP_CUTOFF).",
    Xpress.Lib.XPRS_LP_UNFINISHED => "4 Unfinished ( XPRS_LP_UNFINISHED).",
    Xpress.Lib.XPRS_LP_UNBOUNDED => "5 Unbounded ( XPRS_LP_UNBOUNDED).",
    Xpress.Lib.XPRS_LP_CUTOFF_IN_DUAL => "6 Cutoff in dual ( XPRS_LP_CUTOFF_IN_DUAL).",
    Xpress.Lib.XPRS_LP_UNSOLVED => "7 Problem could not be solved due to numerical issues. ( XPRS_LP_UNSOLVED).",
    Xpress.Lib.XPRS_LP_NONCONVEX => "8 Problem contains quadratic data, which is not convex ( XPRS_LP_NONCONVEX).",
)

const STOPSTATUS_STRING = Dict{Int, String}(
    Xpress.Lib.XPRS_STOP_NONE => "no interruption - the solve completed normally",
    Xpress.Lib.XPRS_STOP_TIMELIMIT => "time limit hit",
    Xpress.Lib.XPRS_STOP_CTRLC => "control C hit",
    Xpress.Lib.XPRS_STOP_NODELIMIT => "node limit hit",
    Xpress.Lib.XPRS_STOP_ITERLIMIT => "iteration limit hit",
    Xpress.Lib.XPRS_STOP_MIPGAP => "MIP gap is sufficiently small",
    Xpress.Lib.XPRS_STOP_SOLLIMIT => "solution limit hit",
    Xpress.Lib.XPRS_STOP_USER => "user interrupt.",
)

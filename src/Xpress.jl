__precompile__()

#const xprs = joinpath(ENV["XPRESSDIR"],"bin",string("xprs",".",Libdl.dlext))
#const xprs = "/opt/xpressmp/lib/libxprs"
module Xpress

    if isfile(joinpath(dirname(@__FILE__),"..","deps","deps.jl"))
        include("../deps/deps.jl")
    else
        error("Xpress not properly installed. Please run Pkg.build(\"Xpress\")")
    end

    ### imports

    import Base.show, Base.copy
    import Compat: unsafe_string, String, is_windows, is_unix

    # Standard LP interface
    importall MathProgBase.SolverInterface

    ### exports
    export

    ## xprs_env
    free_env,

    ## xprs_params
    getparam, setparam!, setparams!,

    ## xprs_model
    set_sense!, update_model!, reset_model!, get_tune_result!,
    read_model, write_model, #tune_model, presolve_model, fixed_model,

    ## xprs_attrs
    model_name, model_sense, model_type,
    num_vars, num_constrs, num_sos, num_qconstrs,
    num_cnzs, num_qnzs, num_qcnzs,
    is_qp, is_qcp, is_mip,

    lowerbounds, upperbounds, objcoeffs, set_objcoeffs!,

    ## xprs_vars
    XPRS_CONTINUOUS, XPRS_BINARY, XPRS_INTEGER,
    add_var!, add_vars!, add_cvar!, add_cvars!,
    add_bvar!, add_bvars!, add_ivar!, add_ivars!,

    ## xprs_constrs
    add_constr!, add_constrs!, add_constrs_t!,
    add_rangeconstr!, add_rangeconstrs!, add_rangeconstrs_t!,
    get_constrmatrix, add_sos!,

    ## xprs_quad
    add_qpterms!, add_qconstr!,

    ## higher level
    xpress_model,

    ## xprs_solve
    optimize, computeIIS, get_solution,
    get_status, OptimInfo, get_optiminfo, get_objval


    ### include source files

    include("xprs_full_defines.jl")

    include("xprs_common.jl")
    include("xprs_env.jl")

    include("xprs_model.jl")
    include("xprs_params.jl")
    include("xprs_attrs.jl")

    include("xprs_vars.jl")

    include("xprs_constrs.jl")
    include("xprs_quad.jl")
    include("xprs_highlevel.jl")

    include("xprs_solve.jl")
    #include("xprs_callbacks.jl")

    include("XpressSolverInterface.jl")

    # license checker
    # ---------------
    include("xprs_userlic.jl")

    function __init__()

        # some lics require special check
        # -------------------------------
        userlic()

        # start Xpress with XPRSinit
        # --------------------------
        Env()

        # XPRESS finalizer
        # ----------------
        #atexit(free_env)
    end


end

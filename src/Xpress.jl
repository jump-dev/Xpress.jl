__precompile__()

module Xpress

    using Libdl

    # Load in `deps.jl`, complaining if it does not exist
    const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")

    if !isfile(depsjl_path)
        error("XPRESS cannot be loaded. Please run Pkg.build(\"Xpress\").")
    end

    include(depsjl_path)

    ### imports

    import Base.show, Base.copy

    # ### exports
    # export

    # ## xprs_env
    # free_env,

    # ## xprs_params
    # getparam, setparam!, setparams!,

    # ## xprs_model
    # set_sense!, update_model!, reset_model!,
    # read_model, write_model,
    # copy,

    # ## xprs_attrs
    # model_name, model_sense, model_type,
    # num_vars, num_constrs, num_sos, num_qconstrs,
    # num_cnzs, num_qnzs, num_qcnzs,
    # is_qp, is_qcp, is_mip,

    # lowerbounds, upperbounds, objcoeffs, set_objcoeffs!,

    # ## xprs_vars
    # XPRS_CONTINUOUS, XPRS_BINARY, XPRS_INTEGER,
    # add_var!, add_vars!, add_cvar!, add_cvars!,
    # add_bvar!, add_bvars!, add_ivar!, add_ivars!,
    # del_vars!,

    # ## xprs_constrs
    # add_constr!, add_constrs!, add_constrs_t!,
    # add_rangeconstr!, add_rangeconstrs!, add_rangeconstrs_t!,
    # get_constrmatrix, add_sos!, del_constrs!, chg_coeffs!,

    # ## xprs_quad
    # add_qpterms!, add_qconstr!,

    # ## higher level
    # xpress_model,

    # ## xprs_solve
    # optimize, computeIIS, get_solution,
    # get_status, OptimInfo, get_optiminfo, get_objval


    ### include source files
     module Lib

        import ..Xpress
        const libxprs = Xpress.libxprs

        include("ctypes.jl")
        include("common.jl")
        include("lib.jl")

        # include("custom.jl")

    end

    include("utils.jl")

    include("helper.jl")

    include("api.jl")

    # # license checker
    include("license.jl")

    function initialize()
        userlic()
        init() # Call XPRSinit for initialization
        atexit(free) # Call free when process terminates
    end
    # include("xprs_full_defines.jl")

    # include("xprs_common.jl")
    # include("xprs_env.jl")

    # include("xprs_model.jl")
    # include("xprs_params.jl")
    # include("xprs_attrs.jl")

    # include("xprs_vars.jl")

    # include("xprs_constrs.jl")
    # include("xprs_quad.jl")
    # include("xprs_highlevel.jl")

    # include("xprs_solve.jl")
    # include("xprs_callbacks.jl")
    # include("xprs_iis.jl")

    # include("XpressSolverInterface.jl")
    # include("MOIWrapper.jl")

end

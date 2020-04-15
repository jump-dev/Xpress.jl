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

    include("xprs_callbacks.jl")

    # # license checker
    include("license.jl")

    const XPRS_ATTRIBUTES = Dict{String, Any}(
        replace(string(name), "XPRS_"=>"") => getfield(Lib, name)
            for name in names(Lib; all = true)
            if startswith(string(name), "XPRS_") && all(isuppercase(c) || isdigit(c) for c in string(name) if c != '_')
    )

    function initialize()
        userlic()
        init() # Call XPRSinit for initialization
        atexit(free) # Call free when process terminates
    end

    include("MOI/MOI_wrapper.jl")

    function __init__()
        Xpress.initialize()
    end

end

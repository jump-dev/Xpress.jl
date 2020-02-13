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

    # # license checker
    include("license.jl")

    const parameter_name_to_index = Dict{String, Int}(
        string(name) => getfield(Lib, name)
        for name in names(Lib; all = true)
        if startswith(string(name), "XPRS_") && typeof(getfield(Lib, name)) == Int
    )

    function initialize()
        userlic()
        init() # Call XPRSinit for initialization
        atexit(free) # Call free when process terminates
    end

    include("MOI/MOI_Wrapper.jl")

    function __init__()
        Xpress.initialize()
    end

end

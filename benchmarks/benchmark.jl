using Xpress

function print_help()
    println("""
    Usage
        benchmark.jl [arg] [name]
    [arg]
        --new       Begin a new benchmark comparison
        --compare   Run another benchmark and compare to existing
    [name]          A name for the benchmark test
    Examples
        git checkout master
        julia benchmark.jl --new master
        git checkout approach_1
        julia benchmark.jl --new approach_1
        git checkout approach_2
        julia benchmark.jl --compare master
        julia benchmark.jl --compare approach_1
    """)
end

if length(ARGS) != 2
    print_help()
else
    const Benchmarks = Xpress.MOI.Benchmarks
    const suite = Benchmarks.suite(() -> Xpress.Optimizer())
    if ARGS[1] == "--new"
        Benchmarks.create_baseline(
            suite, ARGS[2]; directory = @__DIR__, verbose = true
        )
    elseif ARGS[1] == "--compare"
        Benchmarks.compare_against_baseline(
            suite, ARGS[2]; directory = @__DIR__, verbose = true
        )
    else
        print_help()
    end
end
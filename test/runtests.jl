using Test
using Xpress

println(Xpress.get_banner())
println("Optimizer version: $(Xpress.get_version())")

function test_MIP_Start()
    # The idea of the test is the following:
    # * Give Xpress a problem it can solve quickly but not simple enough to be
    #   solved at the root node when heuristics and cuts are disabled.
    # * Assert the solution was not found at the root node (query attribute
    #   MIPSOLNODE, it should be higher than one).
    # * Limit the model to searching the root node.
    # * Run again without the MIP-start, so the solution found is worse.
    #   (This is mostly done to be sure no status since the optimal solve
    #   was kept.)
    # * MIP-start the model with the optimal solution.
    # * If the solution found is the MIP-started solution then XPRESS has
    #   used the MIP-start (we checked XPRESS could not solve it using
    #   a single node).
    atol = rtol = 1e-6
    weight = Float64[
        677, 460, 752, 852, 580, 116, 457, 121, 454, 870,
        443, 196, 411, 539, 348, 187, 771, 127, 338, 527,
        932, 961,  48, 135, 367, 998, 363, 153, 921, 578,
        311, 560, 293, 258, 474, 884, 162, 136, 479, 289,
        813, 139, 795, 825, 945, 750, 462, 659, 270,  34,
        758, 865, 238, 367, 444, 116,  69, 894, 584,  96,
         29, 199, 712, 703, 856, 692, 396, 409, 603, 632,
        479, 848, 822, 248, 424, 978, 738, 655, 210, 173,
        731, 100, 889, 195, 245, 329, 446,  47, 235,  25,
        254, 150, 520, 665, 391, 907, 123, 826, 959, 176
    ]
    profit = weight .- (5.0,)
    capacity = 10000.0
    model = Xpress.Optimizer(
        OUTPUTLOG    = 1,
        HEURSTRATEGY = 0,
        HEUREMPHASIS = 0,
        CUTSTRATEGY  = 0,
        PRESOLVE     = 0,
        MIPPRESOLVE  = 0,
        PRESOLVEOPS  = 0,
        # USERSOLHEURISTIC = 1,
    )
    # The variables: x[1:100], Bin
    x, _ = MOI.add_constrained_variables(model, fill(MOI.ZeroOne(), 100))
    # The objective function: maximize sum(profit' * x)
    objf = MOI.ScalarAffineFunction(
        MOI.ScalarAffineTerm.(profit, x), 0.0
    )
    MOI.set(
        model,
        MOI.ObjectiveFunction{MOI.ScalarAffineFunction{Float64}}(),
        objf,
    )
    MOI.set(model, MOI.ObjectiveSense(), MOI.MAX_SENSE)
    # The capacity constraint: sum(weight' * x) <= capacity
    MOI.add_constraint(
        model, MOI.ScalarAffineFunction(MOI.ScalarAffineTerm.(
            weight, x), 0.0
        ),
        MOI.LessThan(capacity)
    )

    @show "==============================="
    @show "==============================="
    @show "==============================="
    # FIRST RUN: get the optimal value. Check that the optimal
    # value was not discovered at the root node.
    Xpress.Lib.XPRSsaveas(model.inner, "r1")
    MOI.optimize!(model)


    solution = MOI.get(model, MOI.VariablePrimal(), x)
    
    for i in eachindex(solution)
        solution[i] = ifelse(solution[i] <= 0.5, 0.0, 1.0)
    end
    @show solution
    
    computed_obj_value = profit' * solution
    obtained_obj_value = MOI.get(model, MOI.ObjectiveValue()) :: Float64
    @test isapprox(
        obtained_obj_value, computed_obj_value; rtol = rtol, atol = atol
    )
    @test isapprox(9945.0, computed_obj_value; rtol = rtol, atol = atol)

    node_solution_was_found = MOI.get(model, MOI.RawOptimizerAttribute("MIPSOLNODE"))

    @test node_solution_was_found > 1

    # SECOND RUN: run without MIP-start and only searching the first node.
    # Should give a worse solution than the previous one.
    MOI.set(model, MOI.RawOptimizerAttribute("MAXNODE"), 1)

    @show "==============================="
    @show "==============================="
    @show "==============================="
    Xpress.Lib.XPRSsaveas(model.inner, "r2")
    MOI.optimize!(model)


    # One node may not be enough to even get any solution.
    if MOI.get(model, MOI.PrimalStatus()) == MOI.FEASIBLE_POINT
        solution2 = MOI.get(model, MOI.VariablePrimal(), x)
        computed_obj_value2 = profit' * solution2
        obtained_obj_value2 = MOI.get(model, MOI.ObjectiveValue()) :: Float64
        @test isapprox(
            obtained_obj_value2, computed_obj_value2; rtol = rtol, atol = atol
        )
        # There should be at least one unit of difference.
        @test obtained_obj_value1 > obtained_obj_value2 + 0.5
    end

    # THIRD RUN: run with MIP-start and searching only the root node.
    # Should find the optimal solution impossible to get in one node.
    MOI.set.(model, MOI.VariablePrimalStart(), x, solution)

    # This postsolve is necessary because of an unrelated bug. Apparently,
    # if Xpress is stopped because MAXNODE and has no feasible solution,
    # then MOI.optimize! will not call postsolve over it, however calling
    # postsolve is necessary otherwise a new call to MOI.optimize will
    # trigger error 707 ("707 Error: Function cannot be called during the
    # global search, except in callbacks.").
    # Xpress.Lib.XPRSpostsolve(model.inner)

    MOI.set(model, MOI.RawOptimizerAttribute("MAXNODE"), 1)

    @show "==============================="
    @show "==============================="
    @show "==============================="
    Xpress.Lib.XPRSsaveas(model.inner, "r3")
    MOI.optimize!(model)

    # @show MOI.get(model, MOI.TerminationStatus())
    # @show MOI.get(model, MOI.PrimalStatus())
    # @show MOI.get(model, MOI.RawStatusString())

    # solution3 = MOI.get(model, MOI.VariablePrimal(), x)
    # computed_obj_value3 = profit' * solution3
    # obtained_obj_value3 = MOI.get(model, MOI.ObjectiveValue()) :: Float64
    # @test isapprox(
    #     obtained_obj_value3, computed_obj_value3; rtol = rtol, atol = atol
    # )
    # @test isapprox(9945.0, computed_obj_value3; rtol = rtol, atol = atol)

    @show "==============================="
    @show "==============================="
    @show "==============================="
    @show 1
    # model.inner = Xpress.XpressProblem()
    MOI.set.(model, MOI.VariablePrimalStart(), x, nothing)

    Xpress.Lib.XPRSloadlp(model.inner, "", 0, 0, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)
    # MOI.set(model, MOI.RawOptimizerAttribute("OUTPUTLOG"), 1)
    # Xpress.Lib.XPRSaddmipsol(model.inner, Cint(0), C_NULL, C_NULL, "C_NULL11")
    Xpress.Lib.XPRSrestore(model.inner, "r1", "")
    MOI.optimize!(model)


    @show "==============================="
    @show "==============================="
    @show "==============================="
    @show 2
    Xpress.Lib.XPRSloadlp(model.inner, "", 0, 0, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)
    Xpress.Lib.XPRSrestore(model.inner, "r2", "")
    MOI.optimize!(model)

    
    @show "==============================="
    @show "==============================="
    @show "==============================="
    @show 3
    Xpress.Lib.XPRSloadlp(model.inner, "", 0, 0, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)
    Xpress.Lib.XPRSrestore(model.inner, "r3", "")
    MOI.optimize!(model)


end

test_MIP_Start()

#=
@testset "$(folder)" for folder in [
    "MathOptInterface",
    "xprs_callbacks",
    "Derivative",
]
    @testset "$(file)" for file in readdir(folder)
        include(joinpath(folder, file))
    end
end

@testset "Xpress tests" begin

    prob = Xpress.XpressProblem()

    @test Xpress.getcontrol(prob, "HEURTHREADS") == 0

    vXpress_major = Int(Xpress.get_version().major)
    file_extension = ifelse(vXpress_major <= 38, ".mps","")
    msg = "Xpress internal error:\n\n85 Error: File not found: $(file_extension).\n"
    if Xpress.get_version() >= v"41.0.0"
        @test_throws Xpress.XpressError(85, msg) Xpress.readprob(prob,"","")
    else
        @test_throws Xpress.XpressError(32, msg) Xpress.readprob(prob,"","")
    end
end
=#
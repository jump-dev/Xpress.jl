using Test
using Xpress

@testset "$(folder)" for folder in [
    "MathOptInterface", "xprs_callbacks", "Derivative"
]
    @testset "$(file)" for file in readdir(folder)
        include(joinpath(folder, file))
    end
end

@testset "Xpress tests" begin

    prob = Xpress.XpressProblem()

    @test Xpress.getcontrol(prob, "HEURTHREADS") == 0
    @test Xpress.getcontrol(prob, :HEURTHREADS) == 0

    msg = "Unable to call `Xpress.copyprob`:\n\n91 Error: No problem has been input.\n"
    @test_throws Xpress.XpressError(32,msg) Xpress.copyprob(prob, prob)
end

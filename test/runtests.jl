using Test
using Xpress

@testset "$(folder)" for folder in [
    "MathOptInterface", "xprs_callbacks"
]
    @testset "$(file)" for file in readdir(folder)
        include(joinpath(folder, file))
    end
end

@testset "Xpress tests" begin

    prob = Xpress.XpressProblem()

    @test Xpress.getcontrol(prob, "HEURTHREADS") == 0
    @test Xpress.getcontrol(prob, :HEURTHREADS) == 0

end

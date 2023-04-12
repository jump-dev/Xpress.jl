using Test
using Xpress

println(Xpress.get_banner())
println("Optimizer version: $(Xpress.get_version())")

@testset "$(folder)" for folder in [
    "MathOptInterface",
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

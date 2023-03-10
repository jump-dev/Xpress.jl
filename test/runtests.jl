using Test
using Xpress

println(Xpress.getbanner())
println("Optimizer version: $(Xpress.getversion())")

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

    vXpress_major = Int(Xpress.getversion().major)
    file_extension = ifelse(vXpress_major <= 38, ".mps","")
    
    msg = """
    Unable to call `Xpress.readprob`:
    
    85 Error: File not found: $(file_extension).
    """

    @test_throws Xpress.XpressError(32, msg) Xpress.readprob(prob, "", "")
end

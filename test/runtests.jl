using Test
using Xpress

println(Xpress.invoke(Xpress.Lib.XPRSgetbanner, 2, String))
println("Optimizer version: $(Xpress.invoke(Xpress.Lib.XPRSgetversion, 2, String))")

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
    msg = "Unable to call `Xpress.readprob`:\n\n85 Error: File not found: $(file_extension).\n"
    @test_throws Xpress.XpressError(32, msg) Xpress.readprob(prob,"","")
end

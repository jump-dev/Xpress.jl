using Xpress, Test

Xpress.initialize()

@testset "Xpress API" begin

    @test Xpress.getversion() isa VersionNumber

    @test Xpress.getbanner() isa String

    xp = Xpress.XpressProblem()

    @test Xpress.getprobname(xp) == ""
    @test Xpress.setprobname(xp, "xpress-optimization-problem") == nothing
    @test Xpress.getprobname(xp) == "xpress-optimization-problem"

end


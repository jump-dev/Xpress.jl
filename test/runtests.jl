using Xpress, Test

Xpress.initialize()

@testset "Xpress API" begin

    @test Xpress.getversion() isa VersionNumber

    @test Xpress.getbanner() isa String

    xp = Xpress.XpressProblem()

    @test Xpress.getprobname(xp) == ""
    @test Xpress.setprobname(xp, "xpress-optimization-problem") == nothing
    @test Xpress.getprobname(xp) == "xpress-optimization-problem"

    @test Xpress.getintcontrol(xp, Xpress.Lib.XPRS_DEFAULTALG) == 1
    @test Xpress.getcontrol(xp, Xpress.Lib.XPRS_DEFAULTALG) == 1

    Xpress.setcontrol!(xp, Xpress.Lib.XPRS_PRESOLVE, 0)
    @test Xpress.getcontrol(xp, :XPRS_PRESOLVE) == 0
    Xpress.setcontrol!(xp, Xpress.Lib.XPRS_PRESOLVE, 1)
    @test Xpress.getcontrol(xp, Xpress.Lib.XPRS_PRESOLVE) == 1
end


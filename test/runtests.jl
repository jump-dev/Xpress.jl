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

    @test Xpress.setcontrol!(xp, Xpress.Lib.XPRS_PRESOLVE, 0) == nothing
    @test Xpress.getcontrol(xp, :XPRS_PRESOLVE) == 0
    @test Xpress.setcontrol!(xp, Xpress.Lib.XPRS_PRESOLVE, 1) == nothing
    @test Xpress.getcontrol(xp, Xpress.Lib.XPRS_PRESOLVE) == 1

    iob = IOBuffer()
    show(iob, xp)
    @test String(take!(iob)) == """
Xpress Problem:
    type   : LP
    sense  : minimize
    number of variables                    = 0
    number of linear constraints           = 0
    number of quadratic constraints        = 0
    number of sos constraints              = 0
    number of non-zero coeffs              = 0
    number of non-zero qp objective terms  = 0
    number of non-zero qp constraint terms = 0
    number of integer entities             = 0
"""

end


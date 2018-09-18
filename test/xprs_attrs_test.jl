using Xpress, Compat.Test

m = Xpress.Model()

@testset "Attributes" begin
    @test Xpress.get_intattr(m, Xpress.XPRS_COLS) == 0
    @test Xpress.get_dblattr(m, Xpress.XPRS_OBJRHS) == 0.0
    @test Xpress.get_strattr(m, Xpress.XPRS_MATRIXNAME) == ""
end


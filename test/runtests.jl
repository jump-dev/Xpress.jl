# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test
using Xpress

println(Xpress.get_banner())
println("Optimizer version: $(Xpress.get_version())")

@testset "$f" for f in filter!(f -> startswith(f, "test_"), readdir(@__DIR__))
    include(f)
end

@testset "Xpress tests" begin
    prob = Xpress.XpressProblem()
    @test Xpress.getcontrol(prob, "HEURTHREADS") == 0
    r = Xpress.Lib.XPRSreadprob(prob, "", "")
    if Xpress.get_version() >= v"41.0.0"
        msg = "Xpress internal error:\n\n85 Error: File not found: .\n"
        @test_throws Xpress.XpressError(85, msg) Xpress._check(prob, r)
    end
end

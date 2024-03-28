# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test
using Xpress

function test_licensing()
    # Create a bogus license file
    xpauth_path = mktempdir()
    filename = joinpath(xpauth_path, "xpauth.xpr")
    write(filename, "bogus_license")
    # Test that passing `""` can find our current license. This should already
    # be the case because we managed to install and start the tests...
    @test isfile(Xpress._get_xpauthpath("", false))
    # Test that using the test directory cannot find a license.
    @test_throws ErrorException Xpress._get_xpauthpath(@__DIR__, false)
    # Now're going to test checking for new licenses. To do so, we first need to
    # free the current one:
    Xpress.Lib.XPRSfree()
    # Then, we can check that using the root fails to find a license
    @test_throws Xpress.XpressError Xpress.initialize(; xpauth_path)
    # Now we need to re-initialize the license so that we can run other tests.
    Xpress.initialize()
    return
end

@testset "test_licensing" begin
    # It is important that we test this first, so that there no XpressProblem
    # objects with finalizers that may get run during the function call.
    test_licensing()
end

println(Xpress.get_banner())
println("Optimizer version: $(Xpress.get_version())")

@testset "$f" for f in filter!(f -> startswith(f, "test_"), readdir(@__DIR__))
    include(f)
end

# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Test

if haskey(ENV, "XPRESS_JL_LOCAL")
    # When testing the local installation, also test that manually initializing
    # the license works.
    ENV["XPRESS_JL_NO_AUTO_INIT"] = true
    using Xpress
    xpauth = joinpath(dirname(dirname(Xpress.libxprs)), "custom-xpauth.xpr")
    Xpress.initialize(; verbose = true, xpauth_path = xpauth)
else
    import Xpress_jll
    ENV["XPRESS_JL_LIBRARY"] = Xpress_jll.libxprs
    if isfile(joinpath(dirname(@__DIR__), "xpauth.xpr"))
        ENV["XPAUTH_PATH"] = dirname(@__DIR__)
    end
    using Xpress
end

@info "Running tests with $(Xpress.libxprs)"

println(Xpress.get_banner())
println("Optimizer version: $(Xpress.get_version())")

@testset "$f" for f in filter!(f -> startswith(f, "test_"), readdir(@__DIR__))
    include(f)
end

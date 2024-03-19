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

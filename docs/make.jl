# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Documenter, Xpress

makedocs(
    format = :html,
    sitename = "Xpress",
    pages = [
        "Introduction" => "index.md"
    ]
)

deploydocs(
    repo   = "github.com/jump-dev/Xpress.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps   = nothing,
    make   = nothing
)

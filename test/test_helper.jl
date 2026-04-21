# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module TestHelper

using Xpress
using Test

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$(name)", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
    return
end

function test_licensing()
    if !haskey(ENV, "XPRESS_JL_LOCAL")
        return
    end
    xpauth_path = mktempdir()
    write(joinpath(xpauth_path, "xpauth.xpr"), "bogus_license")
    @test_throws(
        ErrorException(
            "Could not find xpauth.xpr license file. Set the `XPRESSDIR` or " *
            "`XPAUTH_PATH` environment variables.",
        ),
        Xpress._get_xpauthpath(@__DIR__, false),
    )
    @test isfile(Xpress._get_xpauthpath(xpauth_path, false))
    return
end

function test_show_xpress_error()
    msg = "help"
    for code in (1, 2, 4, 8, 16, 32, 64, 128)
        err = Xpress.XpressError(code, msg)
        contents = sprint(showerror, err)
        @test occursin("XpressError($code):", contents)
        @test occursin(". $msg", contents)
    end
    return
end

function test_XpressProblem_show()
    p = Xpress.XpressProblem()
    target = """
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
    @test target == sprint(show, p)
    return
end

function test_checked()
    prob = Xpress.XpressProblem()
    msg = "Xpress internal error:\n\n85 Error: File not found: .\n"
    ret = XPRSreadprob(prob, "", "")
    @test_throws Xpress.XpressError(85, msg) Xpress._check(prob, ret)
    return
end

function test_validate_version()
    @test Xpress._validate_version(v"41.0.1") === nothing
    version = v"40.0.0"
    @test_throws(
        ErrorException(
            "Unsupported Xpress version: $version. We require Xpress v41.0.0 (v9) or above",
        ),
        Xpress._validate_version(version),
    )
    return
end

end  # TestHelper

TestHelper.runtests()

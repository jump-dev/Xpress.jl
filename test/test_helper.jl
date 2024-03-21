# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

module TestHelper

using Xpress
using Test

import Xpress.Lib as Lib

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

function test_xpress_problem_logfile()
    p = Xpress.XpressProblem(; logfile = "test.log")
    @test isfile("test.log")
    rm("test.log")
    return
end

function test_getattribute_error()
    p = Xpress.XpressProblem()
    @test_throws(
        ErrorException("Unrecognized attribute: bad"),
        Xpress.getattribute(p, "bad"),
    )
    return
end

function test_getcontrol_error()
    p = Xpress.XpressProblem()
    @test_throws(
        ErrorException("Unrecognized control: bad"),
        Xpress.getcontrol(p, "bad"),
    )
    return
end

function test_setcontrol_error()
    p = Xpress.XpressProblem()
    @test_throws(
        ErrorException("Unrecognized control: bad"),
        Xpress.setcontrol!(p, "bad", false),
    )
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
    if Xpress.get_version() < v"41.0.0"
        return
    end
    prob = Xpress.XpressProblem()
    msg = "Xpress internal error:\n\n85 Error: File not found: .\n"
    @test_throws(
        Xpress.XpressError(85, msg),
        Xpress.@checked(Lib.XPRSreadprob(prob, "", "")),
    )
    return
end

function test_invoke_errors()
    prob = C_NULL
    @test_throws(
        Xpress.XpressError,
        Xpress.@_invoke(
            Lib.XPRSgetintattrib(prob, Lib.XPRS_ORIGINALCOLS, _)::Int,
        ),
    )
    @test_throws(
        Xpress.XpressError,
        Xpress.@_invoke(
            Lib.XPRSgetdblattrib(prob, Lib.XPRS_OBJSENSE, _)::Float64,
        ),
    )
    @test_throws(
        Xpress.XpressError,
        Xpress.@_invoke(Lib.XPRSgetlasterror(prob, _)::String)
    )
    return
end

function test_get_xpauth_path_fail()
    @test isfile(Xpress.get_xpauthpath("", false))
    @test_throws ErrorException Xpress.get_xpauthpath(@__DIR__, false)
    return
end

end  # TestHelper

TestHelper.runtests()

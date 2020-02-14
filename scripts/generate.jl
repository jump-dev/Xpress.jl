using Clang

# LIBXPRESS_HEADERS are those headers to be wrapped.
const LIBXPRESS_INCLUDE = joinpath(ENV["XPRESSDIR"], "include") |> expanduser |> normpath
const LIBXPRESS_HEADERS = [
                           joinpath(LIBXPRESS_INCLUDE, header) for header in [
                                                                               # "bindrv.h",
                                                                               # "mmhttp.h",
                                                                               # "mmquad.h",
                                                                               # "mmsystem.h",
                                                                               # "mmxprs.h",
                                                                               # "mosel_dso.h",
                                                                               # "mosel_mc.h",
                                                                               # "mosel_ni.h",
                                                                               # "mosel_nifct.h",
                                                                               # "mosel_rt.h",
                                                                               # "xprb.h",
                                                                               # "xprb_cpp.h",
                                                                               # "xprd.h",
                                                                               # "xprm_mc.h",
                                                                               # "xprm_ni.h",
                                                                               # "xprm_rt.h",
                                                                               # "xprnls.h",
                                                                               "xprs.h",
                                                                               # "xprs_mse_defaulthandler.h",
                                                                               # "XPRSdefaultMipSolEnumHandler.java",
                                                                               # "xslp.h",
                                                                            ]
                          ]

wc = init(; headers = LIBXPRESS_HEADERS,
            output_file = joinpath(@__DIR__, "../src/lib.jl"),
            common_file = joinpath(@__DIR__, "../src/common.jl"),
            clang_includes = vcat(LIBXPRESS_INCLUDE, CLANG_INCLUDE),
            clang_args = ["-I", joinpath(LIBXPRESS_INCLUDE, "..")],
            header_wrapped = (root, current)->root == current,
            header_library = x->"libxprs",
            clang_diagnostics = true,
            )

run(wc)

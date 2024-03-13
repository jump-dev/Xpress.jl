# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# lic checking file
# -----------------

# license check empty function
# ----------------------------
function emptyliccheck(lic::Vector{Cint})
    return lic
end

function touchlic(path)
    f = open(path)
    return close(f)
end

function get_xpauthpath(xpauth_path = "", verbose::Bool = true)
    XPAUTH = "xpauth.xpr"

    candidates = []

    # user sent the complete path
    push!(candidates, xpauth_path)

    # user sent directory
    push!(candidates, joinpath(xpauth_path, XPAUTH))

    # default env (not metioned in manual)
    if haskey(ENV, "XPAUTH_PATH")
        xpauth_path = replace(ENV["XPAUTH_PATH"], "\"" => "")
        push!(candidates, joinpath(xpauth_path, XPAUTH))
    end

    # default lib dir
    if haskey(ENV, "XPRESSDIR")
        xpressdir = replace(ENV["XPRESSDIR"], "\"" => "")
        push!(candidates, joinpath(xpressdir, "bin", XPAUTH))
    end

    # user´s lib dir
    push!(candidates, joinpath(dirname(dirname(libxprs)), "bin", XPAUTH))

    for i in candidates
        if isfile(i)
            if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
                @info("Xpress: Found license file $i")
            end
            return i
        end
    end

    return error(
        "Could not find xpauth.xpr license file. Check XPRESSDIR or XPAUTH_PATH environment variables.",
    )
end
"""
    userlic(; liccheck::Function = emptyliccheck, xpauth_path::String = "" )
Performs license chhecking with `liccheck` validation function on dir `xpauth_path`
"""
function userlic(;
    verbose::Bool = true,
    liccheck::Function = emptyliccheck,
    xpauth_path::String = "",
)

    # change directory to reach all libs
    initdir = pwd()
    if isdir(dirname(libxprs))
        cd(dirname(libxprs))
    end

    # open and free xpauth.xpr (touches the file to release it)
    path_lic = get_xpauthpath(xpauth_path, verbose)
    touchlic(path_lic)

    # pre allocate vars
    lic = Cint[1]
    slicmsg = path_lic #xpauth_path == "dh" ? Array{Cchar}(undef, 1024*8) :

    # FIRST call do xprslicense to get BASE LIC
    Lib.XPRSlicense(lic, slicmsg)

    # convert BASE LIC to GIVEN LIC
    lic = liccheck(lic)

    # Send GIVEN LIC to XPRESS lib
    buffer = Array{Cchar}(undef, 1024 * 8)
    buffer_p = pointer(buffer)
    ierr = GC.@preserve buffer begin
        Lib.XPRSlicense(lic, Cstring(buffer_p))
    end

    # check LIC TYPE
    if ierr == 16
        # DEVELOPER
        if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
            @info("Xpress: Development license detected.")
        end
    elseif ierr != 0
        # FAIL
        @info("Xpress: Failed to find working license.")
        error(getlicerrmsg())
    else
        # USER
        if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
            @info("Xpress: User license detected.")
            @info(unsafe_string(pointer(slicmsg)))
        end
    end

    # go back to initial folder
    return cd(initdir)
end

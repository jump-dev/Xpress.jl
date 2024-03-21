# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

function get_xpauthpath(xpauth_path = "", verbose::Bool = true)
    XPAUTH = "xpauth.xpr"
    candidates = [xpauth_path, joinpath(xpauth_path, XPAUTH)]
    for key in ("XPAUTH_PATH", "XPRESSDIR")
        if haskey(ENV, key)
            push!(candidates, joinpath(replace(ENV[key], "\"" => ""), XPAUTH))
        end
    end
    push!(candidates, joinpath(dirname(dirname(libxprs)), "bin", XPAUTH))
    for candidate in candidates
        if isfile(candidate)
            if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
                @info("Xpress: Found license file $candidate")
            end
            return candidate
        end
    end
    return error(
        "Could not find xpauth.xpr license file. Set the `XPRESSDIR` or " *
        "`XPAUTH_PATH` environment variables.",
    )
end

"""
    userlic(;
        liccheck::Function = identity,
        verbose::Bool = true,
        xpauth_path::String = ""
    )

Performs license chhecking with `liccheck` validation function on dir
`xpauth_path`
"""
function userlic(;
    liccheck::Function = identity,
    verbose::Bool = true,
    xpauth_path::String = "",
)
    verbose &= !haskey(ENV, "XPRESS_JL_NO_INFO")
    # change directory to reach all libs
    initdir = pwd()
    if isdir(dirname(libxprs))
        cd(dirname(libxprs))
    end
    # open and free xpauth.xpr (touches the file to release it)
    path_lic = get_xpauthpath(xpauth_path, verbose)
    touch(path_lic)
    # pre allocate vars
    license = Cint[1]
    # First, call XPRSlicense to populate `license` with an integer.
    Lib.XPRSlicense(license, path_lic)
    # Then, for some licenses, we need to modify the license integer by a
    # secret password.
    license = liccheck(license)
    # Now, we need to send the password back to Xpress
    # Send GIVEN LIC to XPRESS lib
    err = Lib.XPRSlicense(license, path_lic)
    if err == 16 # DEVELOPER
        if verbose
            @info("Xpress: Development license detected.")
        end
    elseif err == 0 # USER
        if verbose
            @info("Xpress: User license detected.")
            @info(path_lic)
        end
    else
        @info("Xpress: Failed to find working license.")
        error(getlicerrmsg())
    end
    # go back to initial folder
    cd(initdir)
    return
end

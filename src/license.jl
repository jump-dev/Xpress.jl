# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

function _get_xpauthpath(xpauth_path = "", verbose::Bool = true)
    # The directory of the xprs shared object. This is the root from which we
    # search for licenses.
    libdir = dirname(libxprs)
    XPAUTH = "xpauth.xpr"
    # Search in absolute path given by the user (assuming it was a file), and as
    # a directory by appending XPAUTH.
    candidates = [xpauth_path, joinpath(xpauth_path, XPAUTH)]
    # Search in the directories of the XPAUTH_PATH and XPRESSDIR environnment
    # variables.
    for key in ("XPAUTH_PATH", "XPRESSDIR")
        if haskey(ENV, key)
            push!(candidates, joinpath(replace(ENV[key], "\"" => ""), XPAUTH))
        end
    end
    # Search in `xpress/lib/../bin/xpauth.xpr`. This is a common location on
    # Windows.
    push!(candidates, joinpath(dirname(libdir), "bin", XPAUTH))
    for candidate in candidates
        # We assume a relative root directory of the shared library. If
        # `candidate` is an absolute path, thhen joinpath will ignore libdir and
        # return candidate.
        filename = joinpath(libdir, candidate)
        # If the file exists, we assume it is a license. We don't attempt to
        # validate the contents of the file.
        if isfile(filename)
            if verbose && !haskey(ENV, "XPRESS_JL_NO_INFO")
                @info("Xpress: Found license file $filename")
            end
            return filename
        end
    end
    return error(
        "Could not find xpauth.xpr license file. Set the `XPRESSDIR` or " *
        "`XPAUTH_PATH` environment variables.",
    )
end

# Keep `userlic` for backwards compatibility. PSR have a customized setup for
# managing licenses.
#
# New users should use `Xpress.initialize`.
function userlic(;
    liccheck::Function = identity,
    verbose::Bool = true,
    xpauth_path::String = "",
)
    verbose &= !haskey(ENV, "XPRESS_JL_NO_INFO")
    path_lic = _get_xpauthpath(xpauth_path, verbose)
    # Pre-allocate storage for the license integer. For backward compatibility,
    # we use `Vector{Cint}`, because some users may have `liccheck` functions
    # which rely on this.
    license = Cint[1]
    # First, call XPRSlicense to populate `license` with an integer. We don't
    # check the return code.
    _ = Lib.XPRSlicense(license, path_lic)
    # Then, for some licenses, we need to modify the license integer by a
    # secret password.
    license = liccheck(license)
    # Now, we need to send the password back to Xpress.
    err = Lib.XPRSlicense(license, path_lic)
    if !(err == 16 || err == 0)
        @info("Xpress: Failed to find working license.")
        buffer = Vector{Cchar}(undef, 1024 * 8)
        p_buffer = pointer(buffer)
        GC.@preserve buffer begin
            Lib.XPRSgetlicerrmsg(p_buffer, 1024)
            throw(XpressError(err, unsafe_string(p_buffer)))
        end
    elseif verbose
        type = err == 16 ? "Development" : "User"
        @info("Xpress: $type license detected.")
    end
    return
end

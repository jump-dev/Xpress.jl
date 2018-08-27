# lic checking file
# -----------------

# license check empty function
# ----------------------------
function emptyliccheck(lic::Vector{Cint})
    return lic
end

function touchlic(path)
    f = open(path)
    close(f)
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
        push!(candidates, joinpath(ENV["XPAUTH_PATH"], XPAUTH))
    end

    # default lib dir
    if haskey(ENV, "XPRESSDIR")
        push!(candidates, joinpath(ENV["XPRESSDIR"], "bin", XPAUTH))
    end

    # user´s lib dir
    push!(candidates, joinpath(dirname(dirname(xprs)), "bin", XPAUTH))

    for i in candidates
        if isfile(i)
            if verbose
                info("Xpress: Found license file $i")
            end
            return i
        end
    end

    error("Could not find xpauth.xpr license file")
end

"""
    userlic(; liccheck::Function = emptyliccheck, xpauth_path::String = "" )

Performs license chhecking with `liccheck` validation function on dir `xpauth_path`
"""
function userlic(; verbose::Bool = true, liccheck::Function = emptyliccheck, xpauth_path::String = "" )

    # change directory to reach all libs
    initdir = pwd()
    if isdir(dirname(xprs))
        cd(dirname(xprs))
    end

    # open and free xpauth.xpr (touches the file to release it)
    path_lic = get_xpauthpath(xpauth_path, verbose)
    touchlic(path_lic)

    # pre allocate vars
    lic = Cint[1]
    slicmsg =  path_lic #xpauth_path == "dh" ? Array{Cchar}(undef, 1024*8) :
    errmsg = Array{Cchar}(undef, 1024*8)

    # FIRST call do xprslicense to get BASE LIC
    ierr = @xprs_ccall(license, Cint, (Ptr{Cint},Ptr{Cchar}), lic, slicmsg)

    # convert BASE LIC to GIVEN LIC
    lic = liccheck(lic)

    # Send GIVEN LIC to XPRESS lib
    slicmsg = Array{Cchar}(undef, 1024*8)
    ierr = @xprs_ccall(license, Cint, (Ptr{Cint},Ptr{Cchar}), lic, slicmsg)

    # check LIC TYPE
    if ierr == 16
        # DEVELOPER
        if verbose
            info("Xpress: Development license detected.")
        end
    elseif ierr != 0
        # FAIL
        info("Xpress: Failed to find working license.")
        ret = @xprs_ccall(getlicerrmsg, Cint, (Ptr{Cchar},Cint), errmsg, 1024)
        error(  unsafe_string(pointer(errmsg))   )
    else
        # USER
        if verbose
            info("Xpress: User license detected.")
            info(  unsafe_string(pointer(slicmsg))  )
        end
    end

    # go back to initial folder
    cd(initdir)
end

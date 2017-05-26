# lic checking file
# -----------------

# license check empty function
# ----------------------------
function emptyliccheck(lic::Vector{Cint})
    return lic
end

# lic check routine
# -----------------
function userlic(; liccheck::Function = emptyliccheck, xpauth_path::Compat.ASCIIString = "" )

	# change directory to reach all libs
	# ----------------------------------
    initdir = pwd()
    libdir = dirname(xprs)
    cd(libdir)

    # open and free xpauth.xpr (touches the file to release it)
    # ---------------------------------------------------------
	path_lic = Array{Cchar}(1024*8)
    if xpauth_path == ""
        path_lic = joinpath(libdir,"xpauth.xpr")
        if isfile(path_lic)
            f = open(path_lic)
            close(f)
        end
	elseif isdir(xpauth_path)
		path_lic = joinpath(xpauth_path,"xpauth.xpr")
        f = open(path_lic)
        close(f)
	elseif isfile(xpauth_path)
		path_lic = xpauth_path
        f = open(path_lic)
        close(f)
    end

    # pre allocate vars
    # ----------------
    lic = Cint[1]
    slicmsg =  path_lic #xpauth_path == "dh" ? Array{Cchar}(1024*8) :
    errmsg = Array{Cchar}(1024*8)

    # FIRST call do xprslicense to get BASE LIC
    # -----------------------------------------
    ierr = @xprs_ccall(license, Cint, (Ptr{Cint},Ptr{Cchar}), lic, slicmsg)


    # convert BASE LIC to GIVEN LIC
    # ---------------------------
    lic = liccheck(lic)

    # Send GIVEN LIC to XPRESS lib
    # --------------------------
    slicmsg = Array{Cchar}(1024*8)
    ierr = @xprs_ccall(license, Cint, (Ptr{Cint},Ptr{Cchar}), lic, slicmsg)

    # check LIC TYPE
    # --------------
    if ierr == 16
        # DEVELOPER
        # ---------
        info("Xpress: Development license detected.")
    elseif ierr != 0
        # FAIL
        # ----
        info("Xpress: Failed to find working license.")

        ret = @xprs_ccall(getlicerrmsg, Cint, (Ptr{Cchar},Cint), errmsg, 1024)

        error(  unsafe_string(pointer(errmsg))   )
    else
        # USER
        # ----
        info("Xpress: User license detected.")
        info(  unsafe_string(pointer(slicmsg))  )
    end

    # go back to initial folder
    # ------------------------
    cd(initdir)
end

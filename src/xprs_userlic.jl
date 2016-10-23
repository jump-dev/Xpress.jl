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
    if xpauth_path != ""
        path_lic = xpauth_path*"\\xpauth.xpr"
        f = open(path_lic)
        close(f)
    end

    # pre allocate vars
    # ----------------
    lic = Cint[1]
    slicmsg = xpauth_path == "" ? Array(Cchar,512) : path_lic
    errmsg = Array(Cchar,512)

    # FIRST call do xprslicense to get BASE LIC
    # -----------------------------------------
    ccall(("XPRSlicense",xprs),
        stdcall, Cint, (Ptr{Cint},Ptr{Cchar}), lic,slicmsg)

    # convert BASE LIC to GIVEN LIC
    # ---------------------------
    # change this line to the code given by  your FICO representative
    lic = liccheck(lic)

    # Send GIVEN LIC to XPRESS lib
    # --------------------------
    ierr = ccall(("XPRSlicense",xprs),
        stdcall, Cint, (Ptr{Cint},Ptr{Cchar}), lic, slicmsg)

    # check LIC TYPE
    # --------------
    if ierr == 16
        # DEVELOPER
        # ---------
        info("Xpress development software detected.")
    elseif ierr != 0
        # FAIL
        # ----
        info("Failed to find working license.")

        ccall(("XPRSgetlicerrmsg",xprs),
            stdcall, Cint, (Ptr{Cchar},Cint), errmsg, 512)

        error(  unsafe_string(pointer(errmsg))   )
    else
        # USER
        # ----
        info("User license detected.")
        info(  unsafe_string(pointer(slicmsg))  )
    end

    # go back to initial folder
    # ------------------------
    cd(initdir)
end

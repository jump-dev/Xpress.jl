# lic checking file
# -----------------

function userlic()

	# change directory to reach all libs
	# ----------------------------------
    initdir = pwd()
    libdir = dirname(xprs)
    cd(libdir)

    # pre allocate vars
    # ----------------
    lic = Cint[1]
    slicmsg = Array(Cchar,512)
    errmsg = Array(Cchar,512)

    # FIRST call do xprslicense to get BASE LIC
    # -----------------------------------------
    ccall(("XPRSlicense",xprs),
        stdcall, Cint, (Ptr{Cint},Ptr{Cchar}), lic,slicmsg)

    # convert BASE LIC to GIVEN LIC
    # ---------------------------
    # change this line to the code given by  your FICO representative

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

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
    #ierr = Cint[1]
    lic = Cint[1]
    slicmsg = Array(Cchar,512)
    errmsg = Array(Cchar,512)

    # FIRST call do xprslicense to get BASE LIC
    # -----------------------------------------
    ccall(("XPRSlicense",xprs), 
        stdcall, Cint, (Ptr{Cint},Ptr{Cchar}), lic,slicmsg)

    #println( ascii( bytestring(pointer(slicmsg))  ) )

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
        println("Xpress development software detected.")
        println( ascii( bytestring(pointer(slicmsg))  ) )
    elseif ierr != 0 
        # FAIL
        # ----
        ccall(("XPRSgetlicerrmsg",xprs), 
            stdcall, Cint, (Ptr{Cchar},Cint), errmsg, 512)

        println( ascii( bytestring(pointer(errmsg))  ) )
    else 
        # USER
        # ----
        println("User license detected.")
        println( ascii( bytestring(pointer(slicmsg))  ) )
    end

    cd(initdir)
end

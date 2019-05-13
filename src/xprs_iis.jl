mutable struct IISData
    stat::Int
    rownumber::Int # number of rows participating in the IIS
    colnumber::Int # number of columns participating in the IIS
    miisrow::Vector{Cint} # index of the rows that participate
    miiscol::Vector{Cint} # index of the columns that participate
    constrainttype::Vector{UInt8} # sense of the rows that participate
    colbndtype::Vector{UInt8} # sense of the column bounds that participate
end

function getfirstiis(model::Model)
    # This function always calls iisfirst first, which computes a first IIS.
    # In other words, any call to this function is expensive.

    # First, compute the first IIS.
    # int XPRS_CC XPRSiisfirst(XPRSprob prob, int ifiis, int *status_code);
    status = Ref{Cint}()
    ret = @xprs_ccall(iisfirst, Cint, (Ptr{Nothing}, Cint, Ptr{Cint}),
        model.ptr_model, 1, status)
    if ret != 0
        throw(XpressError(model))
    end

    # If the computation did not succeed, stop right now.
    if status[] == 1
        # The problem is actually feasible.
        return IISData(status[], 0, 0, Vector{Cint}(), Vector{Cint}(), Vector{UInt8}(), Vector{UInt8}())
    elseif status[] == 2
        # There was a problem in the computation; this should never happen, as
        # in this case the function should return a nonzero code.
        throw(XpressError(model))
    end

    # Then, retrieve it.
    # int XPRS_CC XPRSgetiisdata(XPRSprob prob, int num, int *rownumber, int *colnumber, int miisrow[],
    # int miiscol[], char constrainttype[], char colbndtype[], double duals[], double rdcs[],
    # char isolationrows[], char isolationcols[]);

    # XPRESS' API works in two steps: first, retrieve the sizes of the arrays to
    # retrieve; then, the user is expected to allocate the needed memory,
    # before asking XPRESS to fill it. (Making one call would require having large
    # enough arrays, which would waste lots of memory.)
    rownumber = Ref{Cint}()
    colnumber = Ref{Cint}()
    ret = @xprs_ccall(
        getiisdata,
        Cint,
        (Ptr{Nothing}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{UInt8}),
        model.ptr_model, 1, rownumber, colnumber, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end

    miisrow = Vector{Cint}(undef, rownumber[])
    miiscol = Vector{Cint}(undef, colnumber[])
    constrainttype = Vector{UInt8}(undef, colnumber[])
    colbndtype = Vector{UInt8}(undef, colnumber[])
    # duals ignored (dual multiplier for each IIS constraint)
    # rdcs ignored (reduced costs for each IIS variable)
    # isolationrows ignored (would also required running iisisolations)
    # isolationcols ignored (would also required running iisisolations)
    ret = @xprs_ccall(
        getiisdata,
        Cint,
        (Ptr{Nothing}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{UInt8}),
        model.ptr_model, 1, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, C_NULL, C_NULL, C_NULL, C_NULL)
    if ret != 0
        throw(XpressError(model))
    end

    return IISData(status[], rownumber[], colnumber[], miisrow, miiscol, constrainttype, colbndtype)
end

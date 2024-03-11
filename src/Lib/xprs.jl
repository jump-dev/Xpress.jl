# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

# Julia wrapper for header: xprs.h
# Automatically generated using Clang.jl
#! format: off

function XPRScopycallbacks(dest, src)
    ccall((:XPRScopycallbacks, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopycontrols(dest, src)
    ccall((:XPRScopycontrols, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopyprob(dest, src, name)
    ccall((:XPRScopyprob, libxprs), Cint, (XPRSprob, XPRSprob, Cstring), dest, src, name)
end

function XPRScreateprob(p_prob)
    ccall((:XPRScreateprob, libxprs), Cint, (Ptr{XPRSprob},), p_prob)
end

function XPRSdestroyprob(prob)
    ccall((:XPRSdestroyprob, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSinit(path)
    ccall((:XPRSinit, libxprs), Cint, (Cstring,), path)
end

function XPRSfree()
    ccall((:XPRSfree, libxprs), Cint, ())
end

function XPRSgetlicerrmsg(buffer, maxbytes)
    ccall((:XPRSgetlicerrmsg, libxprs), Cint, (Cstring, Cint), buffer, maxbytes)
end

function XPRSlicense(p_i, p_c)
    ccall((:XPRSlicense, libxprs), Cint, (Ptr{Cint}, Cstring), p_i, p_c)
end

function XPRSbeginlicensing(p_notyet)
    ccall((:XPRSbeginlicensing, libxprs), Cint, (Ptr{Cint},), p_notyet)
end

function XPRSendlicensing()
    ccall((:XPRSendlicensing, libxprs), Cint, ())
end

function XPRSsetcheckedmode(checkedmode)
    ccall((:XPRSsetcheckedmode, libxprs), Cint, (Cint,), checkedmode)
end

function XPRSgetcheckedmode(p_checkedmode)
    ccall((:XPRSgetcheckedmode, libxprs), Cint, (Ptr{Cint},), p_checkedmode)
end

function XPRSgetbanner(banner)
    ccall((:XPRSgetbanner, libxprs), Cint, (Cstring,), banner)
end

function XPRSgetversion(version)
    ccall((:XPRSgetversion, libxprs), Cint, (Cstring,), version)
end

function XPRSgetdaysleft(p_daysleft)
    ccall((:XPRSgetdaysleft, libxprs), Cint, (Ptr{Cint},), p_daysleft)
end

function XPRSfeaturequery(feature, p_status)
    ccall((:XPRSfeaturequery, libxprs), Cint, (Cstring, Ptr{Cint}), feature, p_status)
end

function XPRSsetprobname(prob, probname)
    ccall((:XPRSsetprobname, libxprs), Cint, (XPRSprob, Cstring), prob, probname)
end

function XPRSsetlogfile(prob, filename)
    ccall((:XPRSsetlogfile, libxprs), Cint, (XPRSprob, Cstring), prob, filename)
end

function XPRSsetdefaultcontrol(prob, control)
    ccall((:XPRSsetdefaultcontrol, libxprs), Cint, (XPRSprob, Cint), prob, control)
end

function XPRSsetdefaults(prob)
    ccall((:XPRSsetdefaults, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSinterrupt(prob, reason)
    ccall((:XPRSinterrupt, libxprs), Cint, (XPRSprob, Cint), prob, reason)
end

function XPRSgetprobname(prob, name)
    ccall((:XPRSgetprobname, libxprs), Cint, (XPRSprob, Cstring), prob, name)
end

function XPRSsetintcontrol(prob, control, value)
    ccall((:XPRSsetintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint), prob, control, value)
end

function XPRSsetintcontrol64(prob, control, value)
    ccall((:XPRSsetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Cint), prob, control, value)
end

function XPRSsetdblcontrol(prob, control, value)
    ccall((:XPRSsetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cdouble), prob, control, value)
end

function XPRSsetstrcontrol(prob, control, value)
    ccall((:XPRSsetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, control, value)
end

function XPRSgetintcontrol(prob, control, p_value)
    ccall((:XPRSgetintcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, control, p_value)
end

function XPRSgetintcontrol64(prob, control, p_value)
    ccall((:XPRSgetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, control, p_value)
end

function XPRSgetdblcontrol(prob, control, p_value)
    ccall((:XPRSgetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, control, p_value)
end

function XPRSgetstrcontrol(prob, control, value)
    ccall((:XPRSgetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, control, value)
end

function XPRSgetstringcontrol(prob, control, value, maxbytes, p_nbytes)
    ccall((:XPRSgetstringcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Ptr{Cint}), prob, control, value, maxbytes, p_nbytes)
end

function XPRSgetintattrib(prob, attrib, p_value)
    ccall((:XPRSgetintattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, attrib, p_value)
end

function XPRSgetintattrib64(prob, attrib, p_value)
    ccall((:XPRSgetintattrib64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, attrib, p_value)
end

function XPRSgetstrattrib(prob, attrib, value)
    ccall((:XPRSgetstrattrib, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, attrib, value)
end

function XPRSgetstringattrib(prob, attrib, value, maxbytes, p_nbytes)
    ccall((:XPRSgetstringattrib, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Ptr{Cint}), prob, attrib, value, maxbytes, p_nbytes)
end

function XPRSgetdblattrib(prob, attrib, p_value)
    ccall((:XPRSgetdblattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, attrib, p_value)
end

function XPRSgetcontrolinfo(prob, name, p_id, p_type)
    ccall((:XPRSgetcontrolinfo, libxprs), Cint, (XPRSprob, Cstring, Ptr{Cint}, Ptr{Cint}), prob, name, p_id, p_type)
end

function XPRSgetattribinfo(prob, name, p_id, p_type)
    ccall((:XPRSgetattribinfo, libxprs), Cint, (XPRSprob, Cstring, Ptr{Cint}, Ptr{Cint}), prob, name, p_id, p_type)
end

function XPRSsetobjintcontrol(prob, objidx, control, value)
    ccall((:XPRSsetobjintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Cint), prob, objidx, control, value)
end

function XPRSsetobjdblcontrol(prob, objidx, control, value)
    ccall((:XPRSsetobjdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, objidx, control, value)
end

function XPRSgetobjintcontrol(prob, objidx, control, p_value)
    ccall((:XPRSgetobjintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}), prob, objidx, control, p_value)
end

function XPRSgetobjdblcontrol(prob, objidx, control, p_value)
    ccall((:XPRSgetobjdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, objidx, control, p_value)
end

function XPRSgetobjintattrib(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjintattrib, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}), prob, solveidx, attrib, p_value)
end

function XPRSgetobjintattrib64(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjintattrib64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}), prob, solveidx, attrib, p_value)
end

function XPRSgetobjdblattrib(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjdblattrib, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, solveidx, attrib, p_value)
end

function XPRSgetqobj(prob, objqcol1, objqcol2, p_objqcoef)
    ccall((:XPRSgetqobj, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, objqcol1, objqcol2, p_objqcoef)
end

function XPRSreadprob(prob, filename, flags)
    ccall((:XPRSreadprob, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSloadlp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
    ccall((:XPRSloadlp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
end

function XPRSloadlp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
    ccall((:XPRSloadlp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
end

function XPRSloadqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSloadqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSloadqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSloadqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSloadmiqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadmiqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSfixmipentities(prob, options)
    ccall((:XPRSfixmipentities, libxprs), Cint, (XPRSprob, Cint), prob, options)
end

function XPRSloadmodelcuts(prob, nrows, rowind)
    ccall((:XPRSloadmodelcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, rowind)
end

function XPRSloaddelayedrows(prob, nrows, rowind)
    ccall((:XPRSloaddelayedrows, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, rowind)
end

function XPRSloaddirs(prob, ndirs, colind, priority, dir, uppseudo, downpseudo)
    ccall((:XPRSloaddirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ndirs, colind, priority, dir, uppseudo, downpseudo)
end

function XPRSloadbranchdirs(prob, ncols, colind, dir)
    ccall((:XPRSloadbranchdirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, ncols, colind, dir)
end

function XPRSloadpresolvedirs(prob, ndirs, colind, priority, dir, uppseudo, downpseudo)
    ccall((:XPRSloadpresolvedirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ndirs, colind, priority, dir, uppseudo, downpseudo)
end

function XPRSloadmip(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmip, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadmip64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmip64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSaddnames(prob, type, names, first, last)
    ccall((:XPRSaddnames, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Cint), prob, type, names, first, last)
end

function XPRSaddsetnames(prob, names, first, last)
    ccall((:XPRSaddsetnames, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, names, first, last)
end

function XPRSscale(prob, rowscale, colscale)
    ccall((:XPRSscale, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowscale, colscale)
end

function XPRSreaddirs(prob, filename)
    ccall((:XPRSreaddirs, libxprs), Cint, (XPRSprob, Cstring), prob, filename)
end

function XPRSwritedirs(prob, filename)
    ccall((:XPRSwritedirs, libxprs), Cint, (XPRSprob, Cstring), prob, filename)
end

function XPRSunloadprob(prob)
    ccall((:XPRSunloadprob, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSsetindicators(prob, nrows, rowind, colind, complement)
    ccall((:XPRSsetindicators, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, nrows, rowind, colind, complement)
end

function XPRSaddpwlcons(prob, npwls, npoints, colind, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, colind, resultant, start, xval, yval)
end

function XPRSaddpwlcons64(prob, npwls, npoints, colind, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, colind, resultant, start, xval, yval)
end

function XPRSgetpwlcons(prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
    ccall((:XPRSgetpwlcons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
end

function XPRSgetpwlcons64(prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
    ccall((:XPRSgetpwlcons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
end

function XPRSaddgencons(prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
    ccall((:XPRSaddgencons, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
end

function XPRSaddgencons64(prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
    ccall((:XPRSaddgencons64, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
end

function XPRSgetgencons(prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
    ccall((:XPRSgetgencons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
end

function XPRSgetgencons64(prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
    ccall((:XPRSgetgencons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
end

function XPRSdelpwlcons(prob, npwls, pwlind)
    ccall((:XPRSdelpwlcons, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, npwls, pwlind)
end

function XPRSdelgencons(prob, ncons, conind)
    ccall((:XPRSdelgencons, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, ncons, conind)
end

function XPRSdumpcontrols(prob)
    ccall((:XPRSdumpcontrols, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSgetindicators(prob, colind, complement, first, last)
    ccall((:XPRSgetindicators, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Cint, Cint), prob, colind, complement, first, last)
end

function XPRSdelindicators(prob, first, last)
    ccall((:XPRSdelindicators, libxprs), Cint, (XPRSprob, Cint, Cint), prob, first, last)
end

function XPRSgetdirs(prob, p_ndir, indices, prios, branchdirs, uppseudo, downpseudo)
    ccall((:XPRSgetdirs, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, p_ndir, indices, prios, branchdirs, uppseudo, downpseudo)
end

function XPRSlpoptimize(prob, flags)
    ccall((:XPRSlpoptimize, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRSmipoptimize(prob, flags)
    ccall((:XPRSmipoptimize, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRSoptimize(prob, flags, solvestatus, solstatus)
    ccall((:XPRSoptimize, libxprs), Cint, (XPRSprob, Cstring, Ptr{Cint}, Ptr{Cint}), prob, flags, solvestatus, solstatus)
end

function XPRSreadslxsol(prob, filename, flags)
    ccall((:XPRSreadslxsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSalter(prob, filename)
    ccall((:XPRSalter, libxprs), Cint, (XPRSprob, Cstring), prob, filename)
end

function XPRSreadbasis(prob, filename, flags)
    ccall((:XPRSreadbasis, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSreadbinsol(prob, filename, flags)
    ccall((:XPRSreadbinsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSgetinfeas(prob, p_nprimalcols, p_nprimalrows, p_ndualrows, p_ndualcols, x, slack, duals, djs)
    ccall((:XPRSgetinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, p_nprimalcols, p_nprimalrows, p_ndualrows, p_ndualcols, x, slack, duals, djs)
end

function XPRSgetscaledinfeas(prob, p_nprimalcols, p_nprimalrows, p_ndualrows, p_ndualcols, x, slack, duals, djs)
    ccall((:XPRSgetscaledinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, p_nprimalcols, p_nprimalrows, p_ndualrows, p_ndualcols, x, slack, duals, djs)
end

function XPRSgetunbvec(prob, p_seq)
    ccall((:XPRSgetunbvec, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, p_seq)
end

function XPRScrossoverlpsol(prob, p_status)
    ccall((:XPRScrossoverlpsol, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, p_status)
end

function XPRStune(prob, flags)
    ccall((:XPRStune, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRStunerwritemethod(prob, methodfile)
    ccall((:XPRStunerwritemethod, libxprs), Cint, (XPRSprob, Cstring), prob, methodfile)
end

function XPRStunerreadmethod(prob, methodfile)
    ccall((:XPRStunerreadmethod, libxprs), Cint, (XPRSprob, Cstring), prob, methodfile)
end

function XPRSgetbarnumstability(prob, colstab, rowstab)
    ccall((:XPRSgetbarnumstability, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, colstab, rowstab)
end

function XPRSgetpivotorder(prob, pivotorder)
    ccall((:XPRSgetpivotorder, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, pivotorder)
end

function XPRSgetpresolvemap(prob, rowmap, colmap)
    ccall((:XPRSgetpresolvemap, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowmap, colmap)
end

function XPRSbtran(prob, vec)
    ccall((:XPRSbtran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}), prob, vec)
end

function XPRSftran(prob, vec)
    ccall((:XPRSftran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}), prob, vec)
end

function XPRSsparsebtran(prob, val, ind, p_ncoefs)
    ccall((:XPRSsparsebtran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}), prob, val, ind, p_ncoefs)
end

function XPRSsparseftran(prob, val, ind, p_ncoefs)
    ccall((:XPRSsparseftran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}), prob, val, ind, p_ncoefs)
end

function XPRSgetobj(prob, objcoef, first, last)
    ccall((:XPRSgetobj, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, objcoef, first, last)
end

function XPRSgetobjn(prob, objidx, objcoef, first, last)
    ccall((:XPRSgetobjn, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}, Cint, Cint), prob, objidx, objcoef, first, last)
end

function XPRSgetrhs(prob, rhs, first, last)
    ccall((:XPRSgetrhs, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, rhs, first, last)
end

function XPRSgetrhsrange(prob, rng, first, last)
    ccall((:XPRSgetrhsrange, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, rng, first, last)
end

function XPRSgetlb(prob, lb, first, last)
    ccall((:XPRSgetlb, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, lb, first, last)
end

function XPRSgetub(prob, ub, first, last)
    ccall((:XPRSgetub, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, ub, first, last)
end

function XPRSgetcols(prob, start, rowind, rowcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetcols, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, rowind, rowcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetcols64(prob, start, rowind, rowcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetcols64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, rowind, rowcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetrows(prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetrows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetrows64(prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetrows64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetrowflags(prob, flags, first, last)
    ccall((:XPRSgetrowflags, libxprs), Cint, (XPRSprob, Ptr{Cint}, Cint, Cint), prob, flags, first, last)
end

function XPRSclearrowflags(prob, flags, first, last)
    ccall((:XPRSclearrowflags, libxprs), Cint, (XPRSprob, Ptr{Cint}, Cint, Cint), prob, flags, first, last)
end

function XPRSgetcoef(prob, row, col, p_coef)
    ccall((:XPRSgetcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, row, col, p_coef)
end

function XPRSgetmqobj(prob, start, colind, objqcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetmqobj, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, colind, objqcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetmqobj64(prob, start, colind, objqcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetmqobj64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, colind, objqcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSwritebasis(prob, filename, flags)
    ccall((:XPRSwritebasis, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSwritesol(prob, filename, flags)
    ccall((:XPRSwritesol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSwritebinsol(prob, filename, flags)
    ccall((:XPRSwritebinsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSwriteprtsol(prob, filename, flags)
    ccall((:XPRSwriteprtsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSwriteslxsol(prob, filename, flags)
    ccall((:XPRSwriteslxsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRSgetpresolvesol(prob, x, slack, duals, djs)
    ccall((:XPRSgetpresolvesol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

function XPRSgetsolution(prob, status, x, first, last)
    ccall((:XPRSgetsolution, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, x, first, last)
end

function XPRSgetslacks(prob, status, slacks, first, last)
    ccall((:XPRSgetslacks, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, slacks, first, last)
end

function XPRSgetduals(prob, status, duals, first, last)
    ccall((:XPRSgetduals, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, duals, first, last)
end

function XPRSgetredcosts(prob, status, djs, first, last)
    ccall((:XPRSgetredcosts, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, djs, first, last)
end

function XPRSgetlastbarsol(prob, x, slack, duals, djs, p_status)
    ccall((:XPRSgetlastbarsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, x, slack, duals, djs, p_status)
end

function XPRSiisclear(prob)
    ccall((:XPRSiisclear, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSiisfirst(prob, mode, p_status)
    ccall((:XPRSiisfirst, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, mode, p_status)
end

function XPRSiisnext(prob, p_status)
    ccall((:XPRSiisnext, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, p_status)
end

function XPRSiisstatus(prob, p_niis, nrows, ncols, suminfeas, numinfeas)
    ccall((:XPRSiisstatus, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}), prob, p_niis, nrows, ncols, suminfeas, numinfeas)
end

function XPRSiisall(prob)
    ccall((:XPRSiisall, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSiiswrite(prob, iis, filename, filetype, flags)
    ccall((:XPRSiiswrite, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Cstring), prob, iis, filename, filetype, flags)
end

function XPRSiisisolations(prob, iis)
    ccall((:XPRSiisisolations, libxprs), Cint, (XPRSprob, Cint), prob, iis)
end

function XPRSgetiisdata(prob, iis, p_nrows, p_ncols, rowind, colind, contype, bndtype, duals, djs, isolationrows, isolationcols)
    ccall((:XPRSgetiisdata, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{UInt8}), prob, iis, p_nrows, p_ncols, rowind, colind, contype, bndtype, duals, djs, isolationrows, isolationcols)
end

function XPRSgetiis(prob, p_ncols, p_nrows, colind, rowind)
    ccall((:XPRSgetiis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, p_ncols, p_nrows, colind, rowind)
end

function XPRSloadpresolvebasis(prob, rowstat, colstat)
    ccall((:XPRSloadpresolvebasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowstat, colstat)
end

function XPRSgetmipentities(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetmipentities, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

function XPRSgetmipentities64(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetmipentities64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

function XPRSloadsecurevecs(prob, nrows, ncols, rowind, colind)
    ccall((:XPRSloadsecurevecs, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}), prob, nrows, ncols, rowind, colind)
end

function XPRSaddrows(prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
    ccall((:XPRSaddrows, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
end

function XPRSaddrows64(prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
    ccall((:XPRSaddrows64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
end

function XPRSdelrows(prob, nrows, rowind)
    ccall((:XPRSdelrows, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, rowind)
end

function XPRSaddcols(prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
    ccall((:XPRSaddcols, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
end

function XPRSaddcols64(prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
    ccall((:XPRSaddcols64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
end

function XPRSdelcols(prob, ncols, colind)
    ccall((:XPRSdelcols, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, ncols, colind)
end

function XPRSchgcoltype(prob, ncols, colind, coltype)
    ccall((:XPRSchgcoltype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}), prob, ncols, colind, coltype)
end

function XPRSloadbasis(prob, rowstat, colstat)
    ccall((:XPRSloadbasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowstat, colstat)
end

function XPRSpostsolve(prob)
    ccall((:XPRSpostsolve, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSdelsets(prob, nsets, setind)
    ccall((:XPRSdelsets, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nsets, setind)
end

function XPRSaddsets(prob, nsets, nelems, settype, start, colind, refval)
    ccall((:XPRSaddsets, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nsets, nelems, settype, start, colind, refval)
end

function XPRSaddsets64(prob, nsets, nelems, settype, start, colind, refval)
    ccall((:XPRSaddsets64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nsets, nelems, settype, start, colind, refval)
end

function XPRSstrongbranch(prob, nbounds, colind, bndtype, bndval, iterlim, objval, status)
    ccall((:XPRSstrongbranch, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cint}), prob, nbounds, colind, bndtype, bndval, iterlim, objval, status)
end

function XPRSestimaterowdualranges(prob, nrows, rowind, iterlim, mindual, maxdual)
    ccall((:XPRSestimaterowdualranges, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}, Ptr{Cdouble}), prob, nrows, rowind, iterlim, mindual, maxdual)
end

function XPRSsetmessagestatus(prob, msgcode, status)
    ccall((:XPRSsetmessagestatus, libxprs), Cint, (XPRSprob, Cint, Cint), prob, msgcode, status)
end

function XPRSgetmessagestatus(prob, msgcode, p_status)
    ccall((:XPRSgetmessagestatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, msgcode, p_status)
end

function XPRSchgobjsense(prob, objsense)
    ccall((:XPRSchgobjsense, libxprs), Cint, (XPRSprob, Cint), prob, objsense)
end

function XPRSchgglblimit(prob, ncols, colind, limit)
    ccall((:XPRSchgglblimit, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, colind, limit)
end

function XPRSsave(prob)
    ccall((:XPRSsave, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSsaveas(prob, sSaveFileName)
    ccall((:XPRSsaveas, libxprs), Cint, (XPRSprob, Cstring), prob, sSaveFileName)
end

function XPRSrestore(prob, probname, flags)
    ccall((:XPRSrestore, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, probname, flags)
end

function XPRSpivot(prob, enter, leave)
    ccall((:XPRSpivot, libxprs), Cint, (XPRSprob, Cint, Cint), prob, enter, leave)
end

function XPRSloadlpsol(prob, x, slack, duals, djs, p_status)
    ccall((:XPRSloadlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, x, slack, duals, djs, p_status)
end

function XPRSlogfilehandler(xprsobj, cbdata, thread, msg, msgtype, msgcode)
    ccall((:XPRSlogfilehandler, libxprs), Cint, (XPRSobject, Ptr{Cvoid}, Ptr{Cvoid}, Cstring, Cint, Cint), xprsobj, cbdata, thread, msg, msgtype, msgcode)
end

function XPRSrepairweightedinfeas(prob, p_status, lepref, gepref, lbpref, ubpref, phase2, delta, flags)
    ccall((:XPRSrepairweightedinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Cstring), prob, p_status, lepref, gepref, lbpref, ubpref, phase2, delta, flags)
end

function XPRSrepairweightedinfeasbounds(prob, p_status, lepref, gepref, lbpref, ubpref, lerelax, gerelax, lbrelax, ubrelax, phase2, delta, flags)
    ccall((:XPRSrepairweightedinfeasbounds, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Cstring), prob, p_status, lepref, gepref, lbpref, ubpref, lerelax, gerelax, lbrelax, ubrelax, phase2, delta, flags)
end

function XPRSrepairinfeas(prob, p_status, penalty, phase2, flags, lepref, gepref, lbpref, ubpref, delta)
    ccall((:XPRSrepairinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, UInt8, UInt8, UInt8, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble), prob, p_status, penalty, phase2, flags, lepref, gepref, lbpref, ubpref, delta)
end

function XPRSbasisstability(prob, type, norm, scaled, p_value)
    ccall((:XPRSbasisstability, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cdouble}), prob, type, norm, scaled, p_value)
end

function XPRSgetindex(prob, type, name, p_index)
    ccall((:XPRSgetindex, libxprs), Cint, (XPRSprob, Cint, Cstring, Ptr{Cint}), prob, type, name, p_index)
end

function XPRSgetlasterror(prob, errmsg)
    ccall((:XPRSgetlasterror, libxprs), Cint, (XPRSprob, Cstring), prob, errmsg)
end

function XPRSgetobjecttypename(xprsobj, p_name)
    ccall((:XPRSgetobjecttypename, libxprs), Cint, (XPRSobject, Ptr{Cstring}), xprsobj, p_name)
end

function XPRSgetprimalray(prob, ray, p_hasray)
    ccall((:XPRSgetprimalray, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, ray, p_hasray)
end

function XPRSgetdualray(prob, ray, p_hasray)
    ccall((:XPRSgetdualray, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, ray, p_hasray)
end

function XPRSstrongbranchcb(prob, nbounds, colind, bndtype, bndval, iterlim, objval, status, callback, data)
    ccall((:XPRSstrongbranchcb, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cvoid}, Ptr{Cvoid}), prob, nbounds, colind, bndtype, bndval, iterlim, objval, status, callback, data)
end

function XPRSloadmipsol(prob, x, p_status)
    ccall((:XPRSloadmipsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, x, p_status)
end

function XPRSgetbasis(prob, rowstat, colstat)
    ccall((:XPRSgetbasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowstat, colstat)
end

function XPRSgetbasisval(prob, row, col, p_rowstat, p_colstat)
    ccall((:XPRSgetbasisval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}), prob, row, col, p_rowstat, p_colstat)
end

function XPRSaddcuts(prob, ncuts, cuttype, rowtype, rhs, start, colind, cutcoef)
    ccall((:XPRSaddcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, cuttype, rowtype, rhs, start, colind, cutcoef)
end

function XPRSaddcuts64(prob, ncuts, cuttype, rowtype, rhs, start, colind, cutcoef)
    ccall((:XPRSaddcuts64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, cuttype, rowtype, rhs, start, colind, cutcoef)
end

function XPRSdelcuts(prob, basis, cuttype, interp, delta, ncuts, cutind)
    ccall((:XPRSdelcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble, Cint, Ptr{XPRScut}), prob, basis, cuttype, interp, delta, ncuts, cutind)
end

function XPRSdelcpcuts(prob, cuttype, interp, ncuts, cutind)
    ccall((:XPRSdelcpcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{XPRScut}), prob, cuttype, interp, ncuts, cutind)
end

function XPRSgetcutlist(prob, cuttype, interp, p_ncuts, maxcuts, cutind)
    ccall((:XPRSgetcutlist, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Cint, Ptr{XPRScut}), prob, cuttype, interp, p_ncuts, maxcuts, cutind)
end

function XPRSgetcpcutlist(prob, cuttype, interp, delta, p_ncuts, maxcuts, cutind, viol)
    ccall((:XPRSgetcpcutlist, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble, Ptr{Cint}, Cint, Ptr{XPRScut}, Ptr{Cdouble}), prob, cuttype, interp, delta, p_ncuts, maxcuts, cutind, viol)
end

function XPRSgetcpcuts(prob, rowind, ncuts, maxcoefs, cuttype, rowtype, start, colind, cutcoef, rhs)
    ccall((:XPRSgetcpcuts, libxprs), Cint, (XPRSprob, Ptr{XPRScut}, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, rowind, ncuts, maxcoefs, cuttype, rowtype, start, colind, cutcoef, rhs)
end

function XPRSgetcpcuts64(prob, rowind, ncuts, maxcoefs, cuttype, rowtype, start, colind, cutcoef, rhs)
    ccall((:XPRSgetcpcuts64, libxprs), Cint, (XPRSprob, Ptr{XPRScut}, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, rowind, ncuts, maxcoefs, cuttype, rowtype, start, colind, cutcoef, rhs)
end

function XPRSloadcuts(prob, coltype, interp, ncuts, cutind)
    ccall((:XPRSloadcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{XPRScut}), prob, coltype, interp, ncuts, cutind)
end

function XPRSstorecuts(prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
    ccall((:XPRSstorecuts, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
end

function XPRSstorecuts64(prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
    ccall((:XPRSstorecuts64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
end

function XPRSpresolverow(prob, rowtype, norigcoefs, origcolind, origrowcoef, origrhs, maxcoefs, p_ncoefs, colind, rowcoef, p_rhs, p_status)
    ccall((:XPRSpresolverow, libxprs), Cint, (XPRSprob, UInt8, Cint, Ptr{Cint}, Ptr{Cdouble}, Cdouble, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, rowtype, norigcoefs, origcolind, origrowcoef, origrhs, maxcoefs, p_ncoefs, colind, rowcoef, p_rhs, p_status)
end

function XPRSpostsolvesol(prob, prex, origx)
    ccall((:XPRSpostsolvesol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, prex, origx)
end

function XPRSstorebounds(prob, nbounds, colind, bndtype, bndval, p_bounds)
    ccall((:XPRSstorebounds, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Ptr{Cvoid}}), prob, nbounds, colind, bndtype, bndval, p_bounds)
end

function XPRSsetbranchcuts(prob, ncuts, cutind)
    ccall((:XPRSsetbranchcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRScut}), prob, ncuts, cutind)
end

function XPRSsetbranchbounds(prob, bounds)
    ccall((:XPRSsetbranchbounds, libxprs), Cint, (XPRSprob, Ptr{Cvoid}), prob, bounds)
end

function XPRSgetpivots(prob, enter, outlist, x, p_objval, p_npivots, maxpivots)
    ccall((:XPRSgetpivots, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Cint), prob, enter, outlist, x, p_objval, p_npivots, maxpivots)
end

function XPRSwriteprob(prob, filename, flags)
    ccall((:XPRSwriteprob, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, filename, flags)
end

function XPRScalcslacks(prob, solution, slacks)
    ccall((:XPRScalcslacks, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, slacks)
end

function XPRScalcreducedcosts(prob, duals, solution, djs)
    ccall((:XPRScalcreducedcosts, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, duals, solution, djs)
end

function XPRScalcobjective(prob, solution, p_objval)
    ccall((:XPRScalcobjective, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, p_objval)
end

function XPRScalcobjn(prob, objidx, solution, p_objval)
    ccall((:XPRScalcobjn, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}, Ptr{Cdouble}), prob, objidx, solution, p_objval)
end

function XPRScalcsolinfo(prob, solution, duals, property, p_value)
    ccall((:XPRScalcsolinfo, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cdouble}), prob, solution, duals, property, p_value)
end

function XPRSgetrowtype(prob, rowtype, first, last)
    ccall((:XPRSgetrowtype, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, rowtype, first, last)
end

function XPRSgetpresolvebasis(prob, rowstat, colstat)
    ccall((:XPRSgetpresolvebasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowstat, colstat)
end

function XPRSgetcoltype(prob, coltype, first, last)
    ccall((:XPRSgetcoltype, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, coltype, first, last)
end

function XPRSchgbounds(prob, nbounds, colind, bndtype, bndval)
    ccall((:XPRSchgbounds, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}), prob, nbounds, colind, bndtype, bndval)
end

function XPRSgetnamelist(prob, type, names, maxbytes, p_nbytes, first, last)
    ccall((:XPRSgetnamelist, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{Cint}, Cint, Cint), prob, type, names, maxbytes, p_nbytes, first, last)
end

function XPRSaddmipsol(prob, length, solval, colind, name)
    ccall((:XPRSaddmipsol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}, Ptr{Cint}, Cstring), prob, length, solval, colind, name)
end

function XPRSgetcutslack(prob, cutind, p_slack)
    ccall((:XPRSgetcutslack, libxprs), Cint, (XPRSprob, XPRScut, Ptr{Cdouble}), prob, cutind, p_slack)
end

function XPRSgetcutmap(prob, ncuts, cutind, cutmap)
    ccall((:XPRSgetcutmap, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRScut}, Ptr{Cint}), prob, ncuts, cutind, cutmap)
end

function XPRSgetnames(prob, type, names, first, last)
    ccall((:XPRSgetnames, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Cint), prob, type, names, first, last)
end

function XPRSgetlpsol(prob, x, slack, duals, djs)
    ccall((:XPRSgetlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

function XPRSgetlpsolval(prob, col, row, p_x, p_slack, p_dual, p_dj)
    ccall((:XPRSgetlpsolval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, col, row, p_x, p_slack, p_dual, p_dj)
end

function XPRSgetmipsol(prob, x, slack)
    ccall((:XPRSgetmipsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack)
end

function XPRSgetmipsolval(prob, col, row, p_x, p_slack)
    ccall((:XPRSgetmipsolval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}), prob, col, row, p_x, p_slack)
end

function XPRSchgobj(prob, ncols, colind, objcoef)
    ccall((:XPRSchgobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, colind, objcoef)
end

function XPRSchgcoef(prob, row, col, coef)
    ccall((:XPRSchgcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, row, col, coef)
end

function XPRSchgmcoef(prob, ncoefs, rowind, colind, rowcoef)
    ccall((:XPRSchgmcoef, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, rowcoef)
end

function XPRSchgmcoef64(prob, ncoefs, rowind, colind, rowcoef)
    ccall((:XPRSchgmcoef64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, rowcoef)
end

function XPRSchgmqobj(prob, ncoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSchgmqobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSchgmqobj64(prob, ncoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSchgmqobj64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSchgqobj(prob, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSchgqobj, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, objqcol1, objqcol2, objqcoef)
end

function XPRSchgrhs(prob, nrows, rowind, rhs)
    ccall((:XPRSchgrhs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, rowind, rhs)
end

function XPRSchgrhsrange(prob, nrows, rowind, rng)
    ccall((:XPRSchgrhsrange, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, rowind, rng)
end

function XPRSchgrowtype(prob, nrows, rowind, rowtype)
    ccall((:XPRSchgrowtype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}), prob, nrows, rowind, rowtype)
end

function XPRSaddobj(prob, ncols, colind, objcoef, priority, weight)
    ccall((:XPRSaddobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Cdouble), prob, ncols, colind, objcoef, priority, weight)
end

function XPRSchgobjn(prob, objidx, ncols, colind, objcoef)
    ccall((:XPRSchgobjn, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, objidx, ncols, colind, objcoef)
end

function XPRSdelobj(prob, objidx)
    ccall((:XPRSdelobj, libxprs), Cint, (XPRSprob, Cint), prob, objidx)
end

function XPRSsetcblplog(prob, f_lplog, p)
    ccall((:XPRSsetcblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_lplog, p)
end

function XPRSgetcblplog(prob, f_lplog, p)
    ccall((:XPRSgetcblplog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_lplog, p)
end

function XPRSaddcblplog(prob, f_lplog, p, priority)
    ccall((:XPRSaddcblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_lplog, p, priority)
end

function XPRSremovecblplog(prob, f_lplog, p)
    ccall((:XPRSremovecblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_lplog, p)
end

function XPRSsetcbmiplog(prob, f_miplog, p)
    ccall((:XPRSsetcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_miplog, p)
end

function XPRSgetcbmiplog(prob, f_miplog, p)
    ccall((:XPRSgetcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_miplog, p)
end

function XPRSaddcbmiplog(prob, f_miplog, p, priority)
    ccall((:XPRSaddcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_miplog, p, priority)
end

function XPRSremovecbmiplog(prob, f_miplog, p)
    ccall((:XPRSremovecbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_miplog, p)
end

function XPRSsetcbcutlog(prob, f_cutlog, p)
    ccall((:XPRSsetcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_cutlog, p)
end

function XPRSgetcbcutlog(prob, f_cutlog, p)
    ccall((:XPRSgetcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_cutlog, p)
end

function XPRSaddcbcutlog(prob, f_cutlog, p, priority)
    ccall((:XPRSaddcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_cutlog, p, priority)
end

function XPRSremovecbcutlog(prob, f_cutlog, p)
    ccall((:XPRSremovecbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_cutlog, p)
end

function XPRSsetcbbarlog(prob, f_barlog, p)
    ccall((:XPRSsetcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_barlog, p)
end

function XPRSgetcbbarlog(prob, f_barlog, p)
    ccall((:XPRSgetcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_barlog, p)
end

function XPRSaddcbbarlog(prob, f_barlog, p, priority)
    ccall((:XPRSaddcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_barlog, p, priority)
end

function XPRSremovecbbarlog(prob, f_barlog, p)
    ccall((:XPRSremovecbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_barlog, p)
end

function XPRSsetcbcutmgr(prob, f_cutmgr, p)
    ccall((:XPRSsetcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_cutmgr, p)
end

function XPRSgetcbcutmgr(prob, f_cutmgr, p)
    ccall((:XPRSgetcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_cutmgr, p)
end

function XPRSaddcbcutmgr(prob, f_cutmgr, p, priority)
    ccall((:XPRSaddcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_cutmgr, p, priority)
end

function XPRSremovecbcutmgr(prob, f_cutmgr, p)
    ccall((:XPRSremovecbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_cutmgr, p)
end

function XPRSsetcbchgnode(prob, f_chgnode, p)
    ccall((:XPRSsetcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgnode, p)
end

function XPRSgetcbchgnode(prob, f_chgnode, p)
    ccall((:XPRSgetcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_chgnode, p)
end

function XPRSaddcbchgnode(prob, f_chgnode, p, priority)
    ccall((:XPRSaddcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_chgnode, p, priority)
end

function XPRSremovecbchgnode(prob, f_chgnode, p)
    ccall((:XPRSremovecbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgnode, p)
end

function XPRSsetcboptnode(prob, f_optnode, p)
    ccall((:XPRSsetcboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_optnode, p)
end

function XPRSgetcboptnode(prob, f_optnode, p)
    ccall((:XPRSgetcboptnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_optnode, p)
end

function XPRSaddcboptnode(prob, f_optnode, p, priority)
    ccall((:XPRSaddcboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_optnode, p, priority)
end

function XPRSremovecboptnode(prob, f_optnode, p)
    ccall((:XPRSremovecboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_optnode, p)
end

function XPRSsetcbprenode(prob, f_prenode, p)
    ccall((:XPRSsetcbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_prenode, p)
end

function XPRSgetcbprenode(prob, f_prenode, p)
    ccall((:XPRSgetcbprenode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_prenode, p)
end

function XPRSaddcbprenode(prob, f_prenode, p, priority)
    ccall((:XPRSaddcbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_prenode, p, priority)
end

function XPRSremovecbprenode(prob, f_prenode, p)
    ccall((:XPRSremovecbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_prenode, p)
end

function XPRSsetcbinfnode(prob, f_infnode, p)
    ccall((:XPRSsetcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_infnode, p)
end

function XPRSgetcbinfnode(prob, f_infnode, p)
    ccall((:XPRSgetcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_infnode, p)
end

function XPRSaddcbinfnode(prob, f_infnode, p, priority)
    ccall((:XPRSaddcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_infnode, p, priority)
end

function XPRSremovecbinfnode(prob, f_infnode, p)
    ccall((:XPRSremovecbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_infnode, p)
end

function XPRSsetcbnodecutoff(prob, f_nodecutoff, p)
    ccall((:XPRSsetcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nodecutoff, p)
end

function XPRSgetcbnodecutoff(prob, f_nodecutoff, p)
    ccall((:XPRSgetcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_nodecutoff, p)
end

function XPRSaddcbnodecutoff(prob, f_nodecutoff, p, priority)
    ccall((:XPRSaddcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_nodecutoff, p, priority)
end

function XPRSremovecbnodecutoff(prob, f_nodecutoff, p)
    ccall((:XPRSremovecbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nodecutoff, p)
end

function XPRSsetcbintsol(prob, f_intsol, p)
    ccall((:XPRSsetcbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_intsol, p)
end

function XPRSgetcbintsol(prob, f_intsol, p)
    ccall((:XPRSgetcbintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_intsol, p)
end

function XPRSaddcbintsol(prob, f_intsol, p, priority)
    ccall((:XPRSaddcbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_intsol, p, priority)
end

function XPRSremovecbintsol(prob, f_intsol, p)
    ccall((:XPRSremovecbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_intsol, p)
end

function XPRSsetcbpreintsol(prob, f_preintsol, p)
    ccall((:XPRSsetcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_preintsol, p)
end

function XPRSgetcbpreintsol(prob, f_preintsol, p)
    ccall((:XPRSgetcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_preintsol, p)
end

function XPRSaddcbpreintsol(prob, f_preintsol, p, priority)
    ccall((:XPRSaddcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_preintsol, p, priority)
end

function XPRSremovecbpreintsol(prob, f_preintsol, p)
    ccall((:XPRSremovecbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_preintsol, p)
end

function XPRSsetcbchgbranch(prob, f_chgbranch, p)
    ccall((:XPRSsetcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgbranch, p)
end

function XPRSgetcbchgbranch(prob, f_chgbranch, p)
    ccall((:XPRSgetcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_chgbranch, p)
end

function XPRSaddcbchgbranch(prob, f_chgbranch, p, priority)
    ccall((:XPRSaddcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_chgbranch, p, priority)
end

function XPRSremovecbchgbranch(prob, f_chgbranch, p)
    ccall((:XPRSremovecbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgbranch, p)
end

function XPRSsetcbestimate(prob, f_estimate, p)
    ccall((:XPRSsetcbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_estimate, p)
end

function XPRSgetcbestimate(prob, f_estimate, p)
    ccall((:XPRSgetcbestimate, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_estimate, p)
end

function XPRSaddcbestimate(prob, f_estimate, p, priority)
    ccall((:XPRSaddcbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_estimate, p, priority)
end

function XPRSremovecbestimate(prob, f_estimate, p)
    ccall((:XPRSremovecbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_estimate, p)
end

function XPRSsetcbsepnode(prob, f_sepnode, p)
    ccall((:XPRSsetcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_sepnode, p)
end

function XPRSgetcbsepnode(prob, f_sepnode, p)
    ccall((:XPRSgetcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_sepnode, p)
end

function XPRSaddcbsepnode(prob, f_sepnode, p, priority)
    ccall((:XPRSaddcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_sepnode, p, priority)
end

function XPRSremovecbsepnode(prob, f_sepnode, p)
    ccall((:XPRSremovecbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_sepnode, p)
end

function XPRSsetcbmessage(prob, f_message, p)
    ccall((:XPRSsetcbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_message, p)
end

function XPRSgetcbmessage(prob, f_message, p)
    ccall((:XPRSgetcbmessage, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_message, p)
end

function XPRSaddcbmessage(prob, f_message, p, priority)
    ccall((:XPRSaddcbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_message, p, priority)
end

function XPRSremovecbmessage(prob, f_message, p)
    ccall((:XPRSremovecbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_message, p)
end

function XPRSsetcbmipthread(prob, f_mipthread, p)
    ccall((:XPRSsetcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_mipthread, p)
end

function XPRSgetcbmipthread(prob, f_mipthread, p)
    ccall((:XPRSgetcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_mipthread, p)
end

function XPRSaddcbmipthread(prob, f_mipthread, p, priority)
    ccall((:XPRSaddcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_mipthread, p, priority)
end

function XPRSremovecbmipthread(prob, f_mipthread, p)
    ccall((:XPRSremovecbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_mipthread, p)
end

function XPRSsetcbdestroymt(prob, f_destroymt, p)
    ccall((:XPRSsetcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_destroymt, p)
end

function XPRSgetcbdestroymt(prob, f_destroymt, p)
    ccall((:XPRSgetcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_destroymt, p)
end

function XPRSaddcbdestroymt(prob, f_destroymt, p, priority)
    ccall((:XPRSaddcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_destroymt, p, priority)
end

function XPRSremovecbdestroymt(prob, f_destroymt, p)
    ccall((:XPRSremovecbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_destroymt, p)
end

function XPRSsetcbnewnode(prob, f_newnode, p)
    ccall((:XPRSsetcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_newnode, p)
end

function XPRSgetcbnewnode(prob, f_newnode, p)
    ccall((:XPRSgetcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_newnode, p)
end

function XPRSaddcbnewnode(prob, f_newnode, p, priority)
    ccall((:XPRSaddcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_newnode, p, priority)
end

function XPRSremovecbnewnode(prob, f_newnode, p)
    ccall((:XPRSremovecbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_newnode, p)
end

function XPRSsetcbbariteration(prob, f_bariteration, p)
    ccall((:XPRSsetcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_bariteration, p)
end

function XPRSgetcbbariteration(prob, f_bariteration, p)
    ccall((:XPRSgetcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_bariteration, p)
end

function XPRSaddcbbariteration(prob, f_bariteration, p, priority)
    ccall((:XPRSaddcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_bariteration, p, priority)
end

function XPRSremovecbbariteration(prob, f_bariteration, p)
    ccall((:XPRSremovecbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_bariteration, p)
end

function XPRSsetcbpresolve(prob, f_presolve, p)
    ccall((:XPRSsetcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_presolve, p)
end

function XPRSgetcbpresolve(prob, f_presolve, p)
    ccall((:XPRSgetcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_presolve, p)
end

function XPRSaddcbpresolve(prob, f_presolve, p, priority)
    ccall((:XPRSaddcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_presolve, p, priority)
end

function XPRSremovecbpresolve(prob, f_presolve, p)
    ccall((:XPRSremovecbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_presolve, p)
end

function XPRSsetcbchgbranchobject(prob, f_chgbranchobject, p)
    ccall((:XPRSsetcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgbranchobject, p)
end

function XPRSgetcbchgbranchobject(prob, f_chgbranchobject, p)
    ccall((:XPRSgetcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_chgbranchobject, p)
end

function XPRSaddcbchgbranchobject(prob, f_chgbranchobject, p, priority)
    ccall((:XPRSaddcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_chgbranchobject, p, priority)
end

function XPRSremovecbchgbranchobject(prob, f_chgbranchobject, p)
    ccall((:XPRSremovecbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_chgbranchobject, p)
end

function XPRSsetcbcomputerestart(prob, f_computerestart, p)
    ccall((:XPRSsetcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_computerestart, p)
end

function XPRSgetcbcomputerestart(prob, f_computerestart, p)
    ccall((:XPRSgetcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_computerestart, p)
end

function XPRSaddcbcomputerestart(prob, f_computerestart, p, priority)
    ccall((:XPRSaddcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_computerestart, p, priority)
end

function XPRSremovecbcomputerestart(prob, f_computerestart, p)
    ccall((:XPRSremovecbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_computerestart, p)
end

function XPRSsetcbnodelpsolved(prob, f_nodelpsolved, p)
    ccall((:XPRSsetcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nodelpsolved, p)
end

function XPRSgetcbnodelpsolved(prob, f_nodelpsolved, p)
    ccall((:XPRSgetcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_nodelpsolved, p)
end

function XPRSaddcbnodelpsolved(prob, f_nodelpsolved, p, priority)
    ccall((:XPRSaddcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_nodelpsolved, p, priority)
end

function XPRSremovecbnodelpsolved(prob, f_nodelpsolved, p)
    ccall((:XPRSremovecbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nodelpsolved, p)
end

function XPRSsetcbgapnotify(prob, f_gapnotify, p)
    ccall((:XPRSsetcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_gapnotify, p)
end

function XPRSgetcbgapnotify(prob, f_gapnotify, p)
    ccall((:XPRSgetcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_gapnotify, p)
end

function XPRSaddcbgapnotify(prob, f_gapnotify, p, priority)
    ccall((:XPRSaddcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_gapnotify, p, priority)
end

function XPRSremovecbgapnotify(prob, f_gapnotify, p)
    ccall((:XPRSremovecbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_gapnotify, p)
end

function XPRSsetcbusersolnotify(prob, f_usersolnotify, p)
    ccall((:XPRSsetcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_usersolnotify, p)
end

function XPRSgetcbusersolnotify(prob, f_usersolnotify, p)
    ccall((:XPRSgetcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_usersolnotify, p)
end

function XPRSaddcbusersolnotify(prob, f_usersolnotify, p, priority)
    ccall((:XPRSaddcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_usersolnotify, p, priority)
end

function XPRSremovecbusersolnotify(prob, f_usersolnotify, p)
    ccall((:XPRSremovecbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_usersolnotify, p)
end

function XPRSsetcbbeforesolve(prob, f_beforesolve, p)
    ccall((:XPRSsetcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_beforesolve, p)
end

function XPRSgetcbbeforesolve(prob, f_beforesolve, p)
    ccall((:XPRSgetcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_beforesolve, p)
end

function XPRSaddcbbeforesolve(prob, f_beforesolve, p, priority)
    ccall((:XPRSaddcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_beforesolve, p, priority)
end

function XPRSremovecbbeforesolve(prob, f_beforesolve, p)
    ccall((:XPRSremovecbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_beforesolve, p)
end

function XPRSsetcbbeforeobjective(prob, f_beforeobjective, p)
    ccall((:XPRSsetcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_beforeobjective, p)
end

function XPRSgetcbbeforeobjective(prob, f_beforeobjective, p)
    ccall((:XPRSgetcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_beforeobjective, p)
end

function XPRSaddcbbeforeobjective(prob, f_beforeobjective, p, priority)
    ccall((:XPRSaddcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_beforeobjective, p, priority)
end

function XPRSremovecbbeforeobjective(prob, f_beforeobjective, p)
    ccall((:XPRSremovecbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_beforeobjective, p)
end

function XPRSsetcbafterobjective(prob, f_afterobjective, p)
    ccall((:XPRSsetcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_afterobjective, p)
end

function XPRSgetcbafterobjective(prob, f_afterobjective, p)
    ccall((:XPRSgetcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_afterobjective, p)
end

function XPRSaddcbafterobjective(prob, f_afterobjective, p, priority)
    ccall((:XPRSaddcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_afterobjective, p, priority)
end

function XPRSremovecbafterobjective(prob, f_afterobjective, p)
    ccall((:XPRSremovecbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_afterobjective, p)
end

function XPRSsetcbchecktime(prob, f_checktime, p)
    ccall((:XPRSsetcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_checktime, p)
end

function XPRSgetcbchecktime(prob, f_checktime, p)
    ccall((:XPRSgetcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_checktime, p)
end

function XPRSaddcbchecktime(prob, f_checktime, p, priority)
    ccall((:XPRSaddcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_checktime, p, priority)
end

function XPRSremovecbchecktime(prob, f_checktime, p)
    ccall((:XPRSremovecbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_checktime, p)
end

function XPRSsetcbslpcascadeend(prob, f_slpcascadeend, p)
    ccall((:XPRSsetcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadeend, p)
end

function XPRSgetcbslpcascadeend(prob, f_slpcascadeend, p)
    ccall((:XPRSgetcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpcascadeend, p)
end

function XPRSaddcbslpcascadeend(prob, f_slpcascadeend, p, priority)
    ccall((:XPRSaddcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpcascadeend, p, priority)
end

function XPRSremovecbslpcascadeend(prob, f_slpcascadeend, p)
    ccall((:XPRSremovecbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadeend, p)
end

function XPRSsetcbslpcascadestart(prob, f_slpcascadestart, p)
    ccall((:XPRSsetcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadestart, p)
end

function XPRSgetcbslpcascadestart(prob, f_slpcascadestart, p)
    ccall((:XPRSgetcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpcascadestart, p)
end

function XPRSaddcbslpcascadestart(prob, f_slpcascadestart, p, priority)
    ccall((:XPRSaddcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpcascadestart, p, priority)
end

function XPRSremovecbslpcascadestart(prob, f_slpcascadestart, p)
    ccall((:XPRSremovecbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadestart, p)
end

function XPRSsetcbslpcascadevar(prob, f_slpcascadevar, p)
    ccall((:XPRSsetcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadevar, p)
end

function XPRSgetcbslpcascadevar(prob, f_slpcascadevar, p)
    ccall((:XPRSgetcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpcascadevar, p)
end

function XPRSaddcbslpcascadevar(prob, f_slpcascadevar, p, priority)
    ccall((:XPRSaddcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpcascadevar, p, priority)
end

function XPRSremovecbslpcascadevar(prob, f_slpcascadevar, p)
    ccall((:XPRSremovecbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadevar, p)
end

function XPRSsetcbslpcascadevarfail(prob, f_slpcascadevarfail, p)
    ccall((:XPRSsetcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadevarfail, p)
end

function XPRSgetcbslpcascadevarfail(prob, f_slpcascadevarfail, p)
    ccall((:XPRSgetcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpcascadevarfail, p)
end

function XPRSaddcbslpcascadevarfail(prob, f_slpcascadevarfail, p, priority)
    ccall((:XPRSaddcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpcascadevarfail, p, priority)
end

function XPRSremovecbslpcascadevarfail(prob, f_slpcascadevarfail, p)
    ccall((:XPRSremovecbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpcascadevarfail, p)
end

function XPRSsetcbslpconstruct(prob, f_slpconstruct, p)
    ccall((:XPRSsetcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpconstruct, p)
end

function XPRSgetcbslpconstruct(prob, f_slpconstruct, p)
    ccall((:XPRSgetcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpconstruct, p)
end

function XPRSaddcbslpconstruct(prob, f_slpconstruct, p, priority)
    ccall((:XPRSaddcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpconstruct, p, priority)
end

function XPRSremovecbslpconstruct(prob, f_slpconstruct, p)
    ccall((:XPRSremovecbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpconstruct, p)
end

function XPRSsetcbslpintsol(prob, f_slpintsol, p)
    ccall((:XPRSsetcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpintsol, p)
end

function XPRSgetcbslpintsol(prob, f_slpintsol, p)
    ccall((:XPRSgetcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpintsol, p)
end

function XPRSaddcbslpintsol(prob, f_slpintsol, p, priority)
    ccall((:XPRSaddcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpintsol, p, priority)
end

function XPRSremovecbslpintsol(prob, f_slpintsol, p)
    ccall((:XPRSremovecbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpintsol, p)
end

function XPRSsetcbslpiterend(prob, f_slpiterend, p)
    ccall((:XPRSsetcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpiterend, p)
end

function XPRSgetcbslpiterend(prob, f_slpiterend, p)
    ccall((:XPRSgetcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpiterend, p)
end

function XPRSaddcbslpiterend(prob, f_slpiterend, p, priority)
    ccall((:XPRSaddcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpiterend, p, priority)
end

function XPRSremovecbslpiterend(prob, f_slpiterend, p)
    ccall((:XPRSremovecbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpiterend, p)
end

function XPRSsetcbslpiterstart(prob, f_slpiterstart, p)
    ccall((:XPRSsetcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpiterstart, p)
end

function XPRSgetcbslpiterstart(prob, f_slpiterstart, p)
    ccall((:XPRSgetcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpiterstart, p)
end

function XPRSaddcbslpiterstart(prob, f_slpiterstart, p, priority)
    ccall((:XPRSaddcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpiterstart, p, priority)
end

function XPRSremovecbslpiterstart(prob, f_slpiterstart, p)
    ccall((:XPRSremovecbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpiterstart, p)
end

function XPRSsetcbslpitervar(prob, f_slpitervar, p)
    ccall((:XPRSsetcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpitervar, p)
end

function XPRSgetcbslpitervar(prob, f_slpitervar, p)
    ccall((:XPRSgetcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpitervar, p)
end

function XPRSaddcbslpitervar(prob, f_slpitervar, p, priority)
    ccall((:XPRSaddcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpitervar, p, priority)
end

function XPRSremovecbslpitervar(prob, f_slpitervar, p)
    ccall((:XPRSremovecbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpitervar, p)
end

function XPRSsetcbslpdrcol(prob, f_slpdrcol, p)
    ccall((:XPRSsetcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpdrcol, p)
end

function XPRSgetcbslpdrcol(prob, f_slpdrcol, p)
    ccall((:XPRSgetcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slpdrcol, p)
end

function XPRSaddcbslpdrcol(prob, f_slpdrcol, p, priority)
    ccall((:XPRSaddcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slpdrcol, p, priority)
end

function XPRSremovecbslpdrcol(prob, f_slpdrcol, p)
    ccall((:XPRSremovecbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slpdrcol, p)
end

function XPRSsetcbmsjobstart(prob, f_msjobstart, p)
    ccall((:XPRSsetcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_msjobstart, p)
end

function XPRSgetcbmsjobstart(prob, f_msjobstart, p)
    ccall((:XPRSgetcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_msjobstart, p)
end

function XPRSaddcbmsjobstart(prob, f_msjobstart, p, priority)
    ccall((:XPRSaddcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_msjobstart, p, priority)
end

function XPRSremovecbmsjobstart(prob, f_msjobstart, p)
    ccall((:XPRSremovecbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_msjobstart, p)
end

function XPRSsetcbmsjobend(prob, f_msjobend, p)
    ccall((:XPRSsetcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_msjobend, p)
end

function XPRSgetcbmsjobend(prob, f_msjobend, p)
    ccall((:XPRSgetcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_msjobend, p)
end

function XPRSaddcbmsjobend(prob, f_msjobend, p, priority)
    ccall((:XPRSaddcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_msjobend, p, priority)
end

function XPRSremovecbmsjobend(prob, f_msjobend, p)
    ccall((:XPRSremovecbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_msjobend, p)
end

function XPRSsetcbmswinner(prob, f_mswinner, p)
    ccall((:XPRSsetcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_mswinner, p)
end

function XPRSgetcbmswinner(prob, f_mswinner, p)
    ccall((:XPRSgetcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_mswinner, p)
end

function XPRSaddcbmswinner(prob, f_mswinner, p, priority)
    ccall((:XPRSaddcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_mswinner, p, priority)
end

function XPRSremovecbmswinner(prob, f_mswinner, p)
    ccall((:XPRSremovecbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_mswinner, p)
end

function XPRSsetcbnlpcoefevalerror(prob, f_nlpcoefevalerror, p)
    ccall((:XPRSsetcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nlpcoefevalerror, p)
end

function XPRSgetcbnlpcoefevalerror(prob, f_nlpcoefevalerror, p)
    ccall((:XPRSgetcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_nlpcoefevalerror, p)
end

function XPRSaddcbnlpcoefevalerror(prob, f_nlpcoefevalerror, p, priority)
    ccall((:XPRSaddcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_nlpcoefevalerror, p, priority)
end

function XPRSremovecbnlpcoefevalerror(prob, f_nlpcoefevalerror, p)
    ccall((:XPRSremovecbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_nlpcoefevalerror, p)
end

function XPRSsetcbslppreupdatelinearization(prob, f_slppreupdatelinearization, p)
    ccall((:XPRSsetcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slppreupdatelinearization, p)
end

function XPRSgetcbslppreupdatelinearization(prob, f_slppreupdatelinearization, p)
    ccall((:XPRSgetcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_slppreupdatelinearization, p)
end

function XPRSaddcbslppreupdatelinearization(prob, f_slppreupdatelinearization, p, priority)
    ccall((:XPRSaddcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_slppreupdatelinearization, p, priority)
end

function XPRSremovecbslppreupdatelinearization(prob, f_slppreupdatelinearization, p)
    ccall((:XPRSremovecbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_slppreupdatelinearization, p)
end

function XPRSobjsa(prob, ncols, colind, lower, upper)
    ccall((:XPRSobjsa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, colind, lower, upper)
end

function XPRSbndsa(prob, ncols, colind, lblower, lbupper, ublower, ubupper)
    ccall((:XPRSbndsa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, colind, lblower, lbupper, ublower, ubupper)
end

function XPRSrhssa(prob, nrows, rowind, lower, upper)
    ccall((:XPRSrhssa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, nrows, rowind, lower, upper)
end

function XPRS_ge_setcbmsghandler(f_msghandler, p)
    ccall((:XPRS_ge_setcbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), f_msghandler, p)
end

function XPRS_ge_getcbmsghandler(f_msghandler, p)
    ccall((:XPRS_ge_getcbmsghandler, libxprs), Cint, (Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), f_msghandler, p)
end

function XPRS_ge_addcbmsghandler(f_msghandler, p, priority)
    ccall((:XPRS_ge_addcbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Cint), f_msghandler, p, priority)
end

function XPRS_ge_removecbmsghandler(f_msghandler, p)
    ccall((:XPRS_ge_removecbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), f_msghandler, p)
end

function XPRS_ge_setarchconsistency(consistent)
    ccall((:XPRS_ge_setarchconsistency, libxprs), Cint, (Cint,), consistent)
end

function XPRS_ge_setsafemode(safemode)
    ccall((:XPRS_ge_setsafemode, libxprs), Cint, (Cint,), safemode)
end

function XPRS_ge_getsafemode(p_safemode)
    ccall((:XPRS_ge_getsafemode, libxprs), Cint, (Ptr{Cint},), p_safemode)
end

function XPRS_ge_setdebugmode(debugmode)
    ccall((:XPRS_ge_setdebugmode, libxprs), Cint, (Cint,), debugmode)
end

function XPRS_ge_getdebugmode(p_debugmode)
    ccall((:XPRS_ge_getdebugmode, libxprs), Cint, (Ptr{Cint},), p_debugmode)
end

function XPRS_ge_getlasterror(p_msgcode, msg, maxbytes, p_nbytes)
    ccall((:XPRS_ge_getlasterror, libxprs), Cint, (Ptr{Cint}, Cstring, Cint, Ptr{Cint}), p_msgcode, msg, maxbytes, p_nbytes)
end

function XPRS_ge_setcomputeallowed(allow)
    ccall((:XPRS_ge_setcomputeallowed, libxprs), Cint, (Cint,), allow)
end

function XPRS_ge_getcomputeallowed(p_allow)
    ccall((:XPRS_ge_getcomputeallowed, libxprs), Cint, (Ptr{Cint},), p_allow)
end

function XPRS_msp_create(msp)
    ccall((:XPRS_msp_create, libxprs), Cint, (Ptr{XPRSmipsolpool},), msp)
end

function XPRS_msp_destroy(msp)
    ccall((:XPRS_msp_destroy, libxprs), Cint, (XPRSmipsolpool,), msp)
end

function XPRS_msp_probattach(msp, prob)
    ccall((:XPRS_msp_probattach, libxprs), Cint, (XPRSmipsolpool, XPRSprob), msp, prob)
end

function XPRS_msp_probdetach(msp, prob)
    ccall((:XPRS_msp_probdetach, libxprs), Cint, (XPRSmipsolpool, XPRSprob), msp, prob)
end

function XPRS_msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
    ccall((:XPRS_msp_getsollist, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function XPRS_msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
    ccall((:XPRS_msp_getsollist2, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function XPRS_msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
    ccall((:XPRS_msp_getsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{Cint}), msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
end

function XPRS_msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
    ccall((:XPRS_msp_getslack, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{Cint}), msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
end

function XPRS_msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
    ccall((:XPRS_msp_loadsol, libxprs), Cint, (XPRSmipsolpool, Ptr{Cint}, Ptr{Cdouble}, Cint, Cstring, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
end

function XPRS_msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
    ccall((:XPRS_msp_delsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}), msp, iSolutionId, iSolutionIdStatus_)
end

function XPRS_msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    ccall((:XPRS_msp_getintattribprobsol, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cint}), msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function XPRS_msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    ccall((:XPRS_msp_getdblattribprobsol, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}), msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function XPRS_msp_getintattribprob(msp, prob, iAttribId, Dst)
    ccall((:XPRS_msp_getintattribprob, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}), msp, prob, iAttribId, Dst)
end

function XPRS_msp_getdblattribprob(msp, prob, iAttribId, Dst)
    ccall((:XPRS_msp_getdblattribprob, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cdouble}), msp, prob, iAttribId, Dst)
end

function XPRS_msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    ccall((:XPRS_msp_getintattribsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Ptr{Cint}), msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function XPRS_msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    ccall((:XPRS_msp_getdblattribsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}), msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function XPRS_msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    ccall((:XPRS_msp_getintcontrolsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Ptr{Cint}), msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function XPRS_msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    ccall((:XPRS_msp_getdblcontrolsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}), msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function XPRS_msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    ccall((:XPRS_msp_setintcontrolsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Cint), msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function XPRS_msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    ccall((:XPRS_msp_setdblcontrolsol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}, Cint, Cdouble), msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function XPRS_msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    ccall((:XPRS_msp_getintattribprobextreme, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cint}), msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function XPRS_msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    ccall((:XPRS_msp_getdblattribprobextreme, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}), msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function XPRS_msp_getintattrib(msp, iAttribId, Val)
    ccall((:XPRS_msp_getintattrib, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}), msp, iAttribId, Val)
end

function XPRS_msp_getdblattrib(msp, iAttribId, Val)
    ccall((:XPRS_msp_getdblattrib, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cdouble}), msp, iAttribId, Val)
end

function XPRS_msp_getintcontrol(msp, iControlId, Val)
    ccall((:XPRS_msp_getintcontrol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cint}), msp, iControlId, Val)
end

function XPRS_msp_getdblcontrol(msp, iControlId, Val)
    ccall((:XPRS_msp_getdblcontrol, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{Cdouble}), msp, iControlId, Val)
end

function XPRS_msp_setintcontrol(msp, iControlId, Val)
    ccall((:XPRS_msp_setintcontrol, libxprs), Cint, (XPRSmipsolpool, Cint, Cint), msp, iControlId, Val)
end

function XPRS_msp_setdblcontrol(msp, iControlId, Val)
    ccall((:XPRS_msp_setdblcontrol, libxprs), Cint, (XPRSmipsolpool, Cint, Cdouble), msp, iControlId, Val)
end

function XPRS_msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
    ccall((:XPRS_msp_setsolname, libxprs), Cint, (XPRSmipsolpool, Cint, Cstring, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
end

function XPRS_msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
    ccall((:XPRS_msp_getsolname, libxprs), Cint, (XPRSmipsolpool, Cint, Cstring, Cint, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
end

function XPRS_msp_findsolbyname(msp, sSolutionName, iSolutionId)
    ccall((:XPRS_msp_findsolbyname, libxprs), Cint, (XPRSmipsolpool, Cstring, Ptr{Cint}), msp, sSolutionName, iSolutionId)
end

function XPRS_msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
    ccall((:XPRS_msp_writeslxsol, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Cstring, Cstring), msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
end

function XPRS_msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
    ccall((:XPRS_msp_readslxsol, libxprs), Cint, (XPRSmipsolpool, XPRSnamelist, Cstring, Cstring, Ptr{Cint}, Ptr{Cint}), msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
end

function XPRS_msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_msp_getlasterror, libxprs), Cint, (XPRSmipsolpool, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_msp_setcbmsghandler(msp, f_msghandler, p)
    ccall((:XPRS_msp_setcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}), msp, f_msghandler, p)
end

function XPRS_msp_getcbmsghandler(msp, f_msghandler, p)
    ccall((:XPRS_msp_getcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), msp, f_msghandler, p)
end

function XPRS_msp_addcbmsghandler(msp, f_msghandler, p, priority)
    ccall((:XPRS_msp_addcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Cint), msp, f_msghandler, p, priority)
end

function XPRS_msp_removecbmsghandler(msp, f_msghandler, p)
    ccall((:XPRS_msp_removecbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}), msp, f_msghandler, p)
end

function XPRSaddqmatrix(prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSaddqmatrix, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSaddqmatrix64(prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSaddqmatrix64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSdelqmatrix(prob, row)
    ccall((:XPRSdelqmatrix, libxprs), Cint, (XPRSprob, Cint), prob, row)
end

function XPRSloadqcqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSloadqcqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSloadqcqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSloadqcqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSloadmiqcqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqcqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadmiqcqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqcqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSgetqrowcoeff(prob, row, rowqcol1, rowqcol2, p_rowqcoef)
    ccall((:XPRSgetqrowcoeff, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cdouble}), prob, row, rowqcol1, rowqcol2, p_rowqcoef)
end

function XPRSgetqrowqmatrix(prob, row, start, colind, rowqcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetqrowqmatrix, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, row, start, colind, rowqcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetqrowqmatrixtriplets(prob, row, p_ncoefs, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSgetqrowqmatrixtriplets, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, p_ncoefs, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSchgqrowcoeff(prob, row, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSchgqrowcoeff, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble), prob, row, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSgetqrows(prob, p_nrows, rowind)
    ccall((:XPRSgetqrows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, p_nrows, rowind)
end

function XPRS_mse_create(mse)
    ccall((:XPRS_mse_create, libxprs), Cint, (Ptr{XPRSmipsolenum},), mse)
end

function XPRS_mse_destroy(mse)
    ccall((:XPRS_mse_destroy, libxprs), Cint, (XPRSmipsolenum,), mse)
end

function XPRS_mse_minim(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_minim, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function XPRS_mse_maxim(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_maxim, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function XPRS_mse_opt(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_opt, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function XPRS_mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
    ccall((:XPRS_mse_getsollist, libxprs), Cint, (XPRSmipsolenum, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
end

function XPRS_mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
    ccall((:XPRS_mse_getsolmetric, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}), mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
end

function XPRS_mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
    ccall((:XPRS_mse_getcullchoice, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cint}, Cint, Ptr{Cint}, Cdouble, Ptr{Cdouble}, Cint, Ptr{Cint}), mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
end

function XPRS_mse_getintattrib(mse, iAttribId, Val)
    ccall((:XPRS_mse_getintattrib, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cint}), mse, iAttribId, Val)
end

function XPRS_mse_getdblattrib(mse, iAttribId, Val)
    ccall((:XPRS_mse_getdblattrib, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cdouble}), mse, iAttribId, Val)
end

function XPRS_mse_getintcontrol(mse, iAttribId, Val)
    ccall((:XPRS_mse_getintcontrol, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cint}), mse, iAttribId, Val)
end

function XPRS_mse_getdblcontrol(mse, iAttribId, Val)
    ccall((:XPRS_mse_getdblcontrol, libxprs), Cint, (XPRSmipsolenum, Cint, Ptr{Cdouble}), mse, iAttribId, Val)
end

function XPRS_mse_setintcontrol(mse, iAttribId, Val)
    ccall((:XPRS_mse_setintcontrol, libxprs), Cint, (XPRSmipsolenum, Cint, Cint), mse, iAttribId, Val)
end

function XPRS_mse_setdblcontrol(mse, iAttribId, Val)
    ccall((:XPRS_mse_setdblcontrol, libxprs), Cint, (XPRSmipsolenum, Cint, Cdouble), mse, iAttribId, Val)
end

function XPRS_mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_mse_getlasterror, libxprs), Cint, (XPRSmipsolenum, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_mse_setsolbasename(mse, sSolutionBaseName)
    ccall((:XPRS_mse_setsolbasename, libxprs), Cint, (XPRSmipsolenum, Cstring), mse, sSolutionBaseName)
end

function XPRS_mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_mse_getsolbasename, libxprs), Cint, (XPRSmipsolenum, Cstring, Cint, Ptr{Cint}), mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    ccall((:XPRS_mse_setcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, f_mse_getsolutiondiff, p)
end

function XPRS_mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    ccall((:XPRS_mse_getcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), mse, f_mse_getsolutiondiff, p)
end

function XPRS_mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
    ccall((:XPRS_mse_addcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}, Cint), mse, f_mse_getsolutiondiff, p, priority)
end

function XPRS_mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    ccall((:XPRS_mse_removecbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, f_mse_getsolutiondiff, p)
end

function XPRS_mse_setcbmsghandler(mse, f_msghandler, p)
    ccall((:XPRS_mse_setcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, f_msghandler, p)
end

function XPRS_mse_getcbmsghandler(mse, f_msghandler, p)
    ccall((:XPRS_mse_getcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), mse, f_msghandler, p)
end

function XPRS_mse_addcbmsghandler(mse, f_msghandler, p, priority)
    ccall((:XPRS_mse_addcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}, Cint), mse, f_msghandler, p, priority)
end

function XPRS_mse_removecbmsghandler(mse, f_msghandler, p)
    ccall((:XPRS_mse_removecbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, f_msghandler, p)
end

function XPRS_bo_create(p_bo, prob, isoriginal)
    ccall((:XPRS_bo_create, libxprs), Cint, (Ptr{XPRSbranchobject}, XPRSprob, Cint), p_bo, prob, isoriginal)
end

function XPRS_bo_destroy(bo)
    ccall((:XPRS_bo_destroy, libxprs), Cint, (XPRSbranchobject,), bo)
end

function XPRS_bo_store(bo, p_status)
    ccall((:XPRS_bo_store, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), bo, p_status)
end

function XPRS_bo_addbranches(bo, nbranches)
    ccall((:XPRS_bo_addbranches, libxprs), Cint, (XPRSbranchobject, Cint), bo, nbranches)
end

function XPRS_bo_getbranches(bo, p_nbranches)
    ccall((:XPRS_bo_getbranches, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), bo, p_nbranches)
end

function XPRS_bo_setpriority(bo, priority)
    ccall((:XPRS_bo_setpriority, libxprs), Cint, (XPRSbranchobject, Cint), bo, priority)
end

function XPRS_bo_setpreferredbranch(bo, branch)
    ccall((:XPRS_bo_setpreferredbranch, libxprs), Cint, (XPRSbranchobject, Cint), bo, branch)
end

function XPRS_bo_addbounds(bo, branch, nbounds, bndtype, colind, bndval)
    ccall((:XPRS_bo_addbounds, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}), bo, branch, nbounds, bndtype, colind, bndval)
end

function XPRS_bo_getbounds(bo, branch, p_nbounds, maxbounds, bndtype, colind, bndval)
    ccall((:XPRS_bo_getbounds, libxprs), Cint, (XPRSbranchobject, Cint, Ptr{Cint}, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}), bo, branch, p_nbounds, maxbounds, bndtype, colind, bndval)
end

function XPRS_bo_addrows(bo, branch, nrows, ncoefs, rowtype, rhs, start, colind, rowcoef)
    ccall((:XPRS_bo_addrows, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), bo, branch, nrows, ncoefs, rowtype, rhs, start, colind, rowcoef)
end

function XPRS_bo_getrows(bo, branch, p_nrows, maxrows, p_ncoefs, maxcoefs, rowtype, rhs, start, colind, rowcoef)
    ccall((:XPRS_bo_getrows, libxprs), Cint, (XPRSbranchobject, Cint, Ptr{Cint}, Cint, Ptr{Cint}, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), bo, branch, p_nrows, maxrows, p_ncoefs, maxcoefs, rowtype, rhs, start, colind, rowcoef)
end

function XPRS_bo_addcuts(bo, branch, ncuts, cutind)
    ccall((:XPRS_bo_addcuts, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Ptr{XPRScut}), bo, branch, ncuts, cutind)
end

function XPRS_bo_getid(bo, p_id)
    ccall((:XPRS_bo_getid, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), bo, p_id)
end

function XPRS_bo_getlasterror(bo, p_msgcode, msg, maxbytes, p_nbytes)
    ccall((:XPRS_bo_getlasterror, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), bo, p_msgcode, msg, maxbytes, p_nbytes)
end

function XPRS_bo_validate(bo, p_status)
    ccall((:XPRS_bo_validate, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), bo, p_status)
end

function XPRSmsaddjob(prob, description, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
    ccall((:XPRSmsaddjob, libxprs), Cint, (XPRSprob, Cstring, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cvoid}), prob, description, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
end

function XPRSmsaddpreset(prob, description, preset, maxjobs, data)
    ccall((:XPRSmsaddpreset, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{Cvoid}), prob, description, preset, maxjobs, data)
end

function XPRSmsaddcustompreset(prob, description, preset, maxjobs, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
    ccall((:XPRSmsaddcustompreset, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cvoid}), prob, description, preset, maxjobs, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
end

function XPRSnlpsetfunctionerror(prob)
    ccall((:XPRSnlpsetfunctionerror, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpprintevalinfo(prob)
    ccall((:XPRSnlpprintevalinfo, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpvalidate(prob)
    ccall((:XPRSnlpvalidate, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpoptimize(prob, flags)
    ccall((:XPRSnlpoptimize, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRSgetnlpsol(prob, x, slack, duals, djs)
    ccall((:XPRSgetnlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

function XPRSnlpsetcurrentiv(prob)
    ccall((:XPRSnlpsetcurrentiv, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpvalidaterow(prob, row)
    ccall((:XPRSnlpvalidaterow, libxprs), Cint, (XPRSprob, Cint), prob, row)
end

function XPRSnlpvalidatekkt(prob, mode, respectbasis, updatemult, violtarget)
    ccall((:XPRSnlpvalidatekkt, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble), prob, mode, respectbasis, updatemult, violtarget)
end

function XPRSmsclear(prob)
    ccall((:XPRSmsclear, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpevaluateformula(prob, parsed, type, values, p_value)
    ccall((:XPRSnlpevaluateformula, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, parsed, type, values, p_value)
end

function XPRSnlpvalidatevector(prob, solution, p_suminf, p_sumscaledinf, p_objval)
    ccall((:XPRSnlpvalidatevector, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, p_suminf, p_sumscaledinf, p_objval)
end

function XPRSnlpadduserfunction(prob, funcname, functype, nin, nout, options, _function, data, p_type)
    ccall((:XPRSnlpadduserfunction, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Cint, Cint, XPRSfunctionptr, Ptr{Cvoid}, Ptr{Cint}), prob, funcname, functype, nin, nout, options, _function, data, p_type)
end

function XPRSnlpdeluserfunction(prob, type)
    ccall((:XPRSnlpdeluserfunction, libxprs), Cint, (XPRSprob, Cint), prob, type)
end

function XPRSnlpimportlibfunc(prob, libname, funcname, p_function, p_status)
    ccall((:XPRSnlpimportlibfunc, libxprs), Cint, (XPRSprob, Cstring, Cstring, XPRSfunctionptraddr, Ptr{Cint}), prob, libname, funcname, p_function, p_status)
end

function XPRSnlpaddformulas(prob, ncoefs, rowind, formulastart, parsed, type, value)
    ccall((:XPRSnlpaddformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, formulastart, parsed, type, value)
end

function XPRSnlpchgformulastring(prob, row, formula)
    ccall((:XPRSnlpchgformulastring, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, row, formula)
end

function XPRSnlpchgformula(prob, row, parsed, type, value)
    ccall((:XPRSnlpchgformula, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, row, parsed, type, value)
end

function XPRSnlpgetformula(prob, row, parsed, maxtypes, p_ntypes, type, value)
    ccall((:XPRSnlpgetformula, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, parsed, maxtypes, p_ntypes, type, value)
end

function XPRSnlpgetformularows(prob, p_nformulas, rowind)
    ccall((:XPRSnlpgetformularows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, p_nformulas, rowind)
end

function XPRSnlploadformulas(prob, nnlpcoefs, rowind, formulastart, parsed, type, value)
    ccall((:XPRSnlploadformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nnlpcoefs, rowind, formulastart, parsed, type, value)
end

function XPRSnlpdelformulas(prob, nformulas, rowind)
    ccall((:XPRSnlpdelformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nformulas, rowind)
end

function XPRSnlpgetformulastring(prob, row, formula, maxbytes)
    ccall((:XPRSnlpgetformulastring, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint), prob, row, formula, maxbytes)
end

function XPRSnlpsetinitval(prob, nvars, colind, initial)
    ccall((:XPRSnlpsetinitval, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nvars, colind, initial)
end

function XPRSslpgetcoefformula(prob, row, col, p_factor, parsed, maxtypes, p_ntypes, type, value)
    ccall((:XPRSslpgetcoefformula, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, col, p_factor, parsed, maxtypes, p_ntypes, type, value)
end

function XPRSslpgetcoefs(prob, p_ncoefs, rowind, colind)
    ccall((:XPRSslpgetcoefs, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, p_ncoefs, rowind, colind)
end

function XPRSslploadcoefs(prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, coef)
    ccall((:XPRSslploadcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, coef)
end

function XPRSslpdelcoefs(prob, ncoefs, rowind, colind)
    ccall((:XPRSslpdelcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, ncoefs, rowind, colind)
end

function XPRSslpgetccoef(prob, row, col, p_factor, formula, maxbytes)
    ccall((:XPRSslpgetccoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cstring, Cint), prob, row, col, p_factor, formula, maxbytes)
end

function XPRSslpsetdetrow(prob, nvars, colind, rowind)
    ccall((:XPRSslpsetdetrow, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, nvars, colind, rowind)
end

function XPRSslpaddcoefs(prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, value)
    ccall((:XPRSslpaddcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, value)
end

function XPRSslpchgccoef(prob, row, col, factor, formula)
    ccall((:XPRSslpchgccoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cstring), prob, row, col, factor, formula)
end

function XPRSslpchgcoef(prob, row, col, factor, parsed, type, value)
    ccall((:XPRSslpchgcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, row, col, factor, parsed, type, value)
end

function XPRSslpgetcolinfo(prob, type, col, p_info)
    ccall((:XPRSslpgetcolinfo, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cvoid}), prob, type, col, p_info)
end

function XPRSslpgetrowinfo(prob, type, row, p_info)
    ccall((:XPRSslpgetrowinfo, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cvoid}), prob, type, row, p_info)
end

function XPRSslpcascade(prob)
    ccall((:XPRSslpcascade, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpcascadeorder(prob)
    ccall((:XPRSslpcascadeorder, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpchgrowstatus(prob, row, status)
    ccall((:XPRSslpchgrowstatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, row, status)
end

function XPRSslpchgrowwt(prob, row, weight)
    ccall((:XPRSslpchgrowwt, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, row, weight)
end

function XPRSslpchgdeltatype(prob, nvars, varind, deltatypes, values)
    ccall((:XPRSslpchgdeltatype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nvars, varind, deltatypes, values)
end

function XPRSslpchgcascadenlimit(prob, col, limit)
    ccall((:XPRSslpchgcascadenlimit, libxprs), Cint, (XPRSprob, Cint, Cint), prob, col, limit)
end

function XPRSslpconstruct(prob)
    ccall((:XPRSslpconstruct, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpgetrowstatus(prob, row, p_status)
    ccall((:XPRSslpgetrowstatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, row, p_status)
end

function XPRSslpgetrowwt(prob, row, p_weight)
    ccall((:XPRSslpgetrowwt, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, row, p_weight)
end

function XPRSslpevaluatecoef(prob, row, col, p_value)
    ccall((:XPRSslpevaluatecoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, row, col, p_value)
end

function XPRSslpreinitialize(prob)
    ccall((:XPRSslpreinitialize, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpunconstruct(prob)
    ccall((:XPRSslpunconstruct, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpupdatelinearization(prob)
    ccall((:XPRSslpupdatelinearization, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSslpfixpenalties(prob, p_status)
    ccall((:XPRSslpfixpenalties, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, p_status)
end

function XPRSnlppostsolve(prob)
    ccall((:XPRSnlppostsolve, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSnlpcalcslacks(prob, solution, slack)
    ccall((:XPRSnlpcalcslacks, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, slack)
end

function XPRSnlpchgobjformula(prob, parsed, type, value)
    ccall((:XPRSnlpchgobjformula, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, parsed, type, value)
end

function XPRSnlpchgobjformulastring(prob, formula)
    ccall((:XPRSnlpchgobjformulastring, libxprs), Cint, (XPRSprob, Cstring), prob, formula)
end

function XPRSnlpgetobjformula(prob, parsed, maxtypes, p_ntypes, type, value)
    ccall((:XPRSnlpgetobjformula, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, parsed, maxtypes, p_ntypes, type, value)
end

function XPRSnlpgetobjformulastring(prob, formula, maxbytes)
    ccall((:XPRSnlpgetobjformulastring, libxprs), Cint, (XPRSprob, Cstring, Cint), prob, formula, maxbytes)
end

function XPRSnlpdelobjformula(prob)
    ccall((:XPRSnlpdelobjformula, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSminim(prob, flags)
    ccall((:XPRSminim, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRSmaxim(prob, flags)
    ccall((:XPRSmaxim, libxprs), Cint, (XPRSprob, Cstring), prob, flags)
end

function XPRSbasiscondition(prob, p_cond, p_scaledcond)
    ccall((:XPRSbasiscondition, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, p_cond, p_scaledcond)
end

function XPRSrefinemipsol(prob, options, flags, solution, refined, p_status)
    ccall((:XPRSrefinemipsol, libxprs), Cint, (XPRSprob, Cint, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, options, flags, solution, refined, p_status)
end

function XPRSgetnamelistobject(prob, type, p_nml)
    ccall((:XPRSgetnamelistobject, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRSnamelist}), prob, type, p_nml)
end

function XPRS_nml_create(p_nml)
    ccall((:XPRS_nml_create, libxprs), Cint, (Ptr{XPRSnamelist},), p_nml)
end

function XPRS_nml_destroy(nml)
    ccall((:XPRS_nml_destroy, libxprs), Cint, (XPRSnamelist,), nml)
end

function XPRS_nml_getnamecount(nml, p_count)
    ccall((:XPRS_nml_getnamecount, libxprs), Cint, (XPRSnamelist, Ptr{Cint}), nml, p_count)
end

function XPRS_nml_getmaxnamelen(nml, p_namelen)
    ccall((:XPRS_nml_getmaxnamelen, libxprs), Cint, (XPRSnamelist, Ptr{Cint}), nml, p_namelen)
end

function XPRS_nml_getnames(nml, pad, buffer, maxbytes, p_nbytes, first, last)
    ccall((:XPRS_nml_getnames, libxprs), Cint, (XPRSnamelist, Cint, Ptr{UInt8}, Cint, Ptr{Cint}, Cint, Cint), nml, pad, buffer, maxbytes, p_nbytes, first, last)
end

function XPRS_nml_addnames(nml, names, first, last)
    ccall((:XPRS_nml_addnames, libxprs), Cint, (XPRSnamelist, Ptr{UInt8}, Cint, Cint), nml, names, first, last)
end

function XPRS_nml_removenames(nml, first, last)
    ccall((:XPRS_nml_removenames, libxprs), Cint, (XPRSnamelist, Cint, Cint), nml, first, last)
end

function XPRS_nml_findname(nml, name, p_index)
    ccall((:XPRS_nml_findname, libxprs), Cint, (XPRSnamelist, Cstring, Ptr{Cint}), nml, name, p_index)
end

function XPRS_nml_copynames(dest, src)
    ccall((:XPRS_nml_copynames, libxprs), Cint, (XPRSnamelist, XPRSnamelist), dest, src)
end

function XPRS_nml_getlasterror(nml, p_msgcode, msg, maxbytes, p_nbytes)
    ccall((:XPRS_nml_getlasterror, libxprs), Cint, (XPRSnamelist, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), nml, p_msgcode, msg, maxbytes, p_nbytes)
end

function XPRSgetsol(prob, x, slack, duals, djs)
    ccall((:XPRSgetsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

function XPRSfixglobals(prob, options)
    ccall((:XPRSfixglobals, libxprs), Cint, (XPRSprob, Cint), prob, options)
end

function _getversion()
    buffer = Array{Cchar}(undef, 8 * 24)
    buffer_p = pointer(buffer)
    GC.@preserve buffer begin
        out = Cstring(buffer_p)
        r = Lib.XPRSgetversion(out)
        if r != 0
            throw(XpressError(r, "Unable to invoke XPRSgetversion"))
        end
        version = unsafe_string(out)::String
    end
    return VersionNumber(parse.(Int, split(version, "."))...)
end

function XPRSgetglobal(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    if _getversion() >= v"41.0.0"
        return ccall((:XPRSgetmipentities, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    else
        return ccall((:XPRSgetglobal, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    end
end

function XPRSgetglobal64(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    if _getversion() >= v"41.0.0"
        return ccall((:XPRSgetmipentities64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    else
        return ccall((:XPRSgetglobal64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    end
end

function XPRSloadqcqpglobal(prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqcqpglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqcqpglobal64(prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqcqpglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqglobal(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqglobal64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadglobal(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadglobal64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSaddcbgloballog(prob, globallog, data, priority)
    ccall((:XPRSaddcbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, globallog, data, priority)
end

function XPRSremovecbgloballog(prob, globallog, data)
    ccall((:XPRSremovecbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, globallog, data)
end

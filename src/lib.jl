# Julia wrapper for header: xprs.h
# Automatically generated using Clang.jl


function XPRScopycallbacks(dest, src)
    ccall((:XPRScopycallbacks, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopycontrols(dest, src)
    ccall((:XPRScopycontrols, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopyprob(dest, src, probname)
    ccall((:XPRScopyprob, libxprs), Cint, (XPRSprob, XPRSprob, Cstring), dest, src, probname)
end

function XPRScreateprob(_probholder)
    ccall((:XPRScreateprob, libxprs), Cint, (Ptr{XPRSprob},), _probholder)
end

function XPRSdestroyprob(_prob)
    ccall((:XPRSdestroyprob, libxprs), Cint, (XPRSprob,), _prob)
end

function XPRSinit(path)
    ccall((:XPRSinit, libxprs), Cint, (Cstring,), path)
end

function XPRSfree()
    ccall((:XPRSfree, libxprs), Cint, ())
end

function XPRSgetbanner(banner)
    ccall((:XPRSgetbanner, libxprs), Cint, (Cstring,), banner)
end

function XPRSgetversion(version)
    ccall((:XPRSgetversion, libxprs), Cint, (Cstring,), version)
end

function XPRSgetdaysleft(daysleft)
    ccall((:XPRSgetdaysleft, libxprs), Cint, (Ptr{Cint},), daysleft)
end

function XPRSsetcheckedmode(checked_mode)
    ccall((:XPRSsetcheckedmode, libxprs), Cint, (Cint,), checked_mode)
end

function XPRSgetcheckedmode(r_checked_mode)
    ccall((:XPRSgetcheckedmode, libxprs), Cint, (Ptr{Cint},), r_checked_mode)
end

function XPRSlicense(_i1, _c1)
    ccall((:XPRSlicense, libxprs), Cint, (Ptr{Cint}, Cstring), _i1, _c1)
end

function XPRSbeginlicensing(r_dontAlreadyHaveLicense)
    ccall((:XPRSbeginlicensing, libxprs), Cint, (Ptr{Cint},), r_dontAlreadyHaveLicense)
end

function XPRSendlicensing()
    ccall((:XPRSendlicensing, libxprs), Cint, ())
end

function XPRSgetlicerrmsg(msg, len)
    ccall((:XPRSgetlicerrmsg, libxprs), Cint, (Cstring, Cint), msg, len)
end

function XPRSfeaturequery(FeatureName, FeatureStatus)
    ccall((:XPRSfeaturequery, libxprs), Cint, (Cstring, Ptr{Cint}), FeatureName, FeatureStatus)
end

function XPRSsetlogfile(prob, logname)
    ccall((:XPRSsetlogfile, libxprs), Cint, (XPRSprob, Cstring), prob, logname)
end

function XPRSsetintcontrol(prob, _index, _ivalue)
    ccall((:XPRSsetintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint), prob, _index, _ivalue)
end

function XPRSsetintcontrol64(prob, _index, _ivalue)
    ccall((:XPRSsetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Cint), prob, _index, _ivalue)
end

function XPRSsetdblcontrol(prob, _index, _dvalue)
    ccall((:XPRSsetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cdouble), prob, _index, _dvalue)
end

function XPRSinterrupt(prob, reason)
    ccall((:XPRSinterrupt, libxprs), Cint, (XPRSprob, Cint), prob, reason)
end

function XPRSgetprobname(prob, _svalue)
    ccall((:XPRSgetprobname, libxprs), Cint, (XPRSprob, Cstring), prob, _svalue)
end

function XPRSgetqobj(prob, _icol, _jcol, _dval)
    ccall((:XPRSgetqobj, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, _icol, _jcol, _dval)
end

function XPRSsetprobname(prob, _svalue)
    ccall((:XPRSsetprobname, libxprs), Cint, (XPRSprob, Cstring), prob, _svalue)
end

function XPRSsetstrcontrol(prob, _index, _svalue)
    ccall((:XPRSsetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, _index, _svalue)
end

function XPRSgetintcontrol(prob, _index, _ivalue)
    ccall((:XPRSgetintcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, _index, _ivalue)
end

function XPRSgetintcontrol64(prob, _index, _ivalue)
    ccall((:XPRSgetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, _index, _ivalue)
end

function XPRSgetdblcontrol(prob, _index, _dvalue)
    ccall((:XPRSgetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, _index, _dvalue)
end

function XPRSgetstrcontrol(prob, _index, _svalue)
    ccall((:XPRSgetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, _index, _svalue)
end

function XPRSgetstringcontrol(prob, _index, _svalue, _svaluesize, _controlsize)
    ccall((:XPRSgetstringcontrol, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Ptr{Cint}), prob, _index, _svalue, _svaluesize, _controlsize)
end

function XPRSgetintattrib(prob, _index, _ivalue)
    ccall((:XPRSgetintattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, _index, _ivalue)
end

function XPRSgetintattrib64(prob, _index, _ivalue)
    ccall((:XPRSgetintattrib64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, _index, _ivalue)
end

function XPRSgetstrattrib(prob, _index, _cvalue)
    ccall((:XPRSgetstrattrib, libxprs), Cint, (XPRSprob, Cint, Cstring), prob, _index, _cvalue)
end

function XPRSgetstringattrib(prob, _index, _cvalue, _cvaluesize, _controlsize)
    ccall((:XPRSgetstringattrib, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Ptr{Cint}), prob, _index, _cvalue, _cvaluesize, _controlsize)
end

function XPRSgetdblattrib(prob, _index, _dvalue)
    ccall((:XPRSgetdblattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, _index, _dvalue)
end

function XPRSsetdefaultcontrol(prob, _index)
    ccall((:XPRSsetdefaultcontrol, libxprs), Cint, (XPRSprob, Cint), prob, _index)
end

function XPRSsetdefaults(prob)
    ccall((:XPRSsetdefaults, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSdelpwlcons(prob, npwls, _mindex)
    ccall((:XPRSdelpwlcons, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, npwls, _mindex)
end

function XPRSdelgencons(prob, ngencons, _mindex)
    ccall((:XPRSdelgencons, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, ngencons, _mindex)
end

function XPRSgetcontrolinfo(prob, sCaName, iHeaderId, iTypeinfo)
    ccall((:XPRSgetcontrolinfo, libxprs), Cint, (XPRSprob, Cstring, Ptr{Cint}, Ptr{Cint}), prob, sCaName, iHeaderId, iTypeinfo)
end

function XPRSgetattribinfo(prob, sCaName, iHeaderId, iTypeinfo)
    ccall((:XPRSgetattribinfo, libxprs), Cint, (XPRSprob, Cstring, Ptr{Cint}, Ptr{Cint}), prob, sCaName, iHeaderId, iTypeinfo)
end

function XPRSgoal(prob, _filename, _sflags)
    ccall((:XPRSgoal, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _filename, _sflags)
end

function XPRSreadprob(prob, _sprobname, _sflags)
    ccall((:XPRSreadprob, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sprobname, _sflags)
end

function XPRSloadlp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
    ccall((:XPRSloadlp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function XPRSloadlp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
    ccall((:XPRSloadlp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function XPRSloadqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    ccall((:XPRSloadqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function XPRSloadqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    ccall((:XPRSloadqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function XPRSloadqglobal(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    ccall((:XPRSloadqglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function XPRSloadqglobal64(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    ccall((:XPRSloadqglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function XPRSfixglobals(prob, options)
    ccall((:XPRSfixglobals, libxprs), Cint, (XPRSprob, Cint), prob, options)
end

function XPRSloadmodelcuts(prob, nmodcuts, _mrows)
    ccall((:XPRSloadmodelcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nmodcuts, _mrows)
end

function XPRSloaddelayedrows(prob, nrows, _mrows)
    ccall((:XPRSloaddelayedrows, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, _mrows)
end

function XPRSloaddirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    ccall((:XPRSloaddirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function XPRSloadbranchdirs(prob, ndirs, _mcols, _mbranch)
    ccall((:XPRSloadbranchdirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, ndirs, _mcols, _mbranch)
end

function XPRSloadpresolvedirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    ccall((:XPRSloadpresolvedirs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function XPRSgetdirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    ccall((:XPRSgetdirs, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function XPRSloadglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    ccall((:XPRSloadglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function XPRSloadglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    ccall((:XPRSloadglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function XPRSaddnames(prob, _itype, _sname, first, last)
    ccall((:XPRSaddnames, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Cint), prob, _itype, _sname, first, last)
end

function XPRSaddsetnames(prob, _sname, first, last)
    ccall((:XPRSaddsetnames, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, _sname, first, last)
end

function XPRSscale(prob, mrscal, mcscal)
    ccall((:XPRSscale, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, mrscal, mcscal)
end

function XPRSreaddirs(prob, _sfilename)
    ccall((:XPRSreaddirs, libxprs), Cint, (XPRSprob, Cstring), prob, _sfilename)
end

function XPRSwritedirs(prob, _sfilename)
    ccall((:XPRSwritedirs, libxprs), Cint, (XPRSprob, Cstring), prob, _sfilename)
end

function XPRSsetindicators(prob, nrows, _mrows, _inds, _comps)
    ccall((:XPRSsetindicators, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, nrows, _mrows, _inds, _comps)
end

function XPRSgetindicators(prob, _inds, _comps, first, last)
    ccall((:XPRSgetindicators, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Cint, Cint), prob, _inds, _comps, first, last)
end

function XPRSdelindicators(prob, first, last)
    ccall((:XPRSdelindicators, libxprs), Cint, (XPRSprob, Cint, Cint), prob, first, last)
end

function XPRSdumpcontrols(prob)
    ccall((:XPRSdumpcontrols, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSaddpwlcons(prob, npwls, npoints, cols, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, cols, resultant, start, xval, yval)
end

function XPRSaddpwlcons64(prob, npwls, npoints, cols, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, cols, resultant, start, xval, yval)
end

function XPRSgetpwlcons(prob, col, resultant, start, xval, yval, size, npoints, first, last)
    ccall((:XPRSgetpwlcons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, col, resultant, start, xval, yval, size, npoints, first, last)
end

function XPRSgetpwlcons64(prob, col, resultant, start, xval, yval, size, npoints, first, last)
    ccall((:XPRSgetpwlcons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, col, resultant, start, xval, yval, size, npoints, first, last)
end

function XPRSaddgencons(prob, ngencons, ncols, nvals, type, resultant, colstart, col, valstart, val)
    ccall((:XPRSaddgencons, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ngencons, ncols, nvals, type, resultant, colstart, col, valstart, val)
end

function XPRSaddgencons64(prob, ngencons, ncols, nvals, type, resultant, colstart, col, valstart, val)
    ccall((:XPRSaddgencons64, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ngencons, ncols, nvals, type, resultant, colstart, col, valstart, val)
end

function XPRSgetgencons(prob, type, resultant, colstart, col, colsize, ncols, valstart, val, valsize, nvals, first, last)
    ccall((:XPRSgetgencons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, type, resultant, colstart, col, colsize, ncols, valstart, val, valsize, nvals, first, last)
end

function XPRSgetgencons64(prob, type, resultant, colstart, col, colsize, ncols, valstart, val, valsize, nvals, first, last)
    ccall((:XPRSgetgencons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, type, resultant, colstart, col, colsize, ncols, valstart, val, valsize, nvals, first, last)
end

function XPRSminim(prob, _sflags)
    ccall((:XPRSminim, libxprs), Cint, (XPRSprob, Cstring), prob, _sflags)
end

function XPRSmaxim(prob, _sflags)
    ccall((:XPRSmaxim, libxprs), Cint, (XPRSprob, Cstring), prob, _sflags)
end

function XPRSlpoptimize(prob, _sflags)
    ccall((:XPRSlpoptimize, libxprs), Cint, (XPRSprob, Cstring), prob, _sflags)
end

function XPRSmipoptimize(prob, _sflags)
    ccall((:XPRSmipoptimize, libxprs), Cint, (XPRSprob, Cstring), prob, _sflags)
end

function XPRSrange(prob)
    ccall((:XPRSrange, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSgetrowrange(prob, _upact, _loact, _uup, _udn)
    ccall((:XPRSgetrowrange, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _upact, _loact, _uup, _udn)
end

function XPRSgetcolrange(prob, _upact, _loact, _uup, _udn, _ucost, _lcost)
    ccall((:XPRSgetcolrange, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _upact, _loact, _uup, _udn, _ucost, _lcost)
end

function XPRSgetpivotorder(prob, mpiv)
    ccall((:XPRSgetpivotorder, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, mpiv)
end

function XPRSgetpresolvemap(prob, rowmap, colmap)
    ccall((:XPRSgetpresolvemap, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowmap, colmap)
end

function XPRSreadbasis(prob, _sfilename, _sflags)
    ccall((:XPRSreadbasis, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSwritebasis(prob, _sfilename, _sflags)
    ccall((:XPRSwritebasis, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSglobal(prob)
    ccall((:XPRSglobal, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSinitglobal(prob)
    ccall((:XPRSinitglobal, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSwriteprtsol(prob, _sfilename, _sflags)
    ccall((:XPRSwriteprtsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSalter(prob, _sfilename)
    ccall((:XPRSalter, libxprs), Cint, (XPRSprob, Cstring), prob, _sfilename)
end

function XPRSwritesol(prob, _sfilename, _sflags)
    ccall((:XPRSwritesol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSwritebinsol(prob, _sfilename, _sflags)
    ccall((:XPRSwritebinsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSreadbinsol(prob, _sfilename, _sflags)
    ccall((:XPRSreadbinsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSwriteslxsol(prob, _sfilename, _sflags)
    ccall((:XPRSwriteslxsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSreadslxsol(prob, _sfilename, _sflags)
    ccall((:XPRSreadslxsol, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSwriteprtrange(prob)
    ccall((:XPRSwriteprtrange, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSwriterange(prob, _sfilename, _sflags)
    ccall((:XPRSwriterange, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSgetsol(prob, _dx, _dslack, _dual, _dj)
    ccall((:XPRSgetsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _dx, _dslack, _dual, _dj)
end

function XPRSgetpresolvesol(prob, _dx, _dslack, _dual, _dj)
    ccall((:XPRSgetpresolvesol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _dx, _dslack, _dual, _dj)
end

function XPRSgetinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    ccall((:XPRSgetinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function XPRSgetscaledinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    ccall((:XPRSgetscaledinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function XPRSgetunbvec(prob, icol)
    ccall((:XPRSgetunbvec, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, icol)
end

function XPRSbtran(prob, dwork)
    ccall((:XPRSbtran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}), prob, dwork)
end

function XPRSftran(prob, dwork)
    ccall((:XPRSftran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}), prob, dwork)
end

function XPRSsparsebtran(prob, dval, mind, nzcnt)
    ccall((:XPRSsparsebtran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}), prob, dval, mind, nzcnt)
end

function XPRSsparseftran(prob, dval, mind, nzcnt)
    ccall((:XPRSsparseftran, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}), prob, dval, mind, nzcnt)
end

function XPRSgetobj(prob, _dobj, first, last)
    ccall((:XPRSgetobj, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, _dobj, first, last)
end

function XPRSgetrhs(prob, _drhs, first, last)
    ccall((:XPRSgetrhs, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, _drhs, first, last)
end

function XPRSgetrhsrange(prob, _drng, first, last)
    ccall((:XPRSgetrhsrange, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, _drng, first, last)
end

function XPRSgetlb(prob, _dbdl, first, last)
    ccall((:XPRSgetlb, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, _dbdl, first, last)
end

function XPRSgetub(prob, _dbdu, first, last)
    ccall((:XPRSgetub, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Cint, Cint), prob, _dbdu, first, last)
end

function XPRSgetcols(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetcols, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetcols64(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetcols64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetrows(prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetrows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetrows64(prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetrows64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetcoef(prob, _irow, _icol, _dval)
    ccall((:XPRSgetcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, _irow, _icol, _dval)
end

function XPRSgetmqobj(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetmqobj, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetmqobj64(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetmqobj64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

function XPRScrossoverlpsol(prob, status)
    ccall((:XPRScrossoverlpsol, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, status)
end

function XPRStune(prob, _sflags)
    ccall((:XPRStune, libxprs), Cint, (XPRSprob, Cstring), prob, _sflags)
end

function XPRStunerwritemethod(prob, methodfile)
    ccall((:XPRStunerwritemethod, libxprs), Cint, (XPRSprob, Cstring), prob, methodfile)
end

function XPRStunerreadmethod(prob, methodfile)
    ccall((:XPRStunerreadmethod, libxprs), Cint, (XPRSprob, Cstring), prob, methodfile)
end

function XPRSgetbarnumstability(prob, dColumnStability, dRowStability)
    ccall((:XPRSgetbarnumstability, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, dColumnStability, dRowStability)
end

function XPRSiisclear(prob)
    ccall((:XPRSiisclear, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSiisfirst(prob, iismode, status_code)
    ccall((:XPRSiisfirst, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, iismode, status_code)
end

function XPRSiisnext(prob, status_code)
    ccall((:XPRSiisnext, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, status_code)
end

function XPRSiisstatus(prob, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
    ccall((:XPRSiisstatus, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}), prob, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
end

function XPRSiisall(prob)
    ccall((:XPRSiisall, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSiiswrite(prob, number, fn, filetype, typeflags)
    ccall((:XPRSiiswrite, libxprs), Cint, (XPRSprob, Cint, Cstring, Cint, Cstring), prob, number, fn, filetype, typeflags)
end

function XPRSiisisolations(prob, number)
    ccall((:XPRSiisisolations, libxprs), Cint, (XPRSprob, Cint), prob, number)
end

function XPRSgetiisdata(prob, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
    ccall((:XPRSgetiisdata, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{UInt8}), prob, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
end

function XPRSgetiis(prob, ncols, nrows, _miiscol, _miisrow)
    ccall((:XPRSgetiis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, ncols, nrows, _miiscol, _miisrow)
end

function XPRSgetpresolvebasis(prob, _mrowstatus, _mcolstatus)
    ccall((:XPRSgetpresolvebasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, _mrowstatus, _mcolstatus)
end

function XPRSloadpresolvebasis(prob, _mrowstatus, _mcolstatus)
    ccall((:XPRSloadpresolvebasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, _mrowstatus, _mcolstatus)
end

function XPRSgetglobal(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    ccall((:XPRSgetglobal, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function XPRSgetglobal64(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    ccall((:XPRSgetglobal64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function XPRSwriteprob(prob, _sfilename, _sflags)
    ccall((:XPRSwriteprob, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sfilename, _sflags)
end

function XPRSgetnames(prob, _itype, _sbuff, first, last)
    ccall((:XPRSgetnames, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Cint), prob, _itype, _sbuff, first, last)
end

function XPRSgetrowtype(prob, _srowtype, first, last)
    ccall((:XPRSgetrowtype, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, _srowtype, first, last)
end

function XPRSloadsecurevecs(prob, nrows, ncols, mrow, mcol)
    ccall((:XPRSloadsecurevecs, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}), prob, nrows, ncols, mrow, mcol)
end

function XPRSgetcoltype(prob, _coltype, first, last)
    ccall((:XPRSgetcoltype, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, _coltype, first, last)
end

function XPRSgetbasis(prob, _mrowstatus, _mcolstatus)
    ccall((:XPRSgetbasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, _mrowstatus, _mcolstatus)
end

function XPRSgetbasisval(prob, row, col, _rowstatus, _colstatus)
    ccall((:XPRSgetbasisval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}), prob, row, col, _rowstatus, _colstatus)
end

function XPRSloadbasis(prob, _mrowstatus, _mcolstatus)
    ccall((:XPRSloadbasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, _mrowstatus, _mcolstatus)
end

function XPRSgetindex(prob, _itype, _sname, _iseq)
    ccall((:XPRSgetindex, libxprs), Cint, (XPRSprob, Cint, Cstring, Ptr{Cint}), prob, _itype, _sname, _iseq)
end

function XPRSaddrows(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
    ccall((:XPRSaddrows, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
end

function XPRSaddrows64(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
    ccall((:XPRSaddrows64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
end

function XPRSdelrows(prob, nrows, _mindex)
    ccall((:XPRSdelrows, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, _mindex)
end

function XPRSaddcols(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
    ccall((:XPRSaddcols, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

function XPRSaddcols64(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
    ccall((:XPRSaddcols64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

function XPRSdelcols(prob, ncols, _mindex)
    ccall((:XPRSdelcols, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, ncols, _mindex)
end

function XPRSchgcoltype(prob, ncols, _mindex, _coltype)
    ccall((:XPRSchgcoltype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}), prob, ncols, _mindex, _coltype)
end

function XPRSchgrowtype(prob, nrows, _mindex, _srowtype)
    ccall((:XPRSchgrowtype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}), prob, nrows, _mindex, _srowtype)
end

function XPRSchgbounds(prob, nbnds, _mindex, _sboundtype, _dbnd)
    ccall((:XPRSchgbounds, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}), prob, nbnds, _mindex, _sboundtype, _dbnd)
end

function XPRSchgobj(prob, ncols, _mindex, _dobj)
    ccall((:XPRSchgobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, _mindex, _dobj)
end

function XPRSchgcoef(prob, _irow, _icol, _dval)
    ccall((:XPRSchgcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, _irow, _icol, _dval)
end

function XPRSchgmcoef(prob, ncoeffs, _mrow, _mcol, _dval)
    ccall((:XPRSchgmcoef, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoeffs, _mrow, _mcol, _dval)
end

function XPRSchgmcoef64(prob, ncoeffs, _mrow, _mcol, _dval)
    ccall((:XPRSchgmcoef64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoeffs, _mrow, _mcol, _dval)
end

function XPRSchgmqobj(prob, ncols, _mcol1, _mcol2, _dval)
    ccall((:XPRSchgmqobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, _mcol1, _mcol2, _dval)
end

function XPRSchgmqobj64(prob, ncols, _mcol1, _mcol2, _dval)
    ccall((:XPRSchgmqobj64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, _mcol1, _mcol2, _dval)
end

function XPRSchgqobj(prob, _icol, _jcol, _dval)
    ccall((:XPRSchgqobj, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, _icol, _jcol, _dval)
end

function XPRSchgrhs(prob, nrows, _mindex, _drhs)
    ccall((:XPRSchgrhs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, _mindex, _drhs)
end

function XPRSchgrhsrange(prob, nrows, _mindex, _drng)
    ccall((:XPRSchgrhsrange, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, _mindex, _drng)
end

function XPRSchgobjsense(prob, objsense)
    ccall((:XPRSchgobjsense, libxprs), Cint, (XPRSprob, Cint), prob, objsense)
end

function XPRSchgglblimit(prob, ncols, _mindex, _dlimit)
    ccall((:XPRSchgglblimit, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncols, _mindex, _dlimit)
end

function XPRSsave(prob)
    ccall((:XPRSsave, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSsaveas(prob, _filename)
    ccall((:XPRSsaveas, libxprs), Cint, (XPRSprob, Cstring), prob, _filename)
end

function XPRSrestore(prob, _sprobname, _force)
    ccall((:XPRSrestore, libxprs), Cint, (XPRSprob, Cstring, Cstring), prob, _sprobname, _force)
end

function XPRSpivot(prob, _in, _out)
    ccall((:XPRSpivot, libxprs), Cint, (XPRSprob, Cint, Cint), prob, _in, _out)
end

function XPRSgetpivots(prob, _in, _mout, _dout, _dobjo, npiv, maxpiv)
    ccall((:XPRSgetpivots, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Cint), prob, _in, _mout, _dout, _dobjo, npiv, maxpiv)
end

function XPRSaddcuts(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    ccall((:XPRSaddcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

function XPRSaddcuts64(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    ccall((:XPRSaddcuts64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

function XPRSdelcuts(prob, ibasis, itype, interp, delta, ncuts, mcutind)
    ccall((:XPRSdelcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble, Cint, Ptr{XPRScut}), prob, ibasis, itype, interp, delta, ncuts, mcutind)
end

function XPRSdelcpcuts(prob, itype, interp, ncuts, mcutind)
    ccall((:XPRSdelcpcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{XPRScut}), prob, itype, interp, ncuts, mcutind)
end

function XPRSgetcutlist(prob, itype, interp, ncuts, maxcuts, mcutind)
    ccall((:XPRSgetcutlist, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Cint, Ptr{XPRScut}), prob, itype, interp, ncuts, maxcuts, mcutind)
end

function XPRSgetcpcutlist(prob, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
    ccall((:XPRSgetcpcutlist, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble, Ptr{Cint}, Cint, Ptr{XPRScut}, Ptr{Cdouble}), prob, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
end

function XPRSgetcpcuts(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    ccall((:XPRSgetcpcuts, libxprs), Cint, (XPRSprob, Ptr{XPRScut}, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

function XPRSgetcpcuts64(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    ccall((:XPRSgetcpcuts64, libxprs), Cint, (XPRSprob, Ptr{XPRScut}, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

function XPRSloadcuts(prob, itype, interp, ncuts, mcutind)
    ccall((:XPRSloadcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{XPRScut}), prob, itype, interp, ncuts, mcutind)
end

function XPRSstorecuts(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    ccall((:XPRSstorecuts, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

function XPRSstorecuts64(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    ccall((:XPRSstorecuts64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

function XPRSpresolverow(prob, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
    ccall((:XPRSpresolverow, libxprs), Cint, (XPRSprob, UInt8, Cint, Ptr{Cint}, Ptr{Cdouble}, Cdouble, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
end

function XPRSloadlpsol(prob, _dx, _dslack, _dual, _dj, status)
    ccall((:XPRSloadlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, _dx, _dslack, _dual, _dj, status)
end

function XPRSloadmipsol(prob, dsol, status)
    ccall((:XPRSloadmipsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, dsol, status)
end

function XPRSaddmipsol(prob, ilength, mipsolval, mipsolcol, solname)
    ccall((:XPRSaddmipsol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}, Ptr{Cint}, Cstring), prob, ilength, mipsolval, mipsolcol, solname)
end

function XPRSstorebounds(prob, nbnds, mcols, qbtype, dbnd, mindex)
    ccall((:XPRSstorebounds, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Ptr{Cvoid}}), prob, nbnds, mcols, qbtype, dbnd, mindex)
end

function XPRSsetbranchcuts(prob, nbcuts, mindex)
    ccall((:XPRSsetbranchcuts, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRScut}), prob, nbcuts, mindex)
end

function XPRSsetbranchbounds(prob, mindex)
    ccall((:XPRSsetbranchbounds, libxprs), Cint, (XPRSprob, Ptr{Cvoid}), prob, mindex)
end

function XPRSgetlasterror(prob, errmsg)
    ccall((:XPRSgetlasterror, libxprs), Cint, (XPRSprob, Cstring), prob, errmsg)
end

function XPRSbasiscondition(prob, condnum, scondnum)
    ccall((:XPRSbasiscondition, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, condnum, scondnum)
end

function XPRSgetmipsol(prob, _dx, _dslack)
    ccall((:XPRSgetmipsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, _dx, _dslack)
end

function XPRSgetmipsolval(prob, col, row, _dx, _dslack)
    ccall((:XPRSgetmipsolval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}), prob, col, row, _dx, _dslack)
end

function XPRSgetlpsol(prob, _dx, _dslack, _dual, _dj)
    ccall((:XPRSgetlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, _dx, _dslack, _dual, _dj)
end

function XPRSgetlpsolval(prob, col, row, _dx, _dslack, _dual, _dj)
    ccall((:XPRSgetlpsolval, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, col, row, _dx, _dslack, _dual, _dj)
end

function XPRSpostsolve(prob)
    ccall((:XPRSpostsolve, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSdelsets(prob, nsets, msindex)
    ccall((:XPRSdelsets, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nsets, msindex)
end

function XPRSaddsets(prob, newsets, newnz, qstype, msstart, mscols, dref)
    ccall((:XPRSaddsets, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, newsets, newnz, qstype, msstart, mscols, dref)
end

function XPRSaddsets64(prob, newsets, newnz, qstype, msstart, mscols, dref)
    ccall((:XPRSaddsets64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, newsets, newnz, qstype, msstart, mscols, dref)
end

function XPRSstrongbranch(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
    ccall((:XPRSstrongbranch, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cint}), prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
end

function XPRSestimaterowdualranges(prob, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
    ccall((:XPRSestimaterowdualranges, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Cint, Ptr{Cdouble}, Ptr{Cdouble}), prob, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
end

function XPRSgetprimalray(prob, _dpray, _hasray)
    ccall((:XPRSgetprimalray, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, _dpray, _hasray)
end

function XPRSgetdualray(prob, _ddray, _hasray)
    ccall((:XPRSgetdualray, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cint}), prob, _ddray, _hasray)
end

function XPRSsetmessagestatus(prob, errcode, bEnabledStatus)
    ccall((:XPRSsetmessagestatus, libxprs), Cint, (XPRSprob, Cint, Cint), prob, errcode, bEnabledStatus)
end

function XPRSgetmessagestatus(prob, errcode, bEnabledStatus)
    ccall((:XPRSgetmessagestatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, errcode, bEnabledStatus)
end

function XPRSrepairweightedinfeas(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
    ccall((:XPRSrepairweightedinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Cstring), prob, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
end

function XPRSrepairweightedinfeasbounds(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
    ccall((:XPRSrepairweightedinfeasbounds, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Cstring), prob, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
end

function XPRSrepairinfeas(prob, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
    ccall((:XPRSrepairinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, UInt8, UInt8, UInt8, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble), prob, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
end

function XPRSgetcutslack(prob, cut, dslack)
    ccall((:XPRSgetcutslack, libxprs), Cint, (XPRSprob, XPRScut, Ptr{Cdouble}), prob, cut, dslack)
end

function XPRSgetcutmap(prob, ncuts, cuts, cutmap)
    ccall((:XPRSgetcutmap, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRScut}, Ptr{Cint}), prob, ncuts, cuts, cutmap)
end

function XPRSbasisstability(prob, typecode, norm, ifscaled, dval)
    ccall((:XPRSbasisstability, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cdouble}), prob, typecode, norm, ifscaled, dval)
end

function XPRScalcslacks(prob, solution, calculatedslacks)
    ccall((:XPRScalcslacks, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, calculatedslacks)
end

function XPRScalcreducedcosts(prob, duals, solution, calculateddjs)
    ccall((:XPRScalcreducedcosts, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, duals, solution, calculateddjs)
end

function XPRScalcobjective(prob, solution, objective)
    ccall((:XPRScalcobjective, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, objective)
end

function XPRSrefinemipsol(prob, options, _sflags, solution, refined_solution, refinestatus)
    ccall((:XPRSrefinemipsol, libxprs), Cint, (XPRSprob, Cint, Cstring, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, options, _sflags, solution, refined_solution, refinestatus)
end

function XPRScalcsolinfo(prob, solution, dual, Property, Value)
    ccall((:XPRScalcsolinfo, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cdouble}), prob, solution, dual, Property, Value)
end

function XPRSgetnamelist(prob, _itype, _sbuff, names_len, names_len_reqd, first, last)
    ccall((:XPRSgetnamelist, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{Cint}, Cint, Cint), prob, _itype, _sbuff, names_len, names_len_reqd, first, last)
end

function XPRSgetnamelistobject(prob, _itype, r_nl)
    ccall((:XPRSgetnamelistobject, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRSnamelist}), prob, _itype, r_nl)
end

function XPRSlogfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
    ccall((:XPRSlogfilehandler, libxprs), Cint, (XPRSobject, Ptr{Cvoid}, Ptr{Cvoid}, Cstring, Cint, Cint), obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
end

function XPRSgetobjecttypename(obj, sObjectName)
    ccall((:XPRSgetobjecttypename, libxprs), Cint, (XPRSobject, Ptr{Cstring}), obj, sObjectName)
end

function XPRSstrongbranchcb(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
    ccall((:XPRSstrongbranchcb, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cvoid}, Ptr{Cvoid}), prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
end

function XPRSgetlastbarsol(prob, _dx, _dslack, _dual, _dj, lpstatus)
    ccall((:XPRSgetlastbarsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, _dx, _dslack, _dual, _dj, lpstatus)
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

function XPRSsetcbgloballog(prob, f_globallog, p)
    ccall((:XPRSsetcbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_globallog, p)
end

function XPRSgetcbgloballog(prob, f_globallog, p)
    ccall((:XPRSgetcbgloballog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, f_globallog, p)
end

function XPRSaddcbgloballog(prob, f_globallog, p, priority)
    ccall((:XPRSaddcbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, f_globallog, p, priority)
end

function XPRSremovecbgloballog(prob, f_globallog, p)
    ccall((:XPRSremovecbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, f_globallog, p)
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

function XPRSobjsa(prob, ncols, mindex, lower, upper)
    ccall((:XPRSobjsa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, mindex, lower, upper)
end

function XPRSrhssa(prob, nrows, mindex, lower, upper)
    ccall((:XPRSrhssa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, nrows, mindex, lower, upper)
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

function XPRS_ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_ge_getlasterror, libxprs), Cint, (Ptr{Cint}, Cstring, Cint, Ptr{Cint}), iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_ge_setarchconsistency(ifArchConsistent)
    ccall((:XPRS_ge_setarchconsistency, libxprs), Cint, (Cint,), ifArchConsistent)
end

function XPRS_ge_setsafemode(ifSafeMode)
    ccall((:XPRS_ge_setsafemode, libxprs), Cint, (Cint,), ifSafeMode)
end

function XPRS_ge_getsafemode(ifSafeMode)
    ccall((:XPRS_ge_getsafemode, libxprs), Cint, (Ptr{Cint},), ifSafeMode)
end

function XPRS_ge_setdebugmode(ifDebugMode)
    ccall((:XPRS_ge_setdebugmode, libxprs), Cint, (Cint,), ifDebugMode)
end

function XPRS_ge_getdebugmode(ifDebugMode)
    ccall((:XPRS_ge_getdebugmode, libxprs), Cint, (Ptr{Cint},), ifDebugMode)
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

function XPRS_nml_create(r_nl)
    ccall((:XPRS_nml_create, libxprs), Cint, (Ptr{XPRSnamelist},), r_nl)
end

function XPRS_nml_destroy(nml)
    ccall((:XPRS_nml_destroy, libxprs), Cint, (XPRSnamelist,), nml)
end

function XPRS_nml_getnamecount(nml, count)
    ccall((:XPRS_nml_getnamecount, libxprs), Cint, (XPRSnamelist, Ptr{Cint}), nml, count)
end

function XPRS_nml_getmaxnamelen(nml, namlen)
    ccall((:XPRS_nml_getmaxnamelen, libxprs), Cint, (XPRSnamelist, Ptr{Cint}), nml, namlen)
end

function XPRS_nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
    ccall((:XPRS_nml_getnames, libxprs), Cint, (XPRSnamelist, Cint, Ptr{UInt8}, Cint, Ptr{Cint}, Cint, Cint), nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
end

function XPRS_nml_addnames(nml, buf, firstIndex, lastIndex)
    ccall((:XPRS_nml_addnames, libxprs), Cint, (XPRSnamelist, Ptr{UInt8}, Cint, Cint), nml, buf, firstIndex, lastIndex)
end

function XPRS_nml_removenames(nml, firstIndex, lastIndex)
    ccall((:XPRS_nml_removenames, libxprs), Cint, (XPRSnamelist, Cint, Cint), nml, firstIndex, lastIndex)
end

function XPRS_nml_findname(nml, name, r_index)
    ccall((:XPRS_nml_findname, libxprs), Cint, (XPRSnamelist, Cstring, Ptr{Cint}), nml, name, r_index)
end

function XPRS_nml_copynames(dst, src)
    ccall((:XPRS_nml_copynames, libxprs), Cint, (XPRSnamelist, XPRSnamelist), dst, src)
end

function XPRS_nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_nml_getlasterror, libxprs), Cint, (XPRSnamelist, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRSgetqrowcoeff(prob, irow, icol, jcol, dval)
    ccall((:XPRSgetqrowcoeff, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cdouble}), prob, irow, icol, jcol, dval)
end

function XPRSgetqrowqmatrix(prob, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
    ccall((:XPRSgetqrowqmatrix, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
end

function XPRSgetqrowqmatrixtriplets(prob, irow, nqelem, mqcol1, mqcol2, dqe)
    ccall((:XPRSgetqrowqmatrixtriplets, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, irow, nqelem, mqcol1, mqcol2, dqe)
end

function XPRSchgqrowcoeff(prob, irow, icol, jcol, dval)
    ccall((:XPRSchgqrowcoeff, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble), prob, irow, icol, jcol, dval)
end

function XPRSgetqrows(prob, qmn, qcrows)
    ccall((:XPRSgetqrows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, qmn, qcrows)
end

function XPRSaddqmatrix(prob, irow, nqtr, mqc1, mqc2, dqew)
    ccall((:XPRSaddqmatrix, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, irow, nqtr, mqc1, mqc2, dqew)
end

function XPRSaddqmatrix64(prob, irow, nqtr, mqc1, mqc2, dqew)
    ccall((:XPRSaddqmatrix64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, irow, nqtr, mqc1, mqc2, dqew)
end

function XPRSdelqmatrix(prob, irow)
    ccall((:XPRSdelqmatrix, libxprs), Cint, (XPRSprob, Cint), prob, irow)
end

function XPRSloadqcqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    ccall((:XPRSloadqcqp, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function XPRSloadqcqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    ccall((:XPRSloadqcqp64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function XPRSloadqcqpglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    ccall((:XPRSloadqcqpglobal, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function XPRSloadqcqpglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    ccall((:XPRSloadqcqpglobal64, libxprs), Cint, (XPRSprob, Cstring, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function XPRS_mse_create(mse)
    ccall((:XPRS_mse_create, libxprs), Cint, (Ptr{XPRSmipsolenum},), mse)
end

function XPRS_mse_destroy(mse)
    ccall((:XPRS_mse_destroy, libxprs), Cint, (XPRSmipsolenum,), mse)
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

function XPRS_mse_minim(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_minim, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function XPRS_mse_maxim(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_maxim, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function XPRS_mse_opt(mse, prob, msp, f_mse_handler, p, nMaxSols)
    ccall((:XPRS_mse_opt, libxprs), Cint, (XPRSmipsolenum, XPRSprob, XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}), mse, prob, msp, f_mse_handler, p, nMaxSols)
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

function XPRS_bo_create(p_object, prob, isoriginal)
    ccall((:XPRS_bo_create, libxprs), Cint, (Ptr{XPRSbranchobject}, XPRSprob, Cint), p_object, prob, isoriginal)
end

function XPRS_bo_destroy(obranch)
    ccall((:XPRS_bo_destroy, libxprs), Cint, (XPRSbranchobject,), obranch)
end

function XPRS_bo_store(obranch, p_status)
    ccall((:XPRS_bo_store, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), obranch, p_status)
end

function XPRS_bo_addbranches(obranch, nbranches)
    ccall((:XPRS_bo_addbranches, libxprs), Cint, (XPRSbranchobject, Cint), obranch, nbranches)
end

function XPRS_bo_getbranches(obranch, p_nbranches)
    ccall((:XPRS_bo_getbranches, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), obranch, p_nbranches)
end

function XPRS_bo_setpriority(obranch, ipriority)
    ccall((:XPRS_bo_setpriority, libxprs), Cint, (XPRSbranchobject, Cint), obranch, ipriority)
end

function XPRS_bo_setpreferredbranch(obranch, ibranch)
    ccall((:XPRS_bo_setpreferredbranch, libxprs), Cint, (XPRSbranchobject, Cint), obranch, ibranch)
end

function XPRS_bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
    ccall((:XPRS_bo_addbounds, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}), obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
end

function XPRS_bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
    ccall((:XPRS_bo_getbounds, libxprs), Cint, (XPRSbranchobject, Cint, Ptr{Cint}, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}), obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
end

function XPRS_bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
    ccall((:XPRS_bo_addrows, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
end

function XPRS_bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
    ccall((:XPRS_bo_getrows, libxprs), Cint, (XPRSbranchobject, Cint, Ptr{Cint}, Cint, Ptr{Cint}, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
end

function XPRS_bo_addcuts(obranch, ibranch, ncuts, mcutind)
    ccall((:XPRS_bo_addcuts, libxprs), Cint, (XPRSbranchobject, Cint, Cint, Ptr{XPRScut}), obranch, ibranch, ncuts, mcutind)
end

function XPRS_bo_getid(obranch, p_id)
    ccall((:XPRS_bo_getid, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), obranch, p_id)
end

function XPRS_bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_bo_getlasterror, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}, Cstring, Cint, Ptr{Cint}), obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_bo_validate(obranch, p_status)
    ccall((:XPRS_bo_validate, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), obranch, p_status)
end

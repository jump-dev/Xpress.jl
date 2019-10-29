function copycallbacks(dest, src)
    Lib.XPRScopycallbacks(dest, src)
end

function copycontrols(dest, src)
    Lib.XPRScopycontrols(dest, src)
end

function copyprob(dest, src, probname)
    Lib.XPRScopyprob(dest, src, probname)
end

function createprob(_probholder)
    Lib.XPRScreateprob(_probholder)
end

function destroyprob(prob::XpressProblem)
    Lib.XPRSdestroyprob(prob)
end

function init()
    r = Lib.XPRSinit(C_NULL)
    r != 0 && throw(XpressError("Unable to initialize Xpress. Received error code: $r."))
end

function free()
    Lib.XPRSfree()
end

function getbanner()
    banner = @invoke Lib.XPRSgetbanner(_)::String
    return banner
end

function getversion()
    version = @invoke Lib.XPRSgetversion(_)::String
    return VersionNumber(parse.(Int, split(version, "."))...)
end

function getdaysleft()
    daysleft = @invoke Lib.XPRSgetdaysleft(_)::Int
end

function setcheckedmode(checked_mode)
    Lib.XPRSsetcheckedmode(checked_mode)
end

function getcheckedmode(r_checked_mode)
    Lib.XPRSgetcheckedmode(r_checked_mode)
end

function license(lic, path)
    Lib.XPRSlicense(lic, path)
end

function beginlicensing(r_dontAlreadyHaveLicense)
    Lib.XPRSbeginlicensing(r_dontAlreadyHaveLicense)
end

function endlicensing()
    Lib.XPRSendlicensing()
end

function getlicerrmsg()
    msg = Cstring(pointer(Array{Cchar}(undef, 1024*8)))
    len = length(msg)
    Lib.XPRSgetlicerrmsg(msg, len)
    return unsafe_string(msg)
end

function setlogfile(prob::XpressProblem, logname)
    Lib.XPRSsetlogfile(prob, logname)
end

function setintcontrol(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSsetintcontrol(prob, _index, _ivalue)
end

function setintcontrol64(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSsetintcontrol64(prob, _index, _ivalue)
end

function setdblcontrol(prob::XpressProblem, _index, _dvalue)
    Lib.XPRSsetdblcontrol(prob, _index, _dvalue)
end

function interrupt(prob::XpressProblem, reason)
    Lib.XPRSinterrupt(prob, reason)
end

function getprobname(prob::XpressProblem)
    @invoke Lib.XPRSgetprobname(prob, _)::String
end

function getqobj(prob::XpressProblem, _icol, _jcol, _dval)
    Lib.XPRSgetqobj(prob, _icol, _jcol, _dval)
end

function setprobname(prob::XpressProblem, name::AbstractString)
    r = Lib.XPRSsetprobname(prob, name)
    r != 0 ? error("Unable to call setprobname.") : nothing
end

function setstrcontrol(prob::XpressProblem, _index, _svalue)
    Lib.XPRSsetstrcontrol(prob, _index, _svalue)
end

function getintcontrol(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSgetintcontrol(prob, _index, _ivalue)
end

function getintcontrol64(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSgetintcontrol64(prob, _index, _ivalue)
end

function getdblcontrol(prob::XpressProblem, _index, _dvalue)
    Lib.XPRSgetdblcontrol(prob, _index, _dvalue)
end

function getstrcontrol(prob::XpressProblem, _index, _svalue)
    Lib.XPRSgetstrcontrol(prob, _index, _svalue)
end

function getstringcontrol(prob::XpressProblem, _index, _svalue, _svaluesize, _controlsize)
    Lib.XPRSgetstringcontrol(prob, _index, _svalue, _svaluesize, _controlsize)
end

function getintattrib(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSgetintattrib(prob, _index, _ivalue)
end

function getintattrib64(prob::XpressProblem, _index, _ivalue)
    Lib.XPRSgetintattrib64(prob, _index, _ivalue)
end

function getstrattrib(prob::XpressProblem, _index, _cvalue)
    Lib.XPRSgetstrattrib(prob, _index, _cvalue)
end

function getstringattrib(prob::XpressProblem, _index, _cvalue, _cvaluesize, _controlsize)
    Lib.XPRSgetstringattrib(prob, _index, _cvalue, _cvaluesize, _controlsize)
end

function getdblattrib(prob::XpressProblem, _index, _dvalue)
    Lib.XPRSgetdblattrib(prob, _index, _dvalue)
end

function setdefaultcontrol(prob::XpressProblem, _index)
    Lib.XPRSsetdefaultcontrol(prob, _index)
end

function setdefaults(prob::XpressProblem)
    Lib.XPRSsetdefaults(prob)
end

function getcontrolinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    Lib.XPRSgetcontrolinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

function getattribinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    Lib.XPRSgetattribinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

function goal(prob::XpressProblem, _filename, _sflags)
    Lib.XPRSgoal(prob, _filename, _sflags)
end

function readprob(prob::XpressProblem, _sprobname, _sflags)
    Lib.XPRSreadprob(prob, _sprobname, _sflags)
end

function loadlp(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    Lib.XPRSloadlp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function loadlp64(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    Lib.XPRSloadlp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function loadqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    Lib.XPRSloadqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function loadqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    Lib.XPRSloadqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function loadqglobal(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    Lib.XPRSloadqglobal(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqglobal64(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    Lib.XPRSloadqglobal64(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function fixglobals(prob::XpressProblem, ifround)
    Lib.XPRSfixglobals(prob, ifround)
end

function loadmodelcuts(prob::XpressProblem, nmodcuts, _mrows)
    Lib.XPRSloadmodelcuts(prob, nmodcuts, _mrows)
end

function loaddelayedrows(prob::XpressProblem, nrows, _mrows)
    Lib.XPRSloaddelayedrows(prob, nrows, _mrows)
end

function loaddirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    Lib.XPRSloaddirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function loadbranchdirs(prob::XpressProblem, ndirs, _mcols, _mbranch)
    Lib.XPRSloadbranchdirs(prob, ndirs, _mcols, _mbranch)
end

function loadpresolvedirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    Lib.XPRSloadpresolvedirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function getdirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    Lib.XPRSgetdirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function loadglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    Lib.XPRSloadglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function loadglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    Lib.XPRSloadglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function addnames(prob::XpressProblem, _itype, _sname, first, last)
    Lib.XPRSaddnames(prob, _itype, _sname, first, last)
end

function addsetnames(prob::XpressProblem, _sname, first, last)
    Lib.XPRSaddsetnames(prob, _sname, first, last)
end

function scale(prob::XpressProblem, mrscal, mcscal)
    Lib.XPRSscale(prob, mrscal, mcscal)
end

function readdirs(prob::XpressProblem, _sfilename)
    Lib.XPRSreaddirs(prob, _sfilename)
end

function writedirs(prob::XpressProblem, _sfilename)
    Lib.XPRSwritedirs(prob, _sfilename)
end

function setindicators(prob::XpressProblem, nrows, _mrows, _inds, _comps)
    Lib.XPRSsetindicators(prob, nrows, _mrows, _inds, _comps)
end

function getindicators(prob::XpressProblem, _inds, _comps, first, last)
    Lib.XPRSgetindicators(prob, _inds, _comps, first, last)
end

function delindicators(prob::XpressProblem, first, last)
    Lib.XPRSdelindicators(prob, first, last)
end

function dumpcontrols(prob::XpressProblem)
    Lib.XPRSdumpcontrols(prob)
end

function minim(prob::XpressProblem, _sflags)
    Lib.XPRSminim(prob, _sflags)
end

function maxim(prob::XpressProblem, _sflags)
    Lib.XPRSmaxim(prob, _sflags)
end

function lpoptimize(prob::XpressProblem, _sflags)
    Lib.XPRSlpoptimize(prob, _sflags)
end

function mipoptimize(prob::XpressProblem, _sflags)
    Lib.XPRSmipoptimize(prob, _sflags)
end

function range(prob::XpressProblem)
    Lib.XPRSrange(prob)
end

function getrowrange(prob::XpressProblem, _upact, _loact, _uup, _udn)
    Lib.XPRSgetrowrange(prob, _upact, _loact, _uup, _udn)
end

function getcolrange(prob::XpressProblem, _upact, _loact, _uup, _udn, _ucost, _lcost)
    Lib.XPRSgetcolrange(prob, _upact, _loact, _uup, _udn, _ucost, _lcost)
end

function getpivotorder(prob::XpressProblem, mpiv)
    Lib.XPRSgetpivotorder(prob, mpiv)
end

function getpresolvemap(prob::XpressProblem, rowmap, colmap)
    Lib.XPRSgetpresolvemap(prob, rowmap, colmap)
end

function readbasis(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSreadbasis(prob, _sfilename, _sflags)
end

function writebasis(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwritebasis(prob, _sfilename, _sflags)
end

function XPRSglobal(prob::XpressProblem)
    Lib.XPRSglobal(prob)
end

function initglobal(prob::XpressProblem)
    Lib.XPRSinitglobal(prob)
end

function writeprtsol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwriteprtsol(prob, _sfilename, _sflags)
end

function alter(prob::XpressProblem, _sfilename)
    Lib.XPRSalter(prob, _sfilename)
end

function writesol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwritesol(prob, _sfilename, _sflags)
end

function writebinsol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwritebinsol(prob, _sfilename, _sflags)
end

function readbinsol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSreadbinsol(prob, _sfilename, _sflags)
end

function writeslxsol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwriteslxsol(prob, _sfilename, _sflags)
end

function readslxsol(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSreadslxsol(prob, _sfilename, _sflags)
end

function writeprtrange(prob::XpressProblem)
    Lib.XPRSwriteprtrange(prob)
end

function writerange(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwriterange(prob, _sfilename, _sflags)
end

function getsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    Lib.XPRSgetsol(prob, _dx, _dslack, _dual, _dj)
end

function getpresolvesol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    Lib.XPRSgetpresolvesol(prob, _dx, _dslack, _dual, _dj)
end

function getinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    Lib.XPRSgetinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function getscaledinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    Lib.XPRSgetscaledinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function getunbvec(prob::XpressProblem, icol)
    Lib.XPRSgetunbvec(prob, icol)
end

function btran(prob::XpressProblem, dwork)
    Lib.XPRSbtran(prob, dwork)
end

function ftran(prob::XpressProblem, dwork)
    Lib.XPRSftran(prob, dwork)
end

function getobj(prob::XpressProblem, _dobj, first, last)
    Lib.XPRSgetobj(prob, _dobj, first, last)
end

function getrhs(prob::XpressProblem, _drhs, first, last)
    Lib.XPRSgetrhs(prob, _drhs, first, last)
end

function getrhsrange(prob::XpressProblem, _drng, first, last)
    Lib.XPRSgetrhsrange(prob, _drng, first, last)
end

function getlb(prob::XpressProblem, _dbdl, first, last)
    Lib.XPRSgetlb(prob, _dbdl, first, last)
end

function getub(prob::XpressProblem, _dbdu, first, last)
    Lib.XPRSgetub(prob, _dbdu, first, last)
end

function getcols(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetcols(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function getcols64(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetcols64(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function getrows(prob::XpressProblem, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetrows(prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function getrows64(prob::XpressProblem, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetrows64(prob, _mstart, _mclind, _dmatval, maxcoeffs, ncoeffs, first, last)
end

function getcoef(prob::XpressProblem, _irow, _icol, _dval)
    Lib.XPRSgetcoef(prob, _irow, _icol, _dval)
end

function getmqobj(prob::XpressProblem, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetmqobj(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

function getmqobj64(prob::XpressProblem, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetmqobj64(prob, _mstart, _mclind, _dobjval, maxcoeffs, ncoeffs, first, last)
end

function crossoverlpsol(prob::XpressProblem, status)
    Lib.XPRScrossoverlpsol(prob, status)
end

function getbarnumstability(prob::XpressProblem, dColumnStability, dRowStability)
    Lib.XPRSgetbarnumstability(prob, dColumnStability, dRowStability)
end

function iisclear(prob::XpressProblem)
    Lib.XPRSiisclear(prob)
end

function iisfirst(prob::XpressProblem, iismode, status_code)
    Lib.XPRSiisfirst(prob, iismode, status_code)
end

function iisnext(prob::XpressProblem, status_code)
    Lib.XPRSiisnext(prob, status_code)
end

function iisstatus(prob::XpressProblem, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
    Lib.XPRSiisstatus(prob, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
end

function iisall(prob::XpressProblem)
    Lib.XPRSiisall(prob)
end

function iiswrite(prob::XpressProblem, number, fn, filetype, typeflags)
    Lib.XPRSiiswrite(prob, number, fn, filetype, typeflags)
end

function iisisolations(prob::XpressProblem, number)
    Lib.XPRSiisisolations(prob, number)
end

function getiisdata(prob::XpressProblem, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
    Lib.XPRSgetiisdata(prob, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
end

function getiis(prob::XpressProblem, ncols, nrows, _miiscol, _miisrow)
    Lib.XPRSgetiis(prob, ncols, nrows, _miiscol, _miisrow)
end

function getpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    Lib.XPRSgetpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

function loadpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    Lib.XPRSloadpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

function getglobal(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    Lib.XPRSgetglobal(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function getglobal64(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    Lib.XPRSgetglobal64(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function writeprob(prob::XpressProblem, _sfilename, _sflags)
    Lib.XPRSwriteprob(prob, _sfilename, _sflags)
end

function getnames(prob::XpressProblem, _itype, _sbuff, first, last)
    Lib.XPRSgetnames(prob, _itype, _sbuff, first, last)
end

function getrowtype(prob::XpressProblem, _srowtype, first, last)
    Lib.XPRSgetrowtype(prob, _srowtype, first, last)
end

function loadsecurevecs(prob::XpressProblem, nrows, ncols, mrow, mcol)
    Lib.XPRSloadsecurevecs(prob, nrows, ncols, mrow, mcol)
end

function getcoltype(prob::XpressProblem, _coltype, first, last)
    Lib.XPRSgetcoltype(prob, _coltype, first, last)
end

function getbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    Lib.XPRSgetbasis(prob, _mrowstatus, _mcolstatus)
end

function loadbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    Lib.XPRSloadbasis(prob, _mrowstatus, _mcolstatus)
end

function getindex(prob::XpressProblem, _itype, _sname, _iseq)
    Lib.XPRSgetindex(prob, _itype, _sname, _iseq)
end

function addrows(prob::XpressProblem, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
    Lib.XPRSaddrows(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
end

function addrows64(prob::XpressProblem, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
    Lib.XPRSaddrows64(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mclind, _dmatval)
end

function delrows(prob::XpressProblem, nrows, _mindex)
    Lib.XPRSdelrows(prob, nrows, _mindex)
end

function addcols(prob::XpressProblem, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
    Lib.XPRSaddcols(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

function addcols64(prob::XpressProblem, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
    Lib.XPRSaddcols64(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end

function delcols(prob::XpressProblem, ncols, _mindex)
    Lib.XPRSdelcols(prob, ncols, _mindex)
end

function chgcoltype(prob::XpressProblem, ncols, _mindex, _coltype)
    Lib.XPRSchgcoltype(prob, ncols, _mindex, _coltype)
end

function chgrowtype(prob::XpressProblem, nrows, _mindex, _srowtype)
    Lib.XPRSchgrowtype(prob, nrows, _mindex, _srowtype)
end

function chgbounds(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd)
    Lib.XPRSchgbounds(prob, nbnds, _mindex, _sboundtype, _dbnd)
end

function chgobj(prob::XpressProblem, ncols, _mindex, _dobj)
    Lib.XPRSchgobj(prob, ncols, _mindex, _dobj)
end

function chgcoef(prob::XpressProblem, _irow, _icol, _dval)
    Lib.XPRSchgcoef(prob, _irow, _icol, _dval)
end

function chgmcoef(prob::XpressProblem, ncoeffs, _mrow, _mcol, _dval)
    Lib.XPRSchgmcoef(prob, ncoeffs, _mrow, _mcol, _dval)
end

function chgmcoef64(prob::XpressProblem, ncoeffs, _mrow, _mcol, _dval)
    Lib.XPRSchgmcoef64(prob, ncoeffs, _mrow, _mcol, _dval)
end

function chgmqobj(prob::XpressProblem, ncols, _mcol1, _mcol2, _dval)
    Lib.XPRSchgmqobj(prob, ncols, _mcol1, _mcol2, _dval)
end

function chgmqobj64(prob::XpressProblem, ncols, _mcol1, _mcol2, _dval)
    Lib.XPRSchgmqobj64(prob, ncols, _mcol1, _mcol2, _dval)
end

function chgqobj(prob::XpressProblem, _icol, _jcol, _dval)
    Lib.XPRSchgqobj(prob, _icol, _jcol, _dval)
end

function chgrhs(prob::XpressProblem, nrows, _mindex, _drhs)
    Lib.XPRSchgrhs(prob, nrows, _mindex, _drhs)
end

function chgrhsrange(prob::XpressProblem, nrows, _mindex, _drng)
    Lib.XPRSchgrhsrange(prob, nrows, _mindex, _drng)
end

function chgobjsense(prob::XpressProblem, objsense)
    Lib.XPRSchgobjsense(prob, objsense)
end

function chgglblimit(prob::XpressProblem, ncols, _mindex, _dlimit)
    Lib.XPRSchgglblimit(prob, ncols, _mindex, _dlimit)
end

function save(prob::XpressProblem)
    Lib.XPRSsave(prob)
end

function restore(prob::XpressProblem, _sprobname, _force)
    Lib.XPRSrestore(prob, _sprobname, _force)
end

function pivot(prob::XpressProblem, _in, _out)
    Lib.XPRSpivot(prob, _in, _out)
end

function getpivots(prob::XpressProblem, _in, _mout, _dout, _dobjo, npiv, maxpiv)
    Lib.XPRSgetpivots(prob, _in, _mout, _dout, _dobjo, npiv, maxpiv)
end

function addcuts(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    Lib.XPRSaddcuts(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

function addcuts64(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
    Lib.XPRSaddcuts64(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end

function delcuts(prob::XpressProblem, ibasis, itype, interp, delta, ncuts, mcutind)
    Lib.XPRSdelcuts(prob, ibasis, itype, interp, delta, ncuts, mcutind)
end

function delcpcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    Lib.XPRSdelcpcuts(prob, itype, interp, ncuts, mcutind)
end

function getcutlist(prob::XpressProblem, itype, interp, ncuts, maxcuts, mcutind)
    Lib.XPRSgetcutlist(prob, itype, interp, ncuts, maxcuts, mcutind)
end

function getcpcutlist(prob::XpressProblem, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
    Lib.XPRSgetcpcutlist(prob, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
end

function getcpcuts(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    Lib.XPRSgetcpcuts(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

function getcpcuts64(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
    Lib.XPRSgetcpcuts64(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end

function loadcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    Lib.XPRSloadcuts(prob, itype, interp, ncuts, mcutind)
end

function storecuts(prob::XpressProblem, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    Lib.XPRSstorecuts(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

function storecuts64(prob::XpressProblem, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
    Lib.XPRSstorecuts64(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end

function presolverow(prob::XpressProblem, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
    Lib.XPRSpresolverow(prob, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
end

function loadlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj, status)
    Lib.XPRSloadlpsol(prob, _dx, _dslack, _dual, _dj, status)
end

function loadmipsol(prob::XpressProblem, dsol, status)
    Lib.XPRSloadmipsol(prob, dsol, status)
end

function addmipsol(prob::XpressProblem, ilength, mipsolval, mipsolcol, solname)
    Lib.XPRSaddmipsol(prob, ilength, mipsolval, mipsolcol, solname)
end

function storebounds(prob::XpressProblem, nbnds, mcols, qbtype, dbnd, mindex)
    Lib.XPRSstorebounds(prob, nbnds, mcols, qbtype, dbnd, mindex)
end

function setbranchcuts(prob::XpressProblem, nbcuts, mindex)
    Lib.XPRSsetbranchcuts(prob, nbcuts, mindex)
end

function setbranchbounds(prob::XpressProblem, mindex)
    Lib.XPRSsetbranchbounds(prob, mindex)
end

function getlasterror(prob::XpressProblem, errmsg)
    Lib.XPRSgetlasterror(prob, errmsg)
end

function basiscondition(prob::XpressProblem, condnum, scondnum)
    Lib.XPRSbasiscondition(prob, condnum, scondnum)
end

function getmipsol(prob::XpressProblem, _dx, _dslack)
    Lib.XPRSgetmipsol(prob, _dx, _dslack)
end

function getlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    Lib.XPRSgetlpsol(prob, _dx, _dslack, _dual, _dj)
end

function postsolve(prob::XpressProblem)
    Lib.XPRSpostsolve(prob)
end

function delsets(prob::XpressProblem, nsets, msindex)
    Lib.XPRSdelsets(prob, nsets, msindex)
end

function addsets(prob::XpressProblem, newsets, newnz, qstype, msstart, mscols, dref)
    Lib.XPRSaddsets(prob, newsets, newnz, qstype, msstart, mscols, dref)
end

function addsets64(prob::XpressProblem, newsets, newnz, qstype, msstart, mscols, dref)
    Lib.XPRSaddsets64(prob, newsets, newnz, qstype, msstart, mscols, dref)
end

function strongbranch(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
    Lib.XPRSstrongbranch(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
end

function estimaterowdualranges(prob::XpressProblem, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
    Lib.XPRSestimaterowdualranges(prob, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
end

function getprimalray(prob::XpressProblem, _dpray, _hasray)
    Lib.XPRSgetprimalray(prob, _dpray, _hasray)
end

function getdualray(prob::XpressProblem, _ddray, _hasray)
    Lib.XPRSgetdualray(prob, _ddray, _hasray)
end

function setmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    Lib.XPRSsetmessagestatus(prob, errcode, bEnabledStatus)
end

function getmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    Lib.XPRSgetmessagestatus(prob, errcode, bEnabledStatus)
end

function repairweightedinfeas(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
    Lib.XPRSrepairweightedinfeas(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
end

function repairweightedinfeasbounds(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
    Lib.XPRSrepairweightedinfeasbounds(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
end

function repairinfeas(prob::XpressProblem, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
    Lib.XPRSrepairinfeas(prob, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
end

function getcutslack(prob::XpressProblem, cut, dslack)
    Lib.XPRSgetcutslack(prob, cut, dslack)
end

function getcutmap(prob::XpressProblem, ncuts, cuts, cutmap)
    Lib.XPRSgetcutmap(prob, ncuts, cuts, cutmap)
end

function basisstability(prob::XpressProblem, typecode, norm, ifscaled, dval)
    Lib.XPRSbasisstability(prob, typecode, norm, ifscaled, dval)
end

function calcslacks(prob::XpressProblem, solution, calculatedslacks)
    Lib.XPRScalcslacks(prob, solution, calculatedslacks)
end

function calcreducedcosts(prob::XpressProblem, duals, solution, calculateddjs)
    Lib.XPRScalcreducedcosts(prob, duals, solution, calculateddjs)
end

function calcobjective(prob::XpressProblem, solution, objective)
    Lib.XPRScalcobjective(prob, solution, objective)
end

function refinemipsol(prob::XpressProblem, options, _sflags, solution, refined_solution, refinestatus)
    Lib.XPRSrefinemipsol(prob, options, _sflags, solution, refined_solution, refinestatus)
end

function calcsolinfo(prob::XpressProblem, solution, dual, Property, Value)
    Lib.XPRScalcsolinfo(prob, solution, dual, Property, Value)
end

function getnamelist(prob::XpressProblem, _itype, _sbuff, names_len, names_len_reqd, first, last)
    Lib.XPRSgetnamelist(prob, _itype, _sbuff, names_len, names_len_reqd, first, last)
end

function getnamelistobject(prob::XpressProblem, _itype, r_nl)
    Lib.XPRSgetnamelistobject(prob, _itype, r_nl)
end

function logfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
    Lib.XPRSlogfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
end

function getobjecttypename(obj, sObjectName)
    Lib.XPRSgetobjecttypename(obj, sObjectName)
end

function strongbranchcb(prob::XpressProblem, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
    Lib.XPRSstrongbranchcb(prob, nbnds, _mindex, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
end

function setcblplog(prob::XpressProblem, f_lplog, p)
    Lib.XPRSsetcblplog(prob, f_lplog, p)
end

function getcblplog(prob::XpressProblem, f_lplog, p)
    Lib.XPRSgetcblplog(prob, f_lplog, p)
end

function addcblplog(prob::XpressProblem, f_lplog, p, priority)
    Lib.XPRSaddcblplog(prob, f_lplog, p, priority)
end

function removecblplog(prob::XpressProblem, f_lplog, p)
    Lib.XPRSremovecblplog(prob, f_lplog, p)
end

function setcbgloballog(prob::XpressProblem, f_globallog, p)
    Lib.XPRSsetcbgloballog(prob, f_globallog, p)
end

function getcbgloballog(prob::XpressProblem, f_globallog, p)
    Lib.XPRSgetcbgloballog(prob, f_globallog, p)
end

function addcbgloballog(prob::XpressProblem, f_globallog, p, priority)
    Lib.XPRSaddcbgloballog(prob, f_globallog, p, priority)
end

function removecbgloballog(prob::XpressProblem, f_globallog, p)
    Lib.XPRSremovecbgloballog(prob, f_globallog, p)
end

function setcbcutlog(prob::XpressProblem, f_cutlog, p)
    Lib.XPRSsetcbcutlog(prob, f_cutlog, p)
end

function getcbcutlog(prob::XpressProblem, f_cutlog, p)
    Lib.XPRSgetcbcutlog(prob, f_cutlog, p)
end

function addcbcutlog(prob::XpressProblem, f_cutlog, p, priority)
    Lib.XPRSaddcbcutlog(prob, f_cutlog, p, priority)
end

function removecbcutlog(prob::XpressProblem, f_cutlog, p)
    Lib.XPRSremovecbcutlog(prob, f_cutlog, p)
end

function setcbbarlog(prob::XpressProblem, f_barlog, p)
    Lib.XPRSsetcbbarlog(prob, f_barlog, p)
end

function getcbbarlog(prob::XpressProblem, f_barlog, p)
    Lib.XPRSgetcbbarlog(prob, f_barlog, p)
end

function addcbbarlog(prob::XpressProblem, f_barlog, p, priority)
    Lib.XPRSaddcbbarlog(prob, f_barlog, p, priority)
end

function removecbbarlog(prob::XpressProblem, f_barlog, p)
    Lib.XPRSremovecbbarlog(prob, f_barlog, p)
end

function setcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    Lib.XPRSsetcbcutmgr(prob, f_cutmgr, p)
end

function getcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    Lib.XPRSgetcbcutmgr(prob, f_cutmgr, p)
end

function addcbcutmgr(prob::XpressProblem, f_cutmgr, p, priority)
    Lib.XPRSaddcbcutmgr(prob, f_cutmgr, p, priority)
end

function removecbcutmgr(prob::XpressProblem, f_cutmgr, p)
    Lib.XPRSremovecbcutmgr(prob, f_cutmgr, p)
end

function setcbchgnode(prob::XpressProblem, f_chgnode, p)
    Lib.XPRSsetcbchgnode(prob, f_chgnode, p)
end

function getcbchgnode(prob::XpressProblem, f_chgnode, p)
    Lib.XPRSgetcbchgnode(prob, f_chgnode, p)
end

function addcbchgnode(prob::XpressProblem, f_chgnode, p, priority)
    Lib.XPRSaddcbchgnode(prob, f_chgnode, p, priority)
end

function removecbchgnode(prob::XpressProblem, f_chgnode, p)
    Lib.XPRSremovecbchgnode(prob, f_chgnode, p)
end

function setcboptnode(prob::XpressProblem, f_optnode, p)
    Lib.XPRSsetcboptnode(prob, f_optnode, p)
end

function getcboptnode(prob::XpressProblem, f_optnode, p)
    Lib.XPRSgetcboptnode(prob, f_optnode, p)
end

function addcboptnode(prob::XpressProblem, f_optnode, p, priority)
    Lib.XPRSaddcboptnode(prob, f_optnode, p, priority)
end

function removecboptnode(prob::XpressProblem, f_optnode, p)
    Lib.XPRSremovecboptnode(prob, f_optnode, p)
end

function setcbprenode(prob::XpressProblem, f_prenode, p)
    Lib.XPRSsetcbprenode(prob, f_prenode, p)
end

function getcbprenode(prob::XpressProblem, f_prenode, p)
    Lib.XPRSgetcbprenode(prob, f_prenode, p)
end

function addcbprenode(prob::XpressProblem, f_prenode, p, priority)
    Lib.XPRSaddcbprenode(prob, f_prenode, p, priority)
end

function removecbprenode(prob::XpressProblem, f_prenode, p)
    Lib.XPRSremovecbprenode(prob, f_prenode, p)
end

function setcbinfnode(prob::XpressProblem, f_infnode, p)
    Lib.XPRSsetcbinfnode(prob, f_infnode, p)
end

function getcbinfnode(prob::XpressProblem, f_infnode, p)
    Lib.XPRSgetcbinfnode(prob, f_infnode, p)
end

function addcbinfnode(prob::XpressProblem, f_infnode, p, priority)
    Lib.XPRSaddcbinfnode(prob, f_infnode, p, priority)
end

function removecbinfnode(prob::XpressProblem, f_infnode, p)
    Lib.XPRSremovecbinfnode(prob, f_infnode, p)
end

function setcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    Lib.XPRSsetcbnodecutoff(prob, f_nodecutoff, p)
end

function getcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    Lib.XPRSgetcbnodecutoff(prob, f_nodecutoff, p)
end

function addcbnodecutoff(prob::XpressProblem, f_nodecutoff, p, priority)
    Lib.XPRSaddcbnodecutoff(prob, f_nodecutoff, p, priority)
end

function removecbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    Lib.XPRSremovecbnodecutoff(prob, f_nodecutoff, p)
end

function setcbintsol(prob::XpressProblem, f_intsol, p)
    Lib.XPRSsetcbintsol(prob, f_intsol, p)
end

function getcbintsol(prob::XpressProblem, f_intsol, p)
    Lib.XPRSgetcbintsol(prob, f_intsol, p)
end

function addcbintsol(prob::XpressProblem, f_intsol, p, priority)
    Lib.XPRSaddcbintsol(prob, f_intsol, p, priority)
end

function removecbintsol(prob::XpressProblem, f_intsol, p)
    Lib.XPRSremovecbintsol(prob, f_intsol, p)
end

function setcbpreintsol(prob::XpressProblem, f_preintsol, p)
    Lib.XPRSsetcbpreintsol(prob, f_preintsol, p)
end

function getcbpreintsol(prob::XpressProblem, f_preintsol, p)
    Lib.XPRSgetcbpreintsol(prob, f_preintsol, p)
end

function addcbpreintsol(prob::XpressProblem, f_preintsol, p, priority)
    Lib.XPRSaddcbpreintsol(prob, f_preintsol, p, priority)
end

function removecbpreintsol(prob::XpressProblem, f_preintsol, p)
    Lib.XPRSremovecbpreintsol(prob, f_preintsol, p)
end

function setcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    Lib.XPRSsetcbchgbranch(prob, f_chgbranch, p)
end

function getcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    Lib.XPRSgetcbchgbranch(prob, f_chgbranch, p)
end

function addcbchgbranch(prob::XpressProblem, f_chgbranch, p, priority)
    Lib.XPRSaddcbchgbranch(prob, f_chgbranch, p, priority)
end

function removecbchgbranch(prob::XpressProblem, f_chgbranch, p)
    Lib.XPRSremovecbchgbranch(prob, f_chgbranch, p)
end

function setcbestimate(prob::XpressProblem, f_estimate, p)
    Lib.XPRSsetcbestimate(prob, f_estimate, p)
end

function getcbestimate(prob::XpressProblem, f_estimate, p)
    Lib.XPRSgetcbestimate(prob, f_estimate, p)
end

function addcbestimate(prob::XpressProblem, f_estimate, p, priority)
    Lib.XPRSaddcbestimate(prob, f_estimate, p, priority)
end

function removecbestimate(prob::XpressProblem, f_estimate, p)
    Lib.XPRSremovecbestimate(prob, f_estimate, p)
end

function setcbsepnode(prob::XpressProblem, f_sepnode, p)
    Lib.XPRSsetcbsepnode(prob, f_sepnode, p)
end

function getcbsepnode(prob::XpressProblem, f_sepnode, p)
    Lib.XPRSgetcbsepnode(prob, f_sepnode, p)
end

function addcbsepnode(prob::XpressProblem, f_sepnode, p, priority)
    Lib.XPRSaddcbsepnode(prob, f_sepnode, p, priority)
end

function removecbsepnode(prob::XpressProblem, f_sepnode, p)
    Lib.XPRSremovecbsepnode(prob, f_sepnode, p)
end

function setcbmessage(prob::XpressProblem, f_message, p)
    Lib.XPRSsetcbmessage(prob, f_message, p)
end

function getcbmessage(prob::XpressProblem, f_message, p)
    Lib.XPRSgetcbmessage(prob, f_message, p)
end

function addcbmessage(prob::XpressProblem, f_message, p, priority)
    Lib.XPRSaddcbmessage(prob, f_message, p, priority)
end

function removecbmessage(prob::XpressProblem, f_message, p)
    Lib.XPRSremovecbmessage(prob, f_message, p)
end

function setcbmipthread(prob::XpressProblem, f_mipthread, p)
    Lib.XPRSsetcbmipthread(prob, f_mipthread, p)
end

function getcbmipthread(prob::XpressProblem, f_mipthread, p)
    Lib.XPRSgetcbmipthread(prob, f_mipthread, p)
end

function addcbmipthread(prob::XpressProblem, f_mipthread, p, priority)
    Lib.XPRSaddcbmipthread(prob, f_mipthread, p, priority)
end

function removecbmipthread(prob::XpressProblem, f_mipthread, p)
    Lib.XPRSremovecbmipthread(prob, f_mipthread, p)
end

function setcbdestroymt(prob::XpressProblem, f_destroymt, p)
    Lib.XPRSsetcbdestroymt(prob, f_destroymt, p)
end

function getcbdestroymt(prob::XpressProblem, f_destroymt, p)
    Lib.XPRSgetcbdestroymt(prob, f_destroymt, p)
end

function addcbdestroymt(prob::XpressProblem, f_destroymt, p, priority)
    Lib.XPRSaddcbdestroymt(prob, f_destroymt, p, priority)
end

function removecbdestroymt(prob::XpressProblem, f_destroymt, p)
    Lib.XPRSremovecbdestroymt(prob, f_destroymt, p)
end

function setcbnewnode(prob::XpressProblem, f_newnode, p)
    Lib.XPRSsetcbnewnode(prob, f_newnode, p)
end

function getcbnewnode(prob::XpressProblem, f_newnode, p)
    Lib.XPRSgetcbnewnode(prob, f_newnode, p)
end

function addcbnewnode(prob::XpressProblem, f_newnode, p, priority)
    Lib.XPRSaddcbnewnode(prob, f_newnode, p, priority)
end

function removecbnewnode(prob::XpressProblem, f_newnode, p)
    Lib.XPRSremovecbnewnode(prob, f_newnode, p)
end

function setcbbariteration(prob::XpressProblem, f_bariteration, p)
    Lib.XPRSsetcbbariteration(prob, f_bariteration, p)
end

function getcbbariteration(prob::XpressProblem, f_bariteration, p)
    Lib.XPRSgetcbbariteration(prob, f_bariteration, p)
end

function addcbbariteration(prob::XpressProblem, f_bariteration, p, priority)
    Lib.XPRSaddcbbariteration(prob, f_bariteration, p, priority)
end

function removecbbariteration(prob::XpressProblem, f_bariteration, p)
    Lib.XPRSremovecbbariteration(prob, f_bariteration, p)
end

function setcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    Lib.XPRSsetcbchgbranchobject(prob, f_chgbranchobject, p)
end

function getcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    Lib.XPRSgetcbchgbranchobject(prob, f_chgbranchobject, p)
end

function addcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p, priority)
    Lib.XPRSaddcbchgbranchobject(prob, f_chgbranchobject, p, priority)
end

function removecbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    Lib.XPRSremovecbchgbranchobject(prob, f_chgbranchobject, p)
end

function setcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    Lib.XPRSsetcbgapnotify(prob, f_gapnotify, p)
end

function getcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    Lib.XPRSgetcbgapnotify(prob, f_gapnotify, p)
end

function addcbgapnotify(prob::XpressProblem, f_gapnotify, p, priority)
    Lib.XPRSaddcbgapnotify(prob, f_gapnotify, p, priority)
end

function removecbgapnotify(prob::XpressProblem, f_gapnotify, p)
    Lib.XPRSremovecbgapnotify(prob, f_gapnotify, p)
end

function setcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    Lib.XPRSsetcbusersolnotify(prob, f_usersolnotify, p)
end

function getcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    Lib.XPRSgetcbusersolnotify(prob, f_usersolnotify, p)
end

function addcbusersolnotify(prob::XpressProblem, f_usersolnotify, p, priority)
    Lib.XPRSaddcbusersolnotify(prob, f_usersolnotify, p, priority)
end

function removecbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    Lib.XPRSremovecbusersolnotify(prob, f_usersolnotify, p)
end

function objsa(prob::XpressProblem, ncols, mindex, lower, upper)
    Lib.XPRSobjsa(prob, ncols, mindex, lower, upper)
end

function rhssa(prob::XpressProblem, nrows, mindex, lower, upper)
    Lib.XPRSrhssa(prob, nrows, mindex, lower, upper)
end

function _ge_setcbmsghandler(f_msghandler, p)
    Lib.XPRS_ge_setcbmsghandler(f_msghandler, p)
end

function _ge_getcbmsghandler(f_msghandler, p)
    Lib.XPRS_ge_getcbmsghandler(f_msghandler, p)
end

function _ge_addcbmsghandler(f_msghandler, p, priority)
    Lib.XPRS_ge_addcbmsghandler(f_msghandler, p, priority)
end

function _ge_removecbmsghandler(f_msghandler, p)
    Lib.XPRS_ge_removecbmsghandler(f_msghandler, p)
end

function _ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_create(msp)
    Lib.XPRS_msp_create(msp)
end

function _msp_destroy(msp)
    Lib.XPRS_msp_destroy(msp)
end

function _msp_probattach(msp, prob)
    Lib.XPRS_msp_probattach(msp, prob)
end

function _msp_probdetach(msp, prob)
    Lib.XPRS_msp_probdetach(msp, prob)
end

function _msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
    Lib.XPRS_msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
    Lib.XPRS_msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
    Lib.XPRS_msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
end

function _msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
    Lib.XPRS_msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
end

function _msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
    Lib.XPRS_msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
end

function _msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
    Lib.XPRS_msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
end

function _msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    Lib.XPRS_msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    Lib.XPRS_msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    Lib.XPRS_msp_getintattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getdblattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    Lib.XPRS_msp_getdblattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    Lib.XPRS_msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    Lib.XPRS_msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    Lib.XPRS_msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    Lib.XPRS_msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    Lib.XPRS_msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    Lib.XPRS_msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    Lib.XPRS_msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    Lib.XPRS_msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getintattrib(msp, iAttribId, Val)
    Lib.XPRS_msp_getintattrib(msp, iAttribId, Val)
end

function _msp_getdblattrib(msp, iAttribId, Val)
    Lib.XPRS_msp_getdblattrib(msp, iAttribId, Val)
end

function _msp_getintcontrol(msp, iControlId, Val)
    Lib.XPRS_msp_getintcontrol(msp, iControlId, Val)
end

function _msp_getdblcontrol(msp, iControlId, Val)
    Lib.XPRS_msp_getdblcontrol(msp, iControlId, Val)
end

function _msp_setintcontrol(msp, iControlId, Val)
    Lib.XPRS_msp_setintcontrol(msp, iControlId, Val)
end

function _msp_setdblcontrol(msp, iControlId, Val)
    Lib.XPRS_msp_setdblcontrol(msp, iControlId, Val)
end

function _msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
    Lib.XPRS_msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
end

function _msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
    Lib.XPRS_msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
end

function _msp_findsolbyname(msp, sSolutionName, iSolutionId)
    Lib.XPRS_msp_findsolbyname(msp, sSolutionName, iSolutionId)
end

function _msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
    Lib.XPRS_msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
end

function _msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
    Lib.XPRS_msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
end

function _msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_setcbmsghandler(msp, f_msghandler, p)
    Lib.XPRS_msp_setcbmsghandler(msp, f_msghandler, p)
end

function _msp_getcbmsghandler(msp, f_msghandler, p)
    Lib.XPRS_msp_getcbmsghandler(msp, f_msghandler, p)
end

function _msp_addcbmsghandler(msp, f_msghandler, p, priority)
    Lib.XPRS_msp_addcbmsghandler(msp, f_msghandler, p, priority)
end

function _msp_removecbmsghandler(msp, f_msghandler, p)
    Lib.XPRS_msp_removecbmsghandler(msp, f_msghandler, p)
end

function _nml_create(r_nl)
    Lib.XPRS_nml_create(r_nl)
end

function _nml_destroy(nml)
    Lib.XPRS_nml_destroy(nml)
end

function _nml_getnamecount(nml, count)
    Lib.XPRS_nml_getnamecount(nml, count)
end

function _nml_getmaxnamelen(nml, namlen)
    Lib.XPRS_nml_getmaxnamelen(nml, namlen)
end

function _nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
    Lib.XPRS_nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
end

function _nml_addnames(nml, buf, firstIndex, lastIndex)
    Lib.XPRS_nml_addnames(nml, buf, firstIndex, lastIndex)
end

function _nml_removenames(nml, firstIndex, lastIndex)
    Lib.XPRS_nml_removenames(nml, firstIndex, lastIndex)
end

function _nml_findname(nml, name, r_index)
    Lib.XPRS_nml_findname(nml, name, r_index)
end

function _nml_copynames(dst, src)
    Lib.XPRS_nml_copynames(dst, src)
end

function _nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function getqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    Lib.XPRSgetqrowcoeff(prob, irow, icol, jcol, dval)
end

function getqrowqmatrix(prob::XpressProblem, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
    Lib.XPRSgetqrowqmatrix(prob, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
end

function getqrowqmatrixtriplets(prob::XpressProblem, irow, nqelem, mqcol1, mqcol2, dqe)
    Lib.XPRSgetqrowqmatrixtriplets(prob, irow, nqelem, mqcol1, mqcol2, dqe)
end

function chgqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    Lib.XPRSchgqrowcoeff(prob, irow, icol, jcol, dval)
end

function getqrows(prob::XpressProblem, qmn, qcrows)
    Lib.XPRSgetqrows(prob, qmn, qcrows)
end

function addqmatrix(prob::XpressProblem, irow, nqtr, mqc1, mqc2, dqew)
    Lib.XPRSaddqmatrix(prob, irow, nqtr, mqc1, mqc2, dqew)
end

function addqmatrix64(prob::XpressProblem, irow, nqtr, mqc1, mqc2, dqew)
    Lib.XPRSaddqmatrix64(prob, irow, nqtr, mqc1, mqc2, dqew)
end

function delqmatrix(prob::XpressProblem, irow)
    Lib.XPRSdelqmatrix(prob, irow)
end

function loadqcqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    Lib.XPRSloadqcqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function loadqcqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    Lib.XPRSloadqcqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function loadqcqpglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    Lib.XPRSloadqcqpglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqcqpglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    Lib.XPRSloadqcqpglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function _mse_create(mse)
    Lib.XPRS_mse_create(mse)
end

function _mse_destroy(mse)
    Lib.XPRS_mse_destroy(mse)
end

function _mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
    Lib.XPRS_mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
end

function _mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
    Lib.XPRS_mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
end

function _mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
    Lib.XPRS_mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
end

function _mse_minim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    Lib.XPRS_mse_minim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_maxim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    Lib.XPRS_mse_maxim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_opt(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    Lib.XPRS_mse_opt(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_getintattrib(mse, iAttribId, Val)
    Lib.XPRS_mse_getintattrib(mse, iAttribId, Val)
end

function _mse_getdblattrib(mse, iAttribId, Val)
    Lib.XPRS_mse_getdblattrib(mse, iAttribId, Val)
end

function _mse_getintcontrol(mse, iAttribId, Val)
    Lib.XPRS_mse_getintcontrol(mse, iAttribId, Val)
end

function _mse_getdblcontrol(mse, iAttribId, Val)
    Lib.XPRS_mse_getdblcontrol(mse, iAttribId, Val)
end

function _mse_setintcontrol(mse, iAttribId, Val)
    Lib.XPRS_mse_setintcontrol(mse, iAttribId, Val)
end

function _mse_setdblcontrol(mse, iAttribId, Val)
    Lib.XPRS_mse_setdblcontrol(mse, iAttribId, Val)
end

function _mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setsolbasename(mse, sSolutionBaseName)
    Lib.XPRS_mse_setsolbasename(mse, sSolutionBaseName)
end

function _mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    Lib.XPRS_mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    Lib.XPRS_mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
    Lib.XPRS_mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
end

function _mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    Lib.XPRS_mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_setcbmsghandler(mse, f_msghandler, p)
    Lib.XPRS_mse_setcbmsghandler(mse, f_msghandler, p)
end

function _mse_getcbmsghandler(mse, f_msghandler, p)
    Lib.XPRS_mse_getcbmsghandler(mse, f_msghandler, p)
end

function _mse_addcbmsghandler(mse, f_msghandler, p, priority)
    Lib.XPRS_mse_addcbmsghandler(mse, f_msghandler, p, priority)
end

function _mse_removecbmsghandler(mse, f_msghandler, p)
    Lib.XPRS_mse_removecbmsghandler(mse, f_msghandler, p)
end

function _bo_create(p_object, prob::XpressProblem, isoriginal)
    Lib.XPRS_bo_create(p_object, prob, isoriginal)
end

function _bo_destroy(obranch)
    Lib.XPRS_bo_destroy(obranch)
end

function _bo_store(obranch, p_status)
    Lib.XPRS_bo_store(obranch, p_status)
end

function _bo_addbranches(obranch, nbranches)
    Lib.XPRS_bo_addbranches(obranch, nbranches)
end

function _bo_getbranches(obranch, p_nbranches)
    Lib.XPRS_bo_getbranches(obranch, p_nbranches)
end

function _bo_setpriority(obranch, ipriority)
    Lib.XPRS_bo_setpriority(obranch, ipriority)
end

function _bo_setpreferredbranch(obranch, ibranch)
    Lib.XPRS_bo_setpreferredbranch(obranch, ibranch)
end

function _bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
    Lib.XPRS_bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
end

function _bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
    Lib.XPRS_bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
end

function _bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
    Lib.XPRS_bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
end

function _bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
    Lib.XPRS_bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
end

function _bo_addcuts(obranch, ibranch, ncuts, mcutind)
    Lib.XPRS_bo_addcuts(obranch, ibranch, ncuts, mcutind)
end

function _bo_getid(obranch, p_id)
    Lib.XPRS_bo_getid(obranch, p_id)
end

function _bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    Lib.XPRS_bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _bo_validate(obranch, p_status)
    Lib.XPRS_bo_validate(obranch, p_status)
end

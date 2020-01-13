function copycallbacks(dest::XpressProblem, src::XpressProblem)
    @checked Lib.XPRScopycallbacks(dest, src)
end

function copycontrols(dest::XpressProblem, src::XpressProblem)
    @checked Lib.XPRScopycontrols(dest, src)
    return dest
end

function copyprob(dest::XpressProblem, src::XpressProblem, probname="")
    @checked Lib.XPRScopyprob(dest, src, probname)
    return dest
end

function createprob(_probholder)
    @checked Lib.XPRScreateprob(_probholder)
end

function destroyprob(prob::XpressProblem)
    @checked Lib.XPRSdestroyprob(prob)
end

function init()
    @checked Lib.XPRSinit(C_NULL)
end

function free()
    @checked Lib.XPRSfree()
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
    @checked Lib.XPRSsetcheckedmode(checked_mode)
end

function getcheckedmode(r_checked_mode)
    @checked Lib.XPRSgetcheckedmode(r_checked_mode)
end

function license(lic, path)
    r = Lib.XPRSlicense(lic, path)
end

function beginlicensing(r_dontAlreadyHaveLicense)
    @checked Lib.XPRSbeginlicensing(r_dontAlreadyHaveLicense)
end

function endlicensing()
    @checked Lib.XPRSendlicensing()
end

function getlicerrmsg(; len = 1024)
    msg = Cstring(pointer(Array{Cchar}(undef, len*8)))
    Lib.XPRSgetlicerrmsg(msg, len)
    # TODO - @ checked version does not work
    # @checked Lib.XPRSgetlicerrmsg(msg, len)
    return unsafe_string(msg)
end

function setlogfile(prob::XpressProblem, logname::String)
    @checked Lib.XPRSsetlogfile(prob, logname)
end

function setintcontrol(prob::XpressProblem, _index::Integer, _ivalue::Integer)
    @checked Lib.XPRSsetintcontrol(prob, Cint(_index), _ivalue)
end

#= Disable 64Bit versions do to reliability issues.
function setintcontrol(prob::XpressProblem, _index::Int64, _ivalue::Integer)
    @checked Lib.XPRSsetintcontrol64(prob, _index, _ivalue)
end
=#
function setdblcontrol(prob::XpressProblem, _index::Integer, _dvalue::AbstractFloat)
    @checked Lib.XPRSsetdblcontrol(prob, _index, _dvalue)
end

function interrupt(prob::XpressProblem, reason)
    @checked Lib.XPRSinterrupt(prob, reason)
end

function getprobname(prob::XpressProblem)
    @invoke Lib.XPRSgetprobname(prob, _)::String
end

function getqobj(prob::XpressProblem, _icol, _jcol, _dval)
    @checked Lib.XPRSgetqobj(prob, _icol, _jcol, _dval)
end

function setprobname(prob::XpressProblem, name::AbstractString)
    @checked Lib.XPRSsetprobname(prob, name)
end

function setstrcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSsetstrcontrol(prob, _index, _)::String
end

function getintcontrol(prob::XpressProblem, _index::Integer)
    _index = Int32(_index)
    @invoke Lib.XPRSgetintcontrol(prob, _index, _)::Int
end

function getintcontrol64(prob::XpressProblem, _index::Integer)
    _index = Int32(_index)
    @invoke Lib.XPRSgetintcontrol64(prob, _index, _)::Int
end

function getdblcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetdblcontrol(prob, _index, _)::Float64
end

function getstrcontrol(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetstrcontrol(prob, _index, _)::String
end

function getstringcontrol(prob::XpressProblem, _index::Integer, _svalue, _svaluesize, _controlsize)
    @checked Lib.XPRSgetstringcontrol(prob, _index, _svalue, _svaluesize, _controlsize)
end

function getintattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintattrib(prob, _index, _)::Int
end

function getintattrib64(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetintattrib64(prob, _index, _)::Int
end

function getstrattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetstrattrib(prob, _index, _)::String
end

function getstringattrib(prob::XpressProblem, _index::Integer, _cvalue, _cvaluesize, _controlsize)
    @checked Lib.XPRSgetstringattrib(prob, _index, _cvalue, _cvaluesize, _controlsize)
end

function getdblattrib(prob::XpressProblem, _index::Integer)
    @invoke Lib.XPRSgetdblattrib(prob, _index, _)::Float64
end

function setdefaultcontrol(prob::XpressProblem, _index::Integer)
    @checked Lib.XPRSsetdefaultcontrol(prob, _index)
end

function setdefaults(prob::XpressProblem)
    @checked Lib.XPRSsetdefaults(prob)
end

function getcontrolinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    @checked Lib.XPRSgetcontrolinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

function getattribinfo(prob::XpressProblem, sCaName, iHeaderId, iTypeinfo)
    @checked Lib.XPRSgetattribinfo(prob, sCaName, iHeaderId, iTypeinfo)
end

function goal(prob::XpressProblem, _filename::String, _sflags::String="")
    @checked Lib.XPRSgoal(prob, _filename, _sflags)
end

function readprob(prob::XpressProblem, _sprobname::String, _sflags::String="")
    @checked Lib.XPRSreadprob(prob, _sprobname, _sflags)
end

function loadlp(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    @checked Lib.XPRSloadlp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function loadlp64(prob::XpressProblem, _sprobname="", ncols=0, nrows=0, _srowtypes=Cchar[], _drhs=Float64[], _drange=Float64[], _dobj=Float64[], _mstart=Int[], _mnel=Int[], _mrwind=Int[], _dmatval=Float64[], _dlb=Float64[], _dub=Float64[])
    @checked Lib.XPRSloadlp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub)
end

function loadqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    @checked Lib.XPRSloadqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function loadqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
    @checked Lib.XPRSloadqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval)
end

function loadqglobal(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqglobal(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqglobal64(prob::XpressProblem, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqglobal64(prob, probname, ncols, nrows, qsenx, rhsx, range, objx, matbeg, matcnt, matind, dmtval, bndl, bndu, nquads, mqcol1, mqcol2, dqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function fixglobals(prob::XpressProblem, ifround::Bool)
    @checked Lib.XPRSfixglobals(prob, ifround)
end

function loadmodelcuts(prob::XpressProblem, nmodcuts, _mrows)
    @checked Lib.XPRSloadmodelcuts(prob, nmodcuts, _mrows)
end

function loaddelayedrows(prob::XpressProblem, nrows, _mrows)
    @checked Lib.XPRSloaddelayedrows(prob, nrows, _mrows)
end

function loaddirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSloaddirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function loadbranchdirs(prob::XpressProblem, ndirs, _mcols, _mbranch)
    @checked Lib.XPRSloadbranchdirs(prob, ndirs, _mcols, _mbranch)
end

function loadpresolvedirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSloadpresolvedirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function getdirs(prob::XpressProblem, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
    @checked Lib.XPRSgetdirs(prob, ndirs, _mcols, _mpri, _sbr, dupc, ddpc)
end

function loadglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    @checked Lib.XPRSloadglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function loadglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
    @checked Lib.XPRSloadglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, ngents, nsets, _qgtype, _mgcols, _dlim, _stype, _msstart, _mscols, _dref)
end

function addnames(prob::XpressProblem, _itype::Integer, first::Integer, names::Vector{String})
    # TODO: name _itype a Enum?
    NAMELENGTH = 64

    last = first+length(names)-1
    first -= 1
    last -= 1

    _cnames = ""
    for str in names
        _cnames = string(_cnames, join(Base.Iterators.take(str,NAMELENGTH)), "\0")
    end

    @checked Lib.XPRSaddnames(prob, Cint(_itype), _cnames, Cint(first), Cint(last))
end
function addnames(prob::XpressProblem, _itype::Integer, _sname::Vector{String})
    addnames(prob, _itype, 1, _sname)
end

function addsetnames(prob::XpressProblem, _sname, first::Integer, last::Integer)
    @checked Lib.XPRSaddsetnames(prob, _sname, first, last)
end

function scale(prob::XpressProblem, mrscal, mcscal)
    @checked Lib.XPRSscale(prob, mrscal, mcscal)
end

function readdirs(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSreaddirs(prob, _sfilename)
end

function writedirs(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSwritedirs(prob, _sfilename)
end

function setindicators(prob::XpressProblem, nrows, _mrows, _inds, _comps)
    @checked Lib.XPRSsetindicators(prob, nrows, _mrows, _inds, _comps)
end

function getindicators(prob::XpressProblem, _inds, _comps, first::Integer, last::Integer)
    @checked Lib.XPRSgetindicators(prob, _inds, _comps, first, last)
end

function delindicators(prob::XpressProblem, first::Integer, last::Integer)
    @checked Lib.XPRSdelindicators(prob, first, last)
end

function dumpcontrols(prob::XpressProblem)
    @checked Lib.XPRSdumpcontrols(prob)
end

function minim(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSminim(prob, _sflags)
end

function maxim(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSmaxim(prob, _sflags)
end

function lpoptimize(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSlpoptimize(prob, _sflags)
end

function mipoptimize(prob::XpressProblem, _sflags::String="")
    @checked Lib.XPRSmipoptimize(prob, _sflags)
end

function range(prob::XpressProblem)
    @checked Lib.XPRSrange(prob)
end

function getrowrange(prob::XpressProblem, _upact, _loact, _uup, _udn)
    @checked Lib.XPRSgetrowrange(prob, _upact, _loact, _uup, _udn)
end

function getcolrange(prob::XpressProblem, _upact, _loact, _uup, _udn, _ucost, _lcost)
    @checked Lib.XPRSgetcolrange(prob, _upact, _loact, _uup, _udn, _ucost, _lcost)
end

function getpivotorder(prob::XpressProblem, mpiv)
    @checked Lib.XPRSgetpivotorder(prob, mpiv)
end

function getpresolvemap(prob::XpressProblem, rowmap, colmap)
    @checked Lib.XPRSgetpresolvemap(prob, rowmap, colmap)
end

function readbasis(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSreadbasis(prob, _sfilename, _sflags)
end

function writebasis(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSwritebasis(prob, _sfilename, _sflags)
end

function XPRSglobal(prob::XpressProblem)
    @checked Lib.XPRSglobal(prob)
end

function initglobal(prob::XpressProblem)
    @checked Lib.XPRSinitglobal(prob)
end

function writeprtsol(prob::XpressProblem, _sfilename::String, _sflags::String="")
    @checked Lib.XPRSwriteprtsol(prob, _sfilename, _sflags)
end

function alter(prob::XpressProblem, _sfilename::String)
    @checked Lib.XPRSalter(prob, _sfilename)
end

function writesol(prob::XpressProblem, _sfilename::String, _sflags="")
    @checked Lib.XPRSwritesol(prob, _sfilename, _sflags)
end

function writebinsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwritebinsol(prob, _sfilename, _sflags)
end

function readbinsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSreadbinsol(prob, _sfilename, _sflags)
end

function writeslxsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwriteslxsol(prob, _sfilename, _sflags)
end

function readslxsol(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSreadslxsol(prob, _sfilename, _sflags)
end

function writeprtrange(prob::XpressProblem)
    @checked Lib.XPRSwriteprtrange(prob)
end

function writerange(prob::XpressProblem, _sfilename::String, _sflags)
    @checked Lib.XPRSwriterange(prob, _sfilename, _sflags)
end

function getsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetsol(prob, _dx, _dslack, _dual, _dj)
end

function getpresolvesol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetpresolvesol(prob, _dx, _dslack, _dual, _dj)
end

function getinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    @checked Lib.XPRSgetinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function getscaledinfeas(prob::XpressProblem, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
    @checked Lib.XPRSgetscaledinfeas(prob, npv, nps, nds, ndv, mx, mslack, mdual, mdj)
end

function getunbvec(prob::XpressProblem, icol)
    @checked Lib.XPRSgetunbvec(prob, icol)
end

function btran(prob::XpressProblem, dwork)
    @checked Lib.XPRSbtran(prob, dwork)
end

function ftran(prob::XpressProblem, dwork)
    @checked Lib.XPRSftran(prob, dwork)
end

function getobj(prob::XpressProblem)
    ncols = n_variables(prob)
    first = 0
    last = ncols - 1
    _dobj = Vector{Float64}(undef, ncols)
    @checked Lib.XPRSgetobj(prob, _dobj, first, last)
    return _dobj
end

function getrhs(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_constraints(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _drhs = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetrhs(prob, _drhs, first, last)
    return _drhs
end

function getrhsrange(prob::XpressProblem, _drng, first::Integer, last::Integer)
    @checked Lib.XPRSgetrhsrange(prob, _drng, first, last)
end

function getlb(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _dbdl = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetlb(prob, _dbdl, first, last)
    return _dbdl
end

function getub(prob::XpressProblem, first::Integer=1, last::Integer=0)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _dbdu = Vector{Float64}(undef, n_elems)
    @checked Lib.XPRSgetub(prob, _dbdu, first, last)
    return _dbdu
end

function getcols(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetcols(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, Cint(first), Cint(last))
end

#= Disable 64Bit versions do to reliability issues.
function getcols(prob::XpressProblem, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first::Int64, last::Int64)
    @checked Lib.XPRSgetcols64(prob, _mstart, _mrwind, _dmatval, maxcoeffs, ncoeffs, first, last)
end
=#
function getrows(prob::XpressProblem, _mstart::Vector{<:Integer}, _mrwind::Vector{<:Integer}, _dmatval::Vector{Float64}, maxcoeffs::Integer, first::Integer, last::Integer)
    @assert length(_mstart) >= last-first+2
    @assert length(_mrwind) == maxcoeffs
    @assert length(_dmatval) == maxcoeffs
    temp = zeros(Cint, 1)
    @checked Lib.XPRSgetrows(prob, _mstart, _mrwind, _dmatval, maxcoeffs, temp, Cint(first - 1), Cint(last - 1))
    _mstart .+= 1
    _mrwind .+= 1
    return
end

function getrows_nnz(prob::XpressProblem, first::Integer, last::Integer)
    nzcnt = zeros(Cint, 1)
    @checked Lib.XPRSgetrows(prob, C_NULL, C_NULL, C_NULL, 0, nzcnt, first - 1, last - 1)
    return nzcnt[]
end

#= Disable 64Bit versions do to reliability issues.
function getrows(prob::XpressProblem, _mstart::Vector{Int64}, _mrwind::Vector{Int64}, _dmatval::Array{Float64}, maxcoeffs::Integer, val::Integer, first::Int64, last::Int64)
    @assert length(_mstart) >= last-first+2
    @assert length(_mrwind) == maxcoeffs
    @assert length(_dmatval) == maxcoeffs
    temp = zeros(Int, 1)
    @checked Lib.XPRSgetrows64(prob, _mstart, _mrwind, _dmatval, maxcoeffs, temp, first - 1, last - 1)
    _mstart .+= 1
    _mrwind .+= 1
    return
end
=#
function getcoef(prob::XpressProblem, _irow, _icol, _dval)
    @checked Lib.XPRSgetcoef(prob, _irow, _icol, _dval)
end

function getmqobj(prob::XpressProblem, _mstart, _mrwind, _dobjval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetmqobj(prob, _mstart, _mrwind, _dobjval, maxcoeffs, ncoeffs, Cint(first), Cint(last))
end

#= Disable 64Bit versions do to reliability issues.
function getmqobj(prob::XpressProblem, _mstart, _mrwind, _dobjval, maxcoeffs, ncoeffs, first::Int64, last::Int64)
    @checked Lib.XPRSgetmqobj64(prob, _mstart, _mrwind, _dobjval, maxcoeffs, ncoeffs, first, last)
end
=#
function crossoverlpsol(prob::XpressProblem, status)
    @checked Lib.XPRScrossoverlpsol(prob, status)
end

function getbarnumstability(prob::XpressProblem, dColumnStability, dRowStability)
    @checked Lib.XPRSgetbarnumstability(prob, dColumnStability, dRowStability)
end

function iisclear(prob::XpressProblem)
    @checked Lib.XPRSiisclear(prob)
end

function iisfirst(prob::XpressProblem, iismode, status_code)
    @checked Lib.XPRSiisfirst(prob, iismode, status_code)
end

function iisnext(prob::XpressProblem, status_code)
    @checked Lib.XPRSiisnext(prob, status_code)
end

function iisstatus(prob::XpressProblem, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
    @checked Lib.XPRSiisstatus(prob, iiscount, rowsizes, colsizes, suminfeas, numinfeas)
end

function iisall(prob::XpressProblem)
    @checked Lib.XPRSiisall(prob)
end

function iiswrite(prob::XpressProblem, number, fn, filetype, typeflags)
    @checked Lib.XPRSiiswrite(prob, number, fn, filetype, typeflags)
end

function iisisolations(prob::XpressProblem, number)
    @checked Lib.XPRSiisisolations(prob, number)
end

function getiisdata(prob::XpressProblem, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
    @checked Lib.XPRSgetiisdata(prob, number, rownumber, colnumber, miisrow, miiscol, constrainttype, colbndtype, duals, rdcs, isolationrows, isolationcols)
end

function getiis(prob::XpressProblem, ncols, nrows, _miiscol, _miisrow)
    @checked Lib.XPRSgetiis(prob, ncols, nrows, _miiscol, _miisrow)
end

function getpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSgetpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

function loadpresolvebasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSloadpresolvebasis(prob, _mrowstatus, _mcolstatus)
end

function getglobal(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    @checked Lib.XPRSgetglobal(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function getglobal64(prob::XpressProblem, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
    @checked Lib.XPRSgetglobal64(prob, ngents, nsets, _sgtype, _mgcols, _dlim, _sstype, _msstart, _mscols, _dref)
end

function writeprob(prob::XpressProblem, _sfilename::String, _sflags="")
    @checked Lib.XPRSwriteprob(prob, _sfilename, _sflags)
end

function getnames(prob::XpressProblem, _itype, _sbuff, first::Integer, last::Integer)
    @checked Lib.XPRSgetnames(prob, _itype, _sbuff, first, last)
end

function getrowtype(prob::XpressProblem, first::Integer, last::Integer)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_constraints(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _srowtype = Vector{Cchar}(undef, n_elems)
    @checked Lib.XPRSgetrowtype(prob, _dbdl, first, last)
    return _srowtype
end

function loadsecurevecs(prob::XpressProblem, nrows, ncols, mrow, mcol)
    @checked Lib.XPRSloadsecurevecs(prob, nrows, ncols, mrow, mcol)
end

function getcoltype(prob::XpressProblem, first::Integer, last::Integer)
    n_elems = last - first + 1
    if n_elems <= 0
        n_elems = n_variables(prob)
        first = 0
        last = n_elems - 1
    else
        first = first - 1
        last = last - 1
    end
    _coltype = Vector{Cchar}(undef, n_elems)
    @checked Lib.XPRSgetcoltype(prob, _coltype, first, last)
    return _coltype
end

function getbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSgetbasis(prob, _mrowstatus, _mcolstatus)
end

function loadbasis(prob::XpressProblem, _mrowstatus, _mcolstatus)
    @checked Lib.XPRSloadbasis(prob, _mrowstatus, _mcolstatus)
end

function getindex(prob::XpressProblem, _itype, _sname, _iseq)
    @checked Lib.XPRSgetindex(prob, _itype, _sname, _iseq)
end

function addrows(prob::XpressProblem, _srowtype::Vector{Cchar}, _drhs::Vector{Float64}, _drng, _mstart::Vector{<:Integer}, _mrwind::Vector{<:Integer}, _dmatval::Vector{Float64})
    nrows = length(_drhs)
    # @assert nrows == length(_drng) # can be a C_NULL
    @assert nrows == length(_srowtype)
    @assert nrows == length(_mstart)
    ncoeffs = length(_mrwind)
    @assert ncoeffs == length(_dmatval)
    _mstart .-= 1
    _mrwind .-= 1
    @checked Lib.XPRSaddrows(prob, nrows, Cint(ncoeffs), _srowtype, _drhs, _drng, Cint.(_mstart), Cint.(_mrwind), _dmatval)
end

#= Disable 64Bit versions do to reliability issues.
function addrows(prob::XpressProblem, _srowtype::Vector{Cchar}, _drhs::Vector{Float64}, _drng, _mstart::Vector{Int64}, _mrwind::Vector{Int64}, _dmatval::Vector{Float64})
    nrows = length(_drhs)
    # @assert nrows == length(_drng) # can be a C_NULL
    @assert nrows == length(_srowtype)
    @assert nrows == length(_mstart)
    ncoeffs = length(_mrwind)
    @assert ncoeffs == length(_dmatval)
    _mstart .-= 1
    _mrwind .-= 1
    @checked Lib.XPRSaddrows64(prob, nrows, ncoeffs, _srowtype, _drhs, _drng, _mstart, _mrwind, _dmatval)
end
=#
function delrows(prob::XpressProblem, _mindex::Vector{<:Integer})
    nrows = length(_mindex)
    @checked Lib.XPRSdelrows(prob, nrows, Cint.(_mindex .- 1))
end

function addcols(prob::XpressProblem, _dobj::Vector{Float64}, _mstart::Vector{<:Integer}, _mrwind::Vector{<:Integer}, _dmatval::Vector{Float64}, _dbdl::Vector{Float64}, _dbdu::Vector{Float64})
    @assert length(_dbdl) == length(_dbdu)
    fixinfinity!(_dbdl)
    fixinfinity!(_dbdu)
    ncols = length(_dbdl)
    ncoeffs = length(_dmatval)
    _mstart = _mstart .- 1
    _mrwind = _mrwind .- 1
    @checked Lib.XPRSaddcols(prob, ncols, ncoeffs, _dobj, Cint.(_mstart), Cint.(_mrwind), _dmatval, _dbdl, _dbdu)
end

#= Disable 64Bit versions do to reliability issues.
function addcols(prob::XpressProblem, _dobj::Vector{Float64}, _mstart::Vector{Int64}, _mrwind::Vector{Int64}, _dmatval::Vector{Float64}, _dbdl::Vector{Float64}, _dbdu::Vector{Float64})
    @assert length(_dbdl) == length(_dbdu)
    fixinfinity!(_dbdl)
    fixinfinity!(_dbdu)
    ncols = length(_dbdl)
    ncoeffs = length(_dmatval)
    _mstart = _mstart .- 1
    _mrwind = _mrwind .- 1
    @checked Lib.XPRSaddcols64(prob, ncols, ncoeffs, _dobj, _mstart, _mrwind, _dmatval, _dbdl, _dbdu)
end
=#
function delcols(prob::XpressProblem, _mindex::Vector{<:Integer})
    ncols = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSdelcols(prob, ncols, Cint.(_mindex))
end

function chgcoltype(prob::XpressProblem, _mindex::Vector{<:Integer}, _coltype::Vector{Cchar})
    ncols = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgcoltype(prob, ncols, Cint.(_mindex), _coltype)
end

function chgrowtype(prob::XpressProblem, _mindex::Vector{<:Integer}, _srowtype::Vector{Cchar})
    nrows = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgrowtype(prob, nrows, Cint.(_mindex), _srowtype)
end

function chgbounds(prob::XpressProblem, _mindex::Vector{<:Integer}, _sboundtype::Vector{Cchar}, _dbnd::Vector{Float64})
    nbnds = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgbounds(prob, Cint(nbnds), Cint.(_mindex), _sboundtype, _dbnd)
end

function chgobj(prob::XpressProblem, _mindex::Vector{<:Integer}, _dobj::Vector{Float64})
    ncols = length(_dobj)
    @assert length(_mindex) == ncols
    _mindex .-= 1
    @checked Lib.XPRSchgobj(prob, Cint(ncols), Cint.(_mindex), _dobj)
end

function chgcoef(prob::XpressProblem, _irow::Integer, _icol::Integer, _dval)
    @checked Lib.XPRSchgcoef(prob, Cint(_irow - 1), Cint(_icol - 1), _dval)
end

function chgmcoef(prob::XpressProblem, ncoeffs, _mrow::Vector{<:Integer}, _mcol::Vector{<:Integer}, _dval)
    @checked Lib.XPRSchgmcoef(prob, ncoeffs, Cint(_mrow .- 1), Cint(_mcol .- 1), _dval)
end

#= Disable 64Bit versions do to reliability issues.
function chgmcoef(prob::XpressProblem, ncoeffs, _mrow::Vector{Int64}, _mcol::Vector{Int64}, _dval)
    @checked Lib.XPRSchgmcoef64(prob, ncoeffs, _mrow, _mcol, _dval)
end
=#
function chgmqobj(prob::XpressProblem, _mcol1::Vector{<:Integer}, _mcol2::Vector{<:Integer}, _dval)
    ncols = length(_mcol1)
    @assert length(_mcol2) == ncols
    @assert length(_dval) == ncols
    @checked Lib.XPRSchgmqobj(prob, Cint(ncols), Cint.(_mcol1 .- 1), Cint.(_mcol2 .- 1), _dval)
end

#= Disable 64Bit versions do to reliability issues.
function chgmqobj(prob::XpressProblem, _mcol1::Vector{Int64}, _mcol2::Vector{Int64}, _dval)
    ncols = length(_mcol1)
    @assert length(_mcol2) == ncols
    @assert length(_dval) == ncols
    @checked Lib.XPRSchgmqobj64(prob, ncols, _mcol1.-1, _mcol2.-1, _dval)
end
=#
function chgqobj(prob::XpressProblem, _icol, _jcol, _dval)
    @checked Lib.XPRSchgqobj(prob, _icol-1, _jcol-1, _dval)
end

function chgrhs(prob::XpressProblem, _mindex::Vector{<:Integer}, _drhs::Vector{Float64})
    nrows = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgrhs(prob, Cint(nrows), Cint.(_mindex), _drhs)
end

function chgrhsrange(prob::XpressProblem, nrows::Integer, _mindex::Vector{<:Integer}, _drng::Vector{Float64})
    @checked Lib.XPRSchgrhsrange(prob, Cint(nrows), Cint.(_mindex .- 1), _drng)
end

function chgobjsense(prob::XpressProblem, objsense::Union{Symbol, Int})
    v = objsense == :maximize || objsense == :Max || objsense == Lib.XPRS_OBJ_MAXIMIZE ? Lib.XPRS_OBJ_MAXIMIZE :
        objsense == :minimize || objsense == :Min || objsense == Lib.XPRS_OBJ_MINIMIZE ? Lib.XPRS_OBJ_MINIMIZE :
        throw(ArgumentError("Invalid objective sense: $objsense. It can only be `:maximize`, `:minimize`, `:Max`, `:Min`, `$(Lib.XPRS_OBJ_MAXIMIZE)`, or `$(Lib.XPRS_OBJ_MINIMIZE)`."))
    @checked Lib.XPRSchgobjsense(prob, v)
end

function chgglblimit(prob::XpressProblem, _mindex::Vector{<:Integer}, _dlimit::Vector{Float64})
    ncols = length(_mindex)
    _mindex = _mindex .- 1
    @checked Lib.XPRSchgglblimit(prob, Cint.(_mindex), _dlimit)
end

function save(prob::XpressProblem)
    @checked Lib.XPRSsave(prob)
end

function restore(prob::XpressProblem, _sprobname, _force)
    @checked Lib.XPRSrestore(prob, _sprobname, _force)
end

function pivot(prob::XpressProblem, _in, _out)
    @checked Lib.XPRSpivot(prob, _in, _out)
end

function getpivots(prob::XpressProblem, _in, _mout, _dout, _dobjo, npiv, maxpiv)
    @checked Lib.XPRSgetpivots(prob, _in, _mout, _dout, _dobjo, npiv, maxpiv)
end

function addcuts(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart::Vector{<:Integer}, mcols::Vector{<:Integer}, dmatval)
    @checked Lib.XPRSaddcuts(prob, ncuts, mtype, qrtype, drhs, Cint.(mstart), Cint.(mcols), dmatval)
end

#= Disable 64Bit versions do to reliability issues.
function addcuts(prob::XpressProblem, ncuts, mtype, qrtype, drhs, mstart::Vector{Int64}, mcols::Vector{Int64}, dmatval)
    @checked Lib.XPRSaddcuts64(prob, ncuts, mtype, qrtype, drhs, mstart, mcols, dmatval)
end
=#
function delcuts(prob::XpressProblem, ibasis, itype, interp, delta, ncuts, mcutind)
    @checked Lib.XPRSdelcuts(prob, ibasis, itype, interp, delta, ncuts, mcutind)
end

function delcpcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    @checked Lib.XPRSdelcpcuts(prob, itype, interp, ncuts, mcutind)
end

function getcutlist(prob::XpressProblem, itype, interp, ncuts, maxcuts, mcutind)
    @checked Lib.XPRSgetcutlist(prob, itype, interp, ncuts, maxcuts, mcutind)
end

function getcpcutlist(prob::XpressProblem, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
    @checked Lib.XPRSgetcpcutlist(prob, itype, interp, delta, ncuts, maxcuts, mcutind, dviol)
end

function getcpcuts(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart::Vector{<:Integer}, mcols::Vector{<:Integer}, dmatval, drhs)
    @checked Lib.XPRSgetcpcuts(prob, mindex, ncuts, size, mtype, qrtype, Cint.(mstart), Cint.(mcols), dmatval, drhs)
end

#= Disable 64Bit versions do to reliability issues.
function getcpcuts(prob::XpressProblem, mindex, ncuts, size, mtype, qrtype, mstart::Vector{Int64}, mcols::Vector{Int64}, dmatval, drhs)
    @checked Lib.XPRSgetcpcuts64(prob, mindex, ncuts, size, mtype, qrtype, mstart, mcols, dmatval, drhs)
end
=#
function loadcuts(prob::XpressProblem, itype, interp, ncuts, mcutind)
    @checked Lib.XPRSloadcuts(prob, itype, interp, ncuts, mcutind)
end

function storecuts(prob::XpressProblem, ncuts, nodupl, mtype::Vector{<:Integer}, qrtype, drhs::Vector{Float64}, mstart::Vector{<:Integer}, mindex, mcols::Vector{<:Integer}, dmatval)
    @checked Lib.XPRSstorecuts(prob, ncuts, nodupl, Cint.(mtype), qrtype, drhs, Cint.(mstart), mindex, Cint.(cols), dmatval)
end

#= Disable 64Bit versions do to reliability issues.
function storecuts(prob::XpressProblem, ncuts, nodupl, mtype::Vector{Int64}, qrtype, drhs, mstart::Vector{Int64}, mindex, mcols::Vector{Int64}, dmatval)
    @checked Lib.XPRSstorecuts64(prob, ncuts, nodupl, mtype, qrtype, drhs, mstart, mindex, mcols, dmatval)
end
=#
function presolverow(prob::XpressProblem, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
    @checked Lib.XPRSpresolverow(prob, qrtype, nzo, mcolso, dvalo, drhso, maxcoeffs, nzp, mcolsp, dvalp, drhsp, status)
end

function loadlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj, status)
    @checked Lib.XPRSloadlpsol(prob, _dx, _dslack, _dual, _dj, status)
end

function loadmipsol(prob::XpressProblem, dsol, status)
    @checked Lib.XPRSloadmipsol(prob, dsol, status)
end

function addmipsol(prob::XpressProblem, ilength, mipsolval, mipsolcol, solname)
    @checked Lib.XPRSaddmipsol(prob, ilength, mipsolval, mipsolcol, solname)
end

function storebounds(prob::XpressProblem, nbnds, mcols, qbtype, dbnd, mindex)
    @checked Lib.XPRSstorebounds(prob, nbnds, mcols, qbtype, dbnd, mindex)
end

function setbranchcuts(prob::XpressProblem, nbcuts, mindex)
    @checked Lib.XPRSsetbranchcuts(prob, nbcuts, mindex)
end

function setbranchbounds(prob::XpressProblem, mindex)
    @checked Lib.XPRSsetbranchbounds(prob, mindex)
end

function getlasterror(prob::XpressProblem)
    @invoke Lib.XPRSgetlasterror(prob, _)::String
end

function basiscondition(prob::XpressProblem, condnum, scondnum)
    @checked Lib.XPRSbasiscondition(prob, condnum, scondnum)
end

function getmipsol(prob::XpressProblem, _dx, _dslack)
    @checked Lib.XPRSgetmipsol(prob, _dx, _dslack)
end

function getlpsol(prob::XpressProblem, _dx, _dslack, _dual, _dj)
    @checked Lib.XPRSgetlpsol(prob, _dx, _dslack, _dual, _dj)
end

function postsolve(prob::XpressProblem)
    @checked Lib.XPRSpostsolve(prob)
end

function delsets(prob::XpressProblem, nsets, msindex)
    @checked Lib.XPRSdelsets(prob, nsets, msindex)
end

function addsets(prob::XpressProblem, newsets, newnz, qstype, msstart::Vector{<:Integer}, mscols::Vector{<:Integer}, dref)
    @checked Lib.XPRSaddsets(prob, newsets, newnz, qstype, Cint.(msstart), Cint.(mscols .- 1), dref)
end

#= Disable 64Bit versions do to reliability issues.
function addset(prob::XpressProblem, newsets, newnz, qstype, msstart::Vector{Int64}, mscols::Vector{Int64}, dref)
    @checked Lib.XPRSaddsets64(prob, newsets, newnz, qstype, msstart, mscols, dref)
end
=#
function strongbranch(prob::XpressProblem, nbnds::Integer, _mindex::Vector{<:Integer}, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
    @checked Lib.XPRSstrongbranch(prob, nbnds, Cint.(_mindex .- 1), _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus)
end

function estimaterowdualranges(prob::XpressProblem, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
    @checked Lib.XPRSestimaterowdualranges(prob, nRows, rowIndices, iterationLimit, minDualActivity, maxDualActivity)
end

function getprimalray(prob::XpressProblem, _dpray, _hasray)
    @checked Lib.XPRSgetprimalray(prob, _dpray, _hasray)
end

function getdualray(prob::XpressProblem, _ddray, _hasray)
    @checked Lib.XPRSgetdualray(prob, _ddray, _hasray)
end

function setmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    @checked Lib.XPRSsetmessagestatus(prob, errcode, bEnabledStatus)
end

function getmessagestatus(prob::XpressProblem, errcode, bEnabledStatus)
    @checked Lib.XPRSgetmessagestatus(prob, errcode, bEnabledStatus)
end

function repairweightedinfeas(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
    @checked Lib.XPRSrepairweightedinfeas(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, second_phase, delta, optflags)
end

function repairweightedinfeasbounds(prob::XpressProblem, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
    @checked Lib.XPRSrepairweightedinfeasbounds(prob, scode, lrp_array, grp_array, lbp_array, ubp_array, lrb_array, grb_array, lbb_array, ubb_array, second_phase, delta, optflags)
end

function repairinfeas(prob::XpressProblem, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
    @checked Lib.XPRSrepairinfeas(prob, scode, ptype, phase2, globalflags, lrp, grp, lbp, ubp, delta)
end

function getcutslack(prob::XpressProblem, cut, dslack)
    @checked Lib.XPRSgetcutslack(prob, cut, dslack)
end

function getcutmap(prob::XpressProblem, ncuts, cuts, cutmap)
    @checked Lib.XPRSgetcutmap(prob, ncuts, cuts, cutmap)
end

function basisstability(prob::XpressProblem, typecode, norm, ifscaled::Bool, dval)
    @checked Lib.XPRSbasisstability(prob, typecode, norm, ifscaled, dval)
end

function calcslacks(prob::XpressProblem, solution, calculatedslacks)
    @checked Lib.XPRScalcslacks(prob, solution, calculatedslacks)
end

function calcreducedcosts(prob::XpressProblem, duals, solution, calculateddjs)
    @checked Lib.XPRScalcreducedcosts(prob, duals, solution, calculateddjs)
end

function calcobjective(prob::XpressProblem, solution, objective)
    @checked Lib.XPRScalcobjective(prob, solution, objective)
end

function refinemipsol(prob::XpressProblem, options, _sflags, solution, refined_solution, refinestatus)
    @checked Lib.XPRSrefinemipsol(prob, options, _sflags, solution, refined_solution, refinestatus)
end

function calcsolinfo(prob::XpressProblem, solution, dual, Property, Value)
    @checked Lib.XPRScalcsolinfo(prob, solution, dual, Property, Value)
end

function getnamelist(prob::XpressProblem, _itype, _sbuff, names_len, names_len_reqd, first::Integer, last::Integer)
    @checked Lib.XPRSgetnamelist(prob, _itype, _sbuff, names_len, names_len_reqd, first, last)
end

function getnamelistobject(prob::XpressProblem, _itype, r_nl)
    @checked Lib.XPRSgetnamelistobject(prob, _itype, r_nl)
end

function logfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
    @checked Lib.XPRSlogfilehandler(obj, vUserContext, vSystemThreadId, sMsg, iMsgType, iMsgCode)
end

function getobjecttypename(obj, sObjectName)
    @checked Lib.XPRSgetobjecttypename(obj, sObjectName)
end

function strongbranchcb(prob::XpressProblem, nbnds::Integer, _mindex::Vector{Float64}, _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
    @checked Lib.XPRSstrongbranchcb(prob, nbnds, Cint.(_mindex.-1), _sboundtype, _dbnd, itrlimit, _dsbobjval, _msbstatus, sbsolvecb, vContext)
end

function setcblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSsetcblplog(prob, f_lplog, p)
end

function getcblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSgetcblplog(prob, f_lplog, p)
end

function addcblplog(prob::XpressProblem, f_lplog, p, priority)
    @checked Lib.XPRSaddcblplog(prob, f_lplog, p, priority)
end

function removecblplog(prob::XpressProblem, f_lplog, p)
    @checked Lib.XPRSremovecblplog(prob, f_lplog, p)
end

function setcbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSsetcbgloballog(prob, f_globallog, p)
end

function getcbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSgetcbgloballog(prob, f_globallog, p)
end

function addcbgloballog(prob::XpressProblem, f_globallog, p, priority)
    @checked Lib.XPRSaddcbgloballog(prob, f_globallog, p, priority)
end

function removecbgloballog(prob::XpressProblem, f_globallog, p)
    @checked Lib.XPRSremovecbgloballog(prob, f_globallog, p)
end

function setcbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSsetcbcutlog(prob, f_cutlog, p)
end

function getcbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSgetcbcutlog(prob, f_cutlog, p)
end

function addcbcutlog(prob::XpressProblem, f_cutlog, p, priority)
    @checked Lib.XPRSaddcbcutlog(prob, f_cutlog, p, priority)
end

function removecbcutlog(prob::XpressProblem, f_cutlog, p)
    @checked Lib.XPRSremovecbcutlog(prob, f_cutlog, p)
end

function setcbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSsetcbbarlog(prob, f_barlog, p)
end

function getcbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSgetcbbarlog(prob, f_barlog, p)
end

function addcbbarlog(prob::XpressProblem, f_barlog, p, priority)
    @checked Lib.XPRSaddcbbarlog(prob, f_barlog, p, priority)
end

function removecbbarlog(prob::XpressProblem, f_barlog, p)
    @checked Lib.XPRSremovecbbarlog(prob, f_barlog, p)
end

function setcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSsetcbcutmgr(prob, f_cutmgr, p)
end

function getcbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSgetcbcutmgr(prob, f_cutmgr, p)
end

function addcbcutmgr(prob::XpressProblem, f_cutmgr, p, priority)
    @checked Lib.XPRSaddcbcutmgr(prob, f_cutmgr, p, priority)
end

function removecbcutmgr(prob::XpressProblem, f_cutmgr, p)
    @checked Lib.XPRSremovecbcutmgr(prob, f_cutmgr, p)
end

function setcbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSsetcbchgnode(prob, f_chgnode, p)
end

function getcbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSgetcbchgnode(prob, f_chgnode, p)
end

function addcbchgnode(prob::XpressProblem, f_chgnode, p, priority)
    @checked Lib.XPRSaddcbchgnode(prob, f_chgnode, p, priority)
end

function removecbchgnode(prob::XpressProblem, f_chgnode, p)
    @checked Lib.XPRSremovecbchgnode(prob, f_chgnode, p)
end

function setcboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSsetcboptnode(prob, f_optnode, p)
end

function getcboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSgetcboptnode(prob, f_optnode, p)
end

function addcboptnode(prob::XpressProblem, f_optnode, p, priority)
    @checked Lib.XPRSaddcboptnode(prob, f_optnode, p, priority)
end

function removecboptnode(prob::XpressProblem, f_optnode, p)
    @checked Lib.XPRSremovecboptnode(prob, f_optnode, p)
end

function setcbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSsetcbprenode(prob, f_prenode, p)
end

function getcbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSgetcbprenode(prob, f_prenode, p)
end

function addcbprenode(prob::XpressProblem, f_prenode, p, priority)
    @checked Lib.XPRSaddcbprenode(prob, f_prenode, p, priority)
end

function removecbprenode(prob::XpressProblem, f_prenode, p)
    @checked Lib.XPRSremovecbprenode(prob, f_prenode, p)
end

function setcbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSsetcbinfnode(prob, f_infnode, p)
end

function getcbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSgetcbinfnode(prob, f_infnode, p)
end

function addcbinfnode(prob::XpressProblem, f_infnode, p, priority)
    @checked Lib.XPRSaddcbinfnode(prob, f_infnode, p, priority)
end

function removecbinfnode(prob::XpressProblem, f_infnode, p)
    @checked Lib.XPRSremovecbinfnode(prob, f_infnode, p)
end

function setcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSsetcbnodecutoff(prob, f_nodecutoff, p)
end

function getcbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSgetcbnodecutoff(prob, f_nodecutoff, p)
end

function addcbnodecutoff(prob::XpressProblem, f_nodecutoff, p, priority)
    @checked Lib.XPRSaddcbnodecutoff(prob, f_nodecutoff, p, priority)
end

function removecbnodecutoff(prob::XpressProblem, f_nodecutoff, p)
    @checked Lib.XPRSremovecbnodecutoff(prob, f_nodecutoff, p)
end

function setcbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSsetcbintsol(prob, f_intsol, p)
end

function getcbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSgetcbintsol(prob, f_intsol, p)
end

function addcbintsol(prob::XpressProblem, f_intsol, p, priority)
    @checked Lib.XPRSaddcbintsol(prob, f_intsol, p, priority)
end

function removecbintsol(prob::XpressProblem, f_intsol, p)
    @checked Lib.XPRSremovecbintsol(prob, f_intsol, p)
end

function setcbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSsetcbpreintsol(prob, f_preintsol, p)
end

function getcbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSgetcbpreintsol(prob, f_preintsol, p)
end

function addcbpreintsol(prob::XpressProblem, f_preintsol, p, priority)
    @checked Lib.XPRSaddcbpreintsol(prob, f_preintsol, p, priority)
end

function removecbpreintsol(prob::XpressProblem, f_preintsol, p)
    @checked Lib.XPRSremovecbpreintsol(prob, f_preintsol, p)
end

function setcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSsetcbchgbranch(prob, f_chgbranch, p)
end

function getcbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSgetcbchgbranch(prob, f_chgbranch, p)
end

function addcbchgbranch(prob::XpressProblem, f_chgbranch, p, priority)
    @checked Lib.XPRSaddcbchgbranch(prob, f_chgbranch, p, priority)
end

function removecbchgbranch(prob::XpressProblem, f_chgbranch, p)
    @checked Lib.XPRSremovecbchgbranch(prob, f_chgbranch, p)
end

function setcbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSsetcbestimate(prob, f_estimate, p)
end

function getcbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSgetcbestimate(prob, f_estimate, p)
end

function addcbestimate(prob::XpressProblem, f_estimate, p, priority)
    @checked Lib.XPRSaddcbestimate(prob, f_estimate, p, priority)
end

function removecbestimate(prob::XpressProblem, f_estimate, p)
    @checked Lib.XPRSremovecbestimate(prob, f_estimate, p)
end

function setcbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSsetcbsepnode(prob, f_sepnode, p)
end

function getcbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSgetcbsepnode(prob, f_sepnode, p)
end

function addcbsepnode(prob::XpressProblem, f_sepnode, p, priority)
    @checked Lib.XPRSaddcbsepnode(prob, f_sepnode, p, priority)
end

function removecbsepnode(prob::XpressProblem, f_sepnode, p)
    @checked Lib.XPRSremovecbsepnode(prob, f_sepnode, p)
end

function setcbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSsetcbmessage(prob, f_message, p)
end

function getcbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSgetcbmessage(prob, f_message, p)
end

function addcbmessage(prob::XpressProblem, f_message, p, priority)
    @checked Lib.XPRSaddcbmessage(prob, f_message, p, priority)
end

function removecbmessage(prob::XpressProblem, f_message, p)
    @checked Lib.XPRSremovecbmessage(prob, f_message, p)
end

function setcbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSsetcbmipthread(prob, f_mipthread, p)
end

function getcbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSgetcbmipthread(prob, f_mipthread, p)
end

function addcbmipthread(prob::XpressProblem, f_mipthread, p, priority)
    @checked Lib.XPRSaddcbmipthread(prob, f_mipthread, p, priority)
end

function removecbmipthread(prob::XpressProblem, f_mipthread, p)
    @checked Lib.XPRSremovecbmipthread(prob, f_mipthread, p)
end

function setcbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSsetcbdestroymt(prob, f_destroymt, p)
end

function getcbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSgetcbdestroymt(prob, f_destroymt, p)
end

function addcbdestroymt(prob::XpressProblem, f_destroymt, p, priority)
    @checked Lib.XPRSaddcbdestroymt(prob, f_destroymt, p, priority)
end

function removecbdestroymt(prob::XpressProblem, f_destroymt, p)
    @checked Lib.XPRSremovecbdestroymt(prob, f_destroymt, p)
end

function setcbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSsetcbnewnode(prob, f_newnode, p)
end

function getcbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSgetcbnewnode(prob, f_newnode, p)
end

function addcbnewnode(prob::XpressProblem, f_newnode, p, priority)
    @checked Lib.XPRSaddcbnewnode(prob, f_newnode, p, priority)
end

function removecbnewnode(prob::XpressProblem, f_newnode, p)
    @checked Lib.XPRSremovecbnewnode(prob, f_newnode, p)
end

function setcbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSsetcbbariteration(prob, f_bariteration, p)
end

function getcbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSgetcbbariteration(prob, f_bariteration, p)
end

function addcbbariteration(prob::XpressProblem, f_bariteration, p, priority)
    @checked Lib.XPRSaddcbbariteration(prob, f_bariteration, p, priority)
end

function removecbbariteration(prob::XpressProblem, f_bariteration, p)
    @checked Lib.XPRSremovecbbariteration(prob, f_bariteration, p)
end

function setcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSsetcbchgbranchobject(prob, f_chgbranchobject, p)
end

function getcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSgetcbchgbranchobject(prob, f_chgbranchobject, p)
end

function addcbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p, priority)
    @checked Lib.XPRSaddcbchgbranchobject(prob, f_chgbranchobject, p, priority)
end

function removecbchgbranchobject(prob::XpressProblem, f_chgbranchobject, p)
    @checked Lib.XPRSremovecbchgbranchobject(prob, f_chgbranchobject, p)
end

function setcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSsetcbgapnotify(prob, f_gapnotify, p)
end

function getcbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSgetcbgapnotify(prob, f_gapnotify, p)
end

function addcbgapnotify(prob::XpressProblem, f_gapnotify, p, priority)
    @checked Lib.XPRSaddcbgapnotify(prob, f_gapnotify, p, priority)
end

function removecbgapnotify(prob::XpressProblem, f_gapnotify, p)
    @checked Lib.XPRSremovecbgapnotify(prob, f_gapnotify, p)
end

function setcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSsetcbusersolnotify(prob, f_usersolnotify, p)
end

function getcbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSgetcbusersolnotify(prob, f_usersolnotify, p)
end

function addcbusersolnotify(prob::XpressProblem, f_usersolnotify, p, priority)
    @checked Lib.XPRSaddcbusersolnotify(prob, f_usersolnotify, p, priority)
end

function removecbusersolnotify(prob::XpressProblem, f_usersolnotify, p)
    @checked Lib.XPRSremovecbusersolnotify(prob, f_usersolnotify, p)
end

function objsa(prob::XpressProblem, ncols, mindex, lower, upper)
    @checked Lib.XPRSobjsa(prob, ncols, mindex, lower, upper)
end

function rhssa(prob::XpressProblem, nrows, mindex, lower, upper)
    @checked Lib.XPRSrhssa(prob, nrows, mindex, lower, upper)
end

function _ge_setcbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_setcbmsghandler(f_msghandler, p)
end

function _ge_getcbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_getcbmsghandler(f_msghandler, p)
end

function _ge_addcbmsghandler(f_msghandler, p, priority)
    @checked Lib.XPRS_ge_addcbmsghandler(f_msghandler, p, priority)
end

function _ge_removecbmsghandler(f_msghandler, p)
    @checked Lib.XPRS_ge_removecbmsghandler(f_msghandler, p)
end

function _ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_ge_getlasterror(iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_create(msp)
    @checked Lib.XPRS_msp_create(msp)
end

function _msp_destroy(msp)
    @checked Lib.XPRS_msp_destroy(msp)
end

function _msp_probattach(msp, prob)
    @checked Lib.XPRS_msp_probattach(msp, prob)
end

function _msp_probdetach(msp, prob)
    @checked Lib.XPRS_msp_probdetach(msp, prob)
end

function _msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
    @checked Lib.XPRS_msp_getsollist(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
    @checked Lib.XPRS_msp_getsollist2(msp, prob_to_rank_against, iRankAttrib, bRankAscending, iRankFirstIndex_Ob, iRankLastIndex_Ob, bUseUserBitFilter, iUserBitMask, iUserBitPattern, bUseInternalBitFilter, iInternalBitMask, iInternalBitPattern, iSolutionIds_Zb, nReturnedSolIds, nSols)
end

function _msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
    @checked Lib.XPRS_msp_getsol(msp, iSolutionId, iSolutionIdStatus_, x, iColFirst, iColLast, nValuesReturned)
end

function _msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
    @checked Lib.XPRS_msp_getslack(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, slack, iRowFirst, iRowLast, nValuesReturned)
end

function _msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
    @checked Lib.XPRS_msp_loadsol(msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
end

function _msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_delsol(msp, iSolutionId, iSolutionIdStatus_)
end

function _msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribprobsol(msp, prob_to_rank_against, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getdblattribprob(msp, prob::XpressProblem, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribprob(msp, prob, iAttribId, Dst)
end

function _msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getintattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
    @checked Lib.XPRS_msp_getdblattribsol(msp, iSolutionId, iSolutionIdStatus_, iAttribId, Dst)
end

function _msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_getintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_getdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_setintcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
    @checked Lib.XPRS_msp_setdblcontrolsol(msp, iSolutionId, iSolutionIdStatus_, iControlId, Val)
end

function _msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    @checked Lib.XPRS_msp_getintattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
    @checked Lib.XPRS_msp_getdblattribprobextreme(msp, prob_to_rank_against, bGet_Max_Otherwise_Min, iSolutionId, iAttribId, ExtremeVal)
end

function _msp_getintattrib(msp, iAttribId, Val)
    @checked Lib.XPRS_msp_getintattrib(msp, iAttribId, Val)
end

function _msp_getdblattrib(msp, iAttribId, Val)
    @checked Lib.XPRS_msp_getdblattrib(msp, iAttribId, Val)
end

function _msp_getintcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_getintcontrol(msp, iControlId, Val)
end

function _msp_getdblcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_getdblcontrol(msp, iControlId, Val)
end

function _msp_setintcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_setintcontrol(msp, iControlId, Val)
end

function _msp_setdblcontrol(msp, iControlId, Val)
    @checked Lib.XPRS_msp_setdblcontrol(msp, iControlId, Val)
end

function _msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_setsolname(msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
end

function _msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
    @checked Lib.XPRS_msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
end

function _msp_findsolbyname(msp, sSolutionName, iSolutionId)
    @checked Lib.XPRS_msp_findsolbyname(msp, sSolutionName, iSolutionId)
end

function _msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
    @checked Lib.XPRS_msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
end

function _msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
    @checked Lib.XPRS_msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
end

function _msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _msp_setcbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_setcbmsghandler(msp, f_msghandler, p)
end

function _msp_getcbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_getcbmsghandler(msp, f_msghandler, p)
end

function _msp_addcbmsghandler(msp, f_msghandler, p, priority)
    @checked Lib.XPRS_msp_addcbmsghandler(msp, f_msghandler, p, priority)
end

function _msp_removecbmsghandler(msp, f_msghandler, p)
    @checked Lib.XPRS_msp_removecbmsghandler(msp, f_msghandler, p)
end

function _nml_create(r_nl)
    @checked Lib.XPRS_nml_create(r_nl)
end

function _nml_destroy(nml)
    @checked Lib.XPRS_nml_destroy(nml)
end

function _nml_getnamecount(nml, count)
    @checked Lib.XPRS_nml_getnamecount(nml, count)
end

function _nml_getmaxnamelen(nml, namlen)
    @checked Lib.XPRS_nml_getmaxnamelen(nml, namlen)
end

function _nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_getnames(nml, padlen, buf, buflen, r_buflen_reqd, firstIndex, lastIndex)
end

function _nml_addnames(nml, buf, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_addnames(nml, buf, firstIndex, lastIndex)
end

function _nml_removenames(nml, firstIndex, lastIndex)
    @checked Lib.XPRS_nml_removenames(nml, firstIndex, lastIndex)
end

function _nml_findname(nml, name, r_index)
    @checked Lib.XPRS_nml_findname(nml, name, r_index)
end

function _nml_copynames(dst, src)
    @checked Lib.XPRS_nml_copynames(dst, src)
end

function _nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_nml_getlasterror(nml, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function getqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    @checked Lib.XPRSgetqrowcoeff(prob, irow, icol, jcol, dval)
end

function getqrowqmatrix(prob::XpressProblem, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first::Integer, last::Integer)
    @checked Lib.XPRSgetqrowqmatrix(prob, irow, mstart, mclind, dobjval, maxcoeffs, ncoeffs, first, last)
end

function getqrowqmatrixtriplets(prob::XpressProblem, irow)
    _, qcrows = getqrows(prob)
    nqelem = Ref{Cint}()
    @checked Lib.XPRSgetqrowqmatrixtriplets(prob, qcrows[irow], nqelem, C_NULL, C_NULL, C_NULL)
    mqcol1 = Array{Cint}(undef,  nqelem[])
    mqcol2 = Array{Cint}(undef,  nqelem[])
    dqe = Array{Float64}(undef,  nqelem[])
    @checked Lib.XPRSgetqrowqmatrixtriplets(prob, qcrows[irow], nqelem, mqcol1, mqcol2, dqe)
    mqcol1 .+= 1
    mqcol2 .+= 1
    return mqcol1, mqcol2, dqe
end

function chgqrowcoeff(prob::XpressProblem, irow, icol, jcol, dval)
    @checked Lib.XPRSchgqrowcoeff(prob, irow, icol, jcol, dval)
end

function getqrows(prob::XpressProblem)
    qmn = Ref{Cint}()
    @checked Lib.XPRSgetqrows(prob, qmn, C_NULL)
    qcrows = Array{Cint}(undef, qmn[])
    @checked Lib.XPRSgetqrows(prob, qmn, qcrows)
    return qmn[], qcrows
end

function addqmatrix(prob::XpressProblem, mqc1, mqc2, dqew)
    irow = Xpress.n_constraints(prob)
    @checked Lib.XPRSaddqmatrix(prob, irow - 1, length(mqc1), mqc1 .- 1, mqc2 .- 1, dqew)
end

# # Disable 64Bit versions do to reliability issues.
# function addqmatrix(prob::XpressProblem, irow::Int64, nqtr::Int64, mqc1::Int64, mqc2::Int64, dqew)
#    @checked Lib.XPRSaddqmatrix64(prob, irow, nqtr, mqc1, mqc2, dqew)
# end

function delqmatrix(prob::XpressProblem, irow)
    @checked Lib.XPRSdelqmatrix(prob, irow)
end

function loadqcqp(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    @checked Lib.XPRSloadqcqp(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function loadqcqp64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
    @checked Lib.XPRSloadqcqp64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _mstart, _mnel, _mrwind, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval)
end

function loadqcqpglobal(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqcqpglobal(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function loadqcqpglobal64(prob::XpressProblem, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
    @checked Lib.XPRSloadqcqpglobal64(prob, _sprobname, ncols, nrows, _srowtypes, _drhs, _drange, _dobj, _matbeg, _matcnt, _matrow, _dmatval, _dlb, _dub, nquads, _mqcol1, _mqcol2, _dqval, qmn, qcrows, qcnquads, qcmqcol1, qcmqcol2, qcdqval, ngents, nsets, qgtype, mgcols, dlim, qstype, msstart, mscols, dref)
end

function _mse_create(mse)
    @checked Lib.XPRS_mse_create(mse)
end

function _mse_destroy(mse)
    @checked Lib.XPRS_mse_destroy(mse)
end

function _mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
    @checked Lib.XPRS_mse_getsollist(mse, iMetricId, iRankFirstIndex_Ob, iRankLastIndex_Ob, iSolutionIds, nReturnedSolIds, nSols)
end

function _mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
    @checked Lib.XPRS_mse_getsolmetric(mse, iSolutionId, iSolutionIdStatus, iMetricId, dMetric)
end

function _mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
    @checked Lib.XPRS_mse_getcullchoice(mse, iMetricId, cull_sol_id_list, nMaxSolsToCull, nSolsToCull, dNewSolMetric, x, nCols, bRejectSoln)
end

function _mse_minim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_minim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_maxim(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_maxim(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_opt(mse, prob::XpressProblem, msp, f_mse_handler, p, nMaxSols)
    @checked Lib.XPRS_mse_opt(mse, prob, msp, f_mse_handler, p, nMaxSols)
end

function _mse_getintattrib(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getintattrib(mse, iAttribId, Val)
end

function _mse_getdblattrib(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getdblattrib(mse, iAttribId, Val)
end

function _mse_getintcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getintcontrol(mse, iAttribId, Val)
end

function _mse_getdblcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_getdblcontrol(mse, iAttribId, Val)
end

function _mse_setintcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_setintcontrol(mse, iAttribId, Val)
end

function _mse_setdblcontrol(mse, iAttribId, Val)
    @checked Lib.XPRS_mse_setdblcontrol(mse, iAttribId, Val)
end

function _mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_mse_getlasterror(mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setsolbasename(mse, sSolutionBaseName)
    @checked Lib.XPRS_mse_setsolbasename(mse, sSolutionBaseName)
end

function _mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
end

function _mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_setcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_getcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
    @checked Lib.XPRS_mse_addcbgetsolutiondiff(mse, f_mse_getsolutiondiff, p, priority)
end

function _mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
    @checked Lib.XPRS_mse_removecbgetsolutiondiff(mse, f_mse_getsolutiondiff, p)
end

function _mse_setcbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_setcbmsghandler(mse, f_msghandler, p)
end

function _mse_getcbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_getcbmsghandler(mse, f_msghandler, p)
end

function _mse_addcbmsghandler(mse, f_msghandler, p, priority)
    @checked Lib.XPRS_mse_addcbmsghandler(mse, f_msghandler, p, priority)
end

function _mse_removecbmsghandler(mse, f_msghandler, p)
    @checked Lib.XPRS_mse_removecbmsghandler(mse, f_msghandler, p)
end

function _bo_create(p_object, prob::XpressProblem, isoriginal)
    @checked Lib.XPRS_bo_create(p_object, prob, isoriginal)
end

function _bo_destroy(obranch)
    @checked Lib.XPRS_bo_destroy(obranch)
end

function _bo_store(obranch, p_status)
    @checked Lib.XPRS_bo_store(obranch, p_status)
end

function _bo_addbranches(obranch, nbranches)
    @checked Lib.XPRS_bo_addbranches(obranch, nbranches)
end

function _bo_getbranches(obranch, p_nbranches)
    @checked Lib.XPRS_bo_getbranches(obranch, p_nbranches)
end

function _bo_setpriority(obranch, ipriority)
    @checked Lib.XPRS_bo_setpriority(obranch, ipriority)
end

function _bo_setpreferredbranch(obranch, ibranch)
    @checked Lib.XPRS_bo_setpreferredbranch(obranch, ibranch)
end

function _bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
    @checked Lib.XPRS_bo_addbounds(obranch, ibranch, nbounds, cbndtype, mbndcol, dbndval)
end

function _bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
    @checked Lib.XPRS_bo_getbounds(obranch, ibranch, p_nbounds, nbounds_size, cbndtype, mbndcol, dbndval)
end

function _bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
    @checked Lib.XPRS_bo_addrows(obranch, ibranch, nrows, nelems, crtype, drrhs, mrbeg, mcol, dval)
end

function _bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
    @checked Lib.XPRS_bo_getrows(obranch, ibranch, p_nrows, nrows_size, p_nelems, nelems_size, crtype, drrhs, mrbeg, mcol, dval)
end

function _bo_addcuts(obranch, ibranch, ncuts, mcutind)
    @checked Lib.XPRS_bo_addcuts(obranch, ibranch, ncuts, mcutind)
end

function _bo_getid(obranch, p_id)
    @checked Lib.XPRS_bo_getid(obranch, p_id)
end

function _bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    @checked Lib.XPRS_bo_getlasterror(obranch, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function _bo_validate(obranch, p_status)
    @checked Lib.XPRS_bo_validate(obranch, p_status)
end

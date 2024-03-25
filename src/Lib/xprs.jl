# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.
#
# Automatically generated using scripts/generate.jl
#
#! format: off

"""
*************************************************************************\\ Object and reference types *\\**************************************************************************
"""
const XPRSobject = Ptr{Cvoid}

# Struct does not exist in v33
const XPRSfunctionptr = Ptr{Cvoid}

# Struct does not exist in v33
const XPRSfunctionptraddr = Ptr{XPRSfunctionptr}

const XPRSprob = Ptr{Cvoid}

const XPRSglobalenv = Ptr{Cvoid}

const XPRSmipsolpool = Ptr{Cvoid}

const XPRSmessagingadmin = Ptr{Cvoid}

const XPRSnamelist = Ptr{Cvoid}

const XPRSmipsolenum = Ptr{Cvoid}

const XPRSbranchobject = Ptr{Cvoid}

const XPRScut = Ptr{Cvoid}

const XPRSnode = Ptr{Cvoid}

# Struct does not exist in v33
const XPRS_MAP = Cvoid

# Struct does not exist in v33
const XPRS_VECMAP = Cvoid

# Struct does not exist in v33
const XPRS_MULTIMAP = Cvoid

# Struct does not exist in v33
const XPRS_MAPDELTA = Cvoid

# Struct does not exist in v33
const XPRS_VECMAPDELTA = Cvoid

# Struct does not exist in v33
const XPRS_MULTIMAPDELTA = Cvoid

struct var"##Ctag#318"
    data::NTuple{8, UInt8}
end

# Function does not exist in v33
function Base.getproperty(x::Ptr{var"##Ctag#318"}, f::Symbol)
    f === :integer && return Ptr{Cint}(x + 0)
    f === :real && return Ptr{Cdouble}(x + 0)
    return getfield(x, f)
end

# Function does not exist in v33
function Base.getproperty(x::var"##Ctag#318", f::Symbol)
    r = Ref{var"##Ctag#318"}(x)
    ptr = Base.unsafe_convert(Ptr{var"##Ctag#318"}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

# Function does not exist in v33
function Base.setproperty!(x::Ptr{var"##Ctag#318"}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

struct xo_alltypes
    data::NTuple{16, UInt8}
end

# Function does not exist in v33
function Base.getproperty(x::Ptr{xo_alltypes}, f::Symbol)
    f === :value && return Ptr{var"##Ctag#318"}(x + 0)
    f === :type && return Ptr{Cvoid}(x + 8)
    return getfield(x, f)
end

# Function does not exist in v33
function Base.getproperty(x::xo_alltypes, f::Symbol)
    r = Ref{xo_alltypes}(x)
    ptr = Base.unsafe_convert(Ptr{xo_alltypes}, r)
    fptr = getproperty(ptr, f)
    GC.@preserve r unsafe_load(fptr)
end

# Function does not exist in v33
function Base.setproperty!(x::Ptr{xo_alltypes}, f::Symbol, v)
    unsafe_store!(getproperty(x, f), v)
end

# Struct does not exist in v33
const XPRSalltype = xo_alltypes

function XPRScopycallbacks(dest, src)
    ccall((:XPRScopycallbacks, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopycontrols(dest, src)
    ccall((:XPRScopycontrols, libxprs), Cint, (XPRSprob, XPRSprob), dest, src)
end

function XPRScopyprob(dest, src, name)
    ccall((:XPRScopyprob, libxprs), Cint, (XPRSprob, XPRSprob, Ptr{UInt8}), dest, src, name)
end

function XPRScreateprob(p_prob)
    ccall((:XPRScreateprob, libxprs), Cint, (Ptr{XPRSprob},), p_prob)
end

function XPRSdestroyprob(prob)
    ccall((:XPRSdestroyprob, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSinit(path)
    ccall((:XPRSinit, libxprs), Cint, (Ptr{UInt8},), path)
end

function XPRSfree()
    ccall((:XPRSfree, libxprs), Cint, ())
end

function XPRSgetlicerrmsg(buffer, maxbytes)
    ccall((:XPRSgetlicerrmsg, libxprs), Cint, (Ptr{UInt8}, Cint), buffer, maxbytes)
end

function XPRSlicense(p_i, p_c)
    ccall((:XPRSlicense, libxprs), Cint, (Ptr{Cint}, Ptr{UInt8}), p_i, p_c)
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
    ccall((:XPRSgetbanner, libxprs), Cint, (Ptr{UInt8},), banner)
end

function XPRSgetversion(version)
    ccall((:XPRSgetversion, libxprs), Cint, (Ptr{UInt8},), version)
end

# Function does not exist in v33
function XPRSgetversionnumbers(p_major, p_minor, p_build)
    ccall((:XPRSgetversionnumbers, libxprs), Cint, (Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), p_major, p_minor, p_build)
end

function XPRSgetdaysleft(p_daysleft)
    ccall((:XPRSgetdaysleft, libxprs), Cint, (Ptr{Cint},), p_daysleft)
end

function XPRSfeaturequery(feature, p_status)
    ccall((:XPRSfeaturequery, libxprs), Cint, (Ptr{UInt8}, Ptr{Cint}), feature, p_status)
end

function XPRSsetprobname(prob, probname)
    ccall((:XPRSsetprobname, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, probname)
end

function XPRSsetlogfile(prob, filename)
    ccall((:XPRSsetlogfile, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, filename)
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
    ccall((:XPRSgetprobname, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, name)
end

function XPRSsetintcontrol(prob, control, value)
    ccall((:XPRSsetintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint), prob, control, value)
end

function XPRSsetintcontrol64(prob, control, value)
    ccall((:XPRSsetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Clong), prob, control, value)
end

function XPRSsetdblcontrol(prob, control, value)
    ccall((:XPRSsetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cdouble), prob, control, value)
end

function XPRSsetstrcontrol(prob, control, value)
    ccall((:XPRSsetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}), prob, control, value)
end

function XPRSgetintcontrol(prob, control, p_value)
    ccall((:XPRSgetintcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, control, p_value)
end

function XPRSgetintcontrol64(prob, control, p_value)
    ccall((:XPRSgetintcontrol64, libxprs), Cint, (XPRSprob, Cint, Ptr{Clong}), prob, control, p_value)
end

function XPRSgetdblcontrol(prob, control, p_value)
    ccall((:XPRSgetdblcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, control, p_value)
end

function XPRSgetstrcontrol(prob, control, value)
    ccall((:XPRSgetstrcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}), prob, control, value)
end

function XPRSgetstringcontrol(prob, control, value, maxbytes, p_nbytes)
    ccall((:XPRSgetstringcontrol, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{Cint}), prob, control, value, maxbytes, p_nbytes)
end

function XPRSgetintattrib(prob, attrib, p_value)
    ccall((:XPRSgetintattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, attrib, p_value)
end

function XPRSgetintattrib64(prob, attrib, p_value)
    ccall((:XPRSgetintattrib64, libxprs), Cint, (XPRSprob, Cint, Ptr{Clong}), prob, attrib, p_value)
end

function XPRSgetstrattrib(prob, attrib, value)
    ccall((:XPRSgetstrattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}), prob, attrib, value)
end

function XPRSgetstringattrib(prob, attrib, value, maxbytes, p_nbytes)
    ccall((:XPRSgetstringattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{Cint}), prob, attrib, value, maxbytes, p_nbytes)
end

function XPRSgetdblattrib(prob, attrib, p_value)
    ccall((:XPRSgetdblattrib, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, attrib, p_value)
end

function XPRSgetcontrolinfo(prob, name, p_id, p_type)
    ccall((:XPRSgetcontrolinfo, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), prob, name, p_id, p_type)
end

function XPRSgetattribinfo(prob, name, p_id, p_type)
    ccall((:XPRSgetattribinfo, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), prob, name, p_id, p_type)
end

# Function does not exist in v33
function XPRSsetobjintcontrol(prob, objidx, control, value)
    ccall((:XPRSsetobjintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Cint), prob, objidx, control, value)
end

# Function does not exist in v33
function XPRSsetobjdblcontrol(prob, objidx, control, value)
    ccall((:XPRSsetobjdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Cdouble), prob, objidx, control, value)
end

# Function does not exist in v33
function XPRSgetobjintcontrol(prob, objidx, control, p_value)
    ccall((:XPRSgetobjintcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}), prob, objidx, control, p_value)
end

# Function does not exist in v33
function XPRSgetobjdblcontrol(prob, objidx, control, p_value)
    ccall((:XPRSgetobjdblcontrol, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, objidx, control, p_value)
end

# Function does not exist in v33
function XPRSgetobjintattrib(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjintattrib, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}), prob, solveidx, attrib, p_value)
end

# Function does not exist in v33
function XPRSgetobjintattrib64(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjintattrib64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Clong}), prob, solveidx, attrib, p_value)
end

# Function does not exist in v33
function XPRSgetobjdblattrib(prob, solveidx, attrib, p_value)
    ccall((:XPRSgetobjdblattrib, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, solveidx, attrib, p_value)
end

function XPRSgetqobj(prob, objqcol1, objqcol2, p_objqcoef)
    ccall((:XPRSgetqobj, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, objqcol1, objqcol2, p_objqcoef)
end

function XPRSreadprob(prob, filename, flags)
    ccall((:XPRSreadprob, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSloadlp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
    ccall((:XPRSloadlp, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
end

function XPRSloadlp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
    ccall((:XPRSloadlp64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub)
end

function XPRSloadqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSloadqp, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSloadqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSloadqp64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef)
end

# Function does not exist in v33
function XPRSloadmiqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqp, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

# Function does not exist in v33
function XPRSloadmiqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqp64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

# Function does not exist in v33
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
    ccall((:XPRSloadmip, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

# Function does not exist in v33
function XPRSloadmip64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmip64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
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
    ccall((:XPRSreaddirs, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, filename)
end

function XPRSwritedirs(prob, filename)
    ccall((:XPRSwritedirs, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, filename)
end

# Function does not exist in v33
function XPRSunloadprob(prob)
    ccall((:XPRSunloadprob, libxprs), Cint, (XPRSprob,), prob)
end

function XPRSsetindicators(prob, nrows, rowind, colind, complement)
    ccall((:XPRSsetindicators, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, nrows, rowind, colind, complement)
end

# Function does not exist in v33
function XPRSaddpwlcons(prob, npwls, npoints, colind, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, colind, resultant, start, xval, yval)
end

# Function does not exist in v33
function XPRSaddpwlcons64(prob, npwls, npoints, colind, resultant, start, xval, yval)
    ccall((:XPRSaddpwlcons64, libxprs), Cint, (XPRSprob, Cint, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}, Ptr{Cdouble}, Ptr{Cdouble}), prob, npwls, npoints, colind, resultant, start, xval, yval)
end

# Function does not exist in v33
function XPRSgetpwlcons(prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
    ccall((:XPRSgetpwlcons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
end

# Function does not exist in v33
function XPRSgetpwlcons64(prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
    ccall((:XPRSgetpwlcons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Clong}, Cint, Cint), prob, colind, resultant, start, xval, yval, maxpoints, p_npoints, first, last)
end

# Function does not exist in v33
function XPRSaddgencons(prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
    ccall((:XPRSaddgencons, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
end

# Function does not exist in v33
function XPRSaddgencons64(prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
    ccall((:XPRSaddgencons64, libxprs), Cint, (XPRSprob, Cint, Clong, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}, Ptr{Cint}, Ptr{Clong}, Ptr{Cdouble}), prob, ncons, ncols, nvals, contype, resultant, colstart, colind, valstart, val)
end

# Function does not exist in v33
function XPRSgetgencons(prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
    ccall((:XPRSgetgencons, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
end

# Function does not exist in v33
function XPRSgetgencons64(prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
    ccall((:XPRSgetgencons64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Clong}, Ptr{Cint}, Clong, Ptr{Clong}, Ptr{Clong}, Ptr{Cdouble}, Clong, Ptr{Clong}, Cint, Cint), prob, contype, resultant, colstart, colind, maxcols, p_ncols, valstart, val, maxvals, p_nvals, first, last)
end

# Function does not exist in v33
function XPRSdelpwlcons(prob, npwls, pwlind)
    ccall((:XPRSdelpwlcons, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, npwls, pwlind)
end

# Function does not exist in v33
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

function XPRSgetscale(prob, rowscale, colscale)
    ccall((:XPRSgetscale, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowscale, colscale)
end

function XPRSlpoptimize(prob, flags)
    ccall((:XPRSlpoptimize, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

function XPRSmipoptimize(prob, flags)
    ccall((:XPRSmipoptimize, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

# Function does not exist in v33
function XPRSoptimize(prob, flags, solvestatus, solstatus)
    ccall((:XPRSoptimize, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), prob, flags, solvestatus, solstatus)
end

function XPRSreadslxsol(prob, filename, flags)
    ccall((:XPRSreadslxsol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSalter(prob, filename)
    ccall((:XPRSalter, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, filename)
end

function XPRSreadbasis(prob, filename, flags)
    ccall((:XPRSreadbasis, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSreadbinsol(prob, filename, flags)
    ccall((:XPRSreadbinsol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
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
    ccall((:XPRStune, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

# Function does not exist in v33
function XPRStuneprobsetfile(prob, setfile, ifmip, sense)
    ccall((:XPRStuneprobsetfile, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint), prob, setfile, ifmip, sense)
end

function XPRStunerwritemethod(prob, methodfile)
    ccall((:XPRStunerwritemethod, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, methodfile)
end

function XPRStunerreadmethod(prob, methodfile)
    ccall((:XPRStunerreadmethod, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, methodfile)
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

# Function does not exist in v33
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
    ccall((:XPRSgetcols64, libxprs), Cint, (XPRSprob, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}, Clong, Ptr{Clong}, Cint, Cint), prob, start, rowind, rowcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetrows(prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetrows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Cint, Cint), prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSgetrows64(prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
    ccall((:XPRSgetrows64, libxprs), Cint, (XPRSprob, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}, Clong, Ptr{Clong}, Cint, Cint), prob, start, colind, colcoef, maxcoefs, p_ncoefs, first, last)
end

# Function does not exist in v33
function XPRSgetrowflags(prob, flags, first, last)
    ccall((:XPRSgetrowflags, libxprs), Cint, (XPRSprob, Ptr{Cint}, Cint, Cint), prob, flags, first, last)
end

# Function does not exist in v33
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
    ccall((:XPRSgetmqobj64, libxprs), Cint, (XPRSprob, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}, Clong, Ptr{Clong}, Cint, Cint), prob, start, colind, objqcoef, maxcoefs, p_ncoefs, first, last)
end

function XPRSwritebasis(prob, filename, flags)
    ccall((:XPRSwritebasis, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSwritesol(prob, filename, flags)
    ccall((:XPRSwritesol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSwritebinsol(prob, filename, flags)
    ccall((:XPRSwritebinsol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSwriteprtsol(prob, filename, flags)
    ccall((:XPRSwriteprtsol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSwriteslxsol(prob, filename, flags)
    ccall((:XPRSwriteslxsol, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
end

function XPRSgetpresolvesol(prob, x, slack, duals, djs)
    ccall((:XPRSgetpresolvesol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

# Function does not exist in v33
function XPRSgetsolution(prob, status, x, first, last)
    ccall((:XPRSgetsolution, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, x, first, last)
end

# Function does not exist in v33
function XPRSgetslacks(prob, status, slacks, first, last)
    ccall((:XPRSgetslacks, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, slacks, first, last)
end

# Function does not exist in v33
function XPRSgetduals(prob, status, duals, first, last)
    ccall((:XPRSgetduals, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint), prob, status, duals, first, last)
end

# Function does not exist in v33
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
    ccall((:XPRSiiswrite, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{UInt8}), prob, iis, filename, filetype, flags)
end

function XPRSiisisolations(prob, iis)
    ccall((:XPRSiisisolations, libxprs), Cint, (XPRSprob, Cint), prob, iis)
end

function XPRSgetiisdata(prob, iis, p_nrows, p_ncols, rowind, colind, contype, bndtype, duals, djs, isolationrows, isolationcols)
    ccall((:XPRSgetiisdata, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{UInt8}), prob, iis, p_nrows, p_ncols, rowind, colind, contype, bndtype, duals, djs, isolationrows, isolationcols)
end

function XPRSloadpresolvebasis(prob, rowstat, colstat)
    ccall((:XPRSloadpresolvebasis, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, rowstat, colstat)
end

# Function does not exist in v33
function XPRSgetmipentities(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetmipentities, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

# Function does not exist in v33
function XPRSgetmipentities64(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetmipentities64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

function XPRSloadsecurevecs(prob, nrows, ncols, rowind, colind)
    ccall((:XPRSloadsecurevecs, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}), prob, nrows, ncols, rowind, colind)
end

function XPRSaddrows(prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
    ccall((:XPRSaddrows, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
end

function XPRSaddrows64(prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
    ccall((:XPRSaddrows64, libxprs), Cint, (XPRSprob, Cint, Clong, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, nrows, ncoefs, rowtype, rhs, rng, start, colind, rowcoef)
end

function XPRSdelrows(prob, nrows, rowind)
    ccall((:XPRSdelrows, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nrows, rowind)
end

function XPRSaddcols(prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
    ccall((:XPRSaddcols, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
end

function XPRSaddcols64(prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
    ccall((:XPRSaddcols64, libxprs), Cint, (XPRSprob, Cint, Clong, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, ncoefs, objcoef, start, rowind, rowcoef, lb, ub)
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
    ccall((:XPRSaddsets64, libxprs), Cint, (XPRSprob, Cint, Clong, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, nsets, nelems, settype, start, colind, refval)
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

# Function does not exist in v33
function XPRSsaveas(prob, sSaveFileName)
    ccall((:XPRSsaveas, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, sSaveFileName)
end

function XPRSrestore(prob, probname, flags)
    ccall((:XPRSrestore, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, probname, flags)
end

function XPRSpivot(prob, enter, leave)
    ccall((:XPRSpivot, libxprs), Cint, (XPRSprob, Cint, Cint), prob, enter, leave)
end

function XPRSloadlpsol(prob, x, slack, duals, djs, p_status)
    ccall((:XPRSloadlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, x, slack, duals, djs, p_status)
end

function XPRSlogfilehandler(xprsobj, cbdata, thread, msg, msgtype, msgcode)
    ccall((:XPRSlogfilehandler, libxprs), Cint, (XPRSobject, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{UInt8}, Cint, Cint), xprsobj, cbdata, thread, msg, msgtype, msgcode)
end

function XPRSrepairweightedinfeas(prob, p_status, lepref, gepref, lbpref, ubpref, phase2, delta, flags)
    ccall((:XPRSrepairweightedinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Ptr{UInt8}), prob, p_status, lepref, gepref, lbpref, ubpref, phase2, delta, flags)
end

function XPRSrepairweightedinfeasbounds(prob, p_status, lepref, gepref, lbpref, ubpref, lerelax, gerelax, lbrelax, ubrelax, phase2, delta, flags)
    ccall((:XPRSrepairweightedinfeasbounds, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, UInt8, Cdouble, Ptr{UInt8}), prob, p_status, lepref, gepref, lbpref, ubpref, lerelax, gerelax, lbrelax, ubrelax, phase2, delta, flags)
end

function XPRSrepairinfeas(prob, p_status, penalty, phase2, flags, lepref, gepref, lbpref, ubpref, delta)
    ccall((:XPRSrepairinfeas, libxprs), Cint, (XPRSprob, Ptr{Cint}, UInt8, UInt8, UInt8, Cdouble, Cdouble, Cdouble, Cdouble, Cdouble), prob, p_status, penalty, phase2, flags, lepref, gepref, lbpref, ubpref, delta)
end

function XPRSbasisstability(prob, type, norm, scaled, p_value)
    ccall((:XPRSbasisstability, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cdouble}), prob, type, norm, scaled, p_value)
end

function XPRSgetindex(prob, type, name, p_index)
    ccall((:XPRSgetindex, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Ptr{Cint}), prob, type, name, p_index)
end

function XPRSgetlasterror(prob, errmsg)
    ccall((:XPRSgetlasterror, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, errmsg)
end

function XPRSgetobjecttypename(xprsobj, p_name)
    ccall((:XPRSgetobjecttypename, libxprs), Cint, (XPRSobject, Ptr{Ptr{UInt8}}), xprsobj, p_name)
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
    ccall((:XPRSaddcuts64, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, cuttype, rowtype, rhs, start, colind, cutcoef)
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
    ccall((:XPRSgetcpcuts64, libxprs), Cint, (XPRSprob, Ptr{XPRScut}, Cint, Clong, Ptr{Cint}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, rowind, ncuts, maxcoefs, cuttype, rowtype, start, colind, cutcoef, rhs)
end

function XPRSloadcuts(prob, cuttype, interp, ncuts, cutind)
    ccall((:XPRSloadcuts, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{XPRScut}), prob, cuttype, interp, ncuts, cutind)
end

function XPRSstorecuts(prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
    ccall((:XPRSstorecuts, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cint}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
end

function XPRSstorecuts64(prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
    ccall((:XPRSstorecuts64, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Clong}, Ptr{XPRScut}, Ptr{Cint}, Ptr{Cdouble}), prob, ncuts, nodups, cuttype, rowtype, rhs, start, cutind, colind, cutcoef)
end

function XPRSpresolverow(prob, rowtype, norigcoefs, origcolind, origrowcoef, origrhs, maxcoefs, p_ncoefs, colind, rowcoef, p_rhs, p_status)
    ccall((:XPRSpresolverow, libxprs), Cint, (XPRSprob, UInt8, Cint, Ptr{Cint}, Ptr{Cdouble}, Cdouble, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, rowtype, norigcoefs, origcolind, origrowcoef, origrhs, maxcoefs, p_ncoefs, colind, rowcoef, p_rhs, p_status)
end

# Function does not exist in v33
function XPRSpostsolvesol(prob, prex, origx)
    ccall((:XPRSpostsolvesol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, prex, origx)
end

function XPRSgetpivots(prob, enter, outlist, x, p_objval, p_npivots, maxpivots)
    ccall((:XPRSgetpivots, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Cint), prob, enter, outlist, x, p_objval, p_npivots, maxpivots)
end

function XPRSwriteprob(prob, filename, flags)
    ccall((:XPRSwriteprob, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}), prob, filename, flags)
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

# Function does not exist in v33
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
    ccall((:XPRSaddmipsol, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}, Ptr{Cint}, Ptr{UInt8}), prob, length, solval, colind, name)
end

function XPRSgetcutslack(prob, cutind, p_slack)
    ccall((:XPRSgetcutslack, libxprs), Cint, (XPRSprob, XPRScut, Ptr{Cdouble}), prob, cutind, p_slack)
end

function XPRSgetcutmap(prob, ncuts, cutind, cutmap)
    ccall((:XPRSgetcutmap, libxprs), Cint, (XPRSprob, Cint, Ptr{XPRScut}, Ptr{Cint}), prob, ncuts, cutind, cutmap)
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
    ccall((:XPRSchgmcoef64, libxprs), Cint, (XPRSprob, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, rowcoef)
end

function XPRSchgmqobj(prob, ncoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSchgmqobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, objqcol1, objqcol2, objqcoef)
end

function XPRSchgmqobj64(prob, ncoefs, objqcol1, objqcol2, objqcoef)
    ccall((:XPRSchgmqobj64, libxprs), Cint, (XPRSprob, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, objqcol1, objqcol2, objqcoef)
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

# Function does not exist in v33
function XPRSaddobj(prob, ncols, colind, objcoef, priority, weight)
    ccall((:XPRSaddobj, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Cdouble), prob, ncols, colind, objcoef, priority, weight)
end

# Function does not exist in v33
function XPRSchgobjn(prob, objidx, ncols, colind, objcoef)
    ccall((:XPRSchgobjn, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, objidx, ncols, colind, objcoef)
end

# Function does not exist in v33
function XPRSdelobj(prob, objidx)
    ccall((:XPRSdelobj, libxprs), Cint, (XPRSprob, Cint), prob, objidx)
end

function XPRSsetcblplog(prob, lplog, data)
    ccall((:XPRSsetcblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, lplog, data)
end

function XPRSgetcblplog(prob, lplog, data)
    ccall((:XPRSgetcblplog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, lplog, data)
end

function XPRSaddcblplog(prob, lplog, data, priority)
    ccall((:XPRSaddcblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, lplog, data, priority)
end

function XPRSremovecblplog(prob, lplog, data)
    ccall((:XPRSremovecblplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, lplog, data)
end

# Function does not exist in v33
function XPRSsetcbmiplog(prob, miplog, data)
    ccall((:XPRSsetcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, miplog, data)
end

# Function does not exist in v33
function XPRSgetcbmiplog(prob, miplog, data)
    ccall((:XPRSgetcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, miplog, data)
end

# Function does not exist in v33
function XPRSaddcbmiplog(prob, miplog, data, priority)
    ccall((:XPRSaddcbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, miplog, data, priority)
end

# Function does not exist in v33
function XPRSremovecbmiplog(prob, miplog, data)
    ccall((:XPRSremovecbmiplog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, miplog, data)
end

function XPRSsetcbcutlog(prob, cutlog, data)
    ccall((:XPRSsetcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, cutlog, data)
end

function XPRSgetcbcutlog(prob, cutlog, data)
    ccall((:XPRSgetcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, cutlog, data)
end

function XPRSaddcbcutlog(prob, cutlog, data, priority)
    ccall((:XPRSaddcbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, cutlog, data, priority)
end

function XPRSremovecbcutlog(prob, cutlog, data)
    ccall((:XPRSremovecbcutlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, cutlog, data)
end

function XPRSsetcbbarlog(prob, barlog, data)
    ccall((:XPRSsetcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, barlog, data)
end

function XPRSgetcbbarlog(prob, barlog, data)
    ccall((:XPRSgetcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, barlog, data)
end

function XPRSaddcbbarlog(prob, barlog, data, priority)
    ccall((:XPRSaddcbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, barlog, data, priority)
end

function XPRSremovecbbarlog(prob, barlog, data)
    ccall((:XPRSremovecbbarlog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, barlog, data)
end

function XPRSsetcboptnode(prob, optnode, data)
    ccall((:XPRSsetcboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, optnode, data)
end

function XPRSgetcboptnode(prob, optnode, data)
    ccall((:XPRSgetcboptnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, optnode, data)
end

function XPRSaddcboptnode(prob, optnode, data, priority)
    ccall((:XPRSaddcboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, optnode, data, priority)
end

function XPRSremovecboptnode(prob, optnode, data)
    ccall((:XPRSremovecboptnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, optnode, data)
end

function XPRSsetcbprenode(prob, prenode, data)
    ccall((:XPRSsetcbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, prenode, data)
end

function XPRSgetcbprenode(prob, prenode, data)
    ccall((:XPRSgetcbprenode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, prenode, data)
end

function XPRSaddcbprenode(prob, prenode, data, priority)
    ccall((:XPRSaddcbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, prenode, data, priority)
end

function XPRSremovecbprenode(prob, prenode, data)
    ccall((:XPRSremovecbprenode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, prenode, data)
end

function XPRSsetcbinfnode(prob, infnode, data)
    ccall((:XPRSsetcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, infnode, data)
end

function XPRSgetcbinfnode(prob, infnode, data)
    ccall((:XPRSgetcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, infnode, data)
end

function XPRSaddcbinfnode(prob, infnode, data, priority)
    ccall((:XPRSaddcbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, infnode, data, priority)
end

function XPRSremovecbinfnode(prob, infnode, data)
    ccall((:XPRSremovecbinfnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, infnode, data)
end

function XPRSsetcbnodecutoff(prob, nodecutoff, data)
    ccall((:XPRSsetcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nodecutoff, data)
end

function XPRSgetcbnodecutoff(prob, nodecutoff, data)
    ccall((:XPRSgetcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, nodecutoff, data)
end

function XPRSaddcbnodecutoff(prob, nodecutoff, data, priority)
    ccall((:XPRSaddcbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, nodecutoff, data, priority)
end

function XPRSremovecbnodecutoff(prob, nodecutoff, data)
    ccall((:XPRSremovecbnodecutoff, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nodecutoff, data)
end

function XPRSsetcbintsol(prob, intsol, data)
    ccall((:XPRSsetcbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, intsol, data)
end

function XPRSgetcbintsol(prob, intsol, data)
    ccall((:XPRSgetcbintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, intsol, data)
end

function XPRSaddcbintsol(prob, intsol, data, priority)
    ccall((:XPRSaddcbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, intsol, data, priority)
end

function XPRSremovecbintsol(prob, intsol, data)
    ccall((:XPRSremovecbintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, intsol, data)
end

function XPRSsetcbpreintsol(prob, preintsol, data)
    ccall((:XPRSsetcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, preintsol, data)
end

function XPRSgetcbpreintsol(prob, preintsol, data)
    ccall((:XPRSgetcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, preintsol, data)
end

function XPRSaddcbpreintsol(prob, preintsol, data, priority)
    ccall((:XPRSaddcbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, preintsol, data, priority)
end

function XPRSremovecbpreintsol(prob, preintsol, data)
    ccall((:XPRSremovecbpreintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, preintsol, data)
end

function XPRSsetcbmessage(prob, message, data)
    ccall((:XPRSsetcbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, message, data)
end

function XPRSgetcbmessage(prob, message, data)
    ccall((:XPRSgetcbmessage, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, message, data)
end

function XPRSaddcbmessage(prob, message, data, priority)
    ccall((:XPRSaddcbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, message, data, priority)
end

function XPRSremovecbmessage(prob, message, data)
    ccall((:XPRSremovecbmessage, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, message, data)
end

function XPRSsetcbmipthread(prob, mipthread, data)
    ccall((:XPRSsetcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, mipthread, data)
end

function XPRSgetcbmipthread(prob, mipthread, data)
    ccall((:XPRSgetcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, mipthread, data)
end

function XPRSaddcbmipthread(prob, mipthread, data, priority)
    ccall((:XPRSaddcbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, mipthread, data, priority)
end

function XPRSremovecbmipthread(prob, mipthread, data)
    ccall((:XPRSremovecbmipthread, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, mipthread, data)
end

function XPRSsetcbdestroymt(prob, destroymt, data)
    ccall((:XPRSsetcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, destroymt, data)
end

function XPRSgetcbdestroymt(prob, destroymt, data)
    ccall((:XPRSgetcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, destroymt, data)
end

function XPRSaddcbdestroymt(prob, destroymt, data, priority)
    ccall((:XPRSaddcbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, destroymt, data, priority)
end

function XPRSremovecbdestroymt(prob, destroymt, data)
    ccall((:XPRSremovecbdestroymt, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, destroymt, data)
end

function XPRSsetcbnewnode(prob, newnode, data)
    ccall((:XPRSsetcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, newnode, data)
end

function XPRSgetcbnewnode(prob, newnode, data)
    ccall((:XPRSgetcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, newnode, data)
end

function XPRSaddcbnewnode(prob, newnode, data, priority)
    ccall((:XPRSaddcbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, newnode, data, priority)
end

function XPRSremovecbnewnode(prob, newnode, data)
    ccall((:XPRSremovecbnewnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, newnode, data)
end

function XPRSsetcbbariteration(prob, bariteration, data)
    ccall((:XPRSsetcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, bariteration, data)
end

function XPRSgetcbbariteration(prob, bariteration, data)
    ccall((:XPRSgetcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, bariteration, data)
end

function XPRSaddcbbariteration(prob, bariteration, data, priority)
    ccall((:XPRSaddcbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, bariteration, data, priority)
end

function XPRSremovecbbariteration(prob, bariteration, data)
    ccall((:XPRSremovecbbariteration, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, bariteration, data)
end

# Function does not exist in v33
function XPRSsetcbpresolve(prob, presolve, data)
    ccall((:XPRSsetcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, presolve, data)
end

# Function does not exist in v33
function XPRSgetcbpresolve(prob, presolve, data)
    ccall((:XPRSgetcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, presolve, data)
end

# Function does not exist in v33
function XPRSaddcbpresolve(prob, presolve, data, priority)
    ccall((:XPRSaddcbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, presolve, data, priority)
end

# Function does not exist in v33
function XPRSremovecbpresolve(prob, presolve, data)
    ccall((:XPRSremovecbpresolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, presolve, data)
end

function XPRSsetcbchgbranchobject(prob, chgbranchobject, data)
    ccall((:XPRSsetcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgbranchobject, data)
end

function XPRSgetcbchgbranchobject(prob, chgbranchobject, data)
    ccall((:XPRSgetcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, chgbranchobject, data)
end

function XPRSaddcbchgbranchobject(prob, chgbranchobject, data, priority)
    ccall((:XPRSaddcbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, chgbranchobject, data, priority)
end

function XPRSremovecbchgbranchobject(prob, chgbranchobject, data)
    ccall((:XPRSremovecbchgbranchobject, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgbranchobject, data)
end

# Function does not exist in v33
function XPRSsetcbcomputerestart(prob, computerestart, data)
    ccall((:XPRSsetcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, computerestart, data)
end

# Function does not exist in v33
function XPRSgetcbcomputerestart(prob, computerestart, data)
    ccall((:XPRSgetcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, computerestart, data)
end

# Function does not exist in v33
function XPRSaddcbcomputerestart(prob, computerestart, data, priority)
    ccall((:XPRSaddcbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, computerestart, data, priority)
end

# Function does not exist in v33
function XPRSremovecbcomputerestart(prob, computerestart, data)
    ccall((:XPRSremovecbcomputerestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, computerestart, data)
end

# Function does not exist in v33
function XPRSsetcbnodelpsolved(prob, nodelpsolved, data)
    ccall((:XPRSsetcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nodelpsolved, data)
end

# Function does not exist in v33
function XPRSgetcbnodelpsolved(prob, nodelpsolved, data)
    ccall((:XPRSgetcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, nodelpsolved, data)
end

# Function does not exist in v33
function XPRSaddcbnodelpsolved(prob, nodelpsolved, data, priority)
    ccall((:XPRSaddcbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, nodelpsolved, data, priority)
end

# Function does not exist in v33
function XPRSremovecbnodelpsolved(prob, nodelpsolved, data)
    ccall((:XPRSremovecbnodelpsolved, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nodelpsolved, data)
end

function XPRSsetcbgapnotify(prob, gapnotify, data)
    ccall((:XPRSsetcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, gapnotify, data)
end

function XPRSgetcbgapnotify(prob, gapnotify, data)
    ccall((:XPRSgetcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, gapnotify, data)
end

function XPRSaddcbgapnotify(prob, gapnotify, data, priority)
    ccall((:XPRSaddcbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, gapnotify, data, priority)
end

function XPRSremovecbgapnotify(prob, gapnotify, data)
    ccall((:XPRSremovecbgapnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, gapnotify, data)
end

function XPRSsetcbusersolnotify(prob, usersolnotify, data)
    ccall((:XPRSsetcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, usersolnotify, data)
end

function XPRSgetcbusersolnotify(prob, usersolnotify, data)
    ccall((:XPRSgetcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, usersolnotify, data)
end

function XPRSaddcbusersolnotify(prob, usersolnotify, data, priority)
    ccall((:XPRSaddcbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, usersolnotify, data, priority)
end

function XPRSremovecbusersolnotify(prob, usersolnotify, data)
    ccall((:XPRSremovecbusersolnotify, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, usersolnotify, data)
end

function XPRSsetcbbeforesolve(prob, beforesolve, data)
    ccall((:XPRSsetcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, beforesolve, data)
end

function XPRSgetcbbeforesolve(prob, beforesolve, data)
    ccall((:XPRSgetcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, beforesolve, data)
end

function XPRSaddcbbeforesolve(prob, beforesolve, data, priority)
    ccall((:XPRSaddcbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, beforesolve, data, priority)
end

function XPRSremovecbbeforesolve(prob, beforesolve, data)
    ccall((:XPRSremovecbbeforesolve, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, beforesolve, data)
end

# Function does not exist in v33
function XPRSsetcbbeforeobjective(prob, beforeobjective, data)
    ccall((:XPRSsetcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, beforeobjective, data)
end

# Function does not exist in v33
function XPRSgetcbbeforeobjective(prob, beforeobjective, data)
    ccall((:XPRSgetcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, beforeobjective, data)
end

# Function does not exist in v33
function XPRSaddcbbeforeobjective(prob, beforeobjective, data, priority)
    ccall((:XPRSaddcbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, beforeobjective, data, priority)
end

# Function does not exist in v33
function XPRSremovecbbeforeobjective(prob, beforeobjective, data)
    ccall((:XPRSremovecbbeforeobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, beforeobjective, data)
end

# Function does not exist in v33
function XPRSsetcbafterobjective(prob, afterobjective, data)
    ccall((:XPRSsetcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, afterobjective, data)
end

# Function does not exist in v33
function XPRSgetcbafterobjective(prob, afterobjective, data)
    ccall((:XPRSgetcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, afterobjective, data)
end

# Function does not exist in v33
function XPRSaddcbafterobjective(prob, afterobjective, data, priority)
    ccall((:XPRSaddcbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, afterobjective, data, priority)
end

# Function does not exist in v33
function XPRSremovecbafterobjective(prob, afterobjective, data)
    ccall((:XPRSremovecbafterobjective, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, afterobjective, data)
end

# Function does not exist in v33
function XPRSsetcbchecktime(prob, checktime, data)
    ccall((:XPRSsetcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, checktime, data)
end

# Function does not exist in v33
function XPRSgetcbchecktime(prob, checktime, data)
    ccall((:XPRSgetcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, checktime, data)
end

# Function does not exist in v33
function XPRSaddcbchecktime(prob, checktime, data, priority)
    ccall((:XPRSaddcbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, checktime, data, priority)
end

# Function does not exist in v33
function XPRSremovecbchecktime(prob, checktime, data)
    ccall((:XPRSremovecbchecktime, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, checktime, data)
end

# Function does not exist in v33
function XPRSsetcbslpcascadeend(prob, slpcascadeend, data)
    ccall((:XPRSsetcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadeend, data)
end

# Function does not exist in v33
function XPRSgetcbslpcascadeend(prob, slpcascadeend, data)
    ccall((:XPRSgetcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpcascadeend, data)
end

# Function does not exist in v33
function XPRSaddcbslpcascadeend(prob, slpcascadeend, data, priority)
    ccall((:XPRSaddcbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpcascadeend, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpcascadeend(prob, slpcascadeend, data)
    ccall((:XPRSremovecbslpcascadeend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadeend, data)
end

# Function does not exist in v33
function XPRSsetcbslpcascadestart(prob, slpcascadestart, data)
    ccall((:XPRSsetcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadestart, data)
end

# Function does not exist in v33
function XPRSgetcbslpcascadestart(prob, slpcascadestart, data)
    ccall((:XPRSgetcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpcascadestart, data)
end

# Function does not exist in v33
function XPRSaddcbslpcascadestart(prob, slpcascadestart, data, priority)
    ccall((:XPRSaddcbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpcascadestart, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpcascadestart(prob, slpcascadestart, data)
    ccall((:XPRSremovecbslpcascadestart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadestart, data)
end

# Function does not exist in v33
function XPRSsetcbslpcascadevar(prob, slpcascadevar, data)
    ccall((:XPRSsetcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadevar, data)
end

# Function does not exist in v33
function XPRSgetcbslpcascadevar(prob, slpcascadevar, data)
    ccall((:XPRSgetcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpcascadevar, data)
end

# Function does not exist in v33
function XPRSaddcbslpcascadevar(prob, slpcascadevar, data, priority)
    ccall((:XPRSaddcbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpcascadevar, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpcascadevar(prob, slpcascadevar, data)
    ccall((:XPRSremovecbslpcascadevar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadevar, data)
end

# Function does not exist in v33
function XPRSsetcbslpcascadevarfail(prob, slpcascadevarfail, data)
    ccall((:XPRSsetcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadevarfail, data)
end

# Function does not exist in v33
function XPRSgetcbslpcascadevarfail(prob, slpcascadevarfail, data)
    ccall((:XPRSgetcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpcascadevarfail, data)
end

# Function does not exist in v33
function XPRSaddcbslpcascadevarfail(prob, slpcascadevarfail, data, priority)
    ccall((:XPRSaddcbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpcascadevarfail, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpcascadevarfail(prob, slpcascadevarfail, data)
    ccall((:XPRSremovecbslpcascadevarfail, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpcascadevarfail, data)
end

# Function does not exist in v33
function XPRSsetcbslpconstruct(prob, slpconstruct, data)
    ccall((:XPRSsetcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpconstruct, data)
end

# Function does not exist in v33
function XPRSgetcbslpconstruct(prob, slpconstruct, data)
    ccall((:XPRSgetcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpconstruct, data)
end

# Function does not exist in v33
function XPRSaddcbslpconstruct(prob, slpconstruct, data, priority)
    ccall((:XPRSaddcbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpconstruct, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpconstruct(prob, slpconstruct, data)
    ccall((:XPRSremovecbslpconstruct, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpconstruct, data)
end

# Function does not exist in v33
function XPRSsetcbslpintsol(prob, slpintsol, data)
    ccall((:XPRSsetcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpintsol, data)
end

# Function does not exist in v33
function XPRSgetcbslpintsol(prob, slpintsol, data)
    ccall((:XPRSgetcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpintsol, data)
end

# Function does not exist in v33
function XPRSaddcbslpintsol(prob, slpintsol, data, priority)
    ccall((:XPRSaddcbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpintsol, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpintsol(prob, slpintsol, data)
    ccall((:XPRSremovecbslpintsol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpintsol, data)
end

# Function does not exist in v33
function XPRSsetcbslpiterend(prob, slpiterend, data)
    ccall((:XPRSsetcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpiterend, data)
end

# Function does not exist in v33
function XPRSgetcbslpiterend(prob, slpiterend, data)
    ccall((:XPRSgetcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpiterend, data)
end

# Function does not exist in v33
function XPRSaddcbslpiterend(prob, slpiterend, data, priority)
    ccall((:XPRSaddcbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpiterend, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpiterend(prob, slpiterend, data)
    ccall((:XPRSremovecbslpiterend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpiterend, data)
end

# Function does not exist in v33
function XPRSsetcbslpiterstart(prob, slpiterstart, data)
    ccall((:XPRSsetcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpiterstart, data)
end

# Function does not exist in v33
function XPRSgetcbslpiterstart(prob, slpiterstart, data)
    ccall((:XPRSgetcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpiterstart, data)
end

# Function does not exist in v33
function XPRSaddcbslpiterstart(prob, slpiterstart, data, priority)
    ccall((:XPRSaddcbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpiterstart, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpiterstart(prob, slpiterstart, data)
    ccall((:XPRSremovecbslpiterstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpiterstart, data)
end

# Function does not exist in v33
function XPRSsetcbslpitervar(prob, slpitervar, data)
    ccall((:XPRSsetcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpitervar, data)
end

# Function does not exist in v33
function XPRSgetcbslpitervar(prob, slpitervar, data)
    ccall((:XPRSgetcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpitervar, data)
end

# Function does not exist in v33
function XPRSaddcbslpitervar(prob, slpitervar, data, priority)
    ccall((:XPRSaddcbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpitervar, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpitervar(prob, slpitervar, data)
    ccall((:XPRSremovecbslpitervar, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpitervar, data)
end

# Function does not exist in v33
function XPRSsetcbslpdrcol(prob, slpdrcol, data)
    ccall((:XPRSsetcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpdrcol, data)
end

# Function does not exist in v33
function XPRSgetcbslpdrcol(prob, slpdrcol, data)
    ccall((:XPRSgetcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slpdrcol, data)
end

# Function does not exist in v33
function XPRSaddcbslpdrcol(prob, slpdrcol, data, priority)
    ccall((:XPRSaddcbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slpdrcol, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslpdrcol(prob, slpdrcol, data)
    ccall((:XPRSremovecbslpdrcol, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slpdrcol, data)
end

# Function does not exist in v33
function XPRSsetcbmsjobstart(prob, msjobstart, data)
    ccall((:XPRSsetcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, msjobstart, data)
end

# Function does not exist in v33
function XPRSgetcbmsjobstart(prob, msjobstart, data)
    ccall((:XPRSgetcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, msjobstart, data)
end

# Function does not exist in v33
function XPRSaddcbmsjobstart(prob, msjobstart, data, priority)
    ccall((:XPRSaddcbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, msjobstart, data, priority)
end

# Function does not exist in v33
function XPRSremovecbmsjobstart(prob, msjobstart, data)
    ccall((:XPRSremovecbmsjobstart, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, msjobstart, data)
end

# Function does not exist in v33
function XPRSsetcbmsjobend(prob, msjobend, data)
    ccall((:XPRSsetcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, msjobend, data)
end

# Function does not exist in v33
function XPRSgetcbmsjobend(prob, msjobend, data)
    ccall((:XPRSgetcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, msjobend, data)
end

# Function does not exist in v33
function XPRSaddcbmsjobend(prob, msjobend, data, priority)
    ccall((:XPRSaddcbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, msjobend, data, priority)
end

# Function does not exist in v33
function XPRSremovecbmsjobend(prob, msjobend, data)
    ccall((:XPRSremovecbmsjobend, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, msjobend, data)
end

# Function does not exist in v33
function XPRSsetcbmswinner(prob, mswinner, data)
    ccall((:XPRSsetcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, mswinner, data)
end

# Function does not exist in v33
function XPRSgetcbmswinner(prob, mswinner, data)
    ccall((:XPRSgetcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, mswinner, data)
end

# Function does not exist in v33
function XPRSaddcbmswinner(prob, mswinner, data, priority)
    ccall((:XPRSaddcbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, mswinner, data, priority)
end

# Function does not exist in v33
function XPRSremovecbmswinner(prob, mswinner, data)
    ccall((:XPRSremovecbmswinner, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, mswinner, data)
end

# Function does not exist in v33
function XPRSsetcbnlpcoefevalerror(prob, nlpcoefevalerror, data)
    ccall((:XPRSsetcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nlpcoefevalerror, data)
end

# Function does not exist in v33
function XPRSgetcbnlpcoefevalerror(prob, nlpcoefevalerror, data)
    ccall((:XPRSgetcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, nlpcoefevalerror, data)
end

# Function does not exist in v33
function XPRSaddcbnlpcoefevalerror(prob, nlpcoefevalerror, data, priority)
    ccall((:XPRSaddcbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, nlpcoefevalerror, data, priority)
end

# Function does not exist in v33
function XPRSremovecbnlpcoefevalerror(prob, nlpcoefevalerror, data)
    ccall((:XPRSremovecbnlpcoefevalerror, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, nlpcoefevalerror, data)
end

# Function does not exist in v33
function XPRSsetcbslppreupdatelinearization(prob, slppreupdatelinearization, data)
    ccall((:XPRSsetcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slppreupdatelinearization, data)
end

# Function does not exist in v33
function XPRSgetcbslppreupdatelinearization(prob, slppreupdatelinearization, data)
    ccall((:XPRSgetcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, slppreupdatelinearization, data)
end

# Function does not exist in v33
function XPRSaddcbslppreupdatelinearization(prob, slppreupdatelinearization, data, priority)
    ccall((:XPRSaddcbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, slppreupdatelinearization, data, priority)
end

# Function does not exist in v33
function XPRSremovecbslppreupdatelinearization(prob, slppreupdatelinearization, data)
    ccall((:XPRSremovecbslppreupdatelinearization, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, slppreupdatelinearization, data)
end

function XPRSobjsa(prob, ncols, colind, lower, upper)
    ccall((:XPRSobjsa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, colind, lower, upper)
end

# Function does not exist in v33
function XPRSbndsa(prob, ncols, colind, lblower, lbupper, ublower, ubupper)
    ccall((:XPRSbndsa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, ncols, colind, lblower, lbupper, ublower, ubupper)
end

function XPRSrhssa(prob, nrows, rowind, lower, upper)
    ccall((:XPRSrhssa, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, nrows, rowind, lower, upper)
end

function XPRS_ge_setcbmsghandler(msghandler, data)
    ccall((:XPRS_ge_setcbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), msghandler, data)
end

function XPRS_ge_getcbmsghandler(msghandler, data)
    ccall((:XPRS_ge_getcbmsghandler, libxprs), Cint, (Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), msghandler, data)
end

function XPRS_ge_addcbmsghandler(msghandler, data, priority)
    ccall((:XPRS_ge_addcbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Cint), msghandler, data, priority)
end

function XPRS_ge_removecbmsghandler(msghandler, data)
    ccall((:XPRS_ge_removecbmsghandler, libxprs), Cint, (Ptr{Cvoid}, Ptr{Cvoid}), msghandler, data)
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
    ccall((:XPRS_ge_getlasterror, libxprs), Cint, (Ptr{Cint}, Ptr{UInt8}, Cint, Ptr{Cint}), p_msgcode, msg, maxbytes, p_nbytes)
end

# Function does not exist in v33
function XPRS_ge_setcomputeallowed(allow)
    ccall((:XPRS_ge_setcomputeallowed, libxprs), Cint, (Cint,), allow)
end

# Function does not exist in v33
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
    ccall((:XPRS_msp_loadsol, libxprs), Cint, (XPRSmipsolpool, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, x, nCols, sSolutionName, bNameModifiedForUniqueness, iSolutionIdOfExistingDuplicatePreventedLoad)
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
    ccall((:XPRS_msp_setsolname, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, sNewSolutionBaseName, bNameModifiedForUniqueness, iSolutionIdStatus_)
end

function XPRS_msp_getsolname(msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
    ccall((:XPRS_msp_getsolname, libxprs), Cint, (XPRSmipsolpool, Cint, Ptr{UInt8}, Cint, Ptr{Cint}, Ptr{Cint}), msp, iSolutionId, _sname, _iStringBufferBytes, _iBytesInInternalString, iSolutionIdStatus_)
end

function XPRS_msp_findsolbyname(msp, sSolutionName, iSolutionId)
    ccall((:XPRS_msp_findsolbyname, libxprs), Cint, (XPRSmipsolpool, Ptr{UInt8}, Ptr{Cint}), msp, sSolutionName, iSolutionId)
end

function XPRS_msp_writeslxsol(msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
    ccall((:XPRS_msp_writeslxsol, libxprs), Cint, (XPRSmipsolpool, XPRSprob, Cint, Ptr{Cint}, Ptr{UInt8}, Ptr{UInt8}), msp, prob_context, iSolutionId, iSolutionIdStatus_, sFileName, sFlags)
end

function XPRS_msp_readslxsol(msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
    ccall((:XPRS_msp_readslxsol, libxprs), Cint, (XPRSmipsolpool, XPRSnamelist, Ptr{UInt8}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}), msp, col_name_list, sFileName, sFlags, iSolutionId_Beg, iSolutionId_End)
end

function XPRS_msp_getlasterror(msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_msp_getlasterror, libxprs), Cint, (XPRSmipsolpool, Ptr{Cint}, Ptr{UInt8}, Cint, Ptr{Cint}), msp, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_msp_setcbmsghandler(msp, msghandler, data)
    ccall((:XPRS_msp_setcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}), msp, msghandler, data)
end

function XPRS_msp_getcbmsghandler(msp, msghandler, data)
    ccall((:XPRS_msp_getcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), msp, msghandler, data)
end

function XPRS_msp_addcbmsghandler(msp, msghandler, data, priority)
    ccall((:XPRS_msp_addcbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}, Cint), msp, msghandler, data, priority)
end

function XPRS_msp_removecbmsghandler(msp, msghandler, data)
    ccall((:XPRS_msp_removecbmsghandler, libxprs), Cint, (XPRSmipsolpool, Ptr{Cvoid}, Ptr{Cvoid}), msp, msghandler, data)
end

function XPRSaddqmatrix(prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSaddqmatrix, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSaddqmatrix64(prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSaddqmatrix64, libxprs), Cint, (XPRSprob, Cint, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, ncoefs, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSdelqmatrix(prob, row)
    ccall((:XPRSdelqmatrix, libxprs), Cint, (XPRSprob, Cint), prob, row)
end

function XPRSloadqcqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSloadqcqp, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
end

function XPRSloadqcqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
    ccall((:XPRSloadqcqp64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoef, rowqcol1, rowqcol2, rowqcoef)
end

# Function does not exist in v33
function XPRSloadmiqcqp(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqcqp, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

# Function does not exist in v33
function XPRSloadmiqcqp64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadmiqcqp64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
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
    ccall((:XPRS_mse_getlasterror, libxprs), Cint, (XPRSmipsolenum, Ptr{Cint}, Ptr{UInt8}, Cint, Ptr{Cint}), mse, iMsgCode, _msg, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_mse_setsolbasename(mse, sSolutionBaseName)
    ccall((:XPRS_mse_setsolbasename, libxprs), Cint, (XPRSmipsolenum, Ptr{UInt8}), mse, sSolutionBaseName)
end

function XPRS_mse_getsolbasename(mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
    ccall((:XPRS_mse_getsolbasename, libxprs), Cint, (XPRSmipsolenum, Ptr{UInt8}, Cint, Ptr{Cint}), mse, _sname, _iStringBufferBytes, _iBytesInInternalString)
end

function XPRS_mse_setcbgetsolutiondiff(mse, mse_getsolutiondiff, data)
    ccall((:XPRS_mse_setcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, mse_getsolutiondiff, data)
end

function XPRS_mse_getcbgetsolutiondiff(mse, mse_getsolutiondiff, data)
    ccall((:XPRS_mse_getcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), mse, mse_getsolutiondiff, data)
end

function XPRS_mse_addcbgetsolutiondiff(mse, mse_getsolutiondiff, data, priority)
    ccall((:XPRS_mse_addcbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}, Cint), mse, mse_getsolutiondiff, data, priority)
end

function XPRS_mse_removecbgetsolutiondiff(mse, mse_getsolutiondiff, data)
    ccall((:XPRS_mse_removecbgetsolutiondiff, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, mse_getsolutiondiff, data)
end

function XPRS_mse_setcbmsghandler(mse, msghandler, data)
    ccall((:XPRS_mse_setcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, msghandler, data)
end

function XPRS_mse_getcbmsghandler(mse, msghandler, data)
    ccall((:XPRS_mse_getcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), mse, msghandler, data)
end

function XPRS_mse_addcbmsghandler(mse, msghandler, data, priority)
    ccall((:XPRS_mse_addcbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}, Cint), mse, msghandler, data, priority)
end

function XPRS_mse_removecbmsghandler(mse, msghandler, data)
    ccall((:XPRS_mse_removecbmsghandler, libxprs), Cint, (XPRSmipsolenum, Ptr{Cvoid}, Ptr{Cvoid}), mse, msghandler, data)
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
    ccall((:XPRS_bo_getlasterror, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}, Ptr{UInt8}, Cint, Ptr{Cint}), bo, p_msgcode, msg, maxbytes, p_nbytes)
end

function XPRS_bo_validate(bo, p_status)
    ccall((:XPRS_bo_validate, libxprs), Cint, (XPRSbranchobject, Ptr{Cint}), bo, p_status)
end

# Function does not exist in v33
function XPRSmsaddjob(prob, description, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
    ccall((:XPRSmsaddjob, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cvoid}), prob, description, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
end

# Function does not exist in v33
function XPRSmsaddpreset(prob, description, preset, maxjobs, data)
    ccall((:XPRSmsaddpreset, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{Cvoid}), prob, description, preset, maxjobs, data)
end

# Function does not exist in v33
function XPRSmsaddcustompreset(prob, description, preset, maxjobs, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
    ccall((:XPRSmsaddcustompreset, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cvoid}), prob, description, preset, maxjobs, ninitial, colind, initial, nintcontrols, intcontrolid, intcontrolval, ndblcontrols, dblcontrolid, dblcontrolval, data)
end

# Function does not exist in v33
function XPRSnlpsetfunctionerror(prob)
    ccall((:XPRSnlpsetfunctionerror, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpprintevalinfo(prob)
    ccall((:XPRSnlpprintevalinfo, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpvalidate(prob)
    ccall((:XPRSnlpvalidate, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpoptimize(prob, flags)
    ccall((:XPRSnlpoptimize, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

# Function does not exist in v33
function XPRSgetnlpsol(prob, x, slack, duals, djs)
    ccall((:XPRSgetnlpsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
end

# Function does not exist in v33
function XPRSnlpsetcurrentiv(prob)
    ccall((:XPRSnlpsetcurrentiv, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpvalidaterow(prob, row)
    ccall((:XPRSnlpvalidaterow, libxprs), Cint, (XPRSprob, Cint), prob, row)
end

# Function does not exist in v33
function XPRSnlpvalidatekkt(prob, mode, respectbasis, updatemult, violtarget)
    ccall((:XPRSnlpvalidatekkt, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Cdouble), prob, mode, respectbasis, updatemult, violtarget)
end

# Function does not exist in v33
function XPRSmsclear(prob)
    ccall((:XPRSmsclear, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpevaluateformula(prob, parsed, type, values, p_value)
    ccall((:XPRSnlpevaluateformula, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}), prob, parsed, type, values, p_value)
end

# Function does not exist in v33
function XPRSnlpvalidatevector(prob, solution, p_suminf, p_sumscaledinf, p_objval)
    ccall((:XPRSnlpvalidatevector, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, p_suminf, p_sumscaledinf, p_objval)
end

# Function does not exist in v33
function XPRSnlpadduserfunction(prob, funcname, functype, nin, nout, options, _function, data, p_type)
    ccall((:XPRSnlpadduserfunction, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Cint, Cint, XPRSfunctionptr, Ptr{Cvoid}, Ptr{Cint}), prob, funcname, functype, nin, nout, options, _function, data, p_type)
end

# Function does not exist in v33
function XPRSnlpdeluserfunction(prob, type)
    ccall((:XPRSnlpdeluserfunction, libxprs), Cint, (XPRSprob, Cint), prob, type)
end

# Function does not exist in v33
function XPRSnlpimportlibfunc(prob, libname, funcname, p_function, p_status)
    ccall((:XPRSnlpimportlibfunc, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Ptr{UInt8}, XPRSfunctionptraddr, Ptr{Cint}), prob, libname, funcname, p_function, p_status)
end

# Function does not exist in v33
function XPRSnlpaddformulas(prob, ncoefs, rowind, formulastart, parsed, type, value)
    ccall((:XPRSnlpaddformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, formulastart, parsed, type, value)
end

# Function does not exist in v33
function XPRSnlpchgformulastr(prob, row, formula)
    ccall((:XPRSnlpchgformulastr, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}), prob, row, formula)
end

# Function does not exist in v33
function XPRSnlpchgformula(prob, row, parsed, type, value)
    ccall((:XPRSnlpchgformula, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, row, parsed, type, value)
end

# Function does not exist in v33
function XPRSnlpgetformula(prob, row, parsed, maxtypes, p_ntypes, type, value)
    ccall((:XPRSnlpgetformula, libxprs), Cint, (XPRSprob, Cint, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, parsed, maxtypes, p_ntypes, type, value)
end

# Function does not exist in v33
function XPRSnlpgetformularows(prob, p_nformulas, rowind)
    ccall((:XPRSnlpgetformularows, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}), prob, p_nformulas, rowind)
end

# Function does not exist in v33
function XPRSnlploadformulas(prob, nnlpcoefs, rowind, formulastart, parsed, type, value)
    ccall((:XPRSnlploadformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nnlpcoefs, rowind, formulastart, parsed, type, value)
end

# Function does not exist in v33
function XPRSnlpdelformulas(prob, nformulas, rowind)
    ccall((:XPRSnlpdelformulas, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, nformulas, rowind)
end

# Function does not exist in v33
function XPRSnlpgetformulastr(prob, row, formula, maxbytes, p_nbytes)
    ccall((:XPRSnlpgetformulastr, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Ptr{Cint}), prob, row, formula, maxbytes, p_nbytes)
end

# Function does not exist in v33
function XPRSnlpsetinitval(prob, nvars, colind, initial)
    ccall((:XPRSnlpsetinitval, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, nvars, colind, initial)
end

# Function does not exist in v33
function XPRSslpgetcoefformula(prob, row, col, p_factor, parsed, maxtypes, p_ntypes, type, value)
    ccall((:XPRSslpgetcoefformula, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cint, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, row, col, p_factor, parsed, maxtypes, p_ntypes, type, value)
end

# Function does not exist in v33
function XPRSslpgetcoefs(prob, p_ncoefs, rowind, colind)
    ccall((:XPRSslpgetcoefs, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}), prob, p_ncoefs, rowind, colind)
end

# Function does not exist in v33
function XPRSslploadcoefs(prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, coef)
    ccall((:XPRSslploadcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, coef)
end

# Function does not exist in v33
function XPRSslpdelcoefs(prob, ncoefs, rowind, colind)
    ccall((:XPRSslpdelcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, ncoefs, rowind, colind)
end

# Function does not exist in v33
function XPRSslpgetcoefstr(prob, row, col, p_factor, formula, maxbytes, p_nbytes)
    ccall((:XPRSslpgetcoefstr, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{UInt8}, Cint, Ptr{Cint}), prob, row, col, p_factor, formula, maxbytes, p_nbytes)
end

# Function does not exist in v33
function XPRSslpsetdetrow(prob, nvars, colind, rowind)
    ccall((:XPRSslpsetdetrow, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}), prob, nvars, colind, rowind)
end

# Function does not exist in v33
function XPRSslpaddcoefs(prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, value)
    ccall((:XPRSslpaddcoefs, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cint}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, ncoefs, rowind, colind, factor, formulastart, parsed, type, value)
end

# Function does not exist in v33
function XPRSslpchgcoefstr(prob, row, col, factor, formula)
    ccall((:XPRSslpchgcoefstr, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{UInt8}), prob, row, col, factor, formula)
end

# Function does not exist in v33
function XPRSslpchgcoef(prob, row, col, factor, parsed, type, value)
    ccall((:XPRSslpchgcoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cdouble}), prob, row, col, factor, parsed, type, value)
end

# Function does not exist in v33
function XPRSslpgetcolinfo(prob, type, col, p_info)
    ccall((:XPRSslpgetcolinfo, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{XPRSalltype}), prob, type, col, p_info)
end

# Function does not exist in v33
function XPRSslpgetrowinfo(prob, type, row, p_info)
    ccall((:XPRSslpgetrowinfo, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{XPRSalltype}), prob, type, row, p_info)
end

# Function does not exist in v33
function XPRSslpcascade(prob)
    ccall((:XPRSslpcascade, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpcascadeorder(prob)
    ccall((:XPRSslpcascadeorder, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpchgrowstatus(prob, row, status)
    ccall((:XPRSslpchgrowstatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, row, status)
end

# Function does not exist in v33
function XPRSslpchgrowwt(prob, row, weight)
    ccall((:XPRSslpchgrowwt, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, row, weight)
end

# Function does not exist in v33
function XPRSslpchgdeltatype(prob, nvars, varind, deltatypes, values)
    ccall((:XPRSslpchgdeltatype, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, nvars, varind, deltatypes, values)
end

# Function does not exist in v33
function XPRSslpchgcascadenlimit(prob, col, limit)
    ccall((:XPRSslpchgcascadenlimit, libxprs), Cint, (XPRSprob, Cint, Cint), prob, col, limit)
end

# Function does not exist in v33
function XPRSslpconstruct(prob)
    ccall((:XPRSslpconstruct, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpgetrowstatus(prob, row, p_status)
    ccall((:XPRSslpgetrowstatus, libxprs), Cint, (XPRSprob, Cint, Ptr{Cint}), prob, row, p_status)
end

# Function does not exist in v33
function XPRSslpgetrowwt(prob, row, p_weight)
    ccall((:XPRSslpgetrowwt, libxprs), Cint, (XPRSprob, Cint, Ptr{Cdouble}), prob, row, p_weight)
end

# Function does not exist in v33
function XPRSslpevaluatecoef(prob, row, col, p_value)
    ccall((:XPRSslpevaluatecoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}), prob, row, col, p_value)
end

# Function does not exist in v33
function XPRSslpreinitialize(prob)
    ccall((:XPRSslpreinitialize, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpunconstruct(prob)
    ccall((:XPRSslpunconstruct, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpupdatelinearization(prob)
    ccall((:XPRSslpupdatelinearization, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSslpfixpenalties(prob, p_status)
    ccall((:XPRSslpfixpenalties, libxprs), Cint, (XPRSprob, Ptr{Cint}), prob, p_status)
end

# Function does not exist in v33
function XPRSnlppostsolve(prob)
    ccall((:XPRSnlppostsolve, libxprs), Cint, (XPRSprob,), prob)
end

# Function does not exist in v33
function XPRSnlpcalcslacks(prob, solution, slack)
    ccall((:XPRSnlpcalcslacks, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, solution, slack)
end

function XPRSsetcbcutmgr(prob, cutmgr, data)
    ccall((:XPRSsetcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, cutmgr, data)
end

function XPRSgetcbcutmgr(prob, cutmgr, data)
    ccall((:XPRSgetcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, cutmgr, data)
end

function XPRSaddcbcutmgr(prob, cutmgr, data, priority)
    ccall((:XPRSaddcbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, cutmgr, data, priority)
end

function XPRSremovecbcutmgr(prob, cutmgr, data)
    ccall((:XPRSremovecbcutmgr, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, cutmgr, data)
end

function XPRSsetcbchgnode(prob, chgnode, data)
    ccall((:XPRSsetcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgnode, data)
end

function XPRSgetcbchgnode(prob, chgnode, data)
    ccall((:XPRSgetcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, chgnode, data)
end

function XPRSaddcbchgnode(prob, chgnode, data, priority)
    ccall((:XPRSaddcbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, chgnode, data, priority)
end

function XPRSremovecbchgnode(prob, chgnode, data)
    ccall((:XPRSremovecbchgnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgnode, data)
end

function XPRSsetcbchgbranch(prob, chgbranch, data)
    ccall((:XPRSsetcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgbranch, data)
end

function XPRSgetcbchgbranch(prob, chgbranch, data)
    ccall((:XPRSgetcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, chgbranch, data)
end

function XPRSaddcbchgbranch(prob, chgbranch, data, priority)
    ccall((:XPRSaddcbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, chgbranch, data, priority)
end

function XPRSremovecbchgbranch(prob, chgbranch, data)
    ccall((:XPRSremovecbchgbranch, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, chgbranch, data)
end

function XPRSsetcbestimate(prob, estimate, data)
    ccall((:XPRSsetcbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, estimate, data)
end

function XPRSgetcbestimate(prob, estimate, data)
    ccall((:XPRSgetcbestimate, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, estimate, data)
end

function XPRSaddcbestimate(prob, estimate, data, priority)
    ccall((:XPRSaddcbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, estimate, data, priority)
end

function XPRSremovecbestimate(prob, estimate, data)
    ccall((:XPRSremovecbestimate, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, estimate, data)
end

function XPRSsetcbsepnode(prob, sepnode, data)
    ccall((:XPRSsetcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, sepnode, data)
end

function XPRSgetcbsepnode(prob, sepnode, data)
    ccall((:XPRSgetcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Ptr{Cvoid}}, Ptr{Ptr{Cvoid}}), prob, sepnode, data)
end

function XPRSaddcbsepnode(prob, sepnode, data, priority)
    ccall((:XPRSaddcbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, sepnode, data, priority)
end

function XPRSremovecbsepnode(prob, sepnode, data)
    ccall((:XPRSremovecbsepnode, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, sepnode, data)
end

function XPRSminim(prob, flags)
    ccall((:XPRSminim, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

function XPRSmaxim(prob, flags)
    ccall((:XPRSmaxim, libxprs), Cint, (XPRSprob, Ptr{UInt8}), prob, flags)
end

function XPRSbasiscondition(prob, p_cond, p_scaledcond)
    ccall((:XPRSbasiscondition, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}), prob, p_cond, p_scaledcond)
end

function XPRSrefinemipsol(prob, options, flags, solution, refined, p_status)
    ccall((:XPRSrefinemipsol, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}), prob, options, flags, solution, refined, p_status)
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
    ccall((:XPRS_nml_findname, libxprs), Cint, (XPRSnamelist, Ptr{UInt8}, Ptr{Cint}), nml, name, p_index)
end

function XPRS_nml_copynames(dest, src)
    ccall((:XPRS_nml_copynames, libxprs), Cint, (XPRSnamelist, XPRSnamelist), dest, src)
end

function XPRS_nml_getlasterror(nml, p_msgcode, msg, maxbytes, p_nbytes)
    ccall((:XPRS_nml_getlasterror, libxprs), Cint, (XPRSnamelist, Ptr{Cint}, Ptr{UInt8}, Cint, Ptr{Cint}), nml, p_msgcode, msg, maxbytes, p_nbytes)
end

function XPRSgetsol(prob, x, slack, duals, djs)
    ccall((:XPRSgetsol, libxprs), Cint, (XPRSprob, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}), prob, x, slack, duals, djs)
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

function XPRSgetnames(prob, type, names, first, last)
    ccall((:XPRSgetnames, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint, Cint), prob, type, names, first, last)
end

# Function does not exist in v33
function XPRSnlpchgformulastring(prob, row, formula)
    ccall((:XPRSnlpchgformulastring, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}), prob, row, formula)
end

# Function does not exist in v33
function XPRSnlpgetformulastring(prob, row, formula, maxbytes)
    ccall((:XPRSnlpgetformulastring, libxprs), Cint, (XPRSprob, Cint, Ptr{UInt8}, Cint), prob, row, formula, maxbytes)
end

# Function does not exist in v33
function XPRSslpgetccoef(prob, row, col, p_factor, formula, maxbytes)
    ccall((:XPRSslpgetccoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{UInt8}, Cint), prob, row, col, p_factor, formula, maxbytes)
end

# Function does not exist in v33
function XPRSslpchgccoef(prob, row, col, factor, formula)
    ccall((:XPRSslpchgccoef, libxprs), Cint, (XPRSprob, Cint, Cint, Ptr{Cdouble}, Ptr{UInt8}), prob, row, col, factor, formula)
end

"""
    XPRSfixglobals(prob, options)

*************************************************************************\\ Compatibility section for functions removed with Xpress 9.0 *\\**************************************************************************
"""
function XPRSfixglobals(prob, options)
    ccall((:XPRSfixglobals, libxprs), Cint, (XPRSprob, Cint), prob, options)
end

function XPRSgetglobal(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetglobal, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

function XPRSgetglobal64(prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
    ccall((:XPRSgetglobal64, libxprs), Cint, (XPRSprob, Ptr{Cint}, Ptr{Cint}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, p_nentities, p_nsets, coltype, colind, limit, settype, start, setcols, refval)
end

function XPRSloadqcqpglobal(prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqcqpglobal, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqcqpglobal64(prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqcqpglobal64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, qrtypes, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, mqcol1, mqcol2, objqcoef, nqrows, qrowind, nrowqcoefs, rowqcol1, rowqcol2, rowqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqglobal(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqglobal, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadqglobal64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadqglobal64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Clong, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nobjqcoefs, objqcol1, objqcol2, objqcoef, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadglobal(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadglobal, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cint}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSloadglobal64(prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
    ccall((:XPRSloadglobal64, libxprs), Cint, (XPRSprob, Ptr{UInt8}, Cint, Cint, Ptr{UInt8}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Clong}, Ptr{Cint}, Ptr{Cint}, Ptr{Cdouble}, Ptr{Cdouble}, Ptr{Cdouble}, Cint, Cint, Ptr{UInt8}, Ptr{Cint}, Ptr{Cdouble}, Ptr{UInt8}, Ptr{Clong}, Ptr{Cint}, Ptr{Cdouble}), prob, probname, ncols, nrows, rowtype, rhs, rng, objcoef, start, collen, rowind, rowcoef, lb, ub, nentities, nsets, coltype, entind, limit, settype, setstart, setind, refval)
end

function XPRSaddcbgloballog(prob, globallog, data, priority)
    ccall((:XPRSaddcbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}, Cint), prob, globallog, data, priority)
end

function XPRSremovecbgloballog(prob, globallog, data)
    ccall((:XPRSremovecbgloballog, libxprs), Cint, (XPRSprob, Ptr{Cvoid}, Ptr{Cvoid}), prob, globallog, data)
end

const XPRSint64 = Clong

const XPRS_PLUSINFINITY = 1.0e20

const XPRS_MINUSINFINITY = -1.0e20

const XPRS_MAXINT = 2147483647

# Struct does not exist in v33
const XPRS_MAXBANNERLENGTH = 512

# Struct does not exist in v33
const XPVERSION_MAJOR = 42

# Struct does not exist in v33
const XPVERSION_MINOR = 1

# Struct does not exist in v33
const XPVERSION_BUILD = 5

# Struct does not exist in v33
const XPVERSION_FULL = 420105

# Struct does not exist in v33
const XPRS_MAXMESSAGELENGTH = 512

const XPRS_MPSRHSNAME = 6001

const XPRS_MPSOBJNAME = 6002

const XPRS_MPSRANGENAME = 6003

const XPRS_MPSBOUNDNAME = 6004

const XPRS_OUTPUTMASK = 6005

const XPRS_TUNERMETHODFILE = 6017

const XPRS_TUNEROUTPUTPATH = 6018

const XPRS_TUNERSESSIONNAME = 6019

# Struct does not exist in v33
const XPRS_COMPUTEEXECSERVICE = 6022

const XPRS_MAXCUTTIME = 8149

# Struct does not exist in v33
const XPRS_MAXSTALLTIME = 8443

const XPRS_TUNERMAXTIME = 8364

const XPRS_MATRIXTOL = 7001

const XPRS_PIVOTTOL = 7002

const XPRS_FEASTOL = 7003

const XPRS_OUTPUTTOL = 7004

const XPRS_SOSREFTOL = 7005

const XPRS_OPTIMALITYTOL = 7006

const XPRS_ETATOL = 7007

const XPRS_RELPIVOTTOL = 7008

const XPRS_MIPTOL = 7009

const XPRS_MIPTOLTARGET = 7010

# Struct does not exist in v33
const XPRS_BARPERTURB = 7011

const XPRS_MIPADDCUTOFF = 7012

const XPRS_MIPABSCUTOFF = 7013

const XPRS_MIPRELCUTOFF = 7014

const XPRS_PSEUDOCOST = 7015

const XPRS_PENALTY = 7016

const XPRS_BIGM = 7018

const XPRS_MIPABSSTOP = 7019

const XPRS_MIPRELSTOP = 7020

const XPRS_CROSSOVERACCURACYTOL = 7023

const XPRS_PRIMALPERTURB = 7024

const XPRS_DUALPERTURB = 7025

const XPRS_BAROBJSCALE = 7026

const XPRS_BARRHSSCALE = 7027

const XPRS_CHOLESKYTOL = 7032

const XPRS_BARGAPSTOP = 7033

const XPRS_BARDUALSTOP = 7034

const XPRS_BARPRIMALSTOP = 7035

const XPRS_BARSTEPSTOP = 7036

const XPRS_ELIMTOL = 7042

const XPRS_MARKOWITZTOL = 7047

const XPRS_MIPABSGAPNOTIFY = 7064

const XPRS_MIPRELGAPNOTIFY = 7065

const XPRS_BARLARGEBOUND = 7067

const XPRS_PPFACTOR = 7069

const XPRS_REPAIRINDEFINITEQMAX = 7071

const XPRS_BARGAPTARGET = 7073

# Struct does not exist in v33
const XPRS_DUMMYCONTROL = 7075

const XPRS_BARSTARTWEIGHT = 7076

const XPRS_BARFREESCALE = 7077

const XPRS_SBEFFORT = 7086

const XPRS_HEURDIVERANDOMIZE = 7089

const XPRS_HEURSEARCHEFFORT = 7090

const XPRS_CUTFACTOR = 7091

const XPRS_EIGENVALUETOL = 7097

const XPRS_INDLINBIGM = 7099

const XPRS_TREEMEMORYSAVINGTARGET = 7100

const XPRS_INDPRELINBIGM = 7102

const XPRS_RELAXTREEMEMORYLIMIT = 7105

const XPRS_MIPABSGAPNOTIFYOBJ = 7108

const XPRS_MIPABSGAPNOTIFYBOUND = 7109

const XPRS_PRESOLVEMAXGROW = 7110

const XPRS_HEURSEARCHTARGETSIZE = 7112

const XPRS_CROSSOVERRELPIVOTTOL = 7113

const XPRS_CROSSOVERRELPIVOTTOLSAFE = 7114

const XPRS_DETLOGFREQ = 7116

const XPRS_MAXIMPLIEDBOUND = 7120

const XPRS_FEASTOLTARGET = 7121

const XPRS_OPTIMALITYTOLTARGET = 7122

const XPRS_PRECOMPONENTSEFFORT = 7124

const XPRS_LPLOGDELAY = 7127

const XPRS_HEURDIVEITERLIMIT = 7128

# Struct does not exist in v33
const XPRS_BARKERNEL = 7130

# Struct does not exist in v33
const XPRS_FEASTOLPERTURB = 7132

# Struct does not exist in v33
const XPRS_CROSSOVERFEASWEIGHT = 7133

# Struct does not exist in v33
const XPRS_LUPIVOTTOL = 7139

# Struct does not exist in v33
const XPRS_MIPRESTARTGAPTHRESHOLD = 7140

# Struct does not exist in v33
const XPRS_NODEPROBINGEFFORT = 7141

# Struct does not exist in v33
const XPRS_INPUTTOL = 7143

# Struct does not exist in v33
const XPRS_MIPRESTARTFACTOR = 7145

# Struct does not exist in v33
const XPRS_BAROBJPERTURB = 7146

# Struct does not exist in v33
const XPRS_CPIALPHA = 7149

# Struct does not exist in v33
const XPRS_GLOBALSPATIALBRANCHPROPAGATIONEFFORT = 7152

# Struct does not exist in v33
const XPRS_GLOBALSPATIALBRANCHCUTTINGEFFORT = 7153

# Struct does not exist in v33
const XPRS_GLOBALBOUNDINGBOX = 7154

# Struct does not exist in v33
const XPRS_TIMELIMIT = 7158

# Struct does not exist in v33
const XPRS_SOLTIMELIMIT = 7159

# Struct does not exist in v33
const XPRS_REPAIRINFEASTIMELIMIT = 7160

const XPRS_EXTRAROWS = 8004

const XPRS_EXTRACOLS = 8005

const XPRS_LPITERLIMIT = 8007

const XPRS_LPLOG = 8009

const XPRS_SCALING = 8010

const XPRS_PRESOLVE = 8011

const XPRS_CRASH = 8012

const XPRS_PRICINGALG = 8013

const XPRS_INVERTFREQ = 8014

const XPRS_INVERTMIN = 8015

const XPRS_MAXNODE = 8018

const XPRS_MAXTIME = 8020

const XPRS_MAXMIPSOL = 8021

# Struct does not exist in v33
const XPRS_SIFTPASSES = 8022

const XPRS_DEFAULTALG = 8023

const XPRS_VARSELECTION = 8025

const XPRS_NODESELECTION = 8026

const XPRS_BACKTRACK = 8027

const XPRS_MIPLOG = 8028

const XPRS_KEEPNROWS = 8030

const XPRS_MPSECHO = 8032

const XPRS_MAXPAGELINES = 8034

const XPRS_OUTPUTLOG = 8035

const XPRS_BARSOLUTION = 8038

const XPRS_CACHESIZE = 8043

const XPRS_CROSSOVER = 8044

const XPRS_BARITERLIMIT = 8045

const XPRS_CHOLESKYALG = 8046

const XPRS_BAROUTPUT = 8047

const XPRS_EXTRAMIPENTS = 8051

const XPRS_REFACTOR = 8052

const XPRS_BARTHREADS = 8053

const XPRS_KEEPBASIS = 8054

const XPRS_CROSSOVEROPS = 8060

const XPRS_VERSION = 8061

const XPRS_CROSSOVERTHREADS = 8065

const XPRS_BIGMMETHOD = 8068

const XPRS_MPSNAMELENGTH = 8071

# Struct does not exist in v33
const XPRS_ELIMFILLIN = 8073

const XPRS_PRESOLVEOPS = 8077

const XPRS_MIPPRESOLVE = 8078

const XPRS_MIPTHREADS = 8079

const XPRS_BARORDER = 8080

const XPRS_BREADTHFIRST = 8082

const XPRS_AUTOPERTURB = 8084

const XPRS_DENSECOLLIMIT = 8086

const XPRS_CALLBACKFROMMASTERTHREAD = 8090

const XPRS_MAXMCOEFFBUFFERELEMS = 8091

const XPRS_REFINEOPS = 8093

const XPRS_LPREFINEITERLIMIT = 8094

const XPRS_MIPREFINEITERLIMIT = 8095

const XPRS_DUALIZEOPS = 8097

const XPRS_CROSSOVERITERLIMIT = 8104

const XPRS_PREBASISRED = 8106

const XPRS_PRESORT = 8107

const XPRS_PREPERMUTE = 8108

const XPRS_PREPERMUTESEED = 8109

# Struct does not exist in v33
const XPRS_MAXMEMORYSOFT = 8112

const XPRS_CUTFREQ = 8116

const XPRS_SYMSELECT = 8117

const XPRS_SYMMETRY = 8118

# Struct does not exist in v33
const XPRS_MAXMEMORYHARD = 8119

const XPRS_MIQCPALG = 8125

const XPRS_QCCUTS = 8126

const XPRS_QCROOTALG = 8127

# Struct does not exist in v33
const XPRS_PRECONVERTSEPARABLE = 8128

const XPRS_ALGAFTERNETWORK = 8129

const XPRS_TRACE = 8130

const XPRS_MAXIIS = 8131

const XPRS_CPUTIME = 8133

const XPRS_COVERCUTS = 8134

const XPRS_GOMCUTS = 8135

const XPRS_LPFOLDING = 8136

const XPRS_MPSFORMAT = 8137

const XPRS_CUTSTRATEGY = 8138

const XPRS_CUTDEPTH = 8139

const XPRS_TREECOVERCUTS = 8140

const XPRS_TREEGOMCUTS = 8141

const XPRS_CUTSELECT = 8142

const XPRS_TREECUTSELECT = 8143

const XPRS_DUALIZE = 8144

const XPRS_DUALGRADIENT = 8145

const XPRS_SBITERLIMIT = 8146

const XPRS_SBBEST = 8147

const XPRS_BARINDEFLIMIT = 8153

const XPRS_HEURFREQ = 8155

const XPRS_HEURDEPTH = 8156

const XPRS_HEURMAXSOL = 8157

const XPRS_HEURNODES = 8158

const XPRS_LNPBEST = 8160

const XPRS_LNPITERLIMIT = 8161

const XPRS_BRANCHCHOICE = 8162

const XPRS_BARREGULARIZE = 8163

const XPRS_SBSELECT = 8164

# Struct does not exist in v33
const XPRS_IISLOG = 8165

const XPRS_LOCALCHOICE = 8170

const XPRS_LOCALBACKTRACK = 8171

const XPRS_DUALSTRATEGY = 8174

const XPRS_L1CACHE = 8175

const XPRS_HEURDIVESTRATEGY = 8177

const XPRS_HEURSELECT = 8178

const XPRS_BARSTART = 8180

const XPRS_PRESOLVEPASSES = 8183

const XPRS_BARNUMSTABILITY = 8186

const XPRS_BARORDERTHREADS = 8187

const XPRS_EXTRASETS = 8190

const XPRS_FEASIBILITYPUMP = 8193

const XPRS_PRECOEFELIM = 8194

const XPRS_PREDOMCOL = 8195

const XPRS_HEURSEARCHFREQ = 8196

const XPRS_HEURDIVESPEEDUP = 8197

const XPRS_SBESTIMATE = 8198

const XPRS_BARCORES = 8202

const XPRS_MAXCHECKSONMAXTIME = 8203

const XPRS_MAXCHECKSONMAXCUTTIME = 8204

const XPRS_HISTORYCOSTS = 8206

const XPRS_ALGAFTERCROSSOVER = 8208

const XPRS_MUTEXCALLBACKS = 8210

const XPRS_BARCRASH = 8211

const XPRS_HEURDIVESOFTROUNDING = 8215

const XPRS_HEURSEARCHROOTSELECT = 8216

const XPRS_HEURSEARCHTREESELECT = 8217

const XPRS_MPS18COMPATIBLE = 8223

const XPRS_ROOTPRESOLVE = 8224

const XPRS_CROSSOVERDRP = 8227

const XPRS_FORCEOUTPUT = 8229

# Struct does not exist in v33
const XPRS_PRIMALOPS = 8231

const XPRS_DETERMINISTIC = 8232

const XPRS_PREPROBING = 8238

const XPRS_TREEMEMORYLIMIT = 8242

const XPRS_TREECOMPRESSION = 8243

const XPRS_TREEDIAGNOSTICS = 8244

# Struct does not exist in v33
const XPRS_MAXTREEFILESIZE = 8245

# Struct does not exist in v33
const XPRS_PRECLIQUESTRATEGY = 8247

# Struct does not exist in v33
const XPRS_REPAIRINFEASMAXTIME = 8250

const XPRS_IFCHECKCONVEXITY = 8251

const XPRS_PRIMALUNSHIFT = 8252

const XPRS_REPAIRINDEFINITEQ = 8254

const XPRS_MIPRAMPUP = 8255

const XPRS_MAXLOCALBACKTRACK = 8257

const XPRS_USERSOLHEURISTIC = 8258

# Struct does not exist in v33
const XPRS_PRECONVERTOBJTOCONS = 8260

const XPRS_FORCEPARALLELDUAL = 8265

const XPRS_BACKTRACKTIE = 8266

const XPRS_BRANCHDISJ = 8267

const XPRS_MIPFRACREDUCE = 8270

const XPRS_CONCURRENTTHREADS = 8274

const XPRS_MAXSCALEFACTOR = 8275

const XPRS_HEURTHREADS = 8276

const XPRS_THREADS = 8278

const XPRS_HEURBEFORELP = 8280

const XPRS_PREDOMROW = 8281

const XPRS_BRANCHSTRUCTURAL = 8282

const XPRS_QUADRATICUNSHIFT = 8284

const XPRS_BARPRESOLVEOPS = 8286

const XPRS_QSIMPLEXOPS = 8288

# Struct does not exist in v33
const XPRS_MIPRESTART = 8290

const XPRS_CONFLICTCUTS = 8292

const XPRS_PREPROTECTDUAL = 8293

const XPRS_CORESPERCPU = 8296

# Struct does not exist in v33
const XPRS_RESOURCESTRATEGY = 8297

# Struct does not exist in v33
const XPRS_CLAMPING = 8301

const XPRS_SLEEPONTHREADWAIT = 8302

const XPRS_PREDUPROW = 8307

const XPRS_CPUPLATFORM = 8312

const XPRS_BARALG = 8315

const XPRS_SIFTING = 8319

const XPRS_LPLOGSTYLE = 8326

const XPRS_RANDOMSEED = 8328

const XPRS_TREEQCCUTS = 8331

const XPRS_PRELINDEP = 8333

const XPRS_DUALTHREADS = 8334

const XPRS_PREOBJCUTDETECT = 8336

const XPRS_PREBNDREDQUAD = 8337

const XPRS_PREBNDREDCONE = 8338

const XPRS_PRECOMPONENTS = 8339

const XPRS_MAXMIPTASKS = 8347

const XPRS_MIPTERMINATIONMETHOD = 8348

const XPRS_PRECONEDECOMP = 8349

const XPRS_HEURFORCESPECIALOBJ = 8350

const XPRS_HEURSEARCHROOTCUTFREQ = 8351

const XPRS_PREELIMQUAD = 8353

const XPRS_PREIMPLICATIONS = 8356

const XPRS_TUNERMODE = 8359

const XPRS_TUNERMETHOD = 8360

const XPRS_TUNERTARGET = 8362

const XPRS_TUNERTHREADS = 8363

const XPRS_TUNERHISTORY = 8365

const XPRS_TUNERPERMUTE = 8366

# Struct does not exist in v33
const XPRS_TUNERVERBOSE = 8370

const XPRS_TUNEROUTPUT = 8372

const XPRS_PREANALYTICCENTER = 8374

const XPRS_NETCUTS = 8382

# Struct does not exist in v33
const XPRS_LPFLAGS = 8385

# Struct does not exist in v33
const XPRS_MIPKAPPAFREQ = 8386

# Struct does not exist in v33
const XPRS_OBJSCALEFACTOR = 8387

# Struct does not exist in v33
const XPRS_TREEFILELOGINTERVAL = 8389

# Struct does not exist in v33
const XPRS_IGNORECONTAINERCPULIMIT = 8390

# Struct does not exist in v33
const XPRS_IGNORECONTAINERMEMORYLIMIT = 8391

# Struct does not exist in v33
const XPRS_MIPDUALREDUCTIONS = 8392

# Struct does not exist in v33
const XPRS_GENCONSDUALREDUCTIONS = 8395

# Struct does not exist in v33
const XPRS_PWLDUALREDUCTIONS = 8396

# Struct does not exist in v33
const XPRS_BARFAILITERLIMIT = 8398

# Struct does not exist in v33
const XPRS_AUTOSCALING = 8406

# Struct does not exist in v33
const XPRS_GENCONSABSTRANSFORMATION = 8408

# Struct does not exist in v33
const XPRS_COMPUTEJOBPRIORITY = 8409

# Struct does not exist in v33
const XPRS_PREFOLDING = 8410

# Struct does not exist in v33
const XPRS_COMPUTE = 8411

# Struct does not exist in v33
const XPRS_NETSTALLLIMIT = 8412

# Struct does not exist in v33
const XPRS_SERIALIZEPREINTSOL = 8413

# Struct does not exist in v33
const XPRS_NUMERICALEMPHASIS = 8416

# Struct does not exist in v33
const XPRS_PWLNONCONVEXTRANSFORMATION = 8420

# Struct does not exist in v33
const XPRS_MIPCOMPONENTS = 8421

# Struct does not exist in v33
const XPRS_MIPCONCURRENTNODES = 8422

# Struct does not exist in v33
const XPRS_MIPCONCURRENTSOLVES = 8423

# Struct does not exist in v33
const XPRS_OUTPUTCONTROLS = 8424

# Struct does not exist in v33
const XPRS_SIFTSWITCH = 8425

# Struct does not exist in v33
const XPRS_HEUREMPHASIS = 8427

# Struct does not exist in v33
const XPRS_BARREFITER = 8431

# Struct does not exist in v33
const XPRS_COMPUTELOG = 8434

# Struct does not exist in v33
const XPRS_SIFTPRESOLVEOPS = 8435

# Struct does not exist in v33
const XPRS_CHECKINPUTDATA = 8436

# Struct does not exist in v33
const XPRS_ESCAPENAMES = 8440

# Struct does not exist in v33
const XPRS_IOTIMEOUT = 8442

# Struct does not exist in v33
const XPRS_AUTOCUTTING = 8446

# Struct does not exist in v33
const XPRS_CALLBACKCHECKTIMEDELAY = 8451

# Struct does not exist in v33
const XPRS_MULTIOBJOPS = 8457

# Struct does not exist in v33
const XPRS_MULTIOBJLOG = 8458

# Struct does not exist in v33
const XPRS_BACKGROUNDMAXTHREADS = 8461

# Struct does not exist in v33
const XPRS_GLOBALSPATIALBRANCHIFPREFERORIG = 8465

# Struct does not exist in v33
const XPRS_PRECONFIGURATION = 8470

# Struct does not exist in v33
const XPRS_FEASIBILITYJUMP = 8471

# Struct does not exist in v33
const XPRS_IISOPS = 8472

# Struct does not exist in v33
const XPRS_RLTCUTS = 8476

# Struct does not exist in v33
const XPRS_ALTERNATIVEREDCOSTS = 8478

# Struct does not exist in v33
const XPRS_HEURSHIFTPROP = 8479

const XPRS_EXTRAELEMS = 8006

const XPRS_EXTRASETELEMS = 8191

# Struct does not exist in v33
const XPRS_BACKGROUNDSELECT = 8463

# Struct does not exist in v33
const XPRS_HEURSEARCHBACKGROUNDSELECT = 8477

const XPRS_MATRIXNAME = 3001

const XPRS_BOUNDNAME = 3002

const XPRS_OBJNAME = 3003

const XPRS_RHSNAME = 3004

const XPRS_RANGENAME = 3005

const XPRS_XPRESSVERSION = 3010

const XPRS_UUID = 3011

# Struct does not exist in v33
const XPRS_MIPSOLTIME = 1371

const XPRS_TIME = 1122

const XPRS_LPOBJVAL = 2001

const XPRS_SUMPRIMALINF = 2002

const XPRS_MIPOBJVAL = 2003

const XPRS_BESTBOUND = 2004

const XPRS_OBJRHS = 2005

const XPRS_MIPBESTOBJVAL = 2006

const XPRS_OBJSENSE = 2008

const XPRS_BRANCHVALUE = 2009

const XPRS_PENALTYVALUE = 2061

const XPRS_CURRMIPCUTOFF = 2062

const XPRS_BARCONDA = 2063

const XPRS_BARCONDD = 2064

const XPRS_MAXABSPRIMALINFEAS = 2073

const XPRS_MAXRELPRIMALINFEAS = 2074

const XPRS_MAXABSDUALINFEAS = 2075

const XPRS_MAXRELDUALINFEAS = 2076

const XPRS_PRIMALDUALINTEGRAL = 2079

# Struct does not exist in v33
const XPRS_MAXMIPINFEAS = 2083

# Struct does not exist in v33
const XPRS_ATTENTIONLEVEL = 2097

# Struct does not exist in v33
const XPRS_MAXKAPPA = 2098

# Struct does not exist in v33
const XPRS_TREECOMPLETION = 2104

# Struct does not exist in v33
const XPRS_PREDICTEDATTLEVEL = 2105

# Struct does not exist in v33
const XPRS_OBSERVEDPRIMALINTEGRAL = 2106

# Struct does not exist in v33
const XPRS_CPISCALEFACTOR = 2117

# Struct does not exist in v33
const XPRS_OBJVAL = 2118

const XPRS_BARPRIMALOBJ = 4001

const XPRS_BARDUALOBJ = 4002

const XPRS_BARPRIMALINF = 4003

const XPRS_BARDUALINF = 4004

const XPRS_BARCGAP = 4005

const XPRS_ROWS = 1001

const XPRS_SETS = 1004

const XPRS_PRIMALINFEAS = 1007

const XPRS_DUALINFEAS = 1008

const XPRS_SIMPLEXITER = 1009

const XPRS_LPSTATUS = 1010

const XPRS_MIPSTATUS = 1011

const XPRS_CUTS = 1012

const XPRS_NODES = 1013

const XPRS_NODEDEPTH = 1014

const XPRS_ACTIVENODES = 1015

const XPRS_MIPSOLNODE = 1016

const XPRS_MIPSOLS = 1017

const XPRS_COLS = 1018

const XPRS_SPAREROWS = 1019

const XPRS_SPARECOLS = 1020

const XPRS_SPAREMIPENTS = 1022

const XPRS_ERRORCODE = 1023

const XPRS_MIPINFEAS = 1024

const XPRS_PRESOLVESTATE = 1026

const XPRS_PARENTNODE = 1027

const XPRS_NAMELENGTH = 1028

const XPRS_QELEMS = 1030

const XPRS_NUMIIS = 1031

const XPRS_MIPENTS = 1032

const XPRS_BRANCHVAR = 1036

const XPRS_MIPTHREADID = 1037

const XPRS_ALGORITHM = 1049

# Struct does not exist in v33
const XPRS_SOLSTATUS = 1053

const XPRS_ORIGINALROWS = 1124

const XPRS_CALLBACKCOUNT_OPTNODE = 1136

const XPRS_CALLBACKCOUNT_CUTMGR = 1137

const XPRS_ORIGINALQELEMS = 1157

const XPRS_MAXPROBNAMELENGTH = 1158

const XPRS_STOPSTATUS = 1179

const XPRS_ORIGINALMIPENTS = 1191

const XPRS_ORIGINALSETS = 1194

const XPRS_SPARESETS = 1203

const XPRS_CHECKSONMAXTIME = 1208

const XPRS_CHECKSONMAXCUTTIME = 1209

const XPRS_ORIGINALCOLS = 1214

const XPRS_QCELEMS = 1232

const XPRS_QCONSTRAINTS = 1234

const XPRS_ORIGINALQCELEMS = 1237

const XPRS_ORIGINALQCONSTRAINTS = 1239

const XPRS_PEAKTOTALTREEMEMORYUSAGE = 1240

const XPRS_CURRENTNODE = 1248

const XPRS_TREEMEMORYUSAGE = 1251

# Struct does not exist in v33
const XPRS_TREEFILESIZE = 1252

# Struct does not exist in v33
const XPRS_TREEFILEUSAGE = 1253

const XPRS_INDICATORS = 1254

const XPRS_ORIGINALINDICATORS = 1255

const XPRS_CORESPERCPUDETECTED = 1258

const XPRS_CPUSDETECTED = 1259

const XPRS_CORESDETECTED = 1260

# Struct does not exist in v33
const XPRS_PHYSICALCORESDETECTED = 1261

# Struct does not exist in v33
const XPRS_PHYSICALCORESPERCPUDETECTED = 1262

# Struct does not exist in v33
const XPRS_OPTIMIZETYPEUSED = 1268

const XPRS_BARSING = 1281

const XPRS_BARSINGR = 1282

const XPRS_PRESOLVEINDEX = 1284

const XPRS_CONES = 1307

const XPRS_CONEELEMS = 1308

# Struct does not exist in v33
const XPRS_PWLCONS = 1325

# Struct does not exist in v33
const XPRS_GENCONS = 1327

# Struct does not exist in v33
const XPRS_TREERESTARTS = 1335

# Struct does not exist in v33
const XPRS_ORIGINALPWLS = 1336

# Struct does not exist in v33
const XPRS_ORIGINALGENCONS = 1338

# Struct does not exist in v33
const XPRS_COMPUTEEXECUTIONS = 1356

# Struct does not exist in v33
const XPRS_RESTARTS = 1381

# Struct does not exist in v33
const XPRS_SOLVESTATUS = 1394

# Struct does not exist in v33
const XPRS_GLOBALBOUNDINGBOXAPPLIED = 1396

# Struct does not exist in v33
const XPRS_OBJECTIVES = 1397

# Struct does not exist in v33
const XPRS_SOLVEDOBJS = 1399

# Struct does not exist in v33
const XPRS_OBJSTOSOLVE = 1400

# Struct does not exist in v33
const XPRS_GLOBALNLPINFEAS = 1403

# Struct does not exist in v33
const XPRS_IISSOLSTATUS = 1406

const XPRS_BARITER = 5001

const XPRS_BARDENSECOL = 5004

const XPRS_BARCROSSOVER = 5005

const XPRS_IIS = XPRS_NUMIIS

const XPRS_SETMEMBERS = 1005

const XPRS_ELEMS = 1006

const XPRS_SPAREELEMS = 1021

# Struct does not exist in v33
const XPRS_SYSTEMMEMORY = 1148

const XPRS_ORIGINALSETMEMBERS = 1195

const XPRS_SPARESETELEMS = 1204

# Struct does not exist in v33
const XPRS_CURRENTMEMORY = 1285

# Struct does not exist in v33
const XPRS_PEAKMEMORY = 1286

# Struct does not exist in v33
const XPRS_TOTALMEMORY = 1322

# Struct does not exist in v33
const XPRS_AVAILABLEMEMORY = 1324

# Struct does not exist in v33
const XPRS_PWLPOINTS = 1326

# Struct does not exist in v33
const XPRS_GENCONCOLS = 1328

# Struct does not exist in v33
const XPRS_GENCONVALS = 1329

# Struct does not exist in v33
const XPRS_ORIGINALPWLPOINTS = 1337

# Struct does not exist in v33
const XPRS_ORIGINALGENCONCOLS = 1339

# Struct does not exist in v33
const XPRS_ORIGINALGENCONVALS = 1340

# Struct does not exist in v33
const XPRS_MEMORYLIMITDETECTED = 1380

const XPRS_BARAASIZE = 5002

const XPRS_BARLSIZE = 5003

const XPRS_MSP_DEFAULTUSERSOLFEASTOL = 6209

const XPRS_MSP_DEFAULTUSERSOLMIPTOL = 6210

const XPRS_MSP_SOL_FEASTOL = 6402

const XPRS_MSP_SOL_MIPTOL = 6403

const XPRS_MSP_DUPLICATESOLUTIONSPOLICY = 6203

const XPRS_MSP_INCLUDEPROBNAMEINLOGGING = 6211

const XPRS_MSP_WRITESLXSOLLOGGING = 6212

const XPRS_MSP_ENABLESLACKSTORAGE = 6213

const XPRS_MSP_OUTPUTLOG = 6214

const XPRS_MSP_SOL_BITFIELDSUSR = 6406

const XPRS_MSP_SOLPRB_OBJ = 6500

const XPRS_MSP_SOLPRB_INFSUM_PRIMAL = 6502

const XPRS_MSP_SOLPRB_INFSUM_MIP = 6504

const XPRS_MSP_SOLUTIONS = 6208

const XPRS_MSP_PRB_VALIDSOLS = 6300

const XPRS_MSP_PRB_FEASIBLESOLS = 6301

const XPRS_MSP_SOL_COLS = 6400

const XPRS_MSP_SOL_NONZEROS = 6401

const XPRS_MSP_SOL_ISUSERSOLUTION = 6404

const XPRS_MSP_SOL_ISREPROCESSEDUSERSOLUTION = 6405

const XPRS_MSP_SOL_BITFIELDSSYS = 6407

const XPRS_MSP_SOLPRB_INFEASCOUNT = 6501

const XPRS_MSP_SOLPRB_INFCNT_PRIMAL = 6503

const XPRS_MSP_SOLPRB_INFCNT_MIP = 6505

const XPRS_MSE_OUTPUTTOL = 6609

const XPRS_MSE_CALLBACKCULLSOLS_MIPOBJECT = 6601

const XPRS_MSE_CALLBACKCULLSOLS_DIVERSITY = 6602

const XPRS_MSE_CALLBACKCULLSOLS_MODOBJECT = 6603

const XPRS_MSE_OPTIMIZEDIVERSITY = 6607

const XPRS_MSE_OUTPUTLOG = 6610

const XPRS_MSE_DIVERSITYSUM = 6608

const XPRS_MSE_SOLUTIONS = 6600

const XPRS_MSE_METRIC_MIPOBJECT = 6604

const XPRS_MSE_METRIC_DIVERSITY = 6605

const XPRS_MSE_METRIC_MODOBJECT = 6606

# Struct does not exist in v33
const XPRS_NLPFUNCEVAL = 12312

# Struct does not exist in v33
const XPRS_NLPLOG = 12316

# Struct does not exist in v33
const XPRS_NLPKEEPEQUALSCOLUMN = 12325

# Struct does not exist in v33
const XPRS_NLPEVALUATE = 12334

# Struct does not exist in v33
const XPRS_NLPPRESOLVE = 12344

# Struct does not exist in v33
const XPRS_LOCALSOLVER = 12352

# Struct does not exist in v33
const XPRS_NLPSTOPOUTOFRANGE = 12354

# Struct does not exist in v33
const XPRS_NLPTHREADSAFEUSERFUNC = 12359

# Struct does not exist in v33
const XPRS_NLPJACOBIAN = 12360

# Struct does not exist in v33
const XPRS_NLPHESSIAN = 12361

# Struct does not exist in v33
const XPRS_MULTISTART = 12362

# Struct does not exist in v33
const XPRS_MULTISTART_THREADS = 12363

# Struct does not exist in v33
const XPRS_MULTISTART_MAXSOLVES = 12364

# Struct does not exist in v33
const XPRS_MULTISTART_MAXTIME = 12365

# Struct does not exist in v33
const XPRS_NLPMAXTIME = 12366

# Struct does not exist in v33
const XPRS_NLPDERIVATIVES = 12373

# Struct does not exist in v33
const XPRS_NLPREFORMULATE = 12392

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS = 12393

# Struct does not exist in v33
const XPRS_MULTISTART_LOG = 12395

# Struct does not exist in v33
const XPRS_MULTISTART_SEED = 12396

# Struct does not exist in v33
const XPRS_MULTISTART_POOLSIZE = 12397

# Struct does not exist in v33
const XPRS_NLPPOSTSOLVE = 12398

# Struct does not exist in v33
const XPRS_NLPDETERMINISTIC = 12399

# Struct does not exist in v33
const XPRS_NLPPRESOLVELEVEL = 12402

# Struct does not exist in v33
const XPRS_NLPPROBING = 12403

# Struct does not exist in v33
const XPRS_NLPCALCTHREADS = 12405

# Struct does not exist in v33
const XPRS_NLPTHREADS = 12406

# Struct does not exist in v33
const XPRS_NLPFINDIV = 12413

# Struct does not exist in v33
const XPRS_NLPLINQUADBR = 12414

# Struct does not exist in v33
const XPRS_NLPSOLVER = 12417

# Struct does not exist in v33
const XPRS_SLPALGORITHM = 12301

# Struct does not exist in v33
const XPRS_SLPAUGMENTATION = 12302

# Struct does not exist in v33
const XPRS_SLPBARLIMIT = 12303

# Struct does not exist in v33
const XPRS_SLPCASCADE = 12304

# Struct does not exist in v33
const XPRS_SLPCASCADENLIMIT = 12306

# Struct does not exist in v33
const XPRS_SLPDAMPSTART = 12308

# Struct does not exist in v33
const XPRS_SLPCUTSTRATEGY = 12310

# Struct does not exist in v33
const XPRS_SLPDELTAZLIMIT = 12311

# Struct does not exist in v33
const XPRS_SLPINFEASLIMIT = 12314

# Struct does not exist in v33
const XPRS_SLPITERLIMIT = 12315

# Struct does not exist in v33
const XPRS_SLPSAMECOUNT = 12317

# Struct does not exist in v33
const XPRS_SLPSAMEDAMP = 12319

# Struct does not exist in v33
const XPRS_SLPSBSTART = 12320

# Struct does not exist in v33
const XPRS_SLPXCOUNT = 12321

# Struct does not exist in v33
const XPRS_SLPXLIMIT = 12322

# Struct does not exist in v33
const XPRS_SLPDELAYUPDATEROWS = 12329

# Struct does not exist in v33
const XPRS_SLPAUTOSAVE = 12330

# Struct does not exist in v33
const XPRS_SLPANALYZE = 12332

# Struct does not exist in v33
const XPRS_SLPOCOUNT = 12333

# Struct does not exist in v33
const XPRS_SLPMIPALGORITHM = 12336

# Struct does not exist in v33
const XPRS_SLPMIPRELAXSTEPBOUNDS = 12337

# Struct does not exist in v33
const XPRS_SLPMIPFIXSTEPBOUNDS = 12338

# Struct does not exist in v33
const XPRS_SLPMIPITERLIMIT = 12339

# Struct does not exist in v33
const XPRS_SLPMIPCUTOFFLIMIT = 12340

# Struct does not exist in v33
const XPRS_SLPMIPOCOUNT = 12341

# Struct does not exist in v33
const XPRS_SLPMIPDEFAULTALGORITHM = 12343

# Struct does not exist in v33
const XPRS_SLPMIPLOG = 12347

# Struct does not exist in v33
const XPRS_SLPDELTAOFFSET = 12348

# Struct does not exist in v33
const XPRS_SLPUPDATEOFFSET = 12349

# Struct does not exist in v33
const XPRS_SLPERROROFFSET = 12350

# Struct does not exist in v33
const XPRS_SLPSBROWOFFSET = 12351

# Struct does not exist in v33
const XPRS_SLPVCOUNT = 12356

# Struct does not exist in v33
const XPRS_SLPVLIMIT = 12357

# Struct does not exist in v33
const XPRS_SLPECFCHECK = 12369

# Struct does not exist in v33
const XPRS_SLPMIPCUTOFFCOUNT = 12370

# Struct does not exist in v33
const XPRS_SLPWCOUNT = 12374

# Struct does not exist in v33
const XPRS_SLPUNFINISHEDLIMIT = 12376

# Struct does not exist in v33
const XPRS_SLPCONVERGENCEOPS = 12377

# Struct does not exist in v33
const XPRS_SLPZEROCRITERION = 12378

# Struct does not exist in v33
const XPRS_SLPZEROCRITERIONSTART = 12379

# Struct does not exist in v33
const XPRS_SLPZEROCRITERIONCOUNT = 12380

# Struct does not exist in v33
const XPRS_SLPLSPATTERNLIMIT = 12381

# Struct does not exist in v33
const XPRS_SLPLSITERLIMIT = 12382

# Struct does not exist in v33
const XPRS_SLPLSSTART = 12383

# Struct does not exist in v33
const XPRS_SLPPENALTYINFOSTART = 12384

# Struct does not exist in v33
const XPRS_SLPFILTER = 12387

# Struct does not exist in v33
const XPRS_SLPTRACEMASKOPS = 12388

# Struct does not exist in v33
const XPRS_SLPLSZEROLIMIT = 12389

# Struct does not exist in v33
const XPRS_SLPHEURSTRATEGY = 12400

# Struct does not exist in v33
const XPRS_SLPBARCROSSOVERSTART = 12408

# Struct does not exist in v33
const XPRS_SLPBARSTALLINGLIMIT = 12409

# Struct does not exist in v33
const XPRS_SLPBARSTALLINGOBJLIMIT = 12410

# Struct does not exist in v33
const XPRS_SLPBARSTARTOPS = 12411

# Struct does not exist in v33
const XPRS_SLPGRIDHEURSELECT = 12412

# Struct does not exist in v33
const XPRS_NLPINFINITY = 12119

# Struct does not exist in v33
const XPRS_NLPZERO = 12123

# Struct does not exist in v33
const XPRS_NLPDEFAULTIV = 12145

# Struct does not exist in v33
const XPRS_NLPOPTTIME = 12147

# Struct does not exist in v33
const XPRS_NLPVALIDATIONTOL_A = 12165

# Struct does not exist in v33
const XPRS_NLPVALIDATIONTOL_R = 12166

# Struct does not exist in v33
const XPRS_NLPVALIDATIONINDEX_A = 12167

# Struct does not exist in v33
const XPRS_NLPVALIDATIONINDEX_R = 12168

# Struct does not exist in v33
const XPRS_NLPPRIMALINTEGRALREF = 12175

# Struct does not exist in v33
const XPRS_NLPPRIMALINTEGRALALPHA = 12176

# Struct does not exist in v33
const XPRS_NLPOBJVAL = 12179

# Struct does not exist in v33
const XPRS_NLPPRESOLVEZERO = 12193

# Struct does not exist in v33
const XPRS_NLPMERITLAMBDA = 12197

# Struct does not exist in v33
const XPRS_MSMAXBOUNDRANGE = 12204

# Struct does not exist in v33
const XPRS_NLPVALIDATIONTOL_K = 12205

# Struct does not exist in v33
const XPRS_NLPPRESOLVE_ELIMTOL = 12206

# Struct does not exist in v33
const XPRS_NLPVALIDATIONTARGET_R = 12209

# Struct does not exist in v33
const XPRS_NLPVALIDATIONTARGET_K = 12210

# Struct does not exist in v33
const XPRS_NLPVALIDATIONFACTOR = 12211

# Struct does not exist in v33
const XPRS_SLPDAMP = 12103

# Struct does not exist in v33
const XPRS_SLPDAMPEXPAND = 12104

# Struct does not exist in v33
const XPRS_SLPDAMPSHRINK = 12105

# Struct does not exist in v33
const XPRS_SLPDELTA_A = 12106

# Struct does not exist in v33
const XPRS_SLPDELTA_R = 12107

# Struct does not exist in v33
const XPRS_SLPDELTA_Z = 12108

# Struct does not exist in v33
const XPRS_SLPDELTACOST = 12109

# Struct does not exist in v33
const XPRS_SLPDELTAMAXCOST = 12110

# Struct does not exist in v33
const XPRS_SLPDJTOL = 12112

# Struct does not exist in v33
const XPRS_SLPERRORCOST = 12113

# Struct does not exist in v33
const XPRS_SLPERRORMAXCOST = 12114

# Struct does not exist in v33
const XPRS_SLPERRORTOL_A = 12116

# Struct does not exist in v33
const XPRS_SLPEXPAND = 12118

# Struct does not exist in v33
const XPRS_SLPMAXWEIGHT = 12120

# Struct does not exist in v33
const XPRS_SLPMINWEIGHT = 12121

# Struct does not exist in v33
const XPRS_SLPSHRINK = 12122

# Struct does not exist in v33
const XPRS_SLPCTOL = 12124

# Struct does not exist in v33
const XPRS_SLPATOL_A = 12125

# Struct does not exist in v33
const XPRS_SLPATOL_R = 12126

# Struct does not exist in v33
const XPRS_SLPMTOL_A = 12127

# Struct does not exist in v33
const XPRS_SLPMTOL_R = 12128

# Struct does not exist in v33
const XPRS_SLPITOL_A = 12129

# Struct does not exist in v33
const XPRS_SLPITOL_R = 12130

# Struct does not exist in v33
const XPRS_SLPSTOL_A = 12131

# Struct does not exist in v33
const XPRS_SLPSTOL_R = 12132

# Struct does not exist in v33
const XPRS_SLPMVTOL = 12133

# Struct does not exist in v33
const XPRS_SLPXTOL_A = 12134

# Struct does not exist in v33
const XPRS_SLPXTOL_R = 12135

# Struct does not exist in v33
const XPRS_SLPDEFAULTSTEPBOUND = 12136

# Struct does not exist in v33
const XPRS_SLPDAMPMAX = 12137

# Struct does not exist in v33
const XPRS_SLPDAMPMIN = 12138

# Struct does not exist in v33
const XPRS_SLPDELTACOSTFACTOR = 12139

# Struct does not exist in v33
const XPRS_SLPERRORCOSTFACTOR = 12140

# Struct does not exist in v33
const XPRS_SLPERRORTOL_P = 12141

# Struct does not exist in v33
const XPRS_SLPCASCADETOL_PA = 12142

# Struct does not exist in v33
const XPRS_SLPCASCADETOL_PR = 12143

# Struct does not exist in v33
const XPRS_SLPCASCADETOL_Z = 12144

# Struct does not exist in v33
const XPRS_SLPOTOL_A = 12150

# Struct does not exist in v33
const XPRS_SLPOTOL_R = 12151

# Struct does not exist in v33
const XPRS_SLPDELTA_X = 12152

# Struct does not exist in v33
const XPRS_SLPERRORCOSTS = 12153

# Struct does not exist in v33
const XPRS_SLPGRANULARITY = 12157

# Struct does not exist in v33
const XPRS_SLPMIPCUTOFF_A = 12158

# Struct does not exist in v33
const XPRS_SLPMIPCUTOFF_R = 12159

# Struct does not exist in v33
const XPRS_SLPMIPOTOL_A = 12160

# Struct does not exist in v33
const XPRS_SLPMIPOTOL_R = 12161

# Struct does not exist in v33
const XPRS_SLPESCALATION = 12169

# Struct does not exist in v33
const XPRS_SLPOBJTOPENALTYCOST = 12170

# Struct does not exist in v33
const XPRS_SLPSHRINKBIAS = 12171

# Struct does not exist in v33
const XPRS_SLPFEASTOLTARGET = 12172

# Struct does not exist in v33
const XPRS_SLPOPTIMALITYTOLTARGET = 12173

# Struct does not exist in v33
const XPRS_SLPDELTA_INFINITY = 12174

# Struct does not exist in v33
const XPRS_SLPVTOL_A = 12177

# Struct does not exist in v33
const XPRS_SLPVTOL_R = 12178

# Struct does not exist in v33
const XPRS_SLPETOL_A = 12180

# Struct does not exist in v33
const XPRS_SLPETOL_R = 12181

# Struct does not exist in v33
const XPRS_SLPEVTOL_A = 12182

# Struct does not exist in v33
const XPRS_SLPEVTOL_R = 12183

# Struct does not exist in v33
const XPRS_SLPDELTA_ZERO = 12184

# Struct does not exist in v33
const XPRS_SLPMINSBFACTOR = 12185

# Struct does not exist in v33
const XPRS_SLPCLAMPVALIDATIONTOL_A = 12186

# Struct does not exist in v33
const XPRS_SLPCLAMPVALIDATIONTOL_R = 12187

# Struct does not exist in v33
const XPRS_SLPCLAMPSHRINK = 12188

# Struct does not exist in v33
const XPRS_SLPECFTOL_A = 12189

# Struct does not exist in v33
const XPRS_SLPECFTOL_R = 12190

# Struct does not exist in v33
const XPRS_SLPWTOL_A = 12191

# Struct does not exist in v33
const XPRS_SLPWTOL_R = 12192

# Struct does not exist in v33
const XPRS_SLPMATRIXTOL = 12194

# Struct does not exist in v33
const XPRS_SLPDRFIXRANGE = 12195

# Struct does not exist in v33
const XPRS_SLPDRCOLTOL = 12196

# Struct does not exist in v33
const XPRS_SLPMIPERRORTOL_A = 12198

# Struct does not exist in v33
const XPRS_SLPMIPERRORTOL_R = 12199

# Struct does not exist in v33
const XPRS_SLPCDTOL_A = 12200

# Struct does not exist in v33
const XPRS_SLPCDTOL_R = 12201

# Struct does not exist in v33
const XPRS_SLPENFORCEMAXCOST = 12202

# Struct does not exist in v33
const XPRS_SLPENFORCECOSTSHRINK = 12203

# Struct does not exist in v33
const XPRS_SLPDRCOLDJTOL = 12208

# Struct does not exist in v33
const XPRS_SLPBARSTALLINGTOL = 12212

# Struct does not exist in v33
const XPRS_SLPOBJTHRESHOLD = 12213

# Struct does not exist in v33
const XPRS_SLPBOUNDTHRESHOLD = 12214

# Struct does not exist in v33
const XPRS_NLPIVNAME = 12453

# Struct does not exist in v33
const XPRS_SLPDELTAFORMAT = 12452

# Struct does not exist in v33
const XPRS_SLPMINUSDELTAFORMAT = 12456

# Struct does not exist in v33
const XPRS_SLPMINUSERRORFORMAT = 12457

# Struct does not exist in v33
const XPRS_SLPPLUSDELTAFORMAT = 12458

# Struct does not exist in v33
const XPRS_SLPPLUSERRORFORMAT = 12459

# Struct does not exist in v33
const XPRS_SLPSBNAME = 12460

# Struct does not exist in v33
const XPRS_SLPTOLNAME = 12461

# Struct does not exist in v33
const XPRS_SLPUPDATEFORMAT = 12462

# Struct does not exist in v33
const XPRS_SLPPENALTYROWFORMAT = 12463

# Struct does not exist in v33
const XPRS_SLPPENALTYCOLFORMAT = 12464

# Struct does not exist in v33
const XPRS_SLPSBLOROWFORMAT = 12467

# Struct does not exist in v33
const XPRS_SLPSBUPROWFORMAT = 12468

# Struct does not exist in v33
const XPRS_SLPTRACEMASK = 12472

# Struct does not exist in v33
const XPRS_SLPITERFALLBACKOPS = 12474

# Struct does not exist in v33
const XPRS_NLPVALIDATIONSTATUS = 11986

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS = 11987

# Struct does not exist in v33
const XPRS_NLPORIGINALROWS = 11999

# Struct does not exist in v33
const XPRS_NLPORIGINALCOLS = 12000

# Struct does not exist in v33
const XPRS_NLPUFS = 12007

# Struct does not exist in v33
const XPRS_NLPIFS = 12008

# Struct does not exist in v33
const XPRS_NLPEQUALSCOLUMN = 12013

# Struct does not exist in v33
const XPRS_NLPVARIABLES = 12014

# Struct does not exist in v33
const XPRS_NLPIMPLICITVARIABLES = 12015

# Struct does not exist in v33
const XPRS_NONLINEARCONSTRAINTS = 12026

# Struct does not exist in v33
const XPRS_NLPUSERFUNCCALLS = 12031

# Struct does not exist in v33
const XPRS_NLPUSEDERIVATIVES = 12037

# Struct does not exist in v33
const XPRS_NLPKEEPBESTITER = 12042

# Struct does not exist in v33
const XPRS_NLPSTATUS = 12044

# Struct does not exist in v33
const XPRS_LOCALSOLVERSELECTED = 12075

# Struct does not exist in v33
const XPRS_NLPMODELROWS = 12079

# Struct does not exist in v33
const XPRS_NLPMODELCOLS = 12080

# Struct does not exist in v33
const XPRS_NLPJOBID = 12081

# Struct does not exist in v33
const XPRS_MSJOBS = 12082

# Struct does not exist in v33
const XPRS_NLPSTOPSTATUS = 12089

# Struct does not exist in v33
const XPRS_NLPPRESOLVEELIMINATIONS = 12090

# Struct does not exist in v33
const XPRS_NLPTOTALEVALUATIONERRORS = 12093

# Struct does not exist in v33
const XPRS_SLPEXPLOREDELTAS = 11993

# Struct does not exist in v33
const XPRS_SLPSEMICONTDELTAS = 11994

# Struct does not exist in v33
const XPRS_SLPINTEGERDELTAS = 11995

# Struct does not exist in v33
const XPRS_SLPITER = 12001

# Struct does not exist in v33
const XPRS_SLPSTATUS = 12002

# Struct does not exist in v33
const XPRS_SLPUNCONVERGED = 12003

# Struct does not exist in v33
const XPRS_SLPSBXCONVERGED = 12004

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTAROW = 12009

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTACOLUMN = 12010

# Struct does not exist in v33
const XPRS_SLPPENALTYERRORROW = 12011

# Struct does not exist in v33
const XPRS_SLPPENALTYERRORCOLUMN = 12012

# Struct does not exist in v33
const XPRS_SLPCOEFFICIENTS = 12016

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTAS = 12017

# Struct does not exist in v33
const XPRS_SLPPENALTYERRORS = 12018

# Struct does not exist in v33
const XPRS_SLPPLUSPENALTYERRORS = 12019

# Struct does not exist in v33
const XPRS_SLPMINUSPENALTYERRORS = 12020

# Struct does not exist in v33
const XPRS_SLPUCCONSTRAINEDCOUNT = 12021

# Struct does not exist in v33
const XPRS_SLPMIPNODES = 12022

# Struct does not exist in v33
const XPRS_SLPMIPITER = 12023

# Struct does not exist in v33
const XPRS_SLPTOLSETS = 12028

# Struct does not exist in v33
const XPRS_SLPECFCOUNT = 12035

# Struct does not exist in v33
const XPRS_SLPDELTAS = 12041

# Struct does not exist in v33
const XPRS_SLPZEROESRESET = 12046

# Struct does not exist in v33
const XPRS_SLPZEROESTOTAL = 12047

# Struct does not exist in v33
const XPRS_SLPZEROESRETAINED = 12048

# Struct does not exist in v33
const XPRS_SLPNONCONSTANTCOEFFS = 12058

# Struct does not exist in v33
const XPRS_SLPMIPSOLS = 12088

# Struct does not exist in v33
const XPRS_NLPVALIDATIONINDEX_K = 12718

# Struct does not exist in v33
const XPRS_NLPVALIDATIONNETOBJ = 12722

# Struct does not exist in v33
const XPRS_NLPPRIMALINTEGRAL = 12726

# Struct does not exist in v33
const XPRS_SLPCURRENTDELTACOST = 12701

# Struct does not exist in v33
const XPRS_SLPCURRENTERRORCOST = 12702

# Struct does not exist in v33
const XPRS_SLPPENALTYERRORTOTAL = 12704

# Struct does not exist in v33
const XPRS_SLPPENALTYERRORVALUE = 12705

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTATOTAL = 12706

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTAVALUE = 12707

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_NEWPOINT = 101001

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_HONORBNDS = 101002

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_ALGORITHM = 101003

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_MURULE = 101004

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_FEASIBLE = 101006

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_GRADOPT = 101007

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_HESSOPT = 101008

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_INITPT = 101009

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MAXCGIT = 101013

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MAXIT = 101014

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_OUTLEV = 101015

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_SCALE = 101017

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_SOC = 101019

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_DELTA = 101020

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_FEASMODETOL = 101021

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_FEASTOL = 101022

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_FEASTOLABS = 101023

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_INITMU = 101025

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_OBJRANGE = 101026

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_OPTTOL = 101027

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_OPTTOLABS = 101028

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_PIVOT = 101029

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_XTOL = 101030

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_DEBUG = 101031

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MULTISTART = 101033

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSMAXSOLVES = 101034

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSMAXBNDRANGE = 101035

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_LMSIZE = 101038

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_MAXCROSSIT = 101039

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BLASOPTION = 101042

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_MAXREFACTOR = 101043

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_MAXBACKTRACK = 101044

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_PENRULE = 101049

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_PENCONS = 101050

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSNUMTOSAVE = 101051

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSSAVETOL = 101052

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSTERMINATE = 101054

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSSTARTPTRANGE = 101055

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_INFEASTOL = 101056

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_LINSOLVER = 101057

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_DIRECTINTERVAL = 101058

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_PRESOLVE = 101059

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_PRESOLVE_TOL = 101060

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_SWITCHRULE = 101061

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MA_TERMINATE = 101063

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MSSEED = 101066

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_BAR_RELAXCONS = 101077

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_METHOD = 102001

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_BRANCHRULE = 102002

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_SELECTRULE = 102003

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_INTGAPABS = 102004

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_INTGAPREL = 102005

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_OUTLEVEL = 102010

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_OUTINTERVAL = 102011

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_DEBUG = 102013

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_IMPLICATNS = 102014

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_GUB_BRANCH = 102015

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_KNAPSACK = 102016

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_ROUNDING = 102017

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_ROOTALG = 102018

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_LPALG = 102019

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_MAXNODES = 102021

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_HEURISTIC = 102022

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_HEUR_MAXIT = 102023

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_PSEUDOINIT = 102026

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_STRONG_MAXIT = 102027

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_STRONG_CANDLIM = 102028

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_MIP_STRONG_LEVEL = 102029

# Struct does not exist in v33
const XPRS_KNITRO_PARAM_PAR_NUMTHREADS = 103001

# Struct does not exist in v33
const XPRS_TOK_EOF = 0

# Struct does not exist in v33
const XPRS_TOK_CON = 1

# Struct does not exist in v33
const XPRS_TOK_COL = 10

# Struct does not exist in v33
const XPRS_TOK_FUN = 11

# Struct does not exist in v33
const XPRS_TOK_IFUN = 12

# Struct does not exist in v33
const XPRS_TOK_LB = 21

# Struct does not exist in v33
const XPRS_TOK_RB = 22

# Struct does not exist in v33
const XPRS_TOK_DEL = 24

# Struct does not exist in v33
const XPRS_TOK_OP = 31

# Struct does not exist in v33
const XPRS_OP_UMINUS = 1

# Struct does not exist in v33
const XPRS_OP_EXPONENT = 2

# Struct does not exist in v33
const XPRS_OP_MULTIPLY = 3

# Struct does not exist in v33
const XPRS_OP_DIVIDE = 4

# Struct does not exist in v33
const XPRS_OP_PLUS = 5

# Struct does not exist in v33
const XPRS_OP_MINUS = 6

# Struct does not exist in v33
const XPRS_DEL_COMMA = 1

# Struct does not exist in v33
const XPRS_DEL_COLON = 2

# Struct does not exist in v33
const XPRS_IFUN_LOG = 13

# Struct does not exist in v33
const XPRS_IFUN_LOG10 = 14

# Struct does not exist in v33
const XPRS_IFUN_LN = 15

# Struct does not exist in v33
const XPRS_IFUN_EXP = 16

# Struct does not exist in v33
const XPRS_IFUN_ABS = 17

# Struct does not exist in v33
const XPRS_IFUN_SQRT = 18

# Struct does not exist in v33
const XPRS_IFUN_SIN = 27

# Struct does not exist in v33
const XPRS_IFUN_COS = 28

# Struct does not exist in v33
const XPRS_IFUN_TAN = 29

# Struct does not exist in v33
const XPRS_IFUN_ARCSIN = 30

# Struct does not exist in v33
const XPRS_IFUN_ARCCOS = 31

# Struct does not exist in v33
const XPRS_IFUN_ARCTAN = 32

# Struct does not exist in v33
const XPRS_IFUN_MIN = 33

# Struct does not exist in v33
const XPRS_IFUN_MAX = 34

# Struct does not exist in v33
const XPRS_IFUN_PWL = 35

# Struct does not exist in v33
const XPRS_IFUN_SUM = 36

# Struct does not exist in v33
const XPRS_IFUN_PROD = 37

# Struct does not exist in v33
const XPRS_IFUN_SIGN = 46

# Struct does not exist in v33
const XPRS_IFUN_ERF = 49

# Struct does not exist in v33
const XPRS_IFUN_ERFC = 50

# Struct does not exist in v33
const XPRS_SLPTOLSET_TC = 0

# Struct does not exist in v33
const XPRS_SLPTOLSET_TA = 1

# Struct does not exist in v33
const XPRS_SLPTOLSET_RA = 2

# Struct does not exist in v33
const XPRS_SLPTOLSET_TM = 3

# Struct does not exist in v33
const XPRS_SLPTOLSET_RM = 4

# Struct does not exist in v33
const XPRS_SLPTOLSET_TI = 5

# Struct does not exist in v33
const XPRS_SLPTOLSET_RI = 6

# Struct does not exist in v33
const XPRS_SLPTOLSET_TS = 7

# Struct does not exist in v33
const XPRS_SLPTOLSET_RS = 8

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_TC = 0x0001

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_TA = 0x0002

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_RA = 0x0004

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_TM = 0x0008

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_RM = 0x0010

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_TI = 0x0020

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_RI = 0x0040

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_TS = 0x0080

# Struct does not exist in v33
const XPRS_SLPTOLSETBIT_RS = 0x0100

# Struct does not exist in v33
const XPRS_SLPTOLSET_DELETE = 0x00010000

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_CTOL = 0x01

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_ATOL = 0x02

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_MTOL = 0x04

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_ITOL = 0x08

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_STOL = 0x10

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_USER = 0x20

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_VTOL = 0x40

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_XTOL = 0x80

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_OTOL = 0x0100

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_WTOL = 0x0200

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_EXTENDEDSCALING = 0x0400

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_VALIDATION = 0x0800

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_VALIDATION_K = 0x1000

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_NOQUADCHECK = 0x2000

# Struct does not exist in v33
const XPRS_SLPCONVERGEBIT_ECF_BEFORE_SOL = 0x4000

# Struct does not exist in v33
const XPRS_SLPHASNOCOEFS = 0x01

# Struct does not exist in v33
const XPRS_SLPHASDELTA = 0x02

# Struct does not exist in v33
const XPRS_SLPHASIV = 0x04

# Struct does not exist in v33
const XPRS_SLPHASCALCIV = 0x08

# Struct does not exist in v33
const XPRS_SLPISDELTA = 0x0100

# Struct does not exist in v33
const XPRS_SLPISPLUSPENALTYDELTA = 0x0200

# Struct does not exist in v33
const XPRS_SLPISMINUSPENALTYDELTA = 0x0400

# Struct does not exist in v33
const XPRS_SLPISPENALTYDELTA = 0x0600

# Struct does not exist in v33
const XPRS_SLPISPLUSERRORVECTOR = 0x0800

# Struct does not exist in v33
const XPRS_SLPISMINUSERRORVECTOR = 0x1000

# Struct does not exist in v33
const XPRS_SLPISERRORVECTOR = 0x1800

# Struct does not exist in v33
const XPRS_SLPISMISCVECTOR = 0x2000

# Struct does not exist in v33
const XPRS_SLPISEQUALSCOLUMN = 0x4000

# Struct does not exist in v33
const XPRS_NLPPRESOLVEPROTECT = 0x8000

# Struct does not exist in v33
const XPRS_SLPHASCONVERGED = 0x00010000

# Struct does not exist in v33
const XPRS_SLPACTIVESTEPBOUND = 0x00020000

# Struct does not exist in v33
const XPRS_SLPACTIVESBROW = 0x00040000

# Struct does not exist in v33
const XPRS_SLPELIMINATEDCOL = 0x00080000

# Struct does not exist in v33
const XPRS_SLPISSTRUCTURALCOLUMN = 0x00200000

# Struct does not exist in v33
const XPRS_SLPISINCOEFS = 0x00400000

# Struct does not exist in v33
const XPRS_SLPISINGLOBAL = 0x00800000

# Struct does not exist in v33
const XPRS_SLPHASZEROBOUND = 0x01000000

# Struct does not exist in v33
const XPRS_SLPFIXEDVAR = 0x02000000

# Struct does not exist in v33
const XPRS_SLPBOUNDSSET = 0x04000000

# Struct does not exist in v33
const XPRS_SLPUSEFULDELTA = 0x08000000

# Struct does not exist in v33
const XPRS_SLPNOUSEFULDELTA = 0x08000000

# Struct does not exist in v33
const XPRS_SLPISINTEGER = 0x10000000

# Struct does not exist in v33
const XPRS_SLPCASCADECONTRACTION = 0x20000000

# Struct does not exist in v33
const XPRS_SLPISUPDATEROW = 0x02

# Struct does not exist in v33
const XPRS_SLPISPENALTYROW = 0x04

# Struct does not exist in v33
const XPRS_SLPISMISCROW = 0x40

# Struct does not exist in v33
const XPRS_SLPISSBROW = 0x80

# Struct does not exist in v33
const XPRS_SLPHASPLUSERROR = 0x0100

# Struct does not exist in v33
const XPRS_SLPHASMINUSERROR = 0x0200

# Struct does not exist in v33
const XPRS_SLPHASERROR = 0x0300

# Struct does not exist in v33
const XPRS_SLPISDETERMININGROW = 0x0400

# Struct does not exist in v33
const XPRS_SLPNOERRORVECTORS = 0x0800

# Struct does not exist in v33
const XPRS_SLPHASNONZEROCOEF = 0x1000

# Struct does not exist in v33
const XPRS_SLPREDUNDANTROW = 0x2000

# Struct does not exist in v33
const XPRS_SLPUNCONVERGEDROW = 0x4000

# Struct does not exist in v33
const XPRS_SLPACTIVEPENALTY = 0x8000

# Struct does not exist in v33
const XPRS_SLPHASSLPELEMENT = 0x00010000

# Struct does not exist in v33
const XPRS_SLPTRANSFERROW = 0x00040000

# Struct does not exist in v33
const XPRS_SLPMINIMUMAUGMENTATION = 0x01

# Struct does not exist in v33
const XPRS_SLPEVENHANDEDAUGMENTATION = 0x02

# Struct does not exist in v33
const XPRS_SLPEQUALITYERRORVECTORS = 0x04

# Struct does not exist in v33
const XPRS_SLPALLERRORVECTORS = 0x08

# Struct does not exist in v33
const XPRS_SLPPENALTYDELTAVECTORS = 0x10

# Struct does not exist in v33
const XPRS_SLPAMEANWEIGHT = 0x20

# Struct does not exist in v33
const XPRS_SLPSBFROMVALUES = 0x40

# Struct does not exist in v33
const XPRS_SLPSBFROMABSVALUES = 0x80

# Struct does not exist in v33
const XPRS_SLPSTEPBOUNDROWS = 0x0100

# Struct does not exist in v33
const XPRS_SLPALLROWERRORVECTORS = 0x0200

# Struct does not exist in v33
const XPRS_SLPNOUPDATEIFONLYIV = 0x0400

# Struct does not exist in v33
const XPRS_SLPNOFORMULADOMAINIV = 0x0800

# Struct does not exist in v33
const XPRS_SLPSKIPIVLPHEURISTICS = 0x1000

# Struct does not exist in v33
const XPRS_SLPNOSTEPBOUNDS = 0x01

# Struct does not exist in v33
const XPRS_SLPSTEPBOUNDSASREQUIRED = 0x02

# Struct does not exist in v33
const XPRS_SLPESTIMATESTEPBOUNDS = 0x04

# Struct does not exist in v33
const XPRS_SLPDYNAMICDAMPING = 0x08

# Struct does not exist in v33
const XPRS_SLPHOLDVALUES = 0x10

# Struct does not exist in v33
const XPRS_SLPRETAINPREVIOUSVALUE = 0x20

# Struct does not exist in v33
const XPRS_SLPRESETDELTAZ = 0x40

# Struct does not exist in v33
const XPRS_SLPQUICKCONVERGENCECHECK = 0x80

# Struct does not exist in v33
const XPRS_SLPESCALATEPENALTIES = 0x0100

# Struct does not exist in v33
const XPRS_SLPSWITCHTOPRIMAL = 0x0200

# Struct does not exist in v33
const XPRS_SLPNONZEROBOUND = 0x0400

# Struct does not exist in v33
const XPRS_SLPMAXCOSTOPTION = 0x0800

# Struct does not exist in v33
const XPRS_SLPRESIDUALERRORS = 0x1000

# Struct does not exist in v33
const XPRS_SLPNOLPPOLISHING = 0x2000

# Struct does not exist in v33
const XPRS_SLPCASCADEDBOUNDS = 0x4000

# Struct does not exist in v33
const XPRS_SLPCLAMPEXTENDEDACTIVESB = 0x8000

# Struct does not exist in v33
const XPRS_SLPCLAMPEXTENDEDALL = 0x00010000

# Struct does not exist in v33
const XPRS_SLPMIPINITIALSLP = 0x01

# Struct does not exist in v33
const XPRS_SLPMIPINITIALRELAXSLP = 0x04

# Struct does not exist in v33
const XPRS_SLPMIPINITIALFIXSLP = 0x08

# Struct does not exist in v33
const XPRS_SLPMIPNODERELAXSLP = 0x10

# Struct does not exist in v33
const XPRS_SLPMIPNODEFIXSLP = 0x20

# Struct does not exist in v33
const XPRS_SLPMIPNODELIMITSLP = 0x40

# Struct does not exist in v33
const XPRS_SLPMIPFINALRELAXSLP = 0x80

# Struct does not exist in v33
const XPRS_SLPMIPFINALFIXSLP = 0x0100

# Struct does not exist in v33
const XPRS_SLPMIPWITHINSLP = 0x0200

# Struct does not exist in v33
const XPRS_SLPSLPTHENMIP = 0x0400

# Struct does not exist in v33
const XPRS_SLPROOTMIPDRIVEN = 0x1000

# Struct does not exist in v33
const XPRS_SLPSTATUS_CONVERGEDOBJUCC = 0x01

# Struct does not exist in v33
const XPRS_SLPSTATUS_CONVERGEDOBJSBX = 0x02

# Struct does not exist in v33
const XPRS_SLPSTATUS_LPINFEASIBLE = 0x04

# Struct does not exist in v33
const XPRS_SLPSTATUS_LPUNFINISHED = 0x08

# Struct does not exist in v33
const XPRS_SLPSTATUS_MAXSLPITERATIONS = 0x10

# Struct does not exist in v33
const XPRS_SLPSTATUS_INTEGERINFEASIBLE = 0x20

# Struct does not exist in v33
const XPRS_SLPSTATUS_RESIDUALPENALTIES = 0x40

# Struct does not exist in v33
const XPRS_SLPSTATUS_CONVERGEDOBJOBJ = 0x80

# Struct does not exist in v33
const XPRS_SLPSTATUS_MAXTIME = 0x0200

# Struct does not exist in v33
const XPRS_SLPSTATUS_USER = 0x0400

# Struct does not exist in v33
const XPRS_SLPSTATUS_VARSLINKEDINACTIVE = 0x0800

# Struct does not exist in v33
const XPRS_SLPSTATUS_NOVARSINACTIVE = 0x1000

# Struct does not exist in v33
const XPRS_SLPSTATUS_OTOL = 0x2000

# Struct does not exist in v33
const XPRS_SLPSTATUS_VTOL = 0x4000

# Struct does not exist in v33
const XPRS_SLPSTATUS_XTOL = 0x8000

# Struct does not exist in v33
const XPRS_SLPSTATUS_WTOL = 0x00010000

# Struct does not exist in v33
const XPRS_SLPSTATUS_ERROTOL = 0x00020000

# Struct does not exist in v33
const XPRS_SLPSTATUS_EVTOL = 0x00040000

# Struct does not exist in v33
const XPRS_SLPSTATUS_POLISHED = 0x00080000

# Struct does not exist in v33
const XPRS_SLPSTATUS_POLISH_FAILURE = 0x00100000

# Struct does not exist in v33
const XPRS_SLPSTATUS_ENFORCED = 0x00200000

# Struct does not exist in v33
const XPRS_SLPSTATUS_CONSECUTIVE_INFEAS = 0x00400000

# Struct does not exist in v33
const XPRS_SLPSTATUS_KEEPBEST = 0x00800000

# Struct does not exist in v33
const XPRS_SLPSTATUS_CLAMPING = 0x01000000

# Struct does not exist in v33
const XPRS_SLPSTATUS_ADAPTIVEITERS = 0x02000000

# Struct does not exist in v33
const XPRS_SLPSTATUS_OBJQNONCONVEX = 0x04000000

# Struct does not exist in v33
const XPRS_NLPSTATUS_UNSTARTED = 0

# Struct does not exist in v33
const XPRS_NLPSTATUS_SOLUTION = 1

# Struct does not exist in v33
const XPRS_NLPSTATUS_LOCALLY_OPTIMAL = 1

# Struct does not exist in v33
const XPRS_NLPSTATUS_OPTIMAL = 2

# Struct does not exist in v33
const XPRS_NLPSTATUS_NOSOLUTION = 3

# Struct does not exist in v33
const XPRS_NLPSTATUS_LOCALLY_INFEASIBLE = 3

# Struct does not exist in v33
const XPRS_NLPSTATUS_INFEASIBLE = 4

# Struct does not exist in v33
const XPRS_NLPSTATUS_UNBOUNDED = 5

# Struct does not exist in v33
const XPRS_NLPSTATUS_UNFINISHED = 6

# Struct does not exist in v33
const XPRS_NLPSTATUS_UNSOLVED = 7

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS_NONE = 0

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS_SOLUTION_NODUALS = 1

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS_LOCALLYOPTIMAL_WITHDUALS = 2

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS_GLOBALLYOPTIMAL_NODUALS = 3

# Struct does not exist in v33
const XPRS_NLPSOLSTATUS_GLOBALLYOPTIMAL_WITHDUALS = 4

# Struct does not exist in v33
const XPRS_SLPGRIDENUMERATE = 1

# Struct does not exist in v33
const XPRS_SLPGRIDCYCLIC = 2

# Struct does not exist in v33
const XPRS_SLPGRIDANNEALING = 4

# Struct does not exist in v33
const XPRS_NLPRECALC = 0x08

# Struct does not exist in v33
const XPRS_NLPTOLCALC = 0x10

# Struct does not exist in v33
const XPRS_NLPALLCALCS = 0x20

# Struct does not exist in v33
const XPRS_NLP2DERIVATIVE = 0x40

# Struct does not exist in v33
const XPRS_NLP1DERIVATIVE = 0x80

# Struct does not exist in v33
const XPRS_NLPALLDERIVATIVES = 0x0100

# Struct does not exist in v33
const XPRS_NLPINSTANCEFUNCTION = 0x0200

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS_GENERAL = 0x01

# Struct does not exist in v33
const XPRS_NLPPRESOLVEFIXZERO = 0x02

# Struct does not exist in v33
const XPRS_NLPPRESOLVEFIXALL = 0x04

# Struct does not exist in v33
const XPRS_NLPPRESOLVESETBOUNDS = 0x08

# Struct does not exist in v33
const XPRS_NLPPRESOLVEINTBOUNDS = 0x10

# Struct does not exist in v33
const XPRS_NLPPRESOLVEDOMAIN = 0x20

# Struct does not exist in v33
const XPRS_SLPNOPRESOLVECOEFFICIENTS = 0x0100

# Struct does not exist in v33
const XPRS_SLPNOPRESOLVEDELTAS = 0x0200

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS_NO_DUAL_SIDE = 0x0400

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS_ELIMINATIONS = 0x0800

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS_NOLINEAR = 0x1000

# Struct does not exist in v33
const XPRS_NLPPRESOLVEOPS_NOSIMPLIFIER = 0x2000

# Struct does not exist in v33
const XPRS_NLPPRESOLVELEVEL_LOCALIZED = 1

# Struct does not exist in v33
const XPRS_NLPPRESOLVELEVEL_BASIC = 2

# Struct does not exist in v33
const XPRS_NLPPRESOLVELEVEL_LINEAR = 3

# Struct does not exist in v33
const XPRS_NLPPRESOLVELEVEL_FULL = 4

# Struct does not exist in v33
const XPRS_SLPCASCADE_ALL = 0x01

# Struct does not exist in v33
const XPRS_SLPCASCADE_COEF_VAR = 0x02

# Struct does not exist in v33
const XPRS_SLPCASCADE_ALL_COEF_VAR = 0x04

# Struct does not exist in v33
const XPRS_SLPCASCADE_STRUCT_VAR = 0x08

# Struct does not exist in v33
const XPRS_SLPCASCADE_ALL_STRUCT_VAR = 0x10

# Struct does not exist in v33
const XPRS_SLPCASCADE_SECONDARY_GROUPS = 0x20

# Struct does not exist in v33
const XPRS_SLPCASCADE_DRCOL_PREVOUSVALUE = 0x40

# Struct does not exist in v33
const XPRS_SLPCASCADE_DRCOL_PVRANGE = 0x80

# Struct does not exist in v33
const XPRS_SLPCASCADE_AUTOAPPLY = 0x0100

# Struct does not exist in v33
const XPRS_LOCALSOLVER_AUTO = -1

# Struct does not exist in v33
const XPRS_LOCALSOLVER_XSLP = 0

# Struct does not exist in v33
const XPRS_LOCALSOLVER_KNITRO = 1

# Struct does not exist in v33
const XPRS_LOCALSOLVER_OPTIMIZER = 2

# Struct does not exist in v33
const XPRS_MSSET_INITIALVALUES = 0

# Struct does not exist in v33
const XPRS_MSSET_SOLVERS = 1

# Struct does not exist in v33
const XPRS_MSSET_SLP_BASIC = 2

# Struct does not exist in v33
const XPRS_MSSET_SLP_EXTENDED = 3

# Struct does not exist in v33
const XPRS_MSSET_KNITRO_BASIC = 4

# Struct does not exist in v33
const XPRS_MSSET_KNITRO_EXTENDED = 5

# Struct does not exist in v33
const XPRS_MSSET_INITIALFILTERED = 6

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_RECALCULATE_RDJ = 0

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_MINIMZE_KKT_ERROR = 1

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_MEASURE_BOTH = 2

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_ACTIVITY_BASED = 0

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_RESPECT_BASIS = 1

# Struct does not exist in v33
const XPRS_KKT_CALCULATION_ACTIVITY_BOTH = 2

# Struct does not exist in v33
const XPRS_KKT_JUST_CALCULATE = 0

# Struct does not exist in v33
const XPRS_KKT_UPDATE_MULTIPLIERS = 1

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_GENERALFIT = 0x01

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_ROWS = 0x02

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_COLS = 0x04

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_CASCADE = 0x08

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_TYPE = 0x10

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_SLACK = 0x20

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_DUAL = 0x40

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_WEIGHT = 0x80

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_SOLUTION = 0x0100

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_REDUCEDCOST = 0x0200

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_SLPVALUE = 0x0400

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_STEPBOUND = 0x0800

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_CONVERGE = 0x1000

# Struct does not exist in v33
const XPRS_SLPTRACEMASK_LINESEARCH = 0x2000

# Struct does not exist in v33
const XPRS_SLPFILTER_KEEPBEST = 0x01

# Struct does not exist in v33
const XPRS_SLPFILTER_CASCADE = 0x02

# Struct does not exist in v33
const XPRS_SLPFILTER_ZEROLINESEARCH = 0x04

# Struct does not exist in v33
const XPRS_SLPFILTER_ZEROLINESEARCHTR = 0x08

# Struct does not exist in v33
const XPRS_SLPANALYZE_RECORDLINEARIZATION = 0x01

# Struct does not exist in v33
const XPRS_SLPANALYZE_RECORDCASCADE = 0x02

# Struct does not exist in v33
const XPRS_SLPANALYZE_RECORDLINESEARCH = 0x04

# Struct does not exist in v33
const XPRS_SLPANALYZE_EXTENDEDFINALSUMMARY = 0x08

# Struct does not exist in v33
const XPRS_SLPANALYZE_INFEASIBLE_ITERATION = 0x10

# Struct does not exist in v33
const XPRS_SLPANALYZE_AUTOSAVEPOOL = 0x20

# Struct does not exist in v33
const XPRS_SLPANALYZE_SAVELINEARIZATIONS = 0x40

# Struct does not exist in v33
const XPRS_SLPANALYZE_SAVEITERBASIS = 0x80

# Struct does not exist in v33
const XPRS_SLPANALYZE_SAVEFILE = 0x0100

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_SLP2QP = 0x01

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_QP2SLP = 0x02

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_SLP2QCQP = 0x04

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_QCQP2SLP = 0x08

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_SOCP2SLP = 0x10

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_QPSOLVE = 0x20

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_PWL = 0x40

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_ABS = 0x80

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_MINMAX = 0x0100

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_ALLABS = 0x0200

# Struct does not exist in v33
const XPRS_NLPREFORMULATE_ALLMINMAX = 0x0400

# Struct does not exist in v33
const XPRS_SLPDELTA_CONT = 0

# Struct does not exist in v33
const XPRS_SLPDELTA_SEMICONT = 1

# Struct does not exist in v33
const XPRS_SLPDELTA_INTEGER = 2

# Struct does not exist in v33
const XPRS_SLPDELTA_EXPLORE = 3

# Struct does not exist in v33
const XPRS_SLPROWINFO_SLACK = 1

# Struct does not exist in v33
const XPRS_SLPROWINFO_DUAL = 2

# Struct does not exist in v33
const XPRS_SLPROWINFO_NUMPENALTYERRORS = 3

# Struct does not exist in v33
const XPRS_SLPROWINFO_MAXPENALTYERROR = 4

# Struct does not exist in v33
const XPRS_SLPROWINFO_TOTALPENALTYERROR = 5

# Struct does not exist in v33
const XPRS_SLPROWINFO_CURRENTPENALTYERROR = 6

# Struct does not exist in v33
const XPRS_SLPROWINFO_CURRENTPENALTYFACTOR = 7

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNPLUS = 8

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNPLUSVALUE = 9

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNPLUSDJ = 10

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNMINUS = 11

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNMINUSVALUE = 12

# Struct does not exist in v33
const XPRS_SLPROWINFO_PENALTYCOLUMNMINUSDJ = 13

# Struct does not exist in v33
const XPRS_SLPCOLINFO_VALUE = 1

# Struct does not exist in v33
const XPRS_SLPCOLINFO_RDJ = 2

# Struct does not exist in v33
const XPRS_SLPCOLINFO_DELTAINDEX = 3

# Struct does not exist in v33
const XPRS_SLPCOLINFO_DELTA = 4

# Struct does not exist in v33
const XPRS_SLPCOLINFO_DELTADJ = 5

# Struct does not exist in v33
const XPRS_SLPCOLINFO_UPDATEROW = 6

# Struct does not exist in v33
const XPRS_SLPCOLINFO_SB = 7

# Struct does not exist in v33
const XPRS_SLPCOLINFO_SBDUAL = 8

# Struct does not exist in v33
const XPRS_SLPCOLINFO_LPVALUE = 9

# Struct does not exist in v33
const XPRS_USERFUNCTION_MAP = 1

# Struct does not exist in v33
const XPRS_USERFUNCTION_VECMAP = 2

# Struct does not exist in v33
const XPRS_USERFUNCTION_MULTIMAP = 3

# Struct does not exist in v33
const XPRS_USERFUNCTION_MAPDELTA = 4

# Struct does not exist in v33
const XPRS_USERFUNCTION_VECMAPDELTA = 5

# Struct does not exist in v33
const XPRS_USERFUNCTION_MULTIMAPDELTA = 6

# Struct does not exist in v33
const XPRS_NLPUSERFUNCNAMES = 7

# Struct does not exist in v33
const XPRS_NLPINTERNALFUNCNAMES = 8

# Struct does not exist in v33
const XPRS_NLPUSERFUNCNAMESNOCASE = 9

# Struct does not exist in v33
const XPRS_NLPINTERNALFUNCNAMESNOCASE = 10

# Struct does not exist in v33
const XPRS_NLPFORMULACOEFFCOLUMNINDEX = -1000

# Struct does not exist in v33
const XPRS_NLPOBJECTIVEROWINDEX = -1

# Struct does not exist in v33
const XPRS_NLPSOLVER_AUTOMATIC = -1

# Struct does not exist in v33
const XPRS_NLPSOLVER_LOCAL = 1

# Struct does not exist in v33
const XPRS_NLPSOLVER_GLOBAL = 2

# Struct does not exist in v33
const XPRS_SOLSTATUS_NOTFOUND = 0

# Struct does not exist in v33
const XPRS_SOLSTATUS_OPTIMAL = 1

# Struct does not exist in v33
const XPRS_SOLSTATUS_FEASIBLE = 2

# Struct does not exist in v33
const XPRS_SOLSTATUS_INFEASIBLE = 3

# Struct does not exist in v33
const XPRS_SOLSTATUS_UNBOUNDED = 4

# Struct does not exist in v33
const XPRS_SOLVESTATUS_UNSTARTED = 0

# Struct does not exist in v33
const XPRS_SOLVESTATUS_STOPPED = 1

# Struct does not exist in v33
const XPRS_SOLVESTATUS_FAILED = 2

# Struct does not exist in v33
const XPRS_SOLVESTATUS_COMPLETED = 3

const XPRS_LP_UNSTARTED = 0

const XPRS_LP_OPTIMAL = 1

const XPRS_LP_INFEAS = 2

const XPRS_LP_CUTOFF = 3

const XPRS_LP_UNFINISHED = 4

const XPRS_LP_UNBOUNDED = 5

const XPRS_LP_CUTOFF_IN_DUAL = 6

const XPRS_LP_UNSOLVED = 7

const XPRS_LP_NONCONVEX = 8

const XPRS_MIP_NOT_LOADED = 0

const XPRS_MIP_LP_NOT_OPTIMAL = 1

const XPRS_MIP_LP_OPTIMAL = 2

const XPRS_MIP_NO_SOL_FOUND = 3

const XPRS_MIP_SOLUTION = 4

const XPRS_MIP_INFEAS = 5

const XPRS_MIP_OPTIMAL = 6

const XPRS_MIP_UNBOUNDED = 7

# Struct does not exist in v33
const XPRS_IIS_UNSTARTED = 0

# Struct does not exist in v33
const XPRS_IIS_FEASIBLE = 1

# Struct does not exist in v33
const XPRS_IIS_COMPLETED = 2

# Struct does not exist in v33
const XPRS_IIS_UNFINISHED = 3

# Struct does not exist in v33
const XPRS_OPTIMIZETYPE_LP = 0

# Struct does not exist in v33
const XPRS_OPTIMIZETYPE_MIP = 1

# Struct does not exist in v33
const XPRS_OPTIMIZETYPE_LOCAL = 2

# Struct does not exist in v33
const XPRS_OPTIMIZETYPE_GLOBAL = 3

const XPRS_BAR_DEFAULT = 0

const XPRS_BAR_MIN_DEGREE = 1

const XPRS_BAR_MIN_LOCAL_FILL = 2

const XPRS_BAR_NESTED_DISSECTION = 3

const XPRS_ALG_DEFAULT = 1

const XPRS_ALG_DUAL = 2

const XPRS_ALG_PRIMAL = 3

const XPRS_ALG_BARRIER = 4

const XPRS_ALG_NETWORK = 5

const XPRS_STOP_NONE = 0

const XPRS_STOP_TIMELIMIT = 1

const XPRS_STOP_CTRLC = 2

const XPRS_STOP_NODELIMIT = 3

const XPRS_STOP_ITERLIMIT = 4

const XPRS_STOP_MIPGAP = 5

const XPRS_STOP_SOLLIMIT = 6

# Struct does not exist in v33
const XPRS_STOP_GENERICERROR = 7

# Struct does not exist in v33
const XPRS_STOP_MEMORYERROR = 8

const XPRS_STOP_USER = 9

# Struct does not exist in v33
const XPRS_STOP_SOLVECOMPLETE = 10

# Struct does not exist in v33
const XPRS_STOP_LICENSELOST = 11

# Struct does not exist in v33
const XPRS_STOP_NUMERICALERROR = 13

const XPRS_ANA_AUTOMATIC = -1

const XPRS_ANA_NEVER = 0

const XPRS_ANA_ALWAYS = 1

const XPRS_BOOL_OFF = 0

const XPRS_BOOL_ON = 1

const XPRS_BACKTRACKALG_BEST_ESTIMATE = 2

const XPRS_BACKTRACKALG_BEST_BOUND = 3

const XPRS_BACKTRACKALG_DEEPEST_NODE = 4

const XPRS_BACKTRACKALG_HIGHEST_NODE = 5

const XPRS_BACKTRACKALG_EARLIEST_NODE = 6

const XPRS_BACKTRACKALG_LATEST_NODE = 7

const XPRS_BACKTRACKALG_RANDOM = 8

const XPRS_BACKTRACKALG_MIN_INFEAS = 9

const XPRS_BACKTRACKALG_BEST_ESTIMATE_MIN_INFEAS = 10

const XPRS_BACKTRACKALG_DEEPEST_BEST_ESTIMATE = 11

const XPRS_BRANCH_MIN_EST_FIRST = 0

const XPRS_BRANCH_MAX_EST_FIRST = 1

const XPRS_ALG_PULL_CHOLESKY = 0

const XPRS_ALG_PUSH_CHOLESKY = 1

const XPRS_XDRPBEFORE_CROSSOVER = 1

const XPRS_XDRPINSIDE_CROSSOVER = 2

const XPRS_XDRPAGGRESSIVE_BEFORE_CROSSOVER = 4

const XPRS_DUALGRADIENT_AUTOMATIC = -1

const XPRS_DUALGRADIENT_DEVEX = 0

const XPRS_DUALGRADIENT_STEEPESTEDGE = 1

const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_PRIMAL = 0

const XPRS_DUALSTRATEGY_REMOVE_INFEAS_WITH_DUAL = 1

const XPRS_FEASIBILITYPUMP_AUTOMATIC = -1

const XPRS_FEASIBILITYPUMP_NEVER = 0

const XPRS_FEASIBILITYPUMP_ALWAYS = 1

const XPRS_FEASIBILITYPUMP_LASTRESORT = 2

const XPRS_HEURSEARCH_LOCAL_SEARCH_LARGE_NEIGHBOURHOOD = 0

const XPRS_HEURSEARCH_LOCAL_SEARCH_NODE_NEIGHBOURHOOD = 1

const XPRS_HEURSEARCH_LOCAL_SEARCH_SOLUTION_NEIGHBOURHOOD = 2

const XPRS_HEURSTRATEGY_AUTOMATIC = -1

const XPRS_HEURSTRATEGY_NONE = 0

const XPRS_HEURSTRATEGY_BASIC = 1

const XPRS_HEURSTRATEGY_ENHANCED = 2

const XPRS_HEURSTRATEGY_EXTENSIVE = 3

const XPRS_NODESELECTION_LOCAL_FIRST = 1

const XPRS_NODESELECTION_BEST_FIRST = 2

const XPRS_NODESELECTION_LOCAL_DEPTH_FIRST = 3

const XPRS_NODESELECTION_BEST_FIRST_THEN_LOCAL_FIRST = 4

const XPRS_NODESELECTION_DEPTH_FIRST = 5

const XPRS_OUTPUTLOG_NO_OUTPUT = 0

const XPRS_OUTPUTLOG_FULL_OUTPUT = 1

const XPRS_OUTPUTLOG_ERRORS_AND_WARNINGS = 2

const XPRS_OUTPUTLOG_ERRORS = 3

const XPRS_PREPROBING_AUTOMATIC = -1

const XPRS_PREPROBING_DISABLED = 0

const XPRS_PREPROBING_LIGHT = 1

const XPRS_PREPROBING_FULL = 2

const XPRS_PREPROBING_FULL_AND_REPEAT = 3

const XPRS_PRESOLVEOPS_SINGLETONCOLUMNREMOVAL = 1

const XPRS_PRESOLVEOPS_SINGLETONROWREMOVAL = 2

const XPRS_PRESOLVEOPS_FORCINGROWREMOVAL = 4

const XPRS_PRESOLVEOPS_DUALREDUCTIONS = 8

const XPRS_PRESOLVEOPS_REDUNDANTROWREMOVAL = 16

const XPRS_PRESOLVEOPS_DUPLICATECOLUMNREMOVAL = 32

const XPRS_PRESOLVEOPS_DUPLICATEROWREMOVAL = 64

const XPRS_PRESOLVEOPS_STRONGDUALREDUCTIONS = 128

const XPRS_PRESOLVEOPS_VARIABLEELIMINATIONS = 256

const XPRS_PRESOLVEOPS_NOIPREDUCTIONS = 512

const XPRS_PRESOLVEOPS_NOGLOBALDOMAINCHANGE = 1024

const XPRS_PRESOLVEOPS_NOADVANCEDIPREDUCTIONS = 2048

const XPRS_PRESOLVEOPS_LINEARLYDEPENDANTROWREMOVAL = 16384

const XPRS_PRESOLVEOPS_NOINTEGERVARIABLEANDSOSDETECTION = 32768

# Struct does not exist in v33
const XPRS_PRESOLVEOPS_NODUALREDONGLOBALS = 536870912

const XPRS_PRESOLVESTATE_PROBLEMLOADED = 1 << 0

const XPRS_PRESOLVESTATE_PROBLEMLPPRESOLVED = 1 << 1

const XPRS_PRESOLVESTATE_PROBLEMMIPPRESOLVED = 1 << 2

const XPRS_PRESOLVESTATE_SOLUTIONVALID = 1 << 7

const XPRS_MIPPRESOLVE_REDUCED_COST_FIXING = 1

const XPRS_MIPPRESOLVE_LOGIC_PREPROCESSING = 2

const XPRS_MIPPRESOLVE_ALLOW_CHANGE_BOUNDS = 8

# Struct does not exist in v33
const XPRS_MIPPRESOLVE_DUAL_REDUCTIONS = 16

# Struct does not exist in v33
const XPRS_MIPPRESOLVE_GLOBAL_COEFFICIENT_TIGHTENING = 32

# Struct does not exist in v33
const XPRS_MIPPRESOLVE_OBJECTIVE_BASED_REDUCTIONS = 64

# Struct does not exist in v33
const XPRS_MIPPRESOLVE_ALLOW_TREE_RESTART = 128

# Struct does not exist in v33
const XPRS_MIPPRESOLVE_SYMMETRY_REDUCTIONS = 256

const XPRS_PRESOLVE_NOPRIMALINFEASIBILITY = -1

const XPRS_PRESOLVE_NONE = 0

const XPRS_PRESOLVE_DEFAULT = 1

const XPRS_PRESOLVE_KEEPREDUNDANTBOUNDS = 2

const XPRS_PRICING_PARTIAL = -1

const XPRS_PRICING_DEFAULT = 0

const XPRS_PRICING_DEVEX = 1

const XPRS_CUTSTRATEGY_DEFAULT = -1

const XPRS_CUTSTRATEGY_NONE = 0

const XPRS_CUTSTRATEGY_CONSERVATIVE = 1

const XPRS_CUTSTRATEGY_MODERATE = 2

const XPRS_CUTSTRATEGY_AGGRESSIVE = 3

const XPRS_VARSELECTION_AUTOMATIC = -1

const XPRS_VARSELECTION_MIN_UPDOWN_PSEUDO_COSTS = 1

const XPRS_VARSELECTION_SUM_UPDOWN_PSEUDO_COSTS = 2

const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS_PLUS_TWICE_MIN = 3

const XPRS_VARSELECTION_MAX_UPDOWN_PSEUDO_COSTS = 4

const XPRS_VARSELECTION_DOWN_PSEUDO_COST = 5

const XPRS_VARSELECTION_UP_PSEUDO_COST = 6

const XPRS_SCALING_ROW_SCALING = 1

const XPRS_SCALING_COLUMN_SCALING = 2

const XPRS_SCALING_ROW_SCALING_AGAIN = 4

const XPRS_SCALING_MAXIMUM = 8

const XPRS_SCALING_CURTIS_REID = 16

const XPRS_SCALING_BY_MAX_ELEM_NOT_GEO_MEAN = 32

# Struct does not exist in v33
const XPRS_SCALING_BIGM = 64

const XPRS_SCALING_SIMPLEX_OBJECTIVE_SCALING = 128

const XPRS_SCALING_IGNORE_QUADRATIC_ROW_PART = 256

const XPRS_SCALING_BEFORE_PRESOLVE = 512

const XPRS_SCALING_NO_SCALING_ROWS_UP = 1024

const XPRS_SCALING_NO_SCALING_COLUMNS_DOWN = 2048

# Struct does not exist in v33
const XPRS_SCALING_DISABLE_GLOBAL_OBJECTIVE_SCALING = 4096

const XPRS_SCALING_RHS_SCALING = 8192

const XPRS_SCALING_NO_AGGRESSIVE_Q_SCALING = 16384

const XPRS_SCALING_SLACK_SCALING = 32768

# Struct does not exist in v33
const XPRS_SCALING_RUIZ = 65536

# Struct does not exist in v33
const XPRS_SCALING_DOGLEG = 131072

# Struct does not exist in v33
const XPRS_SCALING_BEFORE_AND_AFTER_PRESOLVE = 2 * 131072

const XPRS_CUTSELECT_CLIQUE = 32 + 1823

const XPRS_CUTSELECT_MIR = 64 + 1823

const XPRS_CUTSELECT_COVER = 128 + 1823

const XPRS_CUTSELECT_FLOWPATH = 2048 + 1823

const XPRS_CUTSELECT_IMPLICATION = 4096 + 1823

const XPRS_CUTSELECT_LIFT_AND_PROJECT = 8192 + 1823

const XPRS_CUTSELECT_DISABLE_CUT_ROWS = 16384 + 1823

const XPRS_CUTSELECT_GUB_COVER = 32768 + 1823

const XPRS_CUTSELECT_DEFAULT = -1

const XPRS_REFINEOPS_LPOPTIMAL = 1

const XPRS_REFINEOPS_MIPSOLUTION = 2

const XPRS_REFINEOPS_MIPOPTIMAL = 4

const XPRS_REFINEOPS_MIPNODELP = 8

const XPRS_REFINEOPS_LPPRESOLVE = 16

# Struct does not exist in v33
const XPRS_REFINEOPS_ITERATIVEREFINER = 32

# Struct does not exist in v33
const XPRS_REFINEOPS_REFINERPRECISION = 64

# Struct does not exist in v33
const XPRS_REFINEOPS_REFINERUSEPRIMAL = 128

# Struct does not exist in v33
const XPRS_REFINEOPS_REFINERUSEDUAL = 256

# Struct does not exist in v33
const XPRS_REFINEOPS_MIPFIXGLOBALS = 512

# Struct does not exist in v33
const XPRS_REFINEOPS_MIPFIXGLOBALSTARGET = 1024

const XPRS_DUALIZEOPS_SWITCHALGORITHM = 1

const XPRS_TREEDIAGNOSTICS_MEMORY_USAGE_SUMMARIES = 1

const XPRS_TREEDIAGNOSTICS_MEMORY_SAVED_REPORTS = 2

const XPRS_BARPRESOLVEOPS_STANDARD_PRESOLVE = 0

const XPRS_BARPRESOLVEOPS_EXTRA_BARRIER_PRESOLVE = 1

# Struct does not exist in v33
const XPRS_MIPRESTART_DEFAULT = -1

# Struct does not exist in v33
const XPRS_MIPRESTART_OFF = 0

# Struct does not exist in v33
const XPRS_MIPRESTART_MODERATE = 1

# Struct does not exist in v33
const XPRS_MIPRESTART_AGGRESSIVE = 2

const XPRS_PRECOEFELIM_DISABLED = 0

const XPRS_PRECOEFELIM_AGGRESSIVE = 1

const XPRS_PRECOEFELIM_CAUTIOUS = 2

const XPRS_PREDOMROW_AUTOMATIC = -1

const XPRS_PREDOMROW_DISABLED = 0

const XPRS_PREDOMROW_CAUTIOUS = 1

const XPRS_PREDOMROW_MEDIUM = 2

const XPRS_PREDOMROW_AGGRESSIVE = 3

const XPRS_PREDOMCOL_AUTOMATIC = -1

const XPRS_PREDOMCOL_DISABLED = 0

const XPRS_PREDOMCOL_CAUTIOUS = 1

const XPRS_PREDOMCOL_AGGRESSIVE = 2

const XPRS_PRIMALUNSHIFT_ALLOW_DUAL_UNSHIFT = 0

const XPRS_PRIMALUNSHIFT_NO_DUAL_UNSHIFT = 1

const XPRS_REPAIRINDEFINITEQ_REPAIR_IF_POSSIBLE = 0

const XPRS_REPAIRINDEFINITEQ_NO_REPAIR = 1

const XPRS_OBJ_MINIMIZE = 1

const XPRS_OBJ_MAXIMIZE = -1

const XPRS_TYPE_NOTDEFINED = 0

const XPRS_TYPE_INT = 1

const XPRS_TYPE_INT64 = 2

const XPRS_TYPE_DOUBLE = 3

const XPRS_TYPE_STRING = 4

const XPRS_QCONVEXITY_UNKNOWN = -1

const XPRS_QCONVEXITY_NONCONVEX = 0

const XPRS_QCONVEXITY_CONVEX = 1

const XPRS_QCONVEXITY_REPAIRABLE = 2

const XPRS_QCONVEXITY_CONVEXCONE = 3

const XPRS_QCONVEXITY_CONECONVERTABLE = 4

const XPRS_SOLINFO_ABSPRIMALINFEAS = 0

const XPRS_SOLINFO_RELPRIMALINFEAS = 1

const XPRS_SOLINFO_ABSDUALINFEAS = 2

const XPRS_SOLINFO_RELDUALINFEAS = 3

const XPRS_SOLINFO_MAXMIPFRACTIONAL = 4

# Struct does not exist in v33
const XPRS_SOLINFO_ABSMIPINFEAS = 5

# Struct does not exist in v33
const XPRS_SOLINFO_RELMIPINFEAS = 6

const XPRS_TUNERMODE_AUTOMATIC = -1

const XPRS_TUNERMODE_OFF = 0

const XPRS_TUNERMODE_ON = 1

const XPRS_TUNERMETHOD_AUTOMATIC = -1

const XPRS_TUNERMETHOD_LPQUICK = 0

const XPRS_TUNERMETHOD_MIPQUICK = 1

const XPRS_TUNERMETHOD_MIPCOMPREHENSIVE = 2

const XPRS_TUNERMETHOD_MIPROOTFOCUS = 3

const XPRS_TUNERMETHOD_MIPTREEFOCUS = 4

const XPRS_TUNERMETHOD_MIPSIMPLE = 5

const XPRS_TUNERMETHOD_SLPQUICK = 6

const XPRS_TUNERMETHOD_MISLPQUICK = 7

# Struct does not exist in v33
const XPRS_TUNERMETHOD_MIPHEURISTICS = 8

# Struct does not exist in v33
const XPRS_TUNERMETHOD_GLOBALQUICK = 9

# Struct does not exist in v33
const XPRS_TUNERMETHOD_LPNUMERICS = 10

const XPRS_TUNERTARGET_AUTOMATIC = -1

const XPRS_TUNERTARGET_TIMEGAP = 0

const XPRS_TUNERTARGET_TIMEBOUND = 1

const XPRS_TUNERTARGET_TIMEOBJVAL = 2

const XPRS_TUNERTARGET_INTEGRAL = 3

const XPRS_TUNERTARGET_SLPTIME = 4

const XPRS_TUNERTARGET_SLPOBJVAL = 5

const XPRS_TUNERTARGET_SLPVALIDATION = 6

const XPRS_TUNERTARGET_GAP = 7

const XPRS_TUNERTARGET_BOUND = 8

const XPRS_TUNERTARGET_OBJVAL = 9

# Struct does not exist in v33
const XPRS_TUNERTARGET_PRIMALINTEGRAL = 10

const XPRS_TUNERHISTORY_IGNORE = 0

const XPRS_TUNERHISTORY_APPEND = 1

const XPRS_TUNERHISTORY_REUSE = 2

const XPRS_TUNERROOTALG_DUAL = 1

const XPRS_TUNERROOTALG_PRIMAL = 2

const XPRS_TUNERROOTALG_BARRIER = 4

const XPRS_TUNERROOTALG_NETWORK = 8

# Struct does not exist in v33
const XPRS_LPFLAGS_DUAL = 1

# Struct does not exist in v33
const XPRS_LPFLAGS_PRIMAL = 2

# Struct does not exist in v33
const XPRS_LPFLAGS_BARRIER = 4

# Struct does not exist in v33
const XPRS_LPFLAGS_NETWORK = 8

# Struct does not exist in v33
const XPRS_GENCONS_MAX = 0

# Struct does not exist in v33
const XPRS_GENCONS_MIN = 1

# Struct does not exist in v33
const XPRS_GENCONS_AND = 2

# Struct does not exist in v33
const XPRS_GENCONS_OR = 3

# Struct does not exist in v33
const XPRS_GENCONS_ABS = 4

# Struct does not exist in v33
const XPRS_CLAMPING_PRIMAL = 1

# Struct does not exist in v33
const XPRS_CLAMPING_DUAL = 2

# Struct does not exist in v33
const XPRS_CLAMPING_SLACKS = 4

# Struct does not exist in v33
const XPRS_CLAMPING_RDJ = 8

# Struct does not exist in v33
const XPRS_ROWFLAG_QUADRATIC = 1

# Struct does not exist in v33
const XPRS_ROWFLAG_DELAYED = 2

# Struct does not exist in v33
const XPRS_ROWFLAG_MODELCUT = 4

# Struct does not exist in v33
const XPRS_ROWFLAG_INDICATOR = 8

# Struct does not exist in v33
const XPRS_ROWFLAG_NONLINEAR = 16

# Struct does not exist in v33
const XPRS_OBJECTIVE_PRIORITY = 20001

# Struct does not exist in v33
const XPRS_OBJECTIVE_WEIGHT = 20002

# Struct does not exist in v33
const XPRS_OBJECTIVE_ABSTOL = 20003

# Struct does not exist in v33
const XPRS_OBJECTIVE_RELTOL = 20004

# Struct does not exist in v33
const XPRS_OBJECTIVE_RHS = 20005

# Struct does not exist in v33
const XPRS_ALLOW_COMPUTE_ALWAYS = 1

# Struct does not exist in v33
const XPRS_ALLOW_COMPUTE_NEVER = 0

# Struct does not exist in v33
const XPRS_ALLOW_COMPUTE_DEFAULT = -1

# Struct does not exist in v33
const XPRS_COMPUTELOG_NEVER = 0

# Struct does not exist in v33
const XPRS_COMPUTELOG_REALTIME = 1

# Struct does not exist in v33
const XPRS_COMPUTELOG_ONCOMPLETION = 2

# Struct does not exist in v33
const XPRS_COMPUTELOG_ONERROR = 3

# Struct does not exist in v33
const XPRS_NAMES_ROW = 1

# Struct does not exist in v33
const XPRS_NAMES_COLUMN = 2

# Struct does not exist in v33
const XPRS_NAMES_SET = 3

# Struct does not exist in v33
const XPRS_NAMES_PWLCONS = 4

# Struct does not exist in v33
const XPRS_NAMES_GENCONS = 5

# Struct does not exist in v33
const XPRS_NAMES_OBJECTIVE = 6

# Struct does not exist in v33
const XPRS_NAMES_USERFUNC = 7

# Struct does not exist in v33
const XPRS_NAMES_INTERNALFUNC = 8

# Struct does not exist in v33
const XPRS_NAMES_USERFUNCNOCASE = 9

# Struct does not exist in v33
const XPRS_NAMES_INTERNALFUNCNOCASE = 10

# Struct does not exist in v33
const XPRS_GLOBALBOUNDINGBOX_NOT_APPLIED = 0

# Struct does not exist in v33
const XPRS_GLOBALBOUNDINGBOX_ORIGINAL = 1

# Struct does not exist in v33
const XPRS_GLOBALBOUNDINGBOX_AUXILIARY = 2

# Struct does not exist in v33
const XPRS_MULTIOBJOPS_ENABLED = 1

# Struct does not exist in v33
const XPRS_MULTIOBJOPS_PRESOLVE = 2

# Struct does not exist in v33
const XPRS_MULTIOBJOPS_RCFIXING = 4

# Struct does not exist in v33
const XPRS_IISOPS_BINARY = 1

# Struct does not exist in v33
const XPRS_IISOPS_ZEROLOWER = 2

# Struct does not exist in v33
const XPRS_IISOPS_FIXEDVAR = 4

# Struct does not exist in v33
const XPRS_IISOPS_BOUND = 8

# Struct does not exist in v33
const XPRS_IISOPS_GENINTEGRALITY = 16

# Struct does not exist in v33
const XPRS_IISOPS_INTEGRALITY = 17

# Struct does not exist in v33
const XPRS_IISOPS_VARIABLE = 25

# Struct does not exist in v33
const XPRS_IISOPS_EQUALITY = 32

# Struct does not exist in v33
const XPRS_IISOPS_GENERAL = 64

# Struct does not exist in v33
const XPRS_IISOPS_PWL = 128

# Struct does not exist in v33
const XPRS_IISOPS_SET = 256

# Struct does not exist in v33
const XPRS_IISOPS_INDICATOR = 512

# Struct does not exist in v33
const XPRS_IISOPS_DELAYED = 1024

# Struct does not exist in v33
const XPRS_IISOPS_CONSTRAINT = 2048

const XPRS_ISUSERSOLUTION = 0x01

const XPRS_ISREPROCESSEDUSERSOLUTION = 0x02

const XPRS_GLOBALFILESIZE = XPRS_TREEFILESIZE

const XPRS_GLOBALFILEUSAGE = XPRS_TREEFILEUSAGE

# Struct does not exist in v33
const XPRS_GLOBALFILELOGINTERVAL = XPRS_TREEFILELOGINTERVAL

const XPRS_MAXGLOBALFILESIZE = XPRS_MAXTREEFILESIZE

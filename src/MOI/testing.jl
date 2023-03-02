path=string(pwd(),"\\src\\")
include(string(path,"common.jl"))
include(string(path,"lib.jl"))
println(addition(2,3))

_dbdl=[-Inf]
_dbdu=[Inf]
_dmatval=Float64[]
_mstart=Int[]
_mrwind=Int[]
@assert length(_dbdl) == length(_dbdu)
    fixinfinity!(_dbdl)
    fixinfinity!(_dbdu)
    ncols = length(_dbdl)
    ncoeffs = length(_dmatval)
    _mstart = _mstart .- 1
    _mrwind = _mrwind .- 1
    XPRSaddcols(model.inner, ncols, ncoeffs, [0.0], Cint.(_mstart), Cint.(_mrwind), _dmatval, _dbdl, _dbdu)

    print(Xpress.getintattrib(cb_data.model, Lib.XPRS_CALLBACKCOUNT_OPTNODE)==Lib.XPRSgetintattrib(cb_data.model, Lib.XPRS_CALLBACKCOUNT_OPTNODE, 0))
    print(Xpress.getintattrib(cb_data.model, Lib.XPRS_CALLBACKCOUNT_OPTNODE))
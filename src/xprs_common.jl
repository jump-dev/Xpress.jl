# Common stuff
## convenient types and type conversion functions

const GChars = Union{Cchar, Char}
const IVec  = Vector{Cint}
const FVec = Vector{Float64}
const CVec = Vector{Cchar}

const GCharOrVec = Union{Cchar, Char, Vector{Cchar}, Vector{Char}}

const CoeffMat = Union{Matrix{Float64}, SparseMatrixCSC{Float64}}

cchar(c::Cchar) = c
cchar(c::Char) = convert(Cchar, c)

ivec(v::IVec) = v
fvec(v::FVec) = v
cvec(v::CVec) = v

ivec(v::Vector) = convert(IVec, v)
fvec(v::Vector) = convert(FVec, v)
cvec(v::Vector) = convert(CVec, v)

ivec(v::Int) = Cint[v]
fvec(v::Float64) = Float64[v]
fvec(v::Integer) = Float64[v]
#cvec(v::Vector) = convert(CVec, v)

# cvecx(v, n) and fvecx(v, n)
# converts v into a vector of Cchar or Float64 of length n,
# where v can be either a scalar or a vector of length n.

_chklen(n::Integer, v::Vector) = _chklen(v, n::Integer)
_chklen(v, n::Integer) = (length(v) == n || error("Inconsistent argument dimensions."))
_cmplen(v1::Vector, v2::Vector) = (length(v1) == length(v2) || error("Inconsistent argument dimensions."))

cvecx(c::GChars, n::Integer) = fill(cchar(c), n)
cvecx(c::Vector{Cchar}, n::Integer) = (_chklen(c, n); c)
cvecx(c::Vector{Char}, n::Integer) = (_chklen(c, n); convert(Vector{Cchar}, c))

fvecx(v::Real, n::Integer) = fill(Float64(v), n)
fvecx(v::Vector{Float64}, n::Integer) = (_chklen(v, n); v)
fvecx(v::Vector{T}, n::Integer) where {T<:Real} = (_chklen(v, n); convert(Vector{Float64}, v))

inds32(n::Integer) = collect(Cint(1):Cint(n))

# empty vector & matrix (for the purpose of supplying default arguments)

const emptyfvec = Array{Float64}(undef, 0)
const emptyfmat = Array{Float64}(undef, 0, 0)

# macro to call a Xpress C functions
macro xprs_ccall(func, args...)
    f = "XPRS$(func)"
    args = map(esc,args)

    Compat.Sys.isunix() && return quote
        ccall(($f,xprs), $(args...))
    end
    Compat.Sys.iswindows() && VERSION < v"0.6-" && return quote
        ccall(($f,xprs), stdcall, $(args...))
    end
    Compat.Sys.iswindows() && VERSION >= v"0.6-" && return quote
        ccall(($f,xprs), $(esc(:stdcall)), $(args...))
    end
end

"""
    getlibversion()

Get Xpress optimizer version info
"""
function getlibversion()
    out = Array{Cchar}(undef, 16)                                     # "                "
    ret = @xprs_ccall(getversion, Cint, ( Ptr{Cchar},), out)   # ( Cstring,), out)

    numbers = split(unsafe_string(pointer(out)) ,".")

    _major = parse(Int,numbers[1])
    _minor = parse(Int,numbers[2])
    _tech  = parse(Int,numbers[3])

    return  VersionNumber(_major, _minor, _tech)
end
#const version = getlibversion()

function fixinfinity(val::Float64)
    if val == Inf
        return XPRS_PLUSINFINITY
    elseif val == -Inf
        return XPRS_MINUSINFINITY
    else
        return val
    end
end
function fixinfinity!(vals::Vector{Float64})
    map!(fixinfinity, vals, vals)
end

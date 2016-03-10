# Xpress model attributes

############################################
#
#   Low level attribute getters
#
############################################

function get_intattr(model::Model, ipar::Cint)
    a = Array(Cint, 1)
    ret = @xprs_ccall(getintattrib, Cint, 
        (Ptr{Void}, Cint, Ptr{Cint}),
        model.ptr_model, ipar, a);
    if ret != 0
        throw( XpressError(model,ret  ) )
    end
    convert(Int, a[1])
end

function get_dblattr(model::Model, ipar::Cint)
    a = Array(Float64, 1)
    ret = @xprs_ccall(getdblattrib, Cint, 
        (Ptr{Void}, Cint, Ptr{Float64}),
        model.ptr_model, ipar, a);
    if ret != 0
        throw(XpressError(model,convert(Int, ret[1])))
    end
    a[1]::Float64
end

function get_strattr(model::Model, ipar::Cint)
    a = Array(Cchar, 256)
    ret = @xprs_ccall(getstrattrib, Cint, 
        (Ptr{Void}, Cint, Ptr{Cchar}), 
        model.ptr_model, ipar, a)
    if ret != 0
        throw(XpressError(model,convert(Int, ret[1])))
    end
    bytestring(pointer(a))
end

#=

############################################
#
#   Macros for array definition
#
############################################

macro xprs_int_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_intattr(model, $(attrname))
end

macro xprs_dbl_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_dblattr(model, $(attrname))
end

macro xprs_str_attr(fun, attrname)
    @eval $(fun)(model::Model) = get_strattr(model, $(attrname))
end


############################################
#
#   Model attributes
#
############################################

# basic attributes

@xprs_str_attr model_name  "ModelName"

@xprs_int_attr num_vars     "NumVars"
@xprs_int_attr num_constrs  "NumConstrs"
@xprs_int_attr num_sos      "NumSOS"
@xprs_int_attr num_qconstrs "NumQConstrs"
@xprs_int_attr num_cnzs     "NumNZs"
@xprs_int_attr num_qnzs     "NumQNZs"
@xprs_int_attr num_qcnzs    "NumQCNZs"

@xprs_int_attr num_intvars  "NumIntVars"
@xprs_int_attr num_binvars  "NumBinVars"

# derived attribute functions

model_sense(model::Model) = get_intattr(model, "ModelSense") > 0 ? (:minimize) : (:maximize)

is_mip(model::Model) = get_intattr(model, "IsMIP") != 0
is_qp(model::Model)  = get_intattr(model, "IsQP") != 0
is_qcp(model::Model) = get_intattr(model, "IsQCP") != 0

function model_type(model::Model) 
    is_qp(model)  ? (:QP)  :
    is_qcp(model) ? (:QCP) : (:LP)
end

function set_sense!(model::Model, sense::Symbol)
    v = sense == :maximize ? -1 :
        sense == :minimize ? 1 : 
        throw(ArgumentError("Invalid model sense."))
    
    set_intattr!(model, "ModelSense", v)
end

# variable related attributes

#lowerbounds(model::Model) = get_dblattrarray(model, "LB", 1, num_vars(model))
#upperbounds(model::Model) = get_dblattrarray(model, "UB", 1, num_vars(model))
#objcoeffs(model::Model) = get_dblattrarray(model, "Obj", 1, num_vars(model))

# note: this takes effect only after update_model! is called:
function set_objcoeffs!(model::Model, c::Vector)
    n = num_vars(model)
    length(c) == n || error("Inconsistent argument dimensions.")
    set_dblattrarray!(model, "Obj", 1, n, c)
end


############################################
#
#   The show method for model
#
#   - Based on attributes
#
############################################

function show(io::IO, model::Model)
    if model.ptr_model != C_NULL
        println(io, "Gurobi Model: $(model_name(model))")
        if is_mip(model)
            println(io, "    type   : $(model_type(model)) (MIP)")
        else
            println(io, "    type   : $(model_type(model))")
        end
        println(io, "    sense  : $(model_sense(model))")
        println(io, "    number of variables             = $(num_vars(model))")
        println(io, "    number of linear constraints    = $(num_constrs(model))")
        println(io, "    number of quadratic constraints = $(num_qconstrs(model))")
        println(io, "    number of sos constraints       = $(num_sos(model))")
        println(io, "    number of non-zero coeffs       = $(num_cnzs(model))")
        println(io, "    number of non-zero qp objective terms  = $(num_qnzs(model))")
        println(io, "    number of non-zero qp constraint terms = $(num_qcnzs(model))")
    else
        println(io, "Xpress Model: NULL")
    end
end

=#
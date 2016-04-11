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

#@xprs_str_attr model_name  XPRS_PROBNAME

@xprs_int_attr num_vars     XPRS_COLS
@xprs_int_attr num_constrs  XPRS_ROWS
@xprs_int_attr num_sos      XPRS_SETS
@xprs_int_attr num_qconstrs XPRS_QCONSTRAINTS
@xprs_int_attr num_cnzs     XPRS_ELEMS
@xprs_int_attr num_qnzs     XPRS_QELEMS
@xprs_int_attr num_qcnzs    XPRS_QCELEMS

@xprs_int_attr num_intents  XPRS_MIPENTS

@xprs_int_attr num_setmembers SETMEMBERS


@xprs_dbl_attr obj_sense    XPRS_OBJSENSE
#@xprs_int_attr num_binvars  "NumBinVars"

@xprs_int_attr num_originalvars     XPRS_ORIGINALCOLS
@xprs_int_attr num_originalconstrs  XPRS_ORIGINALROWS


# derived attribute functions

model_sense(model::Model) = obj_sense(model) == XPRS_OBJ_MINIMIZE ? (:minimize) : (:maximize)

is_qcp(model::Model) = num_qconstrs(model) > 0 
is_mip(model::Model) = num_intents(model)+num_sos(model) > 0
is_qp(model::Model) = num_qnzs(model)>0


function model_type(model::Model) 
    is_qp(model)  ? (:QP)  :
    is_qcp(model) ? (:QCP) : (:LP)
end

function set_sense!(model::Model, sense::Symbol)
    v = sense == :maximize ? XPRS_OBJ_MAXIMIZE :
        sense == :minimize ? XPRS_OBJ_MINIMIZE : 
        throw(ArgumentError("Invalid model sense."))

    ret = @xprs_ccall(chgobjsense, Cint, (
            Ptr{Void},    # model
            Cint          # sense
            ), 
            model.ptr_model, v)
            
    if ret != 0
        throw(XpressError(model))
    end 
    
end

# note: this takes effect only after update_model! is called:
function set_objcoeffs!(model::Model, ind::Vector{Int}, c::Vector)
    n = num_vars(model)
    length(c) == length(inds) || error("Inconsistent argument dimensions.")
    n >= maximum(ind) || error("Inconsistent argument dimensions.")

        ret = @xprs_ccall(chgobj, Cint, (
            Ptr{Void},    # model
            Cint,          # sense
            Ptr{Cint},
            Ptr{Float64}
            ), 
            model.ptr_model, inds, fvec(c) )
            
        if ret != 0
            throw(XpressError(model))
        end 

end
function set_objcoeffs!(model::Model,c::Vector)
    n = num_vars(model)
    length(c) == n || error("Inconsistent argument dimensions.")

    set_objcoeffs!(model, cvec(0:(n-1)), c)
end
set_obj!(model::Model,c::Vector) = set_objcoeffs!(model,c)

############################################
#
#   The show method for model
#
#   - Based on attributes
#
############################################

function show(io::IO, model::Model)
    if model.ptr_model != C_NULL
        println(io, "Xpress Model:"     )# $(model_name(model))")
        #if is_mip(model)
        #    println(io, "    type   : $(model_type(model)) (MIP)")
        #else
        #    println(io, "    type   : $(model_type(model))")
        #end
        println(io, "    sense  : $(model_sense(model))")
        println(io, "    number of variables             = $(num_vars(model))")
        println(io, "    number of linear constraints    = $(num_constrs(model))")
        println(io, "    number of quadratic constraints = $(num_qconstrs(model))")
        println(io, "    number of sos constraints       = $(num_sos(model))")
        println(io, "    number of non-zero coeffs       = $(num_cnzs(model))")
        println(io, "    number of non-zero qp objective terms  = $(num_qnzs(model))")
        println(io, "    number of non-zero qp constraint terms = $(num_qcnzs(model))")
        println(io, "    number of integer entities = $(num_intents(model))")
    else
        println(io, "Xpress Model: NULL")
    end
end


############################################
#
#   more setters and getters
#
############################################


function get_lb(model::Model)

    cols = num_vars(model)

    out = Array(Float64,cols)

    ret = @xprs_ccall(getlb, Cint, (
        Ptr{Void},    # model
        Ptr{Float64},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, cols-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end
function get_ub(model::Model)

    cols = num_vars(model)

    out = Array(Float64,cols)

    ret = @xprs_ccall(getub, Cint, (
        Ptr{Void},    # model
        Ptr{Float64},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, cols-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end




function get_obj(model::Model)

    cols = num_vars(model)

    out = Array(Float64,cols)

    ret = @xprs_ccall(getobj, Cint, (
        Ptr{Void},    # model
        Ptr{Float64},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, cols-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end

function get_rhs(model::Model)

    rows = num_constrs(model)

    out = Array(Float64,rows)

    ret = @xprs_ccall(getrhs, Cint, (
        Ptr{Void},    # model
        Ptr{Float64},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, rows-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end
function get_rowtype(model::Model)

    rows = num_constrs(model)

    out = Array(Cchar,rows)

    ret = @xprs_ccall(getrowtype, Cint, (
        Ptr{Void},    # model
        Ptr{Cchar},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, rows-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end

int XPRS_CC XPRSgetcoltype(XPRSprob prob, char coltype[], int first, int
      last);

function get_coltype(model::Model)

    cols = num_vars(model)

    out = Array(Cchar,rows)

    ret = @xprs_ccall(getcoltype, Cint, (
        Ptr{Void},    # model
        Ptr{Cchar},          
        Cint,
        Cint
        ), 
        model.ptr_model, out, 0, cols-1)
        
    if ret != 0
        throw(XpressError(model))
    end 

    return out
end

function set_lb!(model::Model,ind::Vector{Int},lb::Vector{Real})

    nbnds = length(ind)

    ret = @xprs_ccall(chgbounds, Cint, (
        Ptr{Void},    # model
        Cint,          
        Ptr{Cint},
        Ptr{Cchar},
        Ptr{Float64}
        ), 
        model.ptr_model, Cint(nbnds) , ivec(ind)-1, cvecx('L',nbnds), fvec(lb) )
        
    if ret != 0
        throw(XpressError(model))
    end 
end
function set_lb!(model::Model,lb::Vector{Real})
    
    cols = num_vars(model)
    ( cols == length(lb) ) || error("wrong size of LB vector")
    
    ind = ivec(collect(1:cols))
    
    set_lb!(model,ind-1,lb)
end
function set_ub!(model::Model,ind::Vector{Int},ub::Vector{Real})

    nbnds = length(ind)

    ret = @xprs_ccall(chgbounds, Cint, (
        Ptr{Void},    # model
        Cint,          
        Ptr{Cint},
        Ptr{Cchar},
        Ptr{Float64}
        ), 
        model.ptr_model, Cint(nbnds) , ivec(ind)-1, cvecx('U',nbnds), fvec(ub) )
        
    if ret != 0
        throw(XpressError(model))
    end 
end
function set_ub!(model::Model,ub::Vector{Real})
    
    cols = num_vars(model)
    ( cols == length(lb) ) || error("wrong size of UB vector")
    
    ind = ivec(collect(1:cols))
    
    set_lb!(model,ind-1,ub)
end

function set_rhs!(model::Model,ind::Vector{Int},rhs::Vector{Real})

    nels = length(ind)

    ret = @xprs_ccall(chgrhs, Cint, (
        Ptr{Void},    # model
        Cint,          
        Ptr{Cint},
        Ptr{Float64}
        ), 
        model.ptr_model, Cint(nels) , ivec(ind)-1, fvec(rhs) )
        
    if ret != 0
        throw(XpressError(model))
    end 
end
function set_rhs!(model::Model, rhs::Vector)
    rows = num_constrs(model)
    set_rhs!(model, ivec( collect(0:rows-1) ) ,fvec(rhs) )
end

function set_rowtype!(model::Model,senses::Vector)

    rows = num_constrs(model)
    ind = collect(1:rows)
    ret = @xprs_ccall(chgrowtype, Cint, (
        Ptr{Void},    # model
        Cint,          
        Ptr{Cint},
        Ptr{Cchar}
        ), 
        model.ptr_model, Cint(nels) , ivec(ind)-1, cvec(senses) )
        
    if ret != 0
        throw(XpressError(model))
    end 
end

function set_constrLB!(model::Model, lb)
    senses = get_rowtype(model)
    rhs    = get_rhs(model)
    sense_changed = false
    for i = 1:num_constr(model)
        if senses[i] == XPRS_GEQ || senses[i] == XPRS_EQ
            # Do nothing
        elseif senses[i] == XPRS_LEQ
            if lb[i] != -Inf
                # LEQ constraint with non-NegInf LB implies a range
                if isapprox(lb[i], rhs[i])
                    # seems to be an equality
                    senses[i] = XPRS_EQ
                    sense_changed = true
                else
                    error("Tried to set LB != -Inf on a LEQ constraint (index $i)")
                end
            else
                lb[i] = rhs[i]
            end
        end
    end
    if sense_changed
        set_rowtype!(model, senses)
    end
    set_rhs!(model, lb)
end

function set_constrUB!(model::Model, ub)
    senses = get_rowtype(model)
    rhs    = get_rhs(model)
    sense_changed = false
    for i = 1:num_constr(model)
        if senses[i] == XPRS_LEQ || senses[i] == XPRS_EQ
            # Do nothing
        elseif senses[i] == XPRS_GEQ
            if ub[i] != Inf
                # GEQ constraint with non-PosInf UB implies a range
                if isapprox(ub[i], rhs[i])
                    # seems to be an equality
                    senses[i] = XPRS_EQ
                    sense_changed = true
                else
                    error("Tried to set UB != +Inf on a GEQ constraint (index $i)")
                end
            else
              ub[i] = rhs[i]
            end
        end
    end
    if sense_changed
        set_rowtype!(model, senses)
    end
    set_rhs!(model, ub)
end








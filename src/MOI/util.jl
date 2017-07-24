# helper functions

refs2inds(m, refs) = broadcast(x->x.value, refs)

function rejectnonzeroconstant(f::MOI.AbstractScalarFunction)
    if f.constant != 0.0
        return error("nope")
    end
end
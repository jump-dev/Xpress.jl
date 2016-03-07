include("Xpress.jl")

env = Env()

m = Model(env)

read_model(m, "testeMod.mps")

#write_model(m, "opt2.mps")

#m2 = copy(m)
#write_model(m2, "opt3.mps")

#a = get_int_control(m,XPRS_DEFAULTALG)
#println(a)

add_vars!(m, XPRS_INTEGER, [33, 43], 0.03, 1.03)
chgcoltype!(m,1,XPRS_INTEGER)
write_model(m, "testeModOut.mps")



#out=get_intattr(m,XPRS_COLS)
#out=get_intattr(m,XPRS_MATRIXNAME)
#println(out)
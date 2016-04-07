include("Xpress.jl")
println(version)
env = Env()

m = Model(env)

println(pwd())
#read_model(m, "testeMod.mps")

#write_model(m, "opt2.mps")

#read_model(m, "testeMod.mps")

#m2 = copy(m)
#write_model(m2, "opt3.mps")

#a = get_int_control(m,XPRS_DEFAULTALG)
#println(a)



add_cvars!(m, [4])
add_vars!(m, XPRS_INTEGER, [33, 43], 0.03, 1.03)
chgcoltype!(m,1,XPRS_INTEGER)
write_model(m, "testeModOut.mps")

add_constr!(m,[1, 2, 3],Cchar('L'),4)

add_constrs!(m, eye(3), XPRS_EQ,ones(3))

A = get_constrmatrix(m)

println(full(A))

#add_rangeconstr!(m,[4,5,6,7],99,100)

#add_rangeconstrs!(m,rand(4,4),20*ones(4),30*ones(4))


add_sos!(m,:SOS1,[1,2],[1.1,1.2])


write_model(m, "teste_withcstr_Out.mps")

show(STDOUT,m)
#out=get_intattr(m,XPRS_COLS)
#out=get_intattr(m,XPRS_MATRIXNAME)
#println(out)
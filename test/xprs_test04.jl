using Xpress

println(Xpress.getlibversion())

m = Xpress.Model()

filename = "logfile.log"
Xpress.setlogfile(m, filename)

println(pwd())

Xpress.add_cvars!(m, [4])
Xpress.add_vars!(m, Xpress.XPRS_INTEGER, [33, 43], 0.03, 1.03)
Xpress.chgcoltype!(m,1, Xpress.XPRS_INTEGER)

Xpress.add_constr!(m,[1, 2, 3], Cchar('L'),4)

Xpress.add_constrs!(m, eye(3), Xpress.XPRS_EQ, ones(3))

Xpress.optimize(m)

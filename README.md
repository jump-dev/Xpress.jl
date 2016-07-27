# Xpress.jl


The Xpress Optimizer is a commercial optimization solver for a variety of mathematical programming problems, including linear programming (LP), quadratic programming (QP), quadratically constrained programming (QCP), mixed integer linear programming (MILP), mixed-integer quadratic programming (MIQP), and mixed-integer quadratically constrained programming (MIQCP).

The Xpress solver is considered one of the best solvers (in terms of performance and success rate of tackling hard problems) in math programming, and its performance is comparable to (and sometimes superior to) CPLEX. Academic users can obtain a Xpress license for free.

This package is a wrapper of the Xpress solver (through its C interface). Currently, this package supports the following types of problems:

Linear programming (LP)
Mixed Integer Linear Programming (MILP)
Quadratic programming (QP)
Mixed Integer Quadratic Programming (MIQP)
Quadratically constrained quadratic programming (QCQP)
Second order cone programming (SOCP)
Mixed integer second order cone programming (MISOCP)
The Xpress wrapper for Julia is community driven and not officially supported by Xpress. If you are a commercial customer interested in official support for Julia from Xpress, let them know!

## Install:

Here is the procedure to setup this package:

1. Obtain a license of Xpress and install Xpress solver, following the instructions on FICO's website.

2. Install this package using `Pkg.clone("git://github.com/JuliaOpt/Xpress.jl.git")`

4. Run `Pkg.build("Xpress")` 

5. Make sure the XPRESSDIR environmental variable is set to the path of the Xpress directory. This is part of a standard installation. The Xpress library will be searched for in XPRESSDIR/lib on unix platforms and XPRESSDIR/bin on Windows. 

6. Now, you can start using it.

You should use the xpress version matching to your julia installation and vice-versa

## High priority:

* Create wrapper for: Callbacks.

## TODO list:

* set warmstart
* polish quadratic models

## Failing tests:

* qpdualtest: lacks of `getquadconstrdual`

## Reference:
[FICO optimizer manual](http://www.fico.com/en/node/8140?file=5097)


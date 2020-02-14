# Xpress.jl

| **Build Status** | **Social** |
|:----------------:|:----------:|
| [![Build Status][build-img]][build-url] [![Codecov branch][codecov-img]][codecov-url] | [![Gitter][gitter-img]][gitter-url] [<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Discourse_logo.png/799px-Discourse_logo.png" width="64">][discourse-url] |


[build-img]: https://travis-ci.org/JuliaOpt/Xpress.jl.svg?branch=master
[build-url]: https://travis-ci.org/JuliaOpt/Xpress.jl
[codecov-img]: http://codecov.io/github/JuliaOpt/Xpress.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/JuliaOpt/Xpress.jl?branch=master

[gitter-url]: https://gitter.im/JuliaOpt/JuMP-dev?utm_source=share-link&utm_medium=link&utm_campaign=share-link
[gitter-img]: https://badges.gitter.im/JuliaOpt/JuMP-dev.svg
[discourse-url]: https://discourse.julialang.org/c/domain/opt


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

2. Install this package using `Pkg.add("Xpress")`.

3. Make sure the XPRESSDIR environmental variable is set to the path of the Xpress directory. This is part of a standard installation. The Xpress library will be searched for in XPRESSDIR/lib on unix platforms and XPRESSDIR/bin on Windows. 

4. Now, you can start using it.

You should use the xpress version matching to your julia installation and vice-versa

## Use Other Packages

We highly recommend that you use the *Xpress.jl* package with higher level packages such as [JuMP.jl](https://github.com/JuliaOpt/JuMP.jl) or [MathOptInterface.jl](https://github.com/JuliaOpt/MathOptInterface.jl). 

This can be done using the ``Xpress.Optimizer`` object. Here is how to create a *JuMP* model that uses Xpress as the solver. Parameters are passed as keyword arguments:
```julia
using JuMP, Xpress

m = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0))
```
For other parameters use Xpress Optimizer manual.

## API Overview

This package provides both APIs at different levels for constructing models and solving optimization problems just like *Gurobi.jl*, you can use the tests and examples in this package and *Gurobi.jl*'s [README.md](https://github.com/JuliaOpt/Gurobi.jl) basic for reference.

## Julia version warning

The Julia versions 1.1.x do not work properly with MOI dues to Julia bugs. Hence, these versions are not supported.

## Reference:
[FICO optimizer manual](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML)

# Xpress.jl

| **Build Status** | **Social** |
|:----------------:|:----------:|
| [![Build Status][build-img]][build-url] [![Codecov branch][codecov-img]][codecov-url] | [![Gitter][gitter-img]][gitter-url] [<img src="https://upload.wikimedia.org/wikipedia/commons/thumb/a/af/Discourse_logo.png/799px-Discourse_logo.png" width="64">][discourse-url] |


[build-img]: https://travis-ci.org/jump-dev/Xpress.jl.svg?branch=master
[build-url]: https://travis-ci.org/jump-dev/Xpress.jl
[codecov-img]: http://codecov.io/github/jump-dev/Xpress.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/jump-dev/Xpress.jl?branch=master

[gitter-url]: https://gitter.im/JuliaOpt/JuMP-dev?utm_source=share-link&utm_medium=link&utm_campaign=share-link
[gitter-img]: https://badges.gitter.im/JuliaOpt/JuMP-dev.svg
[discourse-url]: https://discourse.julialang.org/c/domain/opt


Xpress.jl is a wrapper for the [FICO Xpress Solver](www.fico.com/products/fico-xpress-solver).

It has two components:
 - a thin wrapper around the complete C API
 - an interface to [MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl)

The C API can be accessed via `Xpress.Lib.XPRSxx` functions, where the names and
arguments are identical to the C API. See the [Xpress documentation](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML)
for details.

*The Xpress wrapper for Julia is community driven and not officially supported
by FICO Xpress. If you are a commercial customer interested in official support for
Julia from FICO Xpress, let them know!*

## Install:

Here is the procedure to setup this package:

1. Obtain a license of Xpress and install Xpress solver, following the instructions on FICO's website.

2. Install this package using `Pkg.add("Xpress")`.

3. Make sure the XPRESSDIR environmental variable is set to the path of the Xpress directory. This is part of a standard installation. The Xpress library will be searched for in XPRESSDIR/lib on unix platforms and XPRESSDIR/bin on Windows.

4. Now, you can start using it.

You should use the xpress version matching to your julia installation and vice-versa.

By default, `build`ing *Xpress.jl* will fail if the Xpress library is not found.
This may not be desirable in certain cases, for example when part of a package's
test suite uses Xpress as an optional test dependency, but Xpress cannot be
installed on a CI server running the test suite. To support this use case, the
`XPRESS_JL_SKIP_LIB_CHECK` environment variable may be set (to any value) to
make *Xpress.jl* installable (but not usable).

## Use Other Packages

We highly recommend that you use the *Xpress.jl* package with higher level
packages such as [JuMP.jl](https://github.com/jump-dev/JuMP.jl) or
[MathOptInterface.jl](https://github.com/jump-dev/MathOptInterface.jl).

This can be done using the ``Xpress.Optimizer`` object. Here is how to create a
*JuMP* model that uses Xpress as the solver. Parameters are passed as keyword
arguments:
```julia
using JuMP, Xpress

model = Model(()->Xpress.Optimizer(DEFAULTALG=2, PRESOLVE=0, logfile = "output.log"))
```

In order to initialize an optimizer without console printing run
`Xpress.Optimizer(OUTPUTLOG = 0)`. Setting `OUTPUTLOG` to zero will also disable
printing to the log file in all systems.

For other parameters use [Xpress Optimizer manual](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/)
or type `julia -e "using Xpress; println(keys(Xpress.XPRS_ATTRIBUTES))"`.

If logfile is set to `""`, log file is disabled and output is printed to the
console ([there might be issues with console output on windows (it is manually implemented with callbacks)](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/OUTPUTLOG.html)).
If logfile is set to a filepath, output is printed to the file. 
By default, logfile is set to `""` (console).

Parameters in a JuMP model can be directly modified:

```julia
julia> using Xpress, JuMP;

julia> model = Model(()->Xpress.Optimizer());

julia> get_optimizer_attribute(model, "logfile")

julia> set_optimizer_attribute(model, "logfile", "output.log")

julia> get_optimizer_attribute(model, "logfile")
"output.log"
```

If you've already created an instance of an MOI `Optimizer`, you can use
`MOI.RawParameter` to get and set the location of the current logfile.

```julia
julia> using Xpress, MathOptInterface; const MOI = MathOptInterface;

julia> OPTIMIZER = Xpress.Optimizer();

julia> MOI.get(OPTIMIZER, MOI.RawParameter("logfile"))
""

julia> MOI.set(OPTIMIZER, MOI.RawParameter("logfile"), "output.log")

julia> MOI.get(OPTIMIZER, MOI.RawParameter("logfile"))
"output.log"
```

## Callbacks

Solver specific and solver independent callbacks are working in
[MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl) and,
consequently, in [JuMP](https://github.com/jump-dev/JuMP.jl). However, the
current implementation should be considered experimental.

## Environement variables

 - `XPRESS_JL_SKIP_LIB_CHECK` - Used to skip build lib check as previsouly described.

 - `XPRESS_JL_NO_INFO` - Disable license info log.

 - `XPRESS_JL_NO_DEPS_ERROR` - Disable error when do deps.jl file is found.

 - `XPRESS_JL_NO_AUTO_INIT` - Disable automatic run of `Xpress.initialize()`.
 Specially useful for explicitly loading the dynamic library.

## Julia version warning

The Julia versions 1.1.x do not work properly with MOI dues to Julia bugs. Hence, these versions are not supported.

## Reference:

[FICO optimizer manual](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML)

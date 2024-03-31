# Xpress.jl

[![Build Status](https://github.com/jump-dev/Xpress.jl/workflows/CI/badge.svg?branch=master)](https://github.com/jump-dev/Xpress.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/jump-dev/Xpress.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jump-dev/Xpress.jl)

[Xpress.jl](https://github.com/jump-dev/Xpress.jl) is a wrapper for the [FICO Xpress Solver](https://www.fico.com/products/fico-xpress-solver).

It has two components:

 - a thin wrapper around the complete C API
 - an interface to [MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl)

## Affiliation

The Xpress wrapper for Julia is community driven and not officially supported
by FICO Xpress. If you are a commercial customer interested in official support
for Julia from FICO Xpress, let them know.

## License

`Xpress.jl` is licensed under the [MIT License](https://github.com/jump-dev/Xpress.jl/blob/master/LICENSE.md).

The underlying solver is a closed-source commercial product for which you must
[purchase a license](https://www.fico.com/products/fico-xpress-solver).

## Installation

First, obtain a license of Xpress and install Xpress solver, following the
[instructions on the FICO website](https://www.fico.com/products/fico-xpress-solver).
Ensure that the `XPRESSDIR` license variable is set to the install location by
checking the output of:
```julia
julia> ENV["XPRESSDIR"]
```

Then, install this package using:
```julia
import Pkg
Pkg.add("Xpress")
```

If you encounter an error, make sure that the `XPRESSDIR` environmental variable
is set to the path of the Xpress directory. This should be part of a standard
installation. The Xpress library will be searched for in `XPRESSDIR/lib` on Unix
platforms and `XPRESSDIR/bin` on Windows.

For example, on macOS, you may need:
```julia
ENV["XPRESSDIR"] = "/Applications/FICO Xpress/xpressmp/"
import Pkg
Pkg.add("Xpress")
```

### Skipping installation

By default, building Xpress.jl will fail if the Xpress library is not found.

This may not be desirable in certain cases, for example when part of a package's
test suite uses Xpress as an optional test dependency, but Xpress cannot be
installed on a CI server running the test suite.

To skip the error, set the `XPRESS_JL_SKIP_LIB_CHECK` environment variable to
`true` to make Xpress.jl installable (but not usable).

```julia
ENV["XPRESS_JL_SKIP_LIB_CHECK"] = true
import Pkg
Pkg.add("Xpress")
```

## Use with Xpress_jll

Instead of manually installing Xpress, you can use the binaries provided by the
[Xpress_jll.jl](https://github.com/jump-dev/Xpress_jll.jl) package.

By using Xpress_jll, you agree to certain license conditions. See the
[Xpress_jll.jl README](https://github.com/jump-dev/Xpress_jll.jl/tree/master?tab=readme-ov-file#license)
for more details.

By default, `Xpress_jll` includes a limited size community license. If you have
purchased a license for FICO Xpress, you should additionally set the
`XPAUTH_PATH` environment variable to point to the directory of your license
file.

```julia
import Xpress_jll
# This environment variable must be set _before_ loading Xpress.jl
ENV["XPRESS_JL_LIBRARY"] = Xpress_jll.libxprs
# Optional: point to the directory of your xpauth.xpr license file
ENV["XPAUTH_PATH"] = "/path/to/directory"
using Xpress
```

If you plan to use Xpress_jll, `Pkg.add("Xpress")` will fail because it cannot
find a local installation of Xpress. Therefore, you should set
`XPRESS_JL_SKIP_LIB_CHECK` before installing.

## Use with JuMP

To use Xpress with JuMP, use:

```julia
using JuMP, Xpress
model = Model(Xpress.Optimizer)
set_optimizer(model, "PRESOLVE", 0)
```

## Options

For other parameters see the [Xpress Optimizer manual](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/).

If `logfile` is set to `""`, the log file is disabled and output is printed to
the console ([there might be issues with console output on windows (it is manually implemented with callbacks)](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML/OUTPUTLOG.html)).

If `logfile` is set to a file's path, output is printed to that file. By
default, `logfile = ""` (console).

### Custom options

 * `MOI_POST_SOLVE::Bool`: set this attribute to `false` to skip `XPRSpostsolve`.
   This is most useful in older versions of Xpress that throw an error if the
   model is infeasible.
 * `MOI_IGNORE_START::Bool`: set this attribute to `true` to skip setting
   `MOI.VariablePrimalStart`
 * `MOI_WARNINGS::Bool`: set this attribute to `false` to turn off the various
   warnings printed by the MathOptInterface wrapper
 * `MOI_SOLVE_MODE::String`: set the `flags` argument to
   [`lpoptimize`](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/R/HTML/lpoptimize.html)
 * `XPRESS_WARNING_WINDOWS::Bool`: set this attribute to `false` to turn of
   warnings on Windows.

## Callbacks

Solver specific and solver independent callbacks are working in
[MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl) and,
consequently, in [JuMP](https://github.com/jump-dev/JuMP.jl). However, the
current implementation should be considered experimental.

## Environment variables

 - `XPRESS_JL_SKIP_LIB_CHECK`: Used to skip build lib check as previously
   described.
 - `XPRESS_JL_NO_INFO`: Disable license info log.
 - `XPRESS_JL_NO_DEPS_ERROR`: Disable error when do deps.jl file is found.
 - `XPRESS_JL_NO_AUTO_INIT`: Disable automatic run of `Xpress.initialize()`.
   Specially useful for explicitly loading the dynamic library.
 - `XPRESS_JL_LIBRARY`: Provide a custom path to `libxprs`
 - `XPAUTH_PATH`: Provide a custom path to the license file

## C API

The C API can be accessed via `Xpress.Lib.XPRSxx` functions, where the names and
arguments are identical to the C API.

See the [Xpress documentation](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML)
for details.

## Documentation

For more information, consult the
[FICO optimizer manual](https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML).


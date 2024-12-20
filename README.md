# Xpress.jl

[![Build Status](https://github.com/jump-dev/Xpress.jl/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/jump-dev/Xpress.jl/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/jump-dev/Xpress.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/jump-dev/Xpress.jl)

[Xpress.jl](https://github.com/jump-dev/Xpress.jl) is a wrapper for the [FICO Xpress Solver](https://www.fico.com/products/fico-xpress-solver).

It has two components:

 - a thin wrapper around the complete C API
 - an interface to [MathOptInterface](https://github.com/jump-dev/MathOptInterface.jl)

## Affiliation

The Xpress wrapper for Julia is community driven and not officially supported
by FICO Xpress. If you are a commercial customer interested in official support
for Julia from FICO Xpress, let them know.

## Getting help

If you need help, please ask a question on the [JuMP community forum](https://jump.dev/forum).

If you have a reproducible example of a bug, please [open a GitHub issue](https://github.com/jump-dev/Xpress.jl/issues/new).

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

```julia
import Xpress_jll
# This environment variable must be set _before_ loading Xpress.jl
ENV["XPRESS_JL_LIBRARY"] = Xpress_jll.libxprs
# Point to your xpauth.xpr license file
ENV["XPAUTH_PATH"] = "/path/to/xpauth.xpr"
using Xpress
```

If you plan to use Xpress_jll, `Pkg.add("Xpress")` will fail because it cannot
find a local installation of Xpress. Therefore, you should set
`XPRESS_JL_SKIP_LIB_CHECK` before installing.

To add a specific version of Xpress with `Xpress_jll` do:

```julia
import Pkg
Pkg.add(name = "Xpress_jll", rev = "v8.14.0")
```

If the version is not found, please open and issue at https://github.com/jump-dev/Xpress_jll.jl

## Use with JuMP

To use Xpress with JuMP, use:

```julia
using JuMP, Xpress
model = Model(Xpress.Optimizer)
# Modify options, for example:
set_attribute(model, "PRESOLVE", 0)
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

Here is an example using Xpress's solver-specific callbacks.

```julia
using JuMP, Xpress, Test

model = direct_model(Xpress.Optimizer())
@variable(model, 0 <= x <= 2.5, Int)
@variable(model, 0 <= y <= 2.5, Int)
@objective(model, Max, y)
function my_callback_function(cb_data)
    prob = cb_data.model
    p_value = Ref{Cint}(0)
    ret = Xpress.Lib.XPRSgetintattrib(prob, Xpress.Lib.XPRS_MIPINFEAS, p_value)
    if p_value[] > 0
        return  # There are integer infeasibilities. The solution is fractional.
    end
    p_obj, p_bound = Ref{Cdouble}(), Ref{Cdouble}()
    Xpress.Lib.XPRSgetdblattrib(prob, Xpress.Lib.XPRS_MIPBESTOBJVAL, p_obj)
    Xpress.Lib.XPRSgetdblattrib(prob, Xpress.Lib.XPRS_BESTBOUND, p_bound)
    rel_gap = abs((p_obj[] - p_bound[]) / p_obj[])
    @info "Relative gap = $rel_gap"
    # Before querying `callback_value`, you must call:
    Xpress.get_cb_solution(unsafe_backend(model), cb_data.model)
    x_val = callback_value(cb_data, x)
    y_val = callback_value(cb_data, y)
    # You can submit solver-independent MathOptInterface attributes such as
    # lazy constraints, user-cuts, and heuristic solutions.
    if y_val - x_val > 1 + 1e-6
        con = @build_constraint(y - x <= 1)
        MOI.submit(model, MOI.LazyConstraint(cb_data), con)
    elseif y_val + x_val > 3 + 1e-6
        con = @build_constraint(y + x <= 3)
        MOI.submit(model, MOI.LazyConstraint(cb_data), con)
    end
    if rand() < 0.1
        # You can terminate the callback as follows:
        Xpress.Lib.XPRSinterrupt(cb_data.model, 1234)
    end
    return
end
set_attribute(model, Xpress.CallbackFunction(), my_callback_function)
set_attribute(model, "HEUREMPHASIS", 0)
optimize!(model)
@test termination_status(model) == MOI.OPTIMAL
@test primal_status(model) == MOI.FEASIBLE_POINT
@test value(x) == 1
@test value(y) == 2
```

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


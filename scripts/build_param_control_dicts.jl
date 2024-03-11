# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Xpress, Dates

@enum DefinitionReadMode Ignore MainControl MainAttribute

FILE = joinpath(ENV["XPRESSDIR"], "include", "xprs.h")

if !isfile(FILE)
    error("File $FILE does not exist.")
end

function process(FILE)
    lines = readlines(FILE)

    out = """
    #=

    File automatically generated with script:
    Xpress.jl/scripts/build_param_control_dicts.jl

    Last build: $(now())

    $("Optimizer version: $(Xpress.get_version())")

    Banner from lib:
    $(Xpress.get_banner())

    Banner from header (xprs.h):
    $(lines[7])
    $(lines[8])

    =#

    """

    controls_start = " * control parameters for XPRSprob"
    string_control = "/* String control parameters */"
    double_control = "/* Double control parameters */"
    integer_control = "/* Integer control parameters */"

    attributes_start = " * attributes for XPRSprob "
    string_attribute = "/* String attributes */"
    double_attribute = "/* Double attributes */"
    integer_attribute = "/* Integer attributes */"

    the_end = " * control parameters for XPRSmipsolpool"

    current_definiton = Ignore
    current_type = Nothing

    dict = Dict(
        i => Any[] for i in [
            (j, k) for j in [Int32, String, Float64],
            k in [MainAttribute, MainControl]
        ]
    )

    for line in lines
        # @show line
        if startswith(line, the_end)
            break
        end
        if startswith(line, controls_start)
            current_definiton = MainControl
            continue
        elseif startswith(line, attributes_start)
            current_definiton = MainAttribute
            continue
        elseif startswith(line, string_control) ||
               startswith(line, string_attribute)
            current_type = String
            continue
        elseif startswith(line, double_control) ||
               startswith(line, double_attribute)
            current_type = Float64
            continue
        elseif startswith(line, integer_control) ||
               startswith(line, integer_attribute)
            current_type = Int32
            continue
        elseif startswith(line, "#define") &&
               current_type != Nothing &&
               current_definiton != Ignore
            data = split(line)
            name = data[2]
            # @show data[3]
            value = tryparse(Int32, data[3])
            if value === nothing
                println("failed to parse $line")
                continue
            end
            push!(dict[current_type, current_definiton], (name, value))
            continue
        else
            continue
        end
    end

    is_first = true

    order = [
        (String, MainControl),
        (Float64, MainControl),
        (Int32, MainControl),
        (String, MainAttribute),
        (Float64, MainAttribute),
        (Int32, MainAttribute),
    ]

    for (tp, mode) in order
        vec = dict[(tp, mode)]
        if is_first
            is_first = false
        else
            out *= ")\n\n"
        end
        if tp == String && mode == MainAttribute
            out *= "const STRING_ATTRIBUTES = Dict{String, Int32}(\n"
        elseif tp == Int32 && mode == MainAttribute
            out *= "const INTEGER_ATTRIBUTES = Dict{String, Int32}(\n"
        elseif tp == Float64 && mode == MainAttribute
            out *= "const DOUBLE_ATTRIBUTES = Dict{String, Int32}(\n"
        elseif tp == String && mode == MainControl
            out *= "const STRING_CONTROLS = Dict{String, Int32}(\n"
        elseif tp == Int32 && mode == MainControl
            out *= "const INTEGER_CONTROLS = Dict{String, Int32}(\n"
        elseif tp == Float64 && mode == MainControl
            out *= "const DOUBLE_CONTROLS = Dict{String, Int32}(\n"
        end
        for (name, value) in vec
            out *= "    \"$(replace(string(name), "XPRS_"=>""))\" => $value,\n"
        end
    end
    out *= ")\n\n"

    out *= """
    const STRING_CONTROLS_VALUES = values(STRING_CONTROLS)

    const DOUBLE_CONTROLS_VALUES = values(DOUBLE_CONTROLS)

    const INTEGER_CONTROLS_VALUES = values(INTEGER_CONTROLS)

    const STRING_ATTRIBUTES_VALUES = values(STRING_ATTRIBUTES)

    const DOUBLE_ATTRIBUTES_VALUES = values(DOUBLE_ATTRIBUTES)

    const INTEGER_ATTRIBUTES_VALUES = values(INTEGER_ATTRIBUTES)
    """

    open(joinpath(@__DIR__, "..", "src", "attributes_controls.jl"), "w") do f
        return write(f, out)
    end

    return nothing
end

process(FILE);

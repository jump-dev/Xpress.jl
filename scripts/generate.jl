# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Clang.Generators

# Copy the appropriate xprs.h file to the scripts directory and edit these lines.

old_xprs_filename = joinpath(@__DIR__, "xprs33.01.12.h")
xprs_filename = joinpath(@__DIR__, "xprs42.01.05.h")

context = create_context(
    [xprs_filename],
    get_default_args(),
    load_options(joinpath(@__DIR__, "generate.toml")),
)
build!(context)

function replace_line_cstring(line, signature)
    changes = getindex.(
        signature,
        findall(r"char(\s*?\*| [a-z0-9]+?\[\])", signature),
    )
    last_index = 1
    outputs = String[]
    for (change, range) in zip(changes, findall("Ptr{UInt8}", line))
        push!(outputs, line[last_index:(first(range)-1)])
        if endswith(change, "*")
            push!(outputs, "Cstring")
        else
            push!(outputs, line[range])
        end
        last_index = last(range) + 1
    end
    push!(outputs, line[last_index:end])
    return join(outputs)
end

function postprocess(filename)
    contents = read(filename, String);
    # Remove the deprecated if-else blocks
    regex = r"if XPRSdeprecated[a-z]+\n\s+(.+?)\n\s+else\n\s+\1\s+end"s
    while (m = match(regex, contents)) !== nothing
        contents = replace(contents, m.match => m.captures[1])
    end
    # Remove mutable structs
    regex = r"mutable struct (.+?) end"
    while (m = match(regex, contents)) !== nothing
        contents = replace(contents, m.match => "")
        contents = replace(contents, m.captures[1] => "Cvoid")
    end
    # Remove the cenum block
    contents = replace(contents, r"\@cenum.+?end\s+"s => "")
    # For backwards compatibility, older versions of Xpress.jl used UInt8
    # instead of Cchar.
    contents = replace(contents, "Cchar" => "UInt8")
    write(filename, contents)
    # Add comments to any symbols which are new in the current version
    lines = readlines(filename)
    old_xprs_contents = read(old_xprs_filename, String);
    # XPRSsetcheckedmode(int checkedmode)
    xprs_signatures = Dict{String,String}()
    for line in readlines(xprs_filename)
        if (m = match(r"XPRS_CC (XPRS[a-z0-9\_]+?)\(.+?\)", line)) !== nothing
            xprs_signatures[m.captures[1]] = m.match
        end
    end
    open(filename, "w") do io
        header = """
        # Copyright (c) 2016: Joaquim Garcia, and contributors
        #
        # Use of this source code is governed by an MIT-style license that can be found
        # in the LICENSE.md file or at https://opensource.org/licenses/MIT.
        #
        # Automatically generated using scripts/generate.jl
        #
        #! format: off

        """
        write(io, header)
        if isempty(lines[end])
            pop!(lines)
        end
        last_line = ""
        for line in lines
            if startswith(line, "#")
                continue # skip
            elseif startswith(line, "const ")
                m = match(r"const (.+) =", line)
                @assert m !== nothing
                if !occursin(m[1], old_xprs_contents)
                    println(io, "# Struct does not exist in v33")
                end
            elseif startswith(line, "function ")
                m = match(r"function (.+)\(", line)
                if m !== nothing && !occursin(m[1], old_xprs_contents)
                    println(io, "# Function does not exist in v33")
                end
            end
            if occursin("Ptr{UInt8}", line)
                # Replace Ptr{Cchar} with Cstring for backward compatibility
                # with older versions of Xpress.jl
                #
                # We need to replace char* with Ptr{UInt8} and char[] with
                # Cstring.
                map = Dict("char*" => "Cstring", "char" => "Ptr{UInt8}")
                m = match(r"ccall\(\(:(XPRS.+?)\,", line)
                @assert m !== nothing
                signature = xprs_signatures[m.captures[1]]
                line = replace_line_cstring(line, signature)
            end
            if !(isempty(line) && isempty(last_line))
                println(io, line)
            end
            last_line = line
        end
    end
    return
end

postprocess("src/Lib/xprs.jl")

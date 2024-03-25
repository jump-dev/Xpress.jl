# Copyright (c) 2016: Joaquim Garcia, and contributors
#
# Use of this source code is governed by an MIT-style license that can be found
# in the LICENSE.md file or at https://opensource.org/licenses/MIT.

using Clang.Generators

# Copy the appropriate xprs.h file to the scripts directory, or edit this line.

old_xprs = joinpath(@__DIR__, "xprs33.01.12.h")
xprs = joinpath(@__DIR__, "xprs42.01.05.h")

context = create_context(
    [xprs],
    get_default_args(),
    load_options(joinpath(@__DIR__, "generate.toml")),
)
build!(context)

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
    # Replace Ptr{Cchar} with Cstring for backward compatibility with older
    # versions of Xpress.jl
    # contents = replace(contents, "Ptr{Cchar}" => "Cstring")
    # For backwards compatibility, older versions of Xpress.jl used UInt8
    # instead of Cchar.
    contents = replace(contents, "Cchar" => "UInt8")
    write(filename, contents)
    # Add comments to any symbols which are new in the current version
    lines = readlines(filename)
    old_xprs_contents = read(old_xprs, String);
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
            if !(isempty(line) && isempty(last_line))
                println(io, line)
            end
            last_line = line
        end
    end
    return
end

postprocess("src/Lib/xprs.jl")

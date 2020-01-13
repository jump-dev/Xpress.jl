push!(DEPOT_PATH, abspath(joinpath(@__DIR__, "..")))

using HTTP
using Gumbo
using Gumbo.AbstractTrees
using Xpress

import Gumbo: text

function get_symbols()
    symbols = Symbol[]
    for n in names(Xpress.Lib, all = true)
        if Symbol(replace(string(n), "XPRS" => "")) in names(Xpress, all = true) && startswith(string(n), "XPRS") && !startswith(string(n), "XPRS_")
            push!(symbols, n)
        end
    end
    return symbols
end

const URL = "https://www.fico.com/fico-xpress-optimization/docs/latest/solver/optimizer/HTML"

function get_data(doc, heading1)
    it = PreOrderDFS(doc.root)
    return_next_element = false
    for elem in it
        if typeof(elem) == Gumbo.HTMLElement{:div}
            if "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctItem" && lowercase(text(elem)) == lowercase(heading1)
                return_next_element = true
            elseif return_next_element == true && "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctItemText"
                return elem
            else
                nothing
            end
        end
    end
end

function get_data(doc, heading1, heading2)
    it = PreOrderDFS(doc.root)
    return_next_element = false
    elems = []
    for elem in it
        if typeof(elem) == Gumbo.HTMLElement{:div}
            if "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctItem" && lowercase(text(elem)) == lowercase(heading1)
                return_next_element = true
            elseif "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctItem" && lowercase(text(elem)) == lowercase(heading2)
                return elems
            elseif return_next_element == true
                push!(elems, elem)
            end
        end
    end
end

function get_synopsis(doc)
    it = PreOrderDFS(doc.root)
    for elem in it
        if typeof(elem) == Gumbo.HTMLElement{:div}
            if "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctSynopsis"
                return elem
            end
        end
    end
end

function get_arguments(doc)
    it = PreOrderDFS(doc.root)
    return_next_element = false
    elems = []
    for elem in it
        if typeof(elem) == Gumbo.HTMLElement{:div}
            if "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "FctItem" && lowercase(text(elem)) == lowercase("Arguments")
                return_next_element = true
            end
        elseif return_next_element == true && typeof(elem) == Gumbo.HTMLElement{:table}
            return elem
        end
    end
end

function generate_documentation(symbols)
    documentation = Dict()

    for n in symbols

        println("Getting documentation for $(string(n))")
        try
            r = HTTP.request("GET", "$URL/$(string(n)).html")
            global doc
            doc = parsehtml(String(r.body));
        catch
            println("Unable to get documentation for $(string(n))")
            continue
        end

        documentation[n] = Dict()
        documentation[n]["purpose"] = strip(replace(join(text.(get_data(doc, "Purpose").children)), "\n" => ""))
        documentation[n]["synopsis"] = strip(replace(join(text.(get_synopsis(doc).children)), "\n" => ""))
        documentation[n]["arguments"] = []

        tbl = get_arguments(doc)
        if !isnothing(tbl)
            tbody = tbl.children[1]
            while length(tbody.children) > 0
                tr = popfirst!(tbody.children)
                kw = text(popfirst!(tr.children).children[1])
                docstring = strip(replace(join(strip.(text.(popfirst!(tr.children).children[1].children)), " "), "\n" => ""))
                push!(documentation[n]["arguments"], kw => docstring)
            end
        end
        rt = get_data(doc, "Related topics")
        if !isnothing(rt)
            documentation[n]["related"] = strip(replace(join(text.(rt.children)), "\n" => ""))
        end
    end

    return documentation

end

text(elem::HTMLElement{:td}) = strip(join(text.(elem.children)))
text(elem::HTMLElement{:tr}) = strip(join(text.(elem.children)))
text(elem::HTMLElement{:code}) = strip(join(text.(elem.children)))
function text(elem::HTMLElement{:span})
    if "class" ∈ keys(elem.attributes) && elem.attributes["class"] == "code"
        return "`$(strip(join(text.(elem.children))))`"
    else
        return join(text.(elem.children))
    end
end
text(elem::HTMLElement{:a}) = strip(join(text.(elem.children)))

documentation = generate_documentation(get_symbols())

function write_docstring(sym)
    f = joinpath(@__DIR__, "../src/api.jl")
    original_lines = collect(readlines(f))
    lines = deepcopy(original_lines)
    needle = string(sym)
    needle = replace(needle, "XPRS" => "")
    needle = "function $(needle)("
    for (i, haystack) in enumerate(original_lines)
        if occursin(needle, haystack)
            temp = String[]
            push!(temp, "\"\"\"")
            push!(temp, "    $(documentation[sym]["synopsis"])")
            push!(temp, "")
            push!(temp, "$(documentation[sym]["purpose"])")
            push!(temp, "")
            if length(documentation[sym]["arguments"]) > 0
                push!(temp, "### Arguments")
                push!(temp, "")
                for (arg, ds) in documentation[sym]["arguments"]
                    push!(temp, "- `$arg`: $ds")
                end
                push!(temp, "")
            end
            push!(temp, "\"\"\"")
            for l in reverse(temp)
                insert!(lines, i, l)
            end
        end
    end
    b = open(f, "w")
    write(b, join(lines, "\n"))
    close(b)
end

for n in get_symbols()
    if n ∈ keys(documentation)
        write_docstring(n)
    end
end

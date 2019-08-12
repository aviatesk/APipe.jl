module FlexPipe

export @>

const splitter = r"\|\s[^\|]+?\s>"


@doc """
    @>

Enhances [|>](@ref) operation, and allows more flexible function chaining.
$(""
# # Example
# ```julia
# julia> function λ(arg1, arg2 = "arg2"; keyarg = "keyarg")
#            arg1, arg2, keyarg
#        end
# λ (generic function with 2 methods)
#
# julia> @> "chanined" |> λ
# ("chanined", "arg2", "keyarg")
#
# julia> @> "chained" |1> λ("passed")
# ("chained", "passed", "keyarg")
#
# julia> @> "chained" |2> λ("passed")
# ("passed", "arg2", "keyarg")
# ```
)
"""
macro >(expr)
    strexpr = string(expr)
    !occursin(splitter, strexpr) && return :($(esc(expr)))

    leftexpr, rightexpr = map(split(strexpr, splitter)) do se
        Meta.parse(se)
    end
    m = match(splitter, strexpr).match
    pipearg = strip(m, ['|', '>', ' ']) |> Meta.parse
    if pipearg isa Int
        # Insert `leftexpr` into a specific argument position
        insert!(rightexpr.args, 1 + pipearg, leftexpr)
    else
        # Insert `leftexpr` as a keyword argument
        insert!(rightexpr.args, 2, Expr(:parameters, :($pipearg=$leftexpr)))
        rightexpr.args[2].args[1].head = :kw
    end

    return quote
        $(esc(rightexpr))
    end
end

end  # module

module APipe

export @>

@doc """
    @>

Enhances [|>](@ref) operation, and allows more flexible function chaining.

# Example
```julia
julia> function λ(arg, default = "default"; keyword = "default")
           arg, default, keyword
       end
λ (generic function with 2 methods)

julia> @> "chanined" |> λ
("chanined", "default", "default")

julia> @> "chained" |> (1, λ())
("chained", "default", "default")

julia> @> "chained" |> (2, λ("passsed"))
("passed", "chained", "default")

julia> @> "chanined" |> (:keyword, λ("passed"))
("passed", "default", "chained")
```
"""
macro >(expr)
    processexpr!(expr)
    :($(esc(expr)))
end


include("manipulate.jl")

end  # module

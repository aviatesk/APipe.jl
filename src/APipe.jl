module APipe

export @>

@doc """
    @>

Enhances [|>](@ref) operation, and allows more flexible function chaining.

# Example
```julia
julia> function λ(arg1, arg2 = "default"; keyarg = "default")
           arg1, arg2, keyarg
       end
λ (generic function with 2 methods)

julia> @> "chanined" |> λ
("chanined", "default", "default")

julia> @> "chained" |> (1, λ())
("chained", "default", "default")

julia> @> "chained" |> (2, λ("arg1"))
("arg1", "chained", "default")

julia> @> "chanined" |> (:keyarg, λ("arg1"))
("arg1", "default", "chained")
```
"""
macro >(expr)
    processexpr!(expr)
    :($(esc(expr)))
end


include("pipe.jl")

end  # module

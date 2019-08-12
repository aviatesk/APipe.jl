@doc """
    @> expr

Enhances [`|>`](@ref) operation, and allows more flexible function chaining.

!!! note
    This macro is _almost_ compatible with the original [`|>`](@ref) operation, except
    [dot fusing](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1).

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

See also: [`|>`](@ref), [`@>>`](@ref)
"""
macro >(expr)
    processexpr!(expr)
    :($(esc(expr)))
end

@doc """
    @>> exprs...

Allows [`@>`](@ref) chaining even without [`|>`](@ref) operators.

# Example
```julia
julia> function λ(arg, default = "default"; keyword = "default")
           arg, default, keyword
       end
λ (generic function with 2 methods)

julia> @>> "chanined" λ
("chanined", "default", "default")

julia> @>> "chained" (1, λ())
("chained", "default", "default")

julia> @>> "chained" (2, λ("passsed"))
("passed", "chained", "default")

julia> @>> "chanined" (:keyword, λ("passed"))
("passed", "default", "chained")
```

See also: [`|>`](@ref), [`@>`](@ref)
"""
macro >>(exprs...)
    expr = concatexpr(exprs...)
    :($(esc(expr)))
end

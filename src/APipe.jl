module APipe

export @>, @>>

@doc """
    @> expr

Enhances [|>](@ref) operation, and allows more flexible function chaining.

!!! note
    This macro is _completely_ compatible with the original [|>](@ref) operation.

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

@doc """
    @>> exprs...

Allows [@>](@ref) chaining even without [|>](@ref) operators.

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
"""
macro >>(exprs...)
    expr = concatexpr(exprs...)
    :($(esc(expr)))
end

include("manipulate.jl")

end  # module

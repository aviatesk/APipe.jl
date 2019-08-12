@doc """
    @> expr

Enhances [`|>`](@ref) operation, and allows more flexible function chaining.

!!! note
    `|>` operations inside the `@>` macro are fully compatible with the original
    [`|>`](@ref) operations.

See also: [`|>`](@ref), [`@>>`](@ref)

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

julia> @> 1:100 .|> string .|> (2, λ("passed"))
100-element Array{Tuple{String,String,String},1}:
 ("passed", "1", "default")
 ("passed", "2", "default")
 ("passed", "3", "default")
 ("passed", "4", "default")
 ("passed", "5", "default")
 ⋮
 ("passed", "97", "default")
 ("passed", "98", "default")
 ("passed", "99", "default")
 ("passed", "100", "default")
```
"""
macro >(expr)
    processexpr!(expr)
    :( $(esc(expr)) )
end

@doc """
    @>> exprs...

Allows [`@>`](@ref) chaining without [`|>`](@ref) operators.

See also: [`|>`](@ref), [`@>`](@ref)

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
    expr = concatexpr(exprs)
    :( $(esc(expr)) )
end

@doc """
    @.>> exprs...

Works almost same as [`@>>`](@ref) except that implicit [`|>`](@ref) is all
[dot-fused](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1).

See also: [`|>`](@ref), [`@>`](@ref), [`@>>`](@ref)

# Example
```julia
julia> function λ(arg, default = "default"; keyword = "default")
           arg, default, keyword
       end
λ (generic function with 2 methods)

julia> @.>> 1:100 string (2, λ("passed"))
100-element Array{Tuple{String,String,String},1}:
 ("passed", "1", "default")
 ("passed", "2", "default")
 ("passed", "3", "default")
 ("passed", "4", "default")
 ("passed", "5", "default")
 ⋮
 ("passed", "97", "default")
 ("passed", "98", "default")
 ("passed", "99", "default")
 ("passed", "100", "default")
```
"""
macro .>>(exprs...)
    expr = concatexpr(exprs, true)
    :( $(esc(expr)) )
end

@doc """
    @> expr

Enhances [`|>`](@ref) operation, and allows more flexible function chaining.

!!! note
    `@>` macro is _almost_ compatible with the original [`|>`](@ref) operation,
    except that chaining arguments by wrapping in an anonymous function like
    `val |> x -> f(x)` **should be avoided**.

See also: [`|>`](@ref), [`@>>`](@ref)

# Example
```julia
julia> function λ(arg, default = "default"; keyword = "default")
           arg, default, keyword
       end
λ (generic function with 2 methods)

# usual function chaining operation
julia> @> "chanined" |> λ
("chanined", "default", "default")

# given function call, injects chained value into the first argument
julia> @> "chained" |> λ()
("chained", "default", "default")

julia> @> "chained" |> λ("passed")
("chained", "passed", "default")

# with tuple, the argument position can be specified
julia> @> "chained" |> (1, λ())
("chained", "default", "default")

julia> @> "chained" |> (2, λ("passsed"))
("passed", "chained", "default")

# keyword argument should be specified with symbol
julia> @> "chanined" |> (:keyword, λ("passed"))
("passed", "default", "chained")

# dot-fusing is fully supported
julia> @> 1:100 .|> string .|> λ("passed")
100-element Array{Tuple{String,String,String},1}:
 ("1", "passed", "default")
 ("2", "passed", "default")
 ("3", "passed", "default")
 ("4", "passed", "default")
 ("5", "passed", "default")
 ⋮
 ("97", "passed", "default")
 ("98", "passed", "default")
 ("99", "passed", "default")
 ("100", "passed", "default")
```
"""
macro >(expr)
    processexpr!(expr)
    :( $(esc(expr)) )
end

@doc """
    @>> exprs...

Allows [`@>`](@ref) chaining without [`|>`](@ref) operators.

See also: [`@>`](@ref)

# Example
```julia
julia> function λ(arg, default = "default"; keyword = "default")
           arg, default, keyword
       end
λ (generic function with 2 methods)

julia> @>> "chained" λ()
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

See also: [`@>`](@ref), [`@>>`](@ref)

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

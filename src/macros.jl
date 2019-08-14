@doc """
    @> expr

Enhances [`|>`](@ref) operation, and allows more flexible function chaining.

!!! note
    `@>` macro is _almost_ compatible with the original [`|>`](@ref) operation,
    except that chaining arguments by wrapping in an anonymous function like
    `val |> x -> f(x, val)` **should be avoided**.

See also: [`|>`](@ref), [`@>>`](@ref)

# Example

- compatible with usual [`|>`](@ref) operations

```julia
julia> λ(val) == val |> λ == @> val |> λ
```

- given function call, injects chained value into the first argument (no need to write `val |> x -> λ(x, val2)`)

```julia
julia> val |> x -> λ(x) == @> val |> λ()
julia> val |> x -> λ(x, val2) == @> val |> λ(val2)
julia> val |> x -> λ(x, val2) |> x -> λ2(x, val3) == @> val |> λ(val2) |> λ2(val3)
```

- using tuple, the argument position can be specified

```julia
julia> val |> x -> λ(x) == @> val |> (1, λ())
julia> val |> x -> λ(val2, x) == @> val |> (2, λ(val2))
julia> val |> x -> λ(val2, x) |> x -> λ2(x, val3) == @> val |> (2, λ(val2)) |> λ2(val3)
```

- keyword argument should be specified with symbol

```julia
julia> val |> x -> λ(val2; keyword = x) == @> val |> (:keyword, λ(val2))
julia> val |> x -> λ(val2; keyword = x) |> x -> λ2(val3; keyword2 = x) == @> val |> (:keyword, λ(val2)) |> (:keyword2, λ2(val3))
```

- [dot-fusing](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1) is fully supported

```julia
julia> (ary .|> string .|> x -> λ(x, val)) == @> ary .|> string .|> λ(val)
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

!!! note
    Equivalent to the examples of [`@>`](@ref)

```julia
julia> λ(val) == val |> λ == @>> val λ
```

```julia
julia> val |> x -> λ(x) == @>> val λ()
julia> val |> x -> λ(x, val2) == @>> val λ(val2)
julia> val |> x -> λ(x, val2) |> x -> λ2(x, val3) == @>> val λ(val2) λ2(val3)
```

```julia
julia> val |> x -> λ(x) == @>> val (1, λ())
julia> val |> x -> λ(val2, x) == @>> val (2, λ(val2))
julia> val |> x -> λ(val2, x) |> x -> λ2(x, val3) == @>> val (2, λ(val2)) λ2(val3)
```

```julia
julia> val |> x -> λ(val2; keyword = x) == @>> val (:keyword, λ(val2))
julia> val |> x -> λ(val2; keyword = x) |> x -> λ2(val3; keyword2 = x) == @>> val (:keyword, λ(val2)) (:keyword2, λ2(val3))
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

!!! note
    Equivalent to the last example of [`@>`](@ref)

```julia
julia> (ary .|> string .|> x -> λ(val, x)) == @.>> ary string (2, λ(val))
```
"""
macro .>>(exprs...)
    expr = concatexpr(exprs, true)
    :( $(esc(expr)) )
end

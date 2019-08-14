# APipe.jl

[![Build Status](https://travis-ci.org/aviatesk/APipe.jl.svg?branch=master)](https://travis-ci.org/aviatesk/APipe.jl)
[![codecov](https://codecov.io/gh/aviatesk/APipe.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/aviatesk/APipe.jl)

Lets you abuse `|>` and may make you `|>` addict.


## Examples

With `@>` macro, you no longer need to write the boring `val |> x -> func(val, x)`.

- compatible with usual [`|>`](@ref) operations

```julia
julia> λ(val) == val |> λ == @> val |> λ
```

- given function call, injects chained value into the first argument (no need to write `x -> λ(x, y)`)

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

***

With `@>>` macro, you no longer need even `|>` operators themselves.
> Equivalent to the examples of `@>`

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

***

With `@.>>` macro, all the implicit `|>` operations are [dot-fused](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1).

> Equivalent to the last example of `@>`

```julia
julia> (ary .|> string .|> x -> λ(val, x)) == @.>> ary string (2, λ(val))
```


## Random TODOs

- [x] Support `.|>` fusing

## License

[MIT License](LICENSE.md).


<!-- ## Acknowledgements -->


<!-- ## References -->


## Author

- **KADOWAKI, Shuhei** - *Undergraduate@Kyoto Univ.* - [aviatesk]


<!-- Links -->

[aviatesk]: https://github.com/aviatesk

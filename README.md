# APipe.jl

[![Build Status](https://travis-ci.org/aviatesk/APipe.jl.svg?branch=master)](https://travis-ci.org/aviatesk/APipe.jl)
[![codecov](https://codecov.io/gh/aviatesk/APipe.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/aviatesk/APipe.jl)

Lets you abuse `|>` and may make you `|>` addict.


## Example

With `@>` macro, you no longer need to write the boring `val |> x -> func(val, x)`.

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

With `@>>` macro, you no longer need even `|>` operators themselves.

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

Within `@.>>` macro, all the implicit `|>` operations are [dot-fused](https://docs.julialang.org/en/v1/manual/functions/#man-vectorized-1).

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

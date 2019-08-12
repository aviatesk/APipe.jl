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

With `@>>` macro, you no longer need even `|>` operators themselves.

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

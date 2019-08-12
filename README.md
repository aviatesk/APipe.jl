# APipe.jl

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


## Random TODOs

- [ ] Support `.|>` fusing

## License

[MIT License](LICENSE.md).


<!-- ## Acknowledgements -->


<!-- ## References -->


## Author

- **KADOWAKI, Shuhei** - *Undergraduate@Kyoto Univ.* - [aviatesk]


<!-- Links -->

[aviatesk]: https://github.com/aviatesk

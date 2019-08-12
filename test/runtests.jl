using APipe
using Test

function λ𝟎(; keyword = "keyword")
    keyword
end

function λ𝟏(arg; keyword = "keyword")
    arg, keyword
end

function λ(arg, default = "default"; keyword = "keyword")
    arg, default, keyword
end

@testset "APipe" begin
    @testset "applied to function" begin
        @test ("chained", "keyword") == @> "chained" |> λ𝟏
        @test ("chained", "keyword") == @> "chained" |> (1, λ𝟏)
        @test ("chained") == @> "chained" |> (:keyword, λ𝟎)
    end

    @testset "applied to function call" begin
        @test ("chained", "default", "keyword") == @> "chained" |> (1, λ())
        @test ("passed", "chained", "keyword") == @> "chained" |> (2, λ("passed"))
        @test ("passed", "default", "chained") == @> "chained" |> (:keyword, λ("passed"))
    end
end

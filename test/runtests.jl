using APipe
using Test

function λ𝟎(keyword = "keyword")
    keyword
end

function λ𝟏(arg; keyword = "keyword")
    arg, keyword
end

@testset "APipe" begin
    @testset "applied to function" begin
        @test ("chained", "keyword") == @> "chained" |> λ𝟏
        @test ("chained", "keyword") == @> "chained" |> (1, λ𝟏)
        @test ("chained") == @> "chained" |> (:keyword, λ𝟎)
    end
end

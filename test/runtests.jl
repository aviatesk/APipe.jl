using APipe
using Test

function λ𝟎(; keyword = "default")
    keyword
end

function λ𝟏(arg; keyword = "default")
    arg, keyword
end

function λ(arg, default = "default"; keyword = "default")
    arg, default, keyword
end


@testset "APipe" begin

@testset "@> macro" begin
    @testset "applied to function" begin
        @test ("chained") == @> "chained" |> (:keyword, λ𝟎)
        @test ("chained", "default") == @> "chained" |> λ𝟏
        @test ("chained", "default") == @> "chained" |> (1, λ𝟏)
    end

    @testset "applied to function call" begin
        @test ("chained", "default", "default") == @> "chained" |> (1, λ)
        @test ("chained", "default", "default") == @> "chained" |> λ()
        @test ("chained", "default", "default") == @> "chained" |> (1, λ())
        @test ("chained", "passed", "default") == @> "chained" |> λ("passed")
        @test ("passed", "chained", "default") == @> "chained" |> (2, λ("passed"))
        @test ("passed", "default", "chained") == @> "chained" |> (:keyword, λ("passed"))
    end

    @testset "applied with dot fuse" begin
        strarray = [rand('A':'Z', 5) |> join for i ∈ 1:10]
        @test (strarray .== @> strarray .|> λ() .|> getindex(1)) |> all
    end
end

@testset "@>> macro" begin
    @testset "usual |> chaining" begin
        @test ("chained") == @>> "chained" x -> λ𝟎(; keyword = x)
        @test ("chained", "default") == @>> "chained" λ𝟏
        @test ("chained", "default") == @>> "chained" x -> λ𝟏(x)
    end

    @testset "@> chanining" begin
        @test ("chained", "default", "default") == @>> "chained" (1, λ)
        @test ("chained", "default", "default") == @>> "chained" λ()
        @test ("passed", "chained", "default") == @>> "chained" (2, λ("passed"))
        @test ("passed", "default", "chained") == @>> "chained" (:keyword, λ("passed"))
    end
end

@testset "@.>> macro" begin
    strarray = [rand('A':'Z', 5) |> join for i ∈ 1:10]
    @test (strarray .== @.>> strarray λ() getindex(1)) |> all
end

end

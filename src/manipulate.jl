function processexpr!(expr) end # fallback

function processexpr!(expr::Expr)
    head = expr.head
    args = expr.args

    if head === :call && args[1] === :|>
        # process inside `|>` operators first
        processexpr!(args[2])

        if args[3] isa Expr && args[3].head === :tuple
            tpl = args[3].args
            pipearg, fcall = tpl

            # verbose ?
            @assert length(tpl) === 2 &&
                    (pipearg isa Int || (pipearg isa QuoteNode && pipearg.value isa Symbol)) &&
                    (fcall isa Symbol || (fcall isa Expr && fcall.head === :call))

            # manipulate chanined expression
            args[3] = makechainfunc(fcall, pipearg)
        end
    end
end

function makechainfunc(fcall::Symbol, pipearg::Int)
    f = fcall
    :(piped -> $f(piped))
end

function makechainfunc(fcall::Symbol, pipearg::QuoteNode)
    f = fcall
    :(piped -> $f(; $(pipearg.value) = piped))
end

function makechainfunc(fcall::Expr, pipearg::Int)
    offset = haskeywordarg(fcall) ? 2 : 1
    insert!(fcall.args, pipearg + offset, :piped)

    :(piped -> $fcall)
end

function makechainfunc(fcall::Expr, pipearg::QuoteNode)
    keyarg = Expr(:kw, pipearg.value, :piped)
    if haskeywordarg(fcall)
        push!(fcall.args[2].args, keyarg)
    else
        insert!(fcall.args, 2, Expr(:parameters, keyarg))
    end

    :(piped -> $fcall)
end

function haskeywordarg(fcall)
    for arg ∈ fcall.args
        arg isa Expr && arg.head === :parameters && return true
    end
    return false
end

# @TODO: absolutely better to manipulate ASTs directly rather than parsing from string
function concatexpr(exprs)
    concated = ["@>"]
    push!(concated, stringify(exprs[1]))
    for expr ∈ exprs[2:end]
        push!(concated, "|>")
        push!(concated, stringify(expr))
    end

    concated |> join |> Meta.parse
end

stringify(expr) = string(expr)
stringify(expr::String) = "\"$(expr)\""

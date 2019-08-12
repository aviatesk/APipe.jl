function processexpr!(expr) end # fallback

function processexpr!(expr::Expr)
    head = expr.head
    args = expr.args

    if head === :call && (args[1] === :|> || args[1] === :.|>)
        # process inside `|>` operators first
        processexpr!(args[2])

        if args[3] isa Expr && args[3].head === :tuple
            tpl = args[3].args
            chainarg, fcall = tpl

            # manipulate chanined expression
            args[3] = makechainfunc(fcall, chainarg)
        end
    end
end

function makechainfunc(fcall::Symbol, chainarg::Int)
    f = fcall
    :( chained -> $f(chained) )
end

function makechainfunc(fcall::Symbol, chainarg::QuoteNode)
    f = fcall
    :( chained -> $f(; $(chainarg.value) = chained) )
end

function makechainfunc(fcall::Expr, chainarg::Int)
    offset = haskeywordarg(fcall) ? 2 : 1
    insert!(fcall.args, chainarg + offset, :chained)

    :( chained -> $fcall )
end

function makechainfunc(fcall::Expr, chainarg::QuoteNode)
    keyarg = Expr(:kw, chainarg.value, :chained)
    if haskeywordarg(fcall)
        push!(fcall.args[2].args, keyarg)
    else
        insert!(fcall.args, 2, Expr(:parameters, keyarg))
    end

    :( chained -> $fcall )
end

function haskeywordarg(fcall)
    for arg ∈ fcall.args
        arg isa Expr && arg.head === :parameters && return true
    end
    return false
end

# @TODO: absolutely better to manipulate ASTs directly rather than parsing from string
function concatexpr(exprs, dotfuse = false)
    concated = ["@>"]
    push!(concated, stringify(exprs[1]))
    for expr ∈ exprs[2:end]
        if dotfuse
            push!(concated, ".|>")
        else
            push!(concated, "|>")
        end
        push!(concated, stringify(expr))
    end

    join(concated, " ") |> Meta.parse
end

stringify(expr) = string(expr)
stringify(expr::String) = "\"$(expr)\""

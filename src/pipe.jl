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
    # the other arguments are not specified and thus `pipearg` should be `1`
    @assert pipearg === 1 "the first argument is not specified"
    :(piped -> $fcall(piped))
end

function makechainfunc(fcall::Symbol, pipearg::QuoteNode)
    :(piped -> $fcall(; $(pipearg.value) = piped))
end

function makechainfunc(fcall::Expr, pipearg::Int) end
function makechainfunc(fcall::Expr, pipearg::Symbol) end

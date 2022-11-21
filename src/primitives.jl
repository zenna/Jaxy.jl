using Base.Iterators

const JLPrimitive = Union{typeof(sin), typeof(cos), typeof(Base.isless), typeof(sqrt),
typeof(+), typeof(-), typeof(*),  typeof(/), typeof(|), typeof(&), typeof(^), 
typeof(ifelse), typeof(!)}

const ARITY_1 = [:(Base.sin), :(Base.cos), :(Base.sqrt), :(Base.:(-)), :(Base.:(!))]

const ARITY_2 = [:(Base.:(+)), :(Base.:(-)), :(Base.:(*)), :(Base.:(/)), :(Base.isless), :(Base.:(|)), :(Base.:(&)), :(Base.:(^))]

const ARITY_3 = [:(Base.ifelse)]

const primitives = vcat(ARITY_1, ARITY_2, ARITY_3)

const ARITY_TO_FUNCS = Dict(1 => ARITY_1,
                            2 => ARITY_2,
                            3 => ARITY_3)

function combo_to_sig(combo; start = 0)
  function f(i, isctxval)
    argname = Symbol("arg_$i")
    if isctxval
      Expr(:(::),  argname, :ContextualValue)
    else
      argname
    end
  end
  map(x -> f(x[1] + start, x[2]), enumerate(combo))
end

function Base.getproperty(x::ContextualValue, key::Symbol)
  if key === :ctx
    getfield(x, :ctx)
  elseif key === :val
    getfield(x, :val)
  else
    mv_ctx(x)(getproperty(sval(x), key))
  end
end

function Base.getindex(x::ContextualValue, i::Int)
  mv_ctx(x)(getindex(sval(x), i))
end

Base.length(x::ContextualValue) = length(sval(x))

function generate_ctx_methods()
  for arity in keys(ARITY_TO_FUNCS)
    funcs = ARITY_TO_FUNCS[arity]
    for func in funcs
      for combo in gen_combinations(arity)
        args = combo_to_sig(combo)
        arg_tuple = Expr(:tuple, args...)
        argnames = [Symbol("arg_$i") for i = 1:arity]
        context = findall(combo)
        all_context = argnames[context]
        first_context = all_context[1]
        expr = quote
          function $(func)($(args...))
            @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
            args_ = map(sval, $arg_tuple)
            outvar = handle_boxed($(func), $(first_context).ctx, args_...)
            return ContextualValue($(first_context).ctx, outvar)
          end
        end
        eval(expr)
      end
    end
  end
end

function gen_ifelse_methods()
  for combo in gen_combinations(2)
    args = [Expr(:(::),  Symbol("arg_1"), :Bool), combo_to_sig(combo, start = 1)...]
    arg_tuple = Expr(:tuple, args...)
    argnames = [Symbol("arg_$i") for i = 1:3]
    context = findall(combo) .+ 1
    all_context = argnames[context]
    first_context = all_context[1]
    expr = quote
      function Base.ifelse($(args...))
        @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
        args_ = map(sval, $arg_tuple)
        outvar = handle_boxed(ifelse, $(first_context).ctx, args_...)
        return ContextualValue($(first_context).ctx, outvar)
      end
    end
    eval(expr)
  end
end
# function Base.ifelse(p::Bool, x::ContextualValue, y)
#   args = [p, x.val, y]
#   ctx = x.ctx
#   outvar = handle_boxed(ifelse, ctx, args...)
#   ContextualValue(ctx, outvar)
# end

# function Base.ifelse(p::Bool, x, y::ContextualValue)
#   args = [p, x, y.val]
#   ctx = y.ctx
#   outvar = handle_boxed(ifelse, ctx, args...)
#   ContextualValue(ctx, outvar)
# end

"Maps e.g. `n=3` to [[0,0,] ] "
function gen_combinations(n)
  b = (false, true)
  Base.Iterators.filter(any, Iterators.product((b for i = 1:n)...))
end

generate_ctx_methods()
gen_ifelse_methods()

mv_ctx(x::ContextualValue, y) = ContextualValue(x.ctx, y)
function mv_ctx(x::ContextualValue, y::ContextualValue)
  @assert x.ctx == y.ctx
  y
end

mv_ctx(x::ContextualValue) = y -> mv_ctx(x, y)

Base.iterate(xs::ContextualValue) = iterate(map(mv_ctx(xs), sval(xs)))
Base.iterate(xs::ContextualValue, i) = iterate(map(mv_ctx(xs), sval(xs)), i)

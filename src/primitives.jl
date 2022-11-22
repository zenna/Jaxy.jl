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
            any(map(has_nested_ctx, $arg_tuple)) && error("Type of args is not valid")
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
        any(map(has_nested_ctx, $arg_tuple)) && error("Type of args is not valid")
        @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
        args_ = map(sval, $arg_tuple)
        outvar = handle_boxed(ifelse, $(first_context).ctx, args_...)
        return ContextualValue($(first_context).ctx, outvar)
      end
    end
    eval(expr)
  end
end

"Maps e.g. `n=3` to [[0,0,] ] "
function gen_combinations(n)
  b = (false, true)
  Base.Iterators.filter(any, Iterators.product((b for i = 1:n)...))
end

function handle_boxed(f::JLPrimitive, ctx::JaxprContext, args...)
  jaxpr = ctx.data
  vals_ = map(sval, args)
  vars_ = map(var, args)
  outval = f(vals_...)
  outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict())
  Boxed(outvar, outval)
end

generate_ctx_methods()
gen_ifelse_methods()

## Make a function a primitive

function primop(f::Function, args...)
  arity = length(args)
  for combo in gen_combinations(arity)
    args = combo_to_sig(combo)
    arg_tuple = Expr(:tuple, args...)
    argnames = [Symbol("arg_$i") for i = 1:arity]
    context = findall(combo)
    all_context = argnames[context]
    first_context = all_context[1]
    function handle_boxed_local(f, ctx::JaxprContext, args...)
      jaxpr = ctx.data
      vals_ = map(sval, args)
      vars_ = map(var, args)
      outval = f(vals_...)
      outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict())
      Boxed(outvar, outval)
    end
    quote
      @eval function $(f)($(args...))
        any(map(has_nested_ctx, $arg_tuple)) || error("Type of args is not valid")
        @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
        args_ = map(sval, $arg_tuple)
        outvar = handle_boxed_local($(f), $(first_context).ctx, args_...)
        return ContextualValue($(first_context).ctx, outvar)
      end
    end
  end
end

# macro primop(expr, define_promotion = true, Ts = [])
#   @assert expr.head === :call
#   f = expr.args[1]
#   quote
#       for combo in gen_combinations(length(expr.args[2:end]))
#         args = combo_to_sig(combo)
#         arg_tuple = Expr(:tuple, args...)
#         argnames = [Symbol("arg_$i") for i = 1:arity]
#         context = findall(combo)
#         all_context = argnames[context]
#         first_context = all_context[1] 
#         exp = quote
#           function $f($(args...))
#             any(map(has_nested_ctx, $arg_tuple)) || error("Type of args is not valid")
#             @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
#             args_ = map(sval, $arg_tuple)
#             outvar = handle_boxed($(func), $(first_context).ctx, args_...)
#             return ContextualValue($(first_context).ctx, outvar)
#           end
#         end
#         eval(exp)
#       end
#   end |> esc
# end
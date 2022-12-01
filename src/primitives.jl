using Base.Iterators

const JLPrimitive = Union{typeof(sin), typeof(cos), typeof(Base.isless), typeof(sqrt),
typeof(+), typeof(-), typeof(*),  typeof(/), typeof(|), typeof(&), typeof(^), 
typeof(ifelse), typeof(!), typeof(eachrow_eager), typeof(first), typeof(exp)}
# mapg, cond and map are also primitives but don't use `handle_boxed`, which is why they're not in the above list.

const ARITY_1 = [:(Base.sin), :(Base.cos), :(Base.sqrt), :(Base.:(-)), :(Base.:(!)), :(Base.first), :(Base.exp)]

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
            args_ = []
            for arg in $arg_tuple
              if has_nested_ctx(arg)
                push!(args_, add_primops!(arg))
              else
                push!(args_, arg)
              end
            end
            @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
            args_ = map(val, args_)
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
        args_ = []
        for arg in $arg_tuple
          if has_nested_ctx(arg)
            push!(args_, add_primops!(arg))
          else
            push!(args_, arg)
          end
        end
        @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
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
  outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict{Symbol, Any}())
  Boxed(outvar, outval)
end

generate_ctx_methods()
gen_ifelse_methods()

## Indicate that a function is a primitive
function primop(f, args_actual...)
  args = []
  for arg in args_actual
    if has_nested_ctx(arg)
      push!(args, add_primops!(arg))
    else
      push!(args, arg)
    end
  end
  cvs = filter(x -> x isa ContextualValue, args)
  if isempty(cvs)
    return f(args...)
  else
    @assert all([cv.ctx == cvs[1].ctx for cv in cvs[2:end]])
    args_ = map(val, args)
    vars_ = map(var, args_)
    jaxpr_ctx = cvs[1].ctx
    outvar = add_eqn!(jaxpr_ctx.data, Primitive(Symbol(f)), [vars_...], Dict())
    outval = f(map(sval, args_)...)
    if has_nested_ctx(outval)
      outval = add_primops!(outval)
    end
    return ContextualValue(jaxpr_ctx, Boxed(outvar, outval))
  end
end

function add_primops!(x::T) where {T}
  if x isa Tuple
    return primop(Core.tuple, x...)  
  elseif x isa Vector
    return primop(Base.vect, x...)
  else
    fields_ = fieldnames(T)
    if isempty(fields_)
      error("Invalid inputs")
    else
      fields__ = map(f -> getfield(x, f), fields_)
      return primop(T.name.wrapper, fields__...)
    end
  end
end

function eachrow_eager(m::ContextualValue)
  if has_nested_ctx(m)
    m = add_primops!(m)
  end
  outval = eachrow_eager(sval(m))
  outvar = add_eqn!(m.ctx.data, Primitive(:eachrow_eager), [var(m.val)], Dict{Symbol, Any}())
  @show outval # returns SubArray, which causes some issue
  return ContextualValue(m.ctx, Boxed(outvar, outval))
end
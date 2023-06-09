function add_arg!(jaxpr::JaxExpr, v = Var(Symbol("arg", length(jaxpr.in_binders) + 1), Float64))
  push!(jaxpr.in_binders, v)
  v
end

function add_eqn!(jaxpr::JaxExpr, primitive, inputs, params)
  # Get an unused Variable in jaxpr
  outvar = Var(Symbol("out", length(jaxpr.eqns) + 1), Float64)
  push!(jaxpr.eqns, JaxprEqn(primitive, inputs, params, [outvar]))
  outvar
end

function make_jaxpr_ctx(f, args...; kwargs...)
  for i in 1:length(args)
    if has_nested_ctx(args[i])
      args[i] = add_primops!(args[i])
    end
  end
  jaxpr = JaxExpr()
  args_ = [Boxed(add_arg!(jaxpr), arg) for arg in args] # FIX TYPE
  ctx_args = ContextualValue[ContextualValue(JaxprContext(jaxpr), arg) for arg in args_]
  ret = f(ctx_args...)
  if has_nested_ctx(ret)
    ret = add_primops!(ret)
  end
  # add return value to output of jaxpr
  push!(jaxpr.outs, var(val(ret)))
  return jaxpr
end

# Current version: Changes args to cond in jaxpr, other branch is an empty jaxpr
function cond(p::ContextualValue, λt::Function, λf::Function, targs_, fargs_)
  if has_nested_ctx(p)
    p = add_primops!(p)
  end
  targs = []
  for t in targs_ 
    if has_nested_ctx(t)
      push!(targs, add_primops!(t))
    else
      push!(targs, t)
    end
  end
  fargs = []
  for i in 1:length(fargs_)  
    if has_nested_ctx(fargs_[i])
      push!(fargs, add_primops!(fargs_[i]))
    else
      push!(fargs, fargs_[i])
    end
  end
  jax1, jax2 = JaxExpr(), JaxExpr()
  args_t = map(val, targs)
  vals_t = sval(args_t)
  vars_t = map(var, args_t)
  args_f = map(val, fargs)
  vals_f = sval(args_f)
  vars_f = map(var, args_f)
  if val(val(p))
    jax1 = make_jaxpr_ctx(λt, vals_t...)
    outval = λt(vals_t...)
  else
    jax2 = make_jaxpr_ctx(λf, vals_f...)
    outval = λf(vals_f...)
  end
  t = add_eqn!(p.ctx.data, Primitive(:vect), vars_t, Dict{Symbol, Any}())
  f = add_eqn!(p.ctx.data, Primitive(:vect), vars_f, Dict{Symbol, Any}())
  outvar = add_eqn!(p.ctx.data, Primitive(:cond), [var(p.val), jax1, jax2, t, f], Dict{Symbol, Any}())
  return ContextualValue(p.ctx, Boxed(outvar, outval))
end

function generate_map(arity)
  for combo in gen_combinations(arity)
    args = combo_to_sig(combo)
    arg_tuple = Expr(:vect, args...)
    argnames = [Symbol("arg_$i") for i = 1:arity]
    context = findall(combo)
    all_context = argnames[context]
    first_context = all_context[1]
    expr = quote
      function Base.map(f::Function, $(args...))
        args_ = map(val, $arg_tuple)
        for i = 1:length(args_)
          if has_nested_ctx(args_[i])
            args_[i] = add_primops!(args_[i])
          end
        end
        @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
        vals_ = sval(args_)
        # Args to the first call of function f
        map_args_first = [first(val) for val in vals_]
        vars_ = map(var, args_)
        jax1 = make_jaxpr_ctx(f, map_args_first...)
        outvar = add_eqn!($(first_context).ctx.data, Primitive(:map), [jax1, vars_...], Dict{Symbol, Any}())
        return ContextualValue($(first_context).ctx, Boxed(outvar, map(f, vals_...)))
      end
    end
    eval(expr)
  end
end

generate_map(1)
generate_map(2)
# generate_map(3)

function generate_mapg(arity)
  for combo in gen_combinations(arity)
    args = combo_to_sig(combo)
    arg_tuple = Expr(:vect, args...)
    argnames = [Symbol("arg_$i") for i = 1:arity]
    context = findall(combo)
    all_context = argnames[context]
    first_context = all_context[1]
    expr = quote
      function mapg(f::Function, globals, $(args...))
        if has_nested_ctx(globals)
          globals = add_primops!(globals)
        end
        if globals isa ContextualValue
          args_ = map(val, $arg_tuple)
          for i = 1:length(args_)
            if has_nested_ctx(args_[i])
              args_[i] = add_primops!(args_[i])
            end
          end
          @assert all([$(first_context).ctx == a.ctx for a in [$(all_context...)]])
          vals_ = sval(args_)
          # Args to the first call of function f
          map_args_first = [first(val) for val in vals_]
          vars_ = map(var, args_)
          g = sval(globals.val)
          jax1 = make_jaxpr_ctx(f, g..., map_args_first...)
          outvar = add_eqn!($(first_context).ctx.data, Primitive(:mapg), [jax1, var(globals.val), vars_...], Dict{Symbol, Any}())
          return ContextualValue($(first_context).ctx, Boxed(outvar, mapg(f, sval(globals), vals_...)))
        else
          f′(x...) = f(globals..., x...)
          return map(f′, $arg_tuple...)
        end
      end
    end
    eval(expr)
  end
end

generate_mapg(1)
generate_mapg(2)
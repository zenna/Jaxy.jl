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
  jaxpr = JaxExpr()
  args_ = [Boxed(add_arg!(jaxpr), arg) for arg in args] # FIX TYPE
  ctx_args = ContextualValue[ContextualValue(JaxprContext(jaxpr), arg) for arg in args_]
  ret = f(ctx_args...)
  return_is_valid(ret) || error("Return type is not valid")
  # add return value to output of jaxpr
  push!(jaxpr.outs, var(val(ret)))
  return jaxpr
end

# is_something_that_looks_like_a_literal_but_is_actually_a_contextual_value)x) = 

# Current version: Changes args to cond in jaxpr, other branch is an empty jaxpr
function cond(p::ContextualValue, λt::Function, λf::Function, targs, fargs)
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
  outvar = add_eqn!(p.ctx.data, Primitive(:cond, Dict(:if => jax1, :else => jax2)), [var(p.val), vars_t..., vars_f...], Dict())
  return ContextualValue(p.ctx, Boxed(outvar, outval))
end

function Base.map(f::Function, x::T...) where T <: ContextualValue
  args = map(val, x)
  vals_ = sval(args)
  # Args to the first call of function f
  map_args_partial = [first(val) for val in vals_]
  vars_ = map(var, args)
  jax1 = make_jaxpr_ctx(f, map_args_partial...)
  outvar = add_eqn!(x[1][1].ctx.data, Primitive(:map, Dict(:map => jax1)), [vars_...], Dict())
  return ContextualValue(x[1][1].ctx, Boxed(outvar, map(f, vals_...)))
end
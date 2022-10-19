
## Casstte Based
using Cassette
Cassette.@context JaxprContext

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

struct Boxed{T}
  var::Var
  val::T
end

val(x::Boxed) = x.val
val(x) = x

var(x::Boxed) = x.var
var(x) = Lit(x)

function make_jaxpr_ctx(f, args...; kwargs...)
  jaxpr = JaxExpr()
  args_ = [Boxed(add_arg!(jaxpr), arg) for arg in args] # FIX TYPE
  invars = map(x -> x.var, args_)
  ctx = JaxprContext(metadata = jaxpr)
  ret = Cassette.overdub(ctx, f, args_...; kwargs...)
  # add return value to output of jaxpr
  push!(jaxpr.outs, var(ret))
  ctx.metadata
end

const JLPrimitive = Union{typeof(sin), typeof(cos), typeof(+), typeof(-), typeof(*)}

function handle_boxed(ctx::JaxprContext, f::JLPrimitive, args...)
  jaxpr = ctx.metadata
  vals_ = map(val, args)
  vars_ = map(var, args)
  outval = f(vals_...)

  outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict())
  Boxed(outvar, outval)
end

Cassette.overdub(ctx::JaxprContext, f::JLPrimitive, x::Boxed, y) = handle_boxed(ctx, f, x, y)
Cassette.overdub(ctx::JaxprContext, f::JLPrimitive, x, y::Boxed) = handle_boxed(ctx, f, x, y)
Cassette.overdub(ctx::JaxprContext, f::JLPrimitive, x::Boxed, y::Boxed) = handle_boxed(ctx, f, x, y)
Cassette.overdub(ctx::JaxprContext, f::JLPrimitive, x::Boxed) = handle_boxed(ctx, f, x)

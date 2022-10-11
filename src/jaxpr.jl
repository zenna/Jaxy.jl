struct Var
  name::Symbol
  type::Type
end

struct Lit{T}
  val::T
end

const Atom = Union{Var, Lit}

struct JaxprEqn
  primitive
  inputs::Vector{Atom}
  params::Dict{Symbol, Any}
  out_binders::Vector{Var}
end

struct JaxExpr
  in_binders::Vector{Var}
  eqns::Vector{JaxprEqn}
  outs::Vector{Atom}
end

JaxExpr() = JaxExpr([], [], [])

function test_jaxpr()
  x = Var(:x, Float64)
  y = Var(:y, Float64)
  z = Var(:z, Float64)
  eqn1 = JaxprEqn(add_p, [x, y], Dict(), [z])
  eqn2 = JaxprEqn(mul_p, [z, z], Dict(), [z])
  eqns = [eqn1, eqn2]
  jaxpr = JaxExpr([x, y], eqns, [z])
end

## Pretty Printing
"""
Pretty Prints a Jaxpr
Example pretty-prented:
```
lambda a:i32[] b:i32[] c:i32[].  let
  d::Float64 = mul b c
  e::Float64 = add a d
    in (e,)'
```
"""
function pp_jaxpr(io::IO, jaxpr::JaxExpr)
  println(io, "lambda ", join([string(binder.name, ":", binder.type) for binder in jaxpr.in_binders], ", "), ".  let")
  for eqn in jaxpr.eqns
    println(io, "  ", pp_eqn(eqn))
  end
  println(io, "    in (", join([pp_atom(atom) for atom in jaxpr.outs], ", "), ")")
end


function pp_jaxpr_eqn(io::IO, eqn::JaxprEqn)
  println(io, "  ", pp_eqn(eqn))
end

function pp_eqn(eqn::JaxprEqn)
  return string(eqn.out_binders[1].name, "::", eqn.out_binders[1].type, " = ", eqn.primitive.name, " ", join([pp_atom(atom) for atom in eqn.inputs], ", "))
end

function pp_atom(atom::Var)
  return string(atom.name, ":", atom.type)
end

function pp_atom(atom::Lit)
  return string(atom.val)
end

Base.show(io::IO, jaxpr::JaxExpr) = pp_jaxpr(io, jaxpr)

## Casstte Based
using Cassette
Cassette.@context JaxprContext

function Cassette.overdub(ctx::JaxprContext, ::typeof(sin), x)
  return x
end

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
  ctx.metadata
end

const JLPrimitive = Union{typeof(sin), typeof(cos), typeof(+), typeof(-), typeof(*)}

function Cassette.overdub(ctx::JaxprContext, f::JLPrimitive, args...)
  jaxpr = ctx.metadata
  vals_ = map(val, args)
  vars_ = map(var, args)
  outval = f(vals_...)

  outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict())
  Boxed(outvar, outval)
end

function test_jaxpr()
  function f(x, y, z)
    a = sin(x)
    b = cos(y)
    c = a + b
    d = c * z
    return d
  end
  make_jaxpr_ctx(f, 1, 2, 3)
end


# ## Tracing
# struct JaxprTracer <: Tracer
#   value
#   type::Type
# end

# struct JaxprTrace <: Trace
#   main::MainTrace
# end

# struct JaxprBuilder
#   eqns::Vector{JaxprEqn}                # The equations in the Jaxpr
#   tracer_to_var::Dict{Int, Var}         # tracer id to var   
#   const_tracers::Dict{Int, JaxprTracer} # tracer id to const tracer
#   constvals::Dict{Var, Any}
#   tracers::Vector{JaxprTracer}
# end

# JaxprBuilder() = JaxprBuilder(JaxprEqn[], Dict{Int, Var}(), Dict{Int, JaxprTracer}(), Dict{Var, Any}(), JaxprTracer[])

# function new_tracer!(builder::JaxprBuilder, trace::JaxprTrace, value, type)
#   tracer = JaxprTracer(value, type)
#   push!(builder.tracers, tracer)
#   return tracer
# end

# function add_eqn!(builder::JaxprBuilder, eqn::JaxprEqn)
#   push!(builder.eqns, eqn)
#   return eqn.out_binders
# end

# function add_var!(builder::JaxprBuilder, name::Symbol, type::Type)
#   var = Var(name, type)
#   return var
# end

# function make_jaxpr_v1(f, absvals_in)
#   builder = JaxprBuilder()

# end

# end
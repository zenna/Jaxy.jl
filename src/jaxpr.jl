import Base: +
using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)
export to_expr,
       make_jaxpr_ctx,
       evaluate_jaxpr, ContextualValue

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

struct JaxprContext{T}
  data::T
end

struct ContextualValue{T, U}
  ctx::T
  val::U
end

val(x::ContextualValue) = x.val

# function Base.sin(x::Jaxy.ContextualValue)
#   outvar = handle_boxed(sin, x.ctx, x.val)
#   return ContextualValue(x.ctx, outvar)
# end

# function Base.:(+)(x::Jaxy.ContextualValue, y::Jaxy.ContextualValue)
#   outvar = handle_boxed((+), x.ctx, x.val, y.val)
#   return ContextualValue(x.ctx, outvar)
# end

const JLPrimitive = Union{typeof(sin), typeof(cos), typeof(+), typeof(-), typeof(*), typeof(Base.isless), typeof(sqrt), typeof(|), typeof(&)}

# One or more (more in the case where if there is any ContextualValue, it is the first arg)
const ARITY_1 = [:(Base.sin), :(Base.cos), :(Base.sqrt)]

# Two or more (more in the case where if there are any ContextualValue, it is either the first or second arg)
const ARITY_2 = [:(Base.:(+)), :(Base.:(-)), :(Base.:(*)), :(Base.isless), :(Base.:(|)), :(Base.:(&))]

const primitives = vcat(ARITY_1, ARITY_2)

const ARITY_TO_FUNCS = Dict(1 => ARITY_1,
                            2 => ARITY_2)

function combo_to_sig(combo)
  function f((i, isctxval))
    argname = Symbol("arg_$i")
    if isctxval
      Expr(:(::),  argname, :ContextualValue)
    else
      argname
    end
  end
  map(f, enumerate(combo))
end

function generate_ctx_methods()
  for arity in keys(ARITY_TO_FUNCS)
    funcs = ARITY_TO_FUNCS[arity]
    for func in funcs
      for combo in gen_combinations(arity)
        args = combo_to_sig(combo)
        arg_tuple = Expr(:tuple, args...)
        argnames = [Symbol("arg_$i") for i = 1:arity]
        context = findfirst(combo)
        first_context = argnames[context]
        expr = quote
          function $(func)($(args...))
            args_ = map(val, $arg_tuple)
            outvar = handle_boxed($(func), $(first_context).ctx, args_...)
            return ContextualValue($(first_context).ctx, outvar)
          end
        end
        eval(expr)
      end
    end
  end
end

"Maps e.g. `n=3` to [[0,0,] ] "
function gen_combinations(n)
  b = (false, true)
  Base.Iterators.filter(any, Iterators.product((b for i = 1:n)...))
end



using Base.Iterators
generate_ctx_methods()
# for f in ARITY_1
#   expr = quote
#     function $(f)(arg1::ContextualValue, args...)
#       temp = map(val, args)
#       args_ = val(arg1)
#       if isempty(temp)
#         args_ = [args_]
#       else
#         args_ = vcat(args_, temp)
#       end
#       outvar = handle_boxed($(f), arg1.ctx, args_...)
#       return ContextualValue(arg1.ctx, outvar)
#     end
#   end
#   eval(expr)
# end

# T_ = fill(:Any, 2)
# for f in ARITY_2
#   for i in 1:2
#     T_[i] = :(ContextualValue)
#     expr = quote
#         T = map(eval, T_)
#         function $(f)(arg1::T_1, arg2::T_2, args...) where T_1 <: T[1] where T_2 <: T[2]
#           temp = map(val, args)
#           args_ = vcat(val(arg1), val(arg2))
#           if isempty(temp)
#             args_ = args_
#           else
#             args_ = vcat(args_, temp)
#           end
#           outvar = handle_boxed($(f), args_[i].ctx, args_...)
#           return ContextualValue(args_[i].ctx, outvar)
#         end
#     end
#     eval(expr)
#     T_[i] = :Any
#   end
# end

function make_jaxpr_ctx(f, args...; kwargs...)
  jaxpr = JaxExpr()
  args_ = [Boxed(add_arg!(jaxpr), arg) for arg in args] # FIX TYPE
  invars = map(x -> x.var, args_)
  ctx_args = [ContextualValue(JaxprContext(jaxpr), arg) for arg in args_]
  ret = f(ctx_args...)
  # add return value to output of jaxpr
  push!(jaxpr.outs, var(ret.val))
  return jaxpr
end

function handle_boxed(f::JLPrimitive, ctx::JaxprContext, args...)
  jaxpr = ctx.data
  vals_ = map(val, args)
  vars_ = map(var, args)
  outval = f(vals_...)

  outvar = add_eqn!(jaxpr, Primitive(Symbol(f)), [vars_...], Dict())
  Boxed(outvar, outval)
end

# function handle_boxed(f, args)
#   @info "Not a primitive:" f
#   jaxpr = args.ctx.data
#   vals_ = map(val, args.val)
#   # outval = handle_boxed(f, args)
#   outval = f(vals_...)
#   outvar = Var(Symbol("out", length(jaxpr.eqns) + 1), Float64)
#   return [Boxed(outvar, outval)]
# end

"Construct a Julia Expr (an anonymous function) from a jaxpr"
function to_expr(jaxpr::JaxExpr)
  # Handle the head
  head = Expr(:function, Expr(:tuple, [binder.name for binder in jaxpr.in_binders]...))
  
  # Now let's handle each equation
  eqns = Expr(:block)
  for eqn in jaxpr.eqns
    eqn_expr = Expr(:call, eqn.primitive.name, [atom.name for atom in eqn.inputs]...)
    eqn_expr = Expr(:(=), eqn.out_binders[1].name, eqn_expr)
    push!(eqns.args, eqn_expr)
  end

  # Now let's handle the return
  ret_expr = Expr(:tuple, [atom.name for atom in jaxpr.outs]...)
  push!(eqns.args, ret_expr)
  push!(head.args, eqns)
  head
end

"Evaluate a jaxpr"
function evaluate_jaxpr(jaxpr, args...)
  expr = to_expr(jaxpr)
  f = @RuntimeGeneratedFunction(expr)
  f(args...)
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
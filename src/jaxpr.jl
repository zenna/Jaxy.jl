using MLStyle
export make_jaxpr_ctx,
       evaluate_jaxpr

@data UnaryPrimitive begin
  Neg
end

@data BinaryPrimitive begin
  Add
  Sub
  Mul
  Div
end

@data ValueExpr begin
  Var(Symbol)
  Lit(Int)
  BinaryCallExpr(BinaryPrimitive, ValueExpr, ValueExpr)
  UnaryCallExpr(UnaryPrimitive, ValueExpr)  
end

struct LetExpr
  var::Symbol
  value::ValueExpr
  body::ValueExpr
end

function interpret(expr::ValueExpr, Γ)
  @match expr begin
    Var(name) => Γ[name]  
    Lit(v) => v
    BinaryCallExpr(op, x, y) => interpret_binary(op, interpret(x, Γ), interpret(y, Γ))
    UnaryCallExpr(op, x) => interpret_unary(op, interpret(x, Γ))
  end
end

function interpret(expr::LetExpr, Γ)
  interpret(expr.body, Dict(Γ, expr.var => interpret(expr.value, Γ)))
end

function interpret_binary(op::BinaryPrimitive, x, y)
  @match op begin
    Add => x + y
    Sub => x - y
    Mul => x * y
    Div => x / y
  end
end

function interpret_unary(op::UnaryPrimitive, x)
  @match op begin
    Neg => -x
  end
end

function interpret(expr::LetExpr, Γ)
  Γ′ = Dict(Γ)
  Γ′[expr.var] = interpret(expr.value, Γ)
  interpret(expr.body, Γ′)
end

## Algebraic EFfects
# Let's implement algebraic effects in a way similar to the Koka language
# with effects and handlers

# return x \to e
@data HandleClause begin
  Return(Var, ValueExpr)  # return x -> e
  body(ValueExpr)
end

# # Now let's add simple simple algebraic effect handling
# # We'll use a simple form whereby a handler will indicate changing one
# # primitive (the original) to another (the new one)
# "handle prim1 prim2"
# struct HandlerExpr
#   orig::Primitive
#   new::Primitive
# end

# # Now we need a handle expression, e.g. handle 1 + 1 with (handle + -)
# struct HandleExpr
#   handler::HandlerExpr
#   expr::ValueExpr # FIXME not just a valueexpr
# end

# # Now we need to interpret this
# function interpret(expr::HandleExpr, Γ)
#   @match expr.handler begin
#     HandlerExpr(orig, new) => interpret(expr.expr, Dict(Γ, orig => new))
#   end
# end

## Testing

function test_create_expr1()
  x = Var(:x)
  y = Var(:y)
  z = Var(:z)
  expr = LetExpr(:z, BinaryCallExpr(Add, x, y), UnaryCallExpr(Neg, z))
  expr
end

export Var, Lit, BinaryCallExpr, UnaryCallExpr, LetExpr, test_create_expr1, Add, Sub, Mul, Div, Neg, interpret

# Now someting different, a nested let expression
function test_create_expr2()
  x = Var(:x)
  y = Var(:y)
  z = Var(:z)
  expr = LetExpr(:z, BinaryCallExpr(Add, x, y), LetExpr(:z, BinaryCallExpr(Add, x, y), UnaryCallExpr(Neg, z)))
  expr
end

# Now something crazy
function test_create_Expr3()
  a = Var(:a)
  b = Var(:b)
  c = Var(:c)
  d = Var(:d)
  e = Var(:e)
  expr = LetExpr(:e, BinaryCallExpr(Add, a, b), LetExpr(:d, BinaryCallExpr(Add, c, e), LetExpr(:z, BinaryCallExpr(Add, a, b), UnaryCallExpr(Neg, z))))
  expr
end

function test_interpret1()
  expr = test_create_expr1()
  interpret(expr, Dict(:x => 1, :y => 2))
end

# struct Lit{T}
#   val::T
# end

# # const Atom = Union{Var, Lit}

# function interpret(aex::LetExpr, Γ)
#   x, v, f = aex.args
#   v = interpret(v, Γ)
#   f = interpret(f, update(Γ, x, v))
#   f
# end

# struct JaxprEqn
#   primitive
#   inputs::Vector{Atom}
#   params::Dict{Symbol, Any}
#   out_binders::Vector{Var}
# end

# struct JaxExpr
#   in_binders::Vector{Var}
#   eqns::Vector{JaxprEqn}
#   outs::Vector{Atom}
# end

# JaxExpr() = JaxExpr([], [], [])

# function test_jaxpr()
#   x = Var(:x, Float64)
#   y = Var(:y, Float64)
#   z = Var(:z, Float64)
#   eqn1 = JaxprEqn(add_p, [x, y], Dict(), [z])
#   eqn2 = JaxprEqn(mul_p, [z, z], Dict(), [z])
#   eqns = [eqn1, eqn2]
#   jaxpr = JaxExpr([x, y], eqns, [z])
# end

# ## Pretty Printing
# """
# Pretty Prints a Jaxpr
# Example pretty-prented:
# ```
# lambda a:i32[] b:i32[] c:i32[].  let
#   d::Float64 = mul b c
#   e::Float64 = add a d
#     in (e,)'
# ```
# """
# function pp_jaxpr(io::IO, jaxpr::JaxExpr)
#   println(io, "lambda ", join([string(binder.name, ":", binder.type) for binder in jaxpr.in_binders], ", "), ".  let")
#   for eqn in jaxpr.eqns
#     println(io, "  ", pp_eqn(eqn))
#   end
#   println(io, "    in (", join([pp_atom(atom) for atom in jaxpr.outs], ", "), ")")
# end

# function pp_jaxpr_eqn(io::IO, eqn::JaxprEqn)
#   println(io, "  ", pp_eqn(eqn))
# end

# function pp_eqn(eqn::JaxprEqn)
#   return string(eqn.out_binders[1].name, "::", eqn.out_binders[1].type, " = ", eqn.primitive.name, " ", join([pp_atom(atom) for atom in eqn.inputs], ", "))
# end

# function pp_atom(atom::Var)
#   return string(atom.name, ":", atom.type)
# end

# function pp_atom(atom::Lit)
#   return string(atom.val)
# end

# Base.show(io::IO, jaxpr::JaxExpr) = pp_jaxpr(io, jaxpr)


# # ## Tracing
# # struct JaxprTracer <: Tracer
# #   value
# #   type::Type
# # end

# # struct JaxprTrace <: Trace
# #   main::MainTrace
# # end

# # struct JaxprBuilder
# #   eqns::Vector{JaxprEqn}                # The equations in the Jaxpr
# #   tracer_to_var::Dict{Int, Var}         # tracer id to var   
# #   const_tracers::Dict{Int, JaxprTracer} # tracer id to const tracer
# #   constvals::Dict{Var, Any}
# #   tracers::Vector{JaxprTracer}
# # end

# # JaxprBuilder() = JaxprBuilder(JaxprEqn[], Dict{Int, Var}(), Dict{Int, JaxprTracer}(), Dict{Var, Any}(), JaxprTracer[])

# # function new_tracer!(builder::JaxprBuilder, trace::JaxprTrace, value, type)
# #   tracer = JaxprTracer(value, type)
# #   push!(builder.tracers, tracer)
# #   return tracer
# # end

# # function add_eqn!(builder::JaxprBuilder, eqn::JaxprEqn)
# #   push!(builder.eqns, eqn)
# #   return eqn.out_binders
# # end

# # function add_var!(builder::JaxprBuilder, name::Symbol, type::Type)
# #   var = Var(name, type)
# #   return var
# # end

# # function make_jaxpr_v1(f, absvals_in)
# #   builder = JaxprBuilder()

# end

# end
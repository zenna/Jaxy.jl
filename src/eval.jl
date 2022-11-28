using RuntimeGeneratedFunctions
import Base.vect, Core.tuple
RuntimeGeneratedFunctions.init(@__MODULE__)

# e = Expr(:function, Expr(:tuple), Expr(:(=), :y, 1), Expr(:tuple, :y))
# e2 = Expr(:function, Expr(:tuple, :x), Expr(:call, e, :x), Expr(:tuple, :y))

"Construct a Julia Expr (an anonymous function) from a jaxpr"
function to_expr(jaxpr::JaxExpr)
  # Handle the head
  in_vars = Expr(:tuple, [binder.name for binder in jaxpr.in_binders]...)
  # Now let's handle each equation
  eqns = Expr(:block)
  for eqn in jaxpr.eqns
    invars = eqn.inputs
    inputs = []
    for atom in invars
      if atom isa Jaxy.Lit
        push!(inputs, atom.val)
      elseif atom isa Jaxy.Var
        push!(inputs, atom.name)
      else
        push!(inputs, to_expr(atom))
      end
    end
    eqn_expr = Expr(:call, eqn.primitive.name, inputs...)
    eqn_expr = Expr(:(=), eqn.out_binders[1].name, eqn_expr)
    push!(eqns.args, eqn_expr)
  end
  # Now let's handle the return
  ret_expr = Expr(:tuple, [binder.name for binder in jaxpr.outs]...)
  # push!(eqns.args, ret_expr)
  # push!(head.args, eqns)
  Expr(:function, in_vars, eqns, ret_expr)
end

"Evaluate a jaxpr"
function evaluate_jaxpr(jaxpr, args...)
  expr = to_expr(jaxpr)
  f = @RuntimeGeneratedFunction(expr)
  f(args...)
end
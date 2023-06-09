using RuntimeGeneratedFunctions
import Base.vect, Core.tuple
RuntimeGeneratedFunctions.init(@__MODULE__)

"Construct a Julia Expr (an anonymous function) from a jaxpr"
function to_expr(jaxpr::JaxExpr)
  # Handle the head
  head = Expr(:function, Expr(:tuple, [binder.name for binder in jaxpr.in_binders]...))
  # Handle each equation
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
    eqn_expr = Expr(:local, eqn_expr)
    push!(eqns.args, eqn_expr)
  end
  # Handle the return
  ret_symbols = [name(binder) for binder in jaxpr.outs]
  push!(eqns.args, ret_symbols...)
  push!(head.args, eqns)
  head
end

"Evaluate a jaxpr"
function evaluate_jaxpr(jaxpr, args...)
  expr = to_expr(jaxpr)
  f = @RuntimeGeneratedFunction(expr)
  f(args...)
end
using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

"Construct a Julia Expr (an anonymous function) from a jaxpr"
function to_expr(jaxpr::JaxExpr)
  # Handle the head
  in_vars = Expr(:tuple, [binder.name for binder in jaxpr.in_binders]...)
  # Now let's handle each equation
  eqns = Expr(:block)
  for eqn in jaxpr.eqns
    invars = eqn.inputs
    if eqn.primitive.name == :map
      exprs = map(to_expr, collect(values(eqn.primitive.expr)))
      inputs = [exprs...]
    elseif eqn.primitive.name == :cond
      arg1 = eqn.inputs[1]
      invars = eqn.inputs[2:end]
      exprs = map(to_expr, collect(values(eqn.primitive.expr)))
      inputs = [arg1.name, exprs...]
    else
      inputs = []
    end
    for atom in invars
      if atom isa Jaxy.Lit
        inputs = vcat(inputs, atom.val)
      else
        inputs = vcat(inputs, atom.name)
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
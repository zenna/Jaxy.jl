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

function pp_atom(atom::JaxExpr)
  s = string("{lambda ", join([string(binder.name, ":", binder.type) for binder in atom.in_binders], ", "), ".  let \n")
  for eqn in atom.eqns
    s = s*string("  ", pp_eqn(eqn), "\n")
  end
  s = s*string("    in (", join([pp_atom(a) for a in atom.outs], ", "), ")}") 
end

Base.show(io::IO, jaxpr::JaxExpr) = pp_jaxpr(io, jaxpr)

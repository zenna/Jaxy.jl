module Interpret

import ..JaxExpr
import MLStyle

# Interpret jaxpr in environment Γ
function interpret(aex, Γ)
    arr = [aex.head, aex.args...]
    next(x) = interpret(x, Γ)
    isaexpr(x) = x isa AExpr
    MLStyle.@match arr begin
      [:program, args...]                            => (AExpr(:assign, x, interpret(v, Γ)), Γ)
      [:assign, x, v::AExpr]                         => (AExpr(:assign, x, interpret(v, Γ)), Γ)
      [:assign, x, v::Symbol]                        => (AExpr(:assign, x, interpret(v, Γ)), Γ)
      [:assign, x, v]                                => (AExpr(:assign, x, v), update(Γ, x, v))
      s::Symbol                                      => (Γ[x], Γ)
      [:if, true, t, e]                              => (t, Γ)
      [:if, false, t, e]                             => (e, Γ)
      [:if, i::AExpr, t, e]                          => (AExpr(:if, interpret(i, Γ), t, e), Γ)
      [:call, f, args...] && if !isprim(f) end       => (AExpr(:call, next(f), args...), Γ)
      [:call, f, args...] && if any(isaexpr, args) end  => (AExpr(:call, map((i, arg) -> i == shit ? next(arg) : arg)), Γ)
      [:call, f, args...] && isprim(f) end           => (primapl(f, args...), Γ)
      _                                              => error("Could not interpret $arr")
    end
  end
  
end
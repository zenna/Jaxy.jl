## TODO

- Check if contextual value is outside of struct or within it
  - Depends on whwat we consider to be a variable
+  Add a flag to force application to be primitive (primop)
- Something like a register in Symbolics.jl

## Issues:
- There are still circular references (probably in map, although it is within cond, and I've check cond, primop, add_primop and has_nested_ctx)
- how to call higher order functions within Expr
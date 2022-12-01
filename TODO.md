## TODO

- Check if contextual value is outside of struct or within it
  - Depends on what we consider to be a variable
+  Add a flag to force application to be primitive (primop)
- Something like a register in Symbolics.jl
- Multiple return statements

## Issues:
- RayTrace.ListScene not defined despite having imported it
  - Fixed it by importing RayTrace before running test() and calling ListScene instead of RayTrace.ListScene
- !(::Float64) not defined error: 
  - Tried naming outs uniquely (instead of strarting from 0 every time a jaxpr is created within map/cond)
  - There could have been an error in that, but the approach seems unnecessary since having variables named the same in a function call within another doesn't seem to affect the result
      (In a toy example by manually constructing an Expr with :function within another)
      e = Expr(:function, Expr(:tuple, :x), Expr(:call, :identity, :x))
      e3 = Expr(:function, Expr(:tuple, :x), Expr(:call, :map, e, :x)) # returns [1, 2, 3] when the input is that
- Figure out why the function calls look straange: Is it because it isn't in a block?
- Multiple return statements
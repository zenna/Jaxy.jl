## TODO

- Check if contextual value struct is outside of struct or within it
  - Depends on what we consider to be a variable
-  Add a flag to force application to be primitive (primop)
- Something like a register in Symbolics.jl
- Multiple return statements

## Issues:
- RayTrace.ListScene not defined despite having imported it
  - (Temporary fix) Fixed it by importing RayTrace before running test() and calling ListScene instead of RayTrace.ListScene
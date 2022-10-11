
struct Primitive
  name::Symbol
end

## Primitives
add_p = Primitive(:add)
mul_p = Primitive(:mul)
neg_p = Primitive(:neg)
sin_p = Primitive(:sin)
cos_p = Primitive(:cos)
reduce_sum_p = Primitive(:reduce_sum)
greater_p = Primitive(:greater)
less_p = Primitive(:less)
transpose_p = Primitive(:transpose)
broadcast_p = Primitive(:broadcast)

# add(x, y) = bind1(add_p, x, y)
# mul(x, y) = bind1(mul_p, x, y)
# neg(x) = bind1(neg_p, x)
# sin(x) = bind1(sin_p, x)
# cos(x) = bind1(cos_p, x)
# reduce_sum(x) = bind1(reduce_sum_p, x)
# greater(x, y) = bind1(greater_p, x, y)
# less(x, y) = bind1(less_p, x, y)
# transpose(x) = bind1(transpose_p, x)
# broadcast(x) = bind1(broadcast_p, x)

function bind1(p::Primitive, args...; kwargs...)
  bind(prim, args...; kwargs...)
end

function bind(prim, args...; params)
  top_trace = find_top_trace(args)  # Find which interpreter should handle this primitive application
  tracers = [full_raise(top_trace, arg) for arg in args]
  outs = top_trace.process_primitive(prim, tracers, params)
  return [full_lower(out) for out in outs]
end

"Returns the highest-level interpreter associated with the Tracers on its inputs,
 and otherwise returns the interpreter at the bottom of the stack"
function find_top_trace(args)
  fx, i = findmax( )
end

"A MainTrace is an interpreter" # Why is it called MainTrace?
struct MainTrace{D, T}
  level::Int  # 
  trace_type::T
  global_data::D
end

# We represent the active (what does this mean?) interpreters as a stack of interpreters
trace_stack = MainTrace[]
# dynamic_trace = 

# function new_main(trace_type::Trace; global_data = nothign)
#   level = length(trace_stack)
# end

# Interpreters

"A Trace is a non-standard interpreter"
struct Trace
  main::MainTrace
end

function pure end
function val end

"A Tracer corresponds to a value that is being traced by an interpreter"
abstract type Tracer end

array_priority(::Tracer) = 1000 # Where does this magic number come from?

# What does this mean?
function aval end
function full_lower end
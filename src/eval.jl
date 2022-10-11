struct EvalTrace
  level::Int
end

function process_primitive(trace::EvalTrace, primitive::Primitive, tracers, params)
  return impl_rules[primitive](tracers; params)
end

pure(trace::EvalTrace, x) = x
lift(trace::EvalTrace, x) = x

const impl_rules = Dict{Primitive, Function}()

g(f) = (args...) -> [f(args...)]
impl_rules[add_p] = g(+)
impl_rules[mul_p] = g(*)
impl_rules[neg_p] = g(-)
impl_rules[sin_p] = g(sin)
impl_rules[cos_p] = g(cos)
impl_rules[reduce_sum_p] = g(sum)
impl_rules[greater_p] = g(>)
impl_rules[less_p] = g(<)
impl_rules[transpose_p] = g(transpose)

# trace_stack.append(MainTrace(0, EvalTrace, None))  # special bottom of the stack

function test()
  function f(x)
    y = sin(x) * 2.
    z = - y + x
    return z
  end

  print(f(3.0))

  # function vp_v1(f, primals, tangents):
  # with new_main(JVPTrace) as main:
  #   trace = EvalTrace(main)
  #   tracers_in = [3.0]
  #   out = f(*tracers_in)
  #   tracer_out = full_raise(trace, out)
  #   primal_out, tangent_out = tracer_out.primal, tracer_out.tangent
  # return primal_out, tangent_out
end
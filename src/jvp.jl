# Tracer for Jacobian-vector products

struct JVPTracer <: Tracer
  primal::Tracer
  tangent::Tracer
end

struct JVPTrace <: Trace
  main::MainTrace
end

# What do Pure and Val mean?
pure(::JVPTrace, x) = JVPTracer(pure(main, x), pure(main, zero(x)))
lift(::JVPTrace, x) = JVPTracer(lift(main, x), lift(main, zero(x)))

# What does process primitive do
function process_primitive(trace::JVPTrace, prim::Primitive, tracers, params)
  primal_tracers, tangent_tracers = unzip(tracers)
  primal_outs = process_primitive(main, prim, primal_tracers, params)
  tangent_outs = process_primitive(main, prim, tangent_tracers, params)
  return [JVPTracer(primal_out, tangent_out) for (primal_out, tangent_out) in zip(primal_outs, tangent_outs)]
end

function test_jvp()
  x = 3.0
  y, sin_deriv_at_3 = jvp_v1(sin, (x,), (1.0,))
  @test sin_deriv_at_3 == cos(3.0)

  function f(x)
    y = sin(x) * 2.
    z = - y + x
    return z
  end
  x, xdot = 3., 1.
  y, ydot = jvp_v1(f, (x,), (xdot,))
end
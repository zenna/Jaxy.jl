using Jaxy
using RayTrace
import RayTrace: Sphere, Vec3, FancySphere, Intersection
function handle_boxed(::typeof(Intersection), ctx, args...)
  @show "Enter"
  Intersection([ContextualValue(ctx, arg) for arg in args]...)
end

"Some example spheres which should create actual image"
function example_spheres(x, y, z)
  scene = [FancySphere(Float64[0.0, -10004, -20], 10000.0, Float64[0.20, 0.20, 0.20], 0.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere([x,      y, z],     4.0, Float64[1.00, 0.32, 0.36], 1.0, 0.5, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[5.0,     -1, -15],     2.0, Float64[0.90, 0.76, 0.46], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[5.0,      0, -25],     3.0, Float64[0.65, 0.77, 0.97], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[-5.5,      0, -15],    3.0, Float64[0.90, 0.90, 0.90], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           # light (emission > 0)
           FancySphere(Float64[0.0, 20.0, -30.],  3.0, Float64[0.00, 0.00, 0.00], 0.0, 0.0, Float64[3.0, 3.0, 3.0])]
  RayTrace.ListScene(scene)
end

function render_scene(x, y, z)
  scene = example_spheres(x, y, z)
  RayTrace.render(scene; width = 2, height = 2)
end

test() = Jaxy.make_jaxpr_ctx(render_scene, 1.0, 1.0, -15.0)

# test()

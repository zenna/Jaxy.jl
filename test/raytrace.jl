using Jaxy
using RayTrace
using Colors, ImageView
import Base.vect, Base.push!
import RayTrace: Sphere, Vec3, FancySphere, Intersection, ListScene, trcdepth, rdirs_rorigs

"Some example spheres which should create actual image"
function example_spheres(x, y, z)
  scene = [FancySphere(Float64[0.0, -10004, -20], 10000.0, Float64[0.20, 0.20, 0.20], 0.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere([x,      y, z],     4.0, Float64[1.00, 0.32, 0.36], 1.0, 0.5, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[5.0,     -1, -15],     2.0, Float64[0.90, 0.76, 0.46], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[5.0,      0, -25],     3.0, Float64[0.65, 0.77, 0.97], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           FancySphere(Float64[-5.5,      0, -15],    3.0, Float64[0.90, 0.90, 0.90], 1.0, 0.0, Float64[0.0, 0.0, 0.0]),
           # light (emission > 0)
           FancySphere(Float64[0.0, 20.0, -30.],  3.0, Float64[0.00, 0.00, 0.00], 0.0, 0.0, Float64[3.0, 3.0, 3.0])]
  ListScene(scene)
end

rdirs, rorigs = rdirs_rorigs(100, 100)
rdirs = convert.(Vector, collect(eachrow(rdirs)))

function render_scene(x, y, z, rdirs)
  scene = example_spheres(x, y, z)
  RayTrace.render_map(scene; rdirs = rdirs, trc = trcdepth)
end

test() = Jaxy.make_jaxpr_ctx(render_scene, 0., 0., -20., rdirs)

jaxpr_render_scene = test();
j = to_expr(jaxpr_render_scene);
new_render = eval(j);
res = new_render(0., 0., -20., rdirs);

function rgbimg(img)
  w = size(img)[1]
  h = size(img)[2]
  img = clamp.(img, 0.0, 1.0)
  clrimg = Array{Colors.RGB}(undef, w, h)
  for i = 1:w
    for j = 1:h
      clrimg[i,j] = Colors.RGB(img[i,j,:]...)
    end
  end
  clrimg
  # clamp.(clrimg. 0.0, 1.0)
end

function show_img(img_)
  image = zeros(100, 100, 3)
  k = 1
  for i in 1:100
    for j in 1:100
      image[j, i, :] = img_[k]
      k += 1
    end
  end
  rgbimg(image)
end

show_img(render_scene(0., 0., -20., rdirs))
show_img(res)
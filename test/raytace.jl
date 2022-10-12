# Python code

# ##
# #@title jax utils
# import jax
# import jax.numpy as jp

# def norm(v, axis=-1, keepdims=False, eps=0.0):
#   return jp.sqrt((v*v).sum(axis, keepdims=keepdims).clip(eps))

# def normalize(v, axis=-1, eps=1e-20):
#   return v/norm(v, axis, keepdims=True, eps=eps)
# ##

# import jax
# import jax.numpy as jp

# class Balls(NamedTuple):
#   pos: jp.ndarray
#   color: jp.ndarray

# def create_balls(key, n=2, R=3.0):
#   pos, color = jax.random.uniform(key, [2, n, 3])
#   pos = (pos-0.5)*R
#   return Balls(pos, color)

# key = jax.random.PRNGKey(123)
# balls = create_balls(key)

# #@title (show_slice)
# def show_slice(sdf, z=0.0, w=400, r=3.5):
#   y, x = jp.mgrid[-r:r:w*1j, -r:r:w*1j].reshape(2, -1)
#   p = jp.c_[x, y, x*0.0+z]
#   d = jax.vmap(sdf)(p).reshape(w, w)
#   pl.figure(figsize=(5, 5))
#   kw = dict(extent=(-r, r, -r, r), vmin=-r, vmax=r)
#   pl.contourf(d, 16, cmap='bwr', **kw );
#   pl.contour(d, levels=[0.0], colors='black', **kw);
#   pl.axis('equal')
#   pl.xlabel('x')
#   pl.ylabel('y')

# def balls_sdf(balls, p, ball_r=0.5):
#   dists = norm(p-balls.pos)-ball_r
#   return dists.min()

# p = jax.random.normal(key, [1000, 3])
# print( jax.vmap(partial(balls_sdf, balls))(p).shape )

# # show_slice(partial(balls_sdf, balls), z=0.0);

# def scene_sdf(balls, p, ball_r=0.5, c=8.0):
#   dists = norm(p-balls.pos)-ball_r
#   balls_dist = -jax.nn.logsumexp(-dists*c)/c  # softmin
#   floor_dist = p[1]+3.0  # floor is at y==-3.0
#   return jp.minimum(balls_dist, floor_dist)  
  
# # show_slice(partial(scene_sdf, balls), z=0.0)

# def raycast(sdf, p0, dir, step_n=50):
#   def f(_, p):
#     return p+sdf(p)*dir
#   return jax.lax.fori_loop(0, step_n, f, p0)

# world_up = jp.array([0., 1., 0.])

# def camera_rays(forward, view_size, fx=0.6):
#   right = jp.cross(forward, world_up)
#   down = jp.cross(right, forward)
#   R = normalize(jp.vstack([right, down, forward]))
#   w, h = view_size
#   fy = fx/w*h
#   y, x = jp.mgrid[fy:-fy:h*1j, -fx:fx:w*1j].reshape(2, -1)
#   return normalize(jp.c_[x, y, jp.ones_like(x)]) @ R

# w, h = 640, 400
# pos0 = jp.float32([3.0, 5.0, 4.0])
# ray_dir = camera_rays(-pos0, view_size=(w, h))
# sdf = partial(scene_sdf, balls)
# hit_pos = jax.vmap(partial(raycast, sdf, pos0))(ray_dir)
# imshow(hit_pos.reshape(h, w, 3)%1.0)

# raw_normal = jax.vmap(jax.grad(sdf))(hit_pos)
# imshow(raw_normal.reshape(h, w, 3))

# def cast_shadow(sdf, light_dir, p0, step_n=50, hardness=8.0):
#   def f(_, carry):
#     t, shadow = carry
#     h = sdf(p0+light_dir*t)
#     return t+h, jp.clip(hardness*h/t, 0.0, shadow)
#   return jax.lax.fori_loop(0, step_n, f, (1e-2, 1.0))[1]

# light_dir = normalize(jp.array([1.1, 1.0, 0.2]))
# shadow = jax.vmap(partial(cast_shadow, sdf, light_dir))(hit_pos)
# imshow(shadow.reshape(h, w))

# def shade_f(surf_color, shadow, raw_normal, ray_dir, light_dir):
#   ambient = norm(raw_normal)
#   normal = raw_normal/ambient
#   diffuse = normal.dot(light_dir).clip(0.0)*shadow
#   half = normalize(light_dir-ray_dir)
#   spec = 0.3 * shadow * half.dot(normal).clip(0.0)**200.0
#   light = 0.7*diffuse+0.2*ambient
#   return surf_color*light + spec

# f = partial(shade_f, jp.ones(3), light_dir=light_dir)
# frame = jax.vmap(f)(shadow, raw_normal, ray_dir)
# frame = frame**(1.0/2.2)  # gamma correction
# imshow(frame.reshape(h, w, 3))

# def scene_sdf(balls, p, ball_r=0.5, c=8.0, with_color=False):
#   dists = norm(p-balls.pos)-ball_r
#   balls_dist = -jax.nn.logsumexp(-dists*c)/c
#   floor_dist = p[1]+3.0  # floor is at y==-3.0
#   min_dist = jp.minimum(balls_dist, floor_dist)
#   if not with_color:
#     return min_dist
#   x, y, z = jp.tanh(jp.sin(p*jp.pi)*20.0)
#   floor_color = (0.5+(x*z)*0.1)*jp.ones(3)
#   balls_color = jax.nn.softmax(-dists*c) @ balls.color
#   color = jp.choose(jp.int32(floor_dist < balls_dist),
#             [balls_color, floor_color], mode='clip')
#   return min_dist, color

# color_sdf = partial(scene_sdf, balls, with_color=True)
# _, surf_color = jax.vmap(color_sdf)(hit_pos)
# f = partial(shade_f, light_dir=light_dir)
# frame = jax.vmap(f)(surf_color, shadow, raw_normal, ray_dir)
# frame = frame**(1.0/2.2)  # gamma correction
# imshow(frame.reshape(h, w, 3))

# def _render_scene(balls,
#                   view_size=(640, 400),
#                   target_pos=jp.array([0.0, 0.0, 0.0]),
#                   camera_pos=jp.array([4.0, 3.0, 4.0]),
#                   light_dir=jp.array([1.5, 1.0, 0.0]),
#                   sky_color=jp.array([0.3, 0.4, 0.7])):
#   sdf = partial(scene_sdf, balls)
#   normal_color_f = jax.grad(partial(sdf, with_color=True), has_aux=True)
#   light_dir = normalize(light_dir)

#   def render_ray(ray_dir):
#     hit_pos = raycast(sdf, camera_pos, ray_dir)
#     shadow = cast_shadow(sdf, light_dir, hit_pos)
#     raw_normal, surf_color = normal_color_f(hit_pos)
#     color = shade_f(surf_color, shadow, raw_normal, ray_dir, light_dir)
#     escape = jp.tanh(jp.abs(hit_pos).max()-20.0)*0.5+0.5
#     color = color + (sky_color-color)*escape
#     return color**(1.0/2.2)  # gamma correction

#   ray_dir = camera_rays(target_pos-camera_pos, view_size)
#   color = jax.vmap(render_ray)(ray_dir)
#   w, h = view_size
#   return color.reshape(h, w, 3)

# render_scene = jax.jit(_render_scene)

# def test_inverse():
#   theta = 0 # change me
#   return inverse(render_scene)(balls, theta)

# jaxpr = jax.make_jaxpr(_render_scene)(balls)
# rem_xla_jaxpr = remove_xla_calls(jaxpr)

# img = jax.core.jaxpr_as_fun(rem_xla_jaxpr)(*balls)
# imshow(img[0])

# Julia Version
using Random: AbstractRNG, MersenneTwister

norm(p::AbstractVector) = sqrt(sum(p.^2))
normalize(p::AbstractVector) = p/norm(p)

struct Balls
    pos::Array{Float64,2}
    color::Array{Float64,2}
end

function create_balls(rng::AbstractRNG; n=2, r=0.5)
    pos = rand(rng, n, 3)
    color = rand(rng, n, 3)
    pos = (pos .- 0.5) .*r
    Balls(pos, color)
end

rng = MersenneTwister(0)
balls = create_balls(rng)

function balls_sdf(balls::Balls, p, ball_r = 0.5)
    dists = norm(p .- balls.pos) .- ball_r
    minimum(dists)
end

p = randn(rng, 1000, 3)

## This is problematic because of the broadcasting.  Each row returns an
## Iterator over vectors but within balls_sdf, we expect p to be a matrix in the .-
# res = map(p -> balls_sdf(balls, p), eachrow(p))

# Correction
res = map(eachrow(p)) do p
    balls_sdf(balls, reshape(p, 1, 3))  
end



function scene_sdf(balls::Balls, p::AbstractVector, ball_r = 0.5, c = 8.0)
    dists = norm.(p .- balls.pos) .- ball_r
    balls_dist = -logsumexp(-dists .* c) ./ c
    floor_dist = p[2] + 3.0
    minimum([balls_dist, floor_dist])
end

function raycast(sdf, origin, ray_dir, max_steps=100, max_dist=100.0)
    dist = 0.0
    for i in 1:max_steps
        p = origin + ray_dir .* dist
        d = sdf(p)
        if d < 1e-3 || dist > max_dist
            return p
        end
        dist += d
    end
    return p
end
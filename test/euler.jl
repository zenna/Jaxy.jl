# Simple simulation of Lotka Voltera
using DataStructures
using Plots
using Statistics
using Test
using Jaxy

# But we'll use an iterative version instead (for speed) and type inference
function euler(f, u::U, t, tmax, Δt) where U
  series = list(u)
  while t < tmax
    u = u .+ f(t + Δt, u) .* Δt
    t = t + Δt
    series = cons(u, series)
  end
  series::Cons{U}
end

# ### Deterministic model

# Lotka Volterra represents dynamics of wolves and Rabbit Populations over time
function lotka_volterra(t, u)
  x, y = u
  α, β, δ, γ = [1.5,1.0,3.0,1.0]
  dx = α*x - β*x*y
  dy = -δ*y + γ*x*y
  (dx, dy)
end

const Δt = 0.01
geti(i, xs) = [x[i] for x in xs]
"Plot helper function"
plotts(x) = plot([geti(1, x), geti(2, x)], label = ["rabbits" "wolves"])
res = euler(lotka_volterra, (1.0, 1.0), 0.0, 10.0, Δt)
plotts(res)

sim(x0, x1) = euler(lotka_volterra, (x0, x1), 0.0, 0.02, Δt)

# Jaxy.make_jaxpr_ctx(sim, 1.0, 1.0)
import jax
import jax.numpy as jnp
from jax import jit, grad, vmap, random

# Simple simulation of Lotka Voltera

def euler(f, u, t, tmax, Δt):
    series = [u]
    while t < tmax:
        u = u + f(t + Δt, u) * Δt
        t = t + Δt
        series.append(u)
    return series

# Lotka Volterra represents dynamics of wolves and Rabbit Populations over time
def lotka_volterra(t, u):
    x, y = u
    α, β, δ, γ = [1.5,1.0,3.0,1.0]
    dx = α*x - β*x*y
    dy = -δ*y + γ*x*y
    return jnp.array([dx, dy])

Δt = 0.01
def geti(i, xs):
    return [x[i] for x in xs]

def plotts(x):
    return plot([geti(1, x), geti(2, x)], label = ["rabbits" "wolves"])

def sim(x0, x1):
    return euler(lotka_volterra, jnp.array([x0, x1]), 0.0, 1.0, Δt)

def test():
    res = euler(lotka_volterra, jnp.array([1.0, 1.0]), 0.0, 10.0, Δt)
    return jax.make_jaxpr(sim)(1.0, 1.0)
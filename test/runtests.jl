# using Test

# function test_jaxpr()
#     function f(x, y, z)
#         a = sin(x)
#         b = cos(y)
#         c = a + b
#         d = c * z
#         return d
#     end
#     jaxpr = make_jaxpr_ctx(f, 1, 2, 3)
#     expr = to_expr(jaxpr)
# end

# include("euler.jl")

using Jaxy

func(y) = sin(y) + 4

make_jaxpr_ctx(func, 1)
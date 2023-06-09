RuntimeGeneratedFunctions.init(@__MODULE__)

function simplify_func(f, args...)
    @variables args_[1:length(args)]
    f_sym = simplify(f(args_...))
    @RuntimeGeneratedFunction(build_function(f_sym, args_...))
end

# "Evaluate a jaxpr"
# function evaluate_jaxpr(jaxpr, args...)
#   expr = to_expr(jaxpr)
#   f = @RuntimeGeneratedFunction(expr)
#   f(args...)
# end

# Works in repl, not within a function because of eval in simplify_func
function simplify_make_jaxpr(f, args...)
    sym_f = simplify_func(f, args...)
    make_jaxpr_ctx(sym_f, args...)
end
# Handle control flow, cond
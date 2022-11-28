abstract type Atom end

struct Var <: Atom
  name::Symbol
  type::Type
end

struct Lit{T} <: Atom
  val::T
end

# const Atom = Union{Var, Lit}

struct JaxprEqn
  primitive
  inputs::Vector{Atom}
  params::Dict{Symbol, Any}
  out_binders::Vector{Var}
end

struct JaxExpr <: Atom
  in_binders::Vector{Var}
  eqns::Vector{JaxprEqn}
  outs::Vector{Atom}
end

JaxExpr() = JaxExpr([], [], [])

struct Primitive
  name::Symbol
end

struct Boxed{T}
  var::Var
  val::T
end

val(x::Boxed) = x.val
val(x) = x

var(x::Boxed) = x.var
var(x) = Lit(x)

struct JaxprContext{T}
  data::T
end

struct ContextualValue{U}
  ctx::JaxprContext
  # var::Var
  val::U
end

val(x::ContextualValue) = x.val
ctx(x::ContextualValue) = x.ctx

sval(x::Boxed) = sval(val(x))
sval(x::ContextualValue) = sval(val(x))
sval(x::Vector) = map(sval, x)
sval(x::Tuple) = map(sval, x)
function sval(x::T) where {T}
  fields_ = fieldnames(T)
  if isempty(fields_)
    x
  else
    fields__ = map(f -> getfield(x, f), fields_)
    construct(T, map(sval, fields__)...)
  end
end

mv_ctx(x::ContextualValue) = y -> mv_ctx(x, y)

Base.iterate(xs::ContextualValue) = iterate(map(mv_ctx(xs), sval(xs)))
Base.iterate(xs::ContextualValue, i) = iterate(map(mv_ctx(xs), sval(xs)), i)

function construct(x::Type{T}, args...) where {T}
  T.name.wrapper(args...)
end

# function find_ctx_l(level)
#   function f(x)
#     println(repeat("\t", level), level, ":", x)
#     find_ctx(x, level)
#   end
# end

# find_ctx(x::ContextualValue, level = 1) = error("Found a contextual value")
# find_ctx(x::Vector, level = 1) = map(find_ctx_l(level + 1), x)
# find_ctx(x::Tuple, level = 1) = map(find_ctx_l(level + 1), x)
# function find_ctx(x, level = 1)
#   fields_ = fieldnames(typeof(x))
#   if isempty(fields_)
#     nothing
#   else
#     fields__ = map(f -> getfield(x, f), fields_)
#     map(find_ctx_l(level + 1), fields__)
#   end
# end

has_nested_ctx(x::ContextualValue) = has_nested_ctx_(val(x))
has_nested_ctx(x) = has_nested_ctx_(x)

has_nested_ctx_(x_::ContextualValue) = true
has_nested_ctx_(x_::Vector) = any(map(has_nested_ctx_, x_))
has_nested_ctx_(x_::Tuple) = any(map(has_nested_ctx_, x_))
function has_nested_ctx_(x_::T) where {T}
  fields_ = fieldnames(T)
  if isempty(fields_)
    false
  else
    fields__ = map(f -> getfield(x_, f), fields_)
    any(map(has_nested_ctx_, fields__))
  end
end
has_nested_ctx_(x_::Boxed) = has_nested_ctx_(val(x_))

mv_ctx(x::ContextualValue, y) = ContextualValue(x.ctx, y)
function mv_ctx(x::ContextualValue, y::ContextualValue)
  @assert x.ctx == y.ctx
  y
end
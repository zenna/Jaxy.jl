
struct ShapedArray
  array_abstraction_level::Int
  shape::D where {D <: Dims}
  dtype::Type
end
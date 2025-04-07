module JamesCore

using LinearAlgebra
using Statistics
using Printf

using StaticArrays
using OffsetArrays
using GeometryBasics
using Rotations
using CoordinateTransformations

include("angles.jl")
include("axis.jl")
include("goniometer.jl")
include("detector.jl")
include("sample.jl")

end # module JamesCore

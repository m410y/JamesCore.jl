module JamesCore

using LinearAlgebra
using Statistics
using Printf

using StaticArrays
using OffsetArrays
using GeometryBasics
using Rotations
using CoordinateTransformations

include("axis.jl")
include("goniometer.jl")
include("detector.jl")
include("sample.jl")
include("xray.jl")
include("geometry.jl")
include("diffraction.jl")

end # module JamesCore

module JamesCore

using LinearAlgebra
using Statistics
using Printf

using StaticArrays
using OffsetArrays
using GeometryBasics
using Rotations

include("isometry.jl")
include("axis.jl")
include("detector.jl")
include("sample.jl")
include("xray.jl")
include("geometry.jl")
include("diffraction.jl")

end # module JamesCore

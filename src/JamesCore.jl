module JamesCore

import Base: iterate, IteratorSize, eltype, isdone
using LinearAlgebra
using Statistics

using StaticArrays
using GeometryBasics
using Rotations
using CoordinateTransformations

export xy2q, xy2q_jac, k2xy
export MillerIterator

include("geometry.jl")
include("model.jl")
include("solve.jl")
include("lattice.jl")

end

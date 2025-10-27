module JamesCore

import Base: iterate, IteratorSize, eltype, isdone
using LinearAlgebra
using Statistics

using StaticArrays
using GeometryBasics
import GeometryBasics: Vec3
using Rotations
using CoordinateTransformations

export RotAxis, TransAxis, fix_axes_params
export Ray, Detector
export ray2xy, xy2q, xy2q_jac
export solve_reflection, solve_orientation, solve_equator_reflection
export MillerIterator

include("geometry.jl")
include("model.jl")
include("solve.jl")
include("lattice.jl")

end

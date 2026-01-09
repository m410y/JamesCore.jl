module JamesCore

import Base: iterate, IteratorSize, eltype, isdone
using LinearAlgebra
using Statistics

using StaticArrays
import GeometryBasics: Vec3
using GeometryBasics
using Rotations
using CoordinateTransformations

export RigidObject
export RotAxis, TransAxis, fix_axes
export Ray, Plane, Lattice
export ray2xy, xy2q, xy2q_jac
export solve_rot, solve_orientation, solve_equator_reflection
export MillerIterator

include("utils.jl")
include("geometry.jl")
include("types.jl")
include("model.jl")
include("solve.jl")
include("miller.jl")

end

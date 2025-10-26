"""
Abstract type to separate transformations Vec, Mat and Point fields.
"""
abstract type RigidObject end

(t::LinearMap)(obj::T) where {T<:RigidObject} = T(
    (
        fieldtype(T, name) <: Union{RigidObject,Vec,Mat} ? t(getfield(obj, name)) :
        getfield(obj, name) for name in fieldnames(T)
    )...,
)
(t::Translation)(obj::T) where {T<:RigidObject} = T(
    (
        fieldtype(T, name) <: Union{RigidObject,Point} ? t(getfield(obj, name)) :
        getfield(obj, name) for name in fieldnames(T)
    )...,
)

"""
    RotAxis{T<:Real}

Affine rotation axis. Uses function-like argument to generate affine transformation.
"""
struct RotAxis{T<:Real} <: RigidObject
    v::Vec3{T}
    p::Point3{T}
    RotAxis{T}(v::AbstractVector, p::AbstractVector) where {T} =
        new{T}(Vec3{T}(normalize(v)), Point3{T}(p))
end

# axis rotation generation
function (axis::RotAxis{T})(angle::Real) where {T}
    recenter(AngleAxis{T}(angle, axis.v..., false), axis.p)
end

"""
    TransAxis{T<:Real}

Affine translation axis. Uses function-like argument to generate translation transformation.
"""
struct TransAxis{T<:Real} <: RigidObject
    v::Vec3{T}
    TransAxis{T}(v::AbstractVector) where {T} =
        new{T}(Vec3{T}(normalize(v)))
end

# axis translation generation
function (axis::TransAxis{T})(distance::Real) where {T}
    Translation(axis.v * distance)
end

"""
    angle(a::AbstractVector, b::AbstractVector)

Returns angle between vectors.
"""
function Base.angle(a::AbstractVector, b::AbstractVector)
    atan(norm(cross(a, b)), dot(a, b))
end


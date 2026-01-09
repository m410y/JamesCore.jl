"""
    Ray{T<:Real} <: RigidObject

Simple structure for ray with point in space and direction.
"""
struct Ray{T<:Real} <: RigidObject
    k::Vec3{T}
    p::Point3{T}
    Ray{T}(k::AbstractVector, p::AbstractVector = zero(Point3{T})) where {T<:Real} =
        new{T}(Vec3{T}(k), Point3{T}(p))
end
Ray{T}(str::AbstractString) where {T<:Real} = Ray{T}(str2dir(str))

Ray(k::AbstractVector) = Ray{eltype(k)}(k)
Ray(k::AbstractVector, p::AbstractVector) = Ray{promote_type(eltype(k), eltype(p))}(k, p)
Ray(str::AbstractString) = Ray(Vec3(str))

"""
    Plane{T<:Real} <: RigidObject

Simple plane detector.
"""
struct Plane{T<:Real} <: RigidObject
    e::Mat{3,2,T,6}
    p::Point3{T}
    Plane{T}(e::AbstractMatrix, p::AbstractVector) where {T<:Real} =
        new{T}(Mat{3,2,T,6}(e), Point3{T}(p))
end

"""
    Lattice{T<:Real} <: RigidObject

Basic crystal model.
"""
struct Lattice{T<:Real} <: RigidObject
    UB::Mat3{T}
    p::Point3{T}
    Lattice{T}(UB::AbstractMatrix, p::AbstractVector = zero(Point3{T})) where {T<:Real} = 
        new{T}(Mat3{T}(UB), Point3{T}(p))
end

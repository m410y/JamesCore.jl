"""
    Ray{T<:Real} <: RigidObject

Simple structure for ray with point in space and direction.
"""
struct Ray{T<:Real} <: RigidObject
    k::Vec3{T}
    p::Point3{T}
end

"""
    Detector{T<:Real} <: RigidObject

Simple plane detector.
"""
struct Detector{T<:Real} <: RigidObject
    e::Mat{3,2,T,6}
    p::Point3{T}
end

"""
    ray2xy(ray::Ray, detect::Detector)

Computes ray and detector intersection point.
"""
function ray2xy(ray::Ray, detect::Detector)
    x, y, d = [-detect.e ray.k] \ Vec(detect.p - ray.p)
    d > 0 ? Point(x, y) : error("Ray doesn't intersect detector")
end

"""
    xy2q(xy::AbstractVector, detect::Detector, ray::Ray)

Computes ray scattering vector for corresponding point on detector.
"""
function xy2q(xy::AbstractVector, detect::Detector, ray::Ray)
    r = Vec(detect.p - ray.p + detect.e * xy)
    norm(ray.k) * normalize(r) - ray.k
end

"""
    xy2q(xy::AbstractVector, detect::Detector, ray::Ray)

Computes jacobian for ray scattering vector for corresponding point on detector.
"""
function xy2q_jac(xy::AbstractVector, detect::Detector, ray::Ray)
    r = Vec(detect.p - ray.p + detect.e * xy)
    dr_perp = detect.e - r * r' * detect.e / norm(r)^2
    dr_perp * norm(ray.k) / norm(r)
end

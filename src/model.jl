struct Beam{T<:Real} <: RigidObject
    k::Vec3{T}
end

abstract type Sample <: RigidObject end

struct UnknownSample{T<:Real} <: Sample
    p::Point3{T}
end

struct Crystal{T<:Real} <: Sample
    ub::Mat3{T}
    p::Point3{T}
end

struct Detector{T<:Real} <: RigidObject
    e::Mat{3,2,T,6}
    p::Point3{T}
end

function xy2q(beam::Beam, detect::Detector, xy::AbstractVector, p::AbstractVector = zero(Point3))
    r = Vec(detect.p - p + detect.e * xy)
    norm(beam.k) * normalize(r) - beam.k
end

function xy2q_jac(beam::Beam, detect::Detector, xy::AbstractVector, p::AbstractVector = zero(Point3))
    r = Vec(detect.p - p + detect.e * xy)
    dr_perp = detect.e - r * r' * detect.e / norm(r)^2
    norm(beam.k) * dr_perp / norm(r)
end

function k2xy(detect::Detector, k::AbstractVector, p::AbstractVector = zero(Point3))
    x, y, d = [-detect.e k] \ Vec(detect.p - p)
    d > 0 ? Point(x, y) : error("Ray doesn't intersect detector")
end

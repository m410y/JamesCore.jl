"""
    ray2xy(ray::Ray, detect::Plane)
using Base: checkbounds_indices

Computes ray and detector intersection point.
"""
function ray2xy(ray::Ray, detect::Plane)
    x, y, r = [-detect.e ray.k] \ Vec(detect.p - ray.p)
    r > 0 ? Point(x, y) : nothing # ray doesn't intersect detector
end

"""
    xy2q(xy::AbstractVector, detect::Plane, ray::Ray)

Computes ray scattering vector for corresponding point on detector.
"""
function xy2q(xy::AbstractVector, detect::Plane, ray::Ray)
    r = Vec(detect.p - ray.p + detect.e * xy)
    norm(ray.k) * normalize(r) - ray.k
end

"""
    xy2q(xy::AbstractVector, detect::Plane, ray::Ray)

Computes jacobian for ray scattering vector for corresponding point on detector.
"""
function xy2q_jac(xy::AbstractVector, detect::Plane, ray::Ray)
    r = Vec(detect.p - ray.p + detect.e * xy)
    dr_perp = detect.e - r * r' * detect.e / norm(r)^2
    dr_perp * norm(ray.k) / norm(r)
end

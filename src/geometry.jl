export orient_angles, intersect_coord

angle(a::AbstractVector, b::AbstractVector) = atan(norm(cross(a, b)), dot(a, b))

function axis_angle(axis::Axis, b::AbstractVector, c::AbstractVector)
    b_a = b - axis.v * dot(axis.v, b)
    c_a = c - axis.v * dot(axis.v, c)
    atan(dot(axis.v, cross(b_a, c_a)), dot(b_a, c_a))
end

function circle_intersection_angles(a::Real, b::Real, c::Real)
    s = (a + b + c) / 2
    @assert s > max(a, b, c) "Impossible spherical triangle"

    sin_s = sin(s)
    sin_a = sin(s - a)
    sin_b = sin(s - b)
    sin_c = sin(s - c)

    α = 2atan(sqrt(sin_b * sin_c), sqrt(sin_s * sin_a))
    β = 2atan(sqrt(sin_c * sin_a), sqrt(sin_s * sin_b))
    γ = 2atan(sqrt(sin_a * sin_b), sqrt(sin_s * sin_c))

    α, β, γ
end

function orient_angles(axis₁::Axis, axis₂::Axis, src::AbstractVector, dst::AbstractVector)
    SA₁ = angle(src, axis₁.v)
    A₁A₂ = angle(axis₁, axis₂.v)
    DA₂ = angle(dst, axis₂.v)

    ∠SA₁A₂ = axis_angle(axis₁, src, axis₂.v)
    ∠A₁A₂D = axis_angle(axis₂, axis₁.v, dst)
    Δα₁, Δα₂, _ = circle_intersection_angles(DA₂, SA₁, A₁A₂)

    (∠SA₁A₂ + Δα₁, ∠A₁A₂D + Δα₂), (∠SA₁A₂ - Δα₁, ∠A₁A₂D - Δα₂)
end

function intersect_coord(detector::Detector, xray::XRay)
    _, x, y = [xray.k detector.M] \ (xray.p - detector.p)
    Vec2(x, y)
end

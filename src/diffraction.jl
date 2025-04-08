export bragg_angle, reflection_angles

bragg_angle(d::Number, λ::Number) = 2asin(λ / 2d)
bragg_angle(s::AbstractVector, k::AbstractVector) = bragg_angle(1 / norm(s), 1 / norm(k))

function reflection_angles(axis::Axis, s::AbstractVector, k::AbstractVector)
    SA = angle(s, axis.v)
    AD = angle(axis.v, k)

    ∠SAD = axis_angle(axis, s, k)
    Δα, _, _ = circle_intersection_angles((pi + bragg_angle(s, k)) / 2, SA, AD)

    ∠SAD + Δα, ∠SAD - Δα
end

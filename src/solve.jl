"""
    solve_trig(a, b, c)
    solve_trig((a, b, c))

Solves trigonomic equation `a * cos(x) + b * sin(x) == c`.
"""
function solve_trig(a, b, c)
    d = sqrt(a^2 + b^2 - c^2)
    atan(b*c - a*d, a*c + b*d), atan(b*c + a*d, a*c - b*d)
end
solve_trig((a, b, c)) = solve_trig(a, b, c)

"""
    solve_trig_nearest(a, b, c)

Solves trigonomic equation `a * cos(x) + b * sin(x) == c` for nearest to zero `x`.
"""
function solve_trig_nearest(a, b, c)
    d = copysign(sqrt(a^2 + b^2 - c^2), b)
    atan(b*c - a*d, a*c + b*d)
end
solve_trig_nearest((a, b, c)) = solve_trig_nearest(a, b, c)

"""
    rot2trig(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::Number)

Returns trigonomic equation coeffs for `(AngleAxis(x, a...) * b) ⋅ c == d`.
"""
function rot2trig(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::Real)
    baac = dot(b, a) * dot(a, c) / dot(a, a)
    dot(b, c) - baac, dot(a, cross(b, c)) / norm(a), d - baac
end

"""
    solve_rot(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::Number)

Solves equation `(AngleAxis(x, a...) * b) ⋅ c == d`.
"""
function solve_rot(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::Number)
    solve_trig(rot2trig(a, b, c, d)...)
end

"""
    reflect2trig(q::AbstractVector, axis::AbstractVector, k::AbstractVector)

Returns trigonomic equation coeffs for `norm(AngleAxis(x, a...) * q + k) == norm(k)`.
"""
function reflect2trig(q::AbstractVector, a::AbstractVector, k::AbstractVector)
    rot2trig(a, q, k, -dot(q, q) / 2)
end

"""
    solve_orientation(from::AbstractVector, axis₁::AbstractVector, axis₂::AbstractVector, to::AbstractVector, )

Solves equation `AngleAxis(x₂, axis₂...) * AngleAxis(x₁, axis₁...) * from == to`.
"""
function solve_orientation(
    from::AbstractVector,
    axis₁::AbstractVector,
    axis₂::AbstractVector,
    to::AbstractVector,
)
    k = norm(from) / norm(to)
    α1, α2 = solve_rot(axis₁, from, axis₂, dot(to, axis₂) * k)
    β1, β2 = solve_rot(-axis₂, to, axis₁, dot(from, axis₁) / k)
    (α1, β1), (α2, β2)
end

"""
    solve_equator_reflection(q::AbstractVector, axis₁::AbstractVector, axis₂::AbstractVector, q::AbstractVector)

Solves equations `norm(k + AngleAxis(x₂, axis₂...) * AngleAxis(x₁, axis₁...) * q) == norm(k)` and `dot(q, axis₂) == 0`.
"""
function solve_equator_reflection(
    q::AbstractVector,
    axis₁::AbstractVector,
    axis₂::AbstractVector,
    k::AbstractVector,
)
    αs = solve_rot(axis₁, q, axis₂, 0)
    map(αs) do α
        q′ = AngleAxis(α, axis₁...) * q
        α, solve_trig(reflect2trig(q′, axis₂, k)...)
    end
end

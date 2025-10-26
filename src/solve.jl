"""
    solve_trig_eq(a::Real, b::Real, c::Reah; sort::Bool = true)

Solves equation `a * cos(x) + b * sin(x) == c`.
"""
function solve_trig_eq(a::Real, b::Real, c::Real)
    d = sqrt(a^2 + b^2 - c^2)
    atan(b*c - a*d, a*c + b*d), atan(b*c + a*d, a*c - b*d)
end

"""
    solve_rot_eq(a::AbstractVector, b::AbstractVector, c::AbstractVector, d::Number)

Solves equation `(AngleAxis(x, a...) * b) ⋅ c == d`.
"""
function solve_rot_eq(
    a::AbstractVector,
    b::AbstractVector,
    c::AbstractVector,
    d::Real
)
    baac = dot(b, a) * dot(a, c) / dot(a, a)
    solve_trig_eq(dot(b, c) - baac, dot(a, cross(b, c)) / norm(a), d - baac)
end

"""
    solve_reflection(k::AbstractVector, q::AbstractVector, axis::AbstractVector)

Solves equation `norm(AngleAxis(x, a...) * q + k) == norm(k)`.
"""
function solve_reflection(
    a::AbstractVector,
    q::AbstractVector,
    k::AbstractVector;
)
    solve_rot_eq(a, q, k, -dot(q, q) / 2)
end

"""
    solve_orientation(from::AbstractVector, to::AbstractVector, axis₁::AbstractVector, axis₂::AbstractVector)

Solves equation `AngleAxis(x₂, axis₂...) * AngleAxis(x₁, axis₁...) * from = to`.
"""
function solve_orientation(
    axis₁::AbstractVector,
    axis₂::AbstractVector,
    from::AbstractVector,
    to::AbstractVector,
)
    k = norm(from) / norm(to)
    α1, α2 = solve_rot_eq(axis₁, from, axis₂, dot(to, axis₂) * k)
    β1, β2 = solve_rot_eq(-axis₂, to, axis₁, dot(from, axis₁) / k)
    (α1, β1), (α2, β2)
end

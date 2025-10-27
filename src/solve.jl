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
    solve_reflection(q::AbstractVector, axis::AbstractVector, k::AbstractVector)

Solves equation `norm(AngleAxis(x, a...) * q + k) == norm(k)`.
"""
function solve_reflection(
    q::AbstractVector,
    a::AbstractVector,
    k::AbstractVector;
)
    solve_rot_eq(a, q, k, -dot(q, q) / 2)
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
    α1, α2 = solve_rot_eq(axis₁, from, axis₂, dot(to, axis₂) * k)
    β1, β2 = solve_rot_eq(-axis₂, to, axis₁, dot(from, axis₁) / k)
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
    α1, α2 = solve_rot_eq(axis₁, q, axis₂, 0)
    βs1 = solve_reflection(AngleAxis(α1, axis₁...) * q, axis₂, k)
    βs2 = solve_reflection(AngleAxis(α2, axis₁...) * q, axis₂, k)
    (α1, βs1), (α2, βs2)
end

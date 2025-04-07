struct Axis{T}
    v::Vec3{T}
    p::Point3{T}
    function Axis{T}(v, p) where {T}
        n = normalize(v)
        pn = p - n * dot(n, p)
        new{T}(n, pn)
    end
end

Axis(v::AbstractVector, p::AbstractVector) = Axis{Float64}(v, p)
axis(v::AbstractVector, p::AbstractVector) = Axis(v, p)
centered_axis(v::AbstractVector) = axis(v, zeros(3))

function (axis::Axis)(angle)
    rot = AngleAxis(angle, axis.v..., false)
    AffineMap(rot, axis.p - rot * axis.p)
end

(::IdentityTransformation)(axis::Axis) = axis
function (trans::LinearMap)(axis::Axis)
    Axis(trans(axis.v), trans(axis.p))
end
function (trans::Translation)(axis::Axis)
    Axis(axis.v, trans(axis.p))
end
function (trans::AffineMap)(axis::Axis)
    Axis(trans.linear * axis.v, trans(axis.p))
end

function Base.show(io::IO, ::MIME"text/plain", axis::Axis)
    println(io, summary(axis), ":")
    @printf(io, "  position [μm]: %6.2f, %6.2f, %6.2f\n", (1e3 * axis.p)...)
    @printf(io, "  direction    : %6.3f, %6.3f, %6.3f", axis.v...)
end

orient_angles(axis₁::Axis, axis₂::Axis, src, dst) =
    orient_angles(axis₁.v, axis₂.v, normalize(src), normalize(dst))

function reflection_angles(axis::Axis, s, k)
    d = 1 / norm(s)
    λ = 1 / norm(k)
    reflection_angles(axis.v, s * d, k * λ, asin(λ / 2d))
end

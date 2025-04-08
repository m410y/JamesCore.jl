export Axis

struct Axis{T}
    v::Vec{3,T}
    p::Point{3,T}
    function Axis{T}(v::AbstractVector, p::AbstractVector) where {T}
        n = normalize(v)
        pn = p - n * dot(n, p)
        new{T}(n, pn)
    end
end
Axis(args...) = Axis{Float64}(args...)
Axis{T}(v::AbstractVector) where {T} = Axis{T}(v, zero(Point{3,T}))
Axis{T}(x::Real, y::Real, z::Real) where {T} = Axis{T}(Vec{3,T}(x, y, z))

function (axis::Axis)(angle)
    rot = AngleAxis(angle, axis.v..., false)
    trans = axis.p - rot * axis.p
    Isometry(rot, trans)
end

Base.:*(iso::Isometry, axis::Axis) = Axis(iso * axis.v, iso * axis.p)

function Base.show(io::IO, ::MIME"text/plain", axis::Axis)
    println(io, summary(axis), ":")
    @printf(io, "  direction: % 8f, % 8f, % 8f", axis.v...)
    if !iszero(axis.p)
        @printf(io, "\n  position : % 8f, % 8f, % 8f", axis.p...)
    end
end

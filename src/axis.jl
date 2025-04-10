export RotAxis, MoveAxis, ScrewAxis

abstract type Axis{T} end

struct RotAxis{T} <: Axis{T}
    v::Vec{3,T}
    p::Point{3,T}
    function RotAxis{T}(v::AbstractVector, p::AbstractVector) where {T}
        n = normalize(v)
        pn = p - n * dot(n, p)
        new{T}(n, pn)
    end
end
RotAxis(args...) = RotAxis{Float64}(args...)
RotAxis{T}(v::AbstractVector) where {T} = RotAxis{T}(v, zero(Point{3,T}))
RotAxis{T}(x::Real, y::Real, z::Real) where {T} = RotAxis{T}(Vec{3,T}(x, y, z))

function (axis::RotAxis)(angle::Real)
    rot = AngleAxis(angle, axis.v..., false)
    trans = axis.p - rot * axis.p
    Isometry(rot, trans)
end

Base.:*(iso::Isometry, axis::RotAxis) = RotAxis(iso * axis.v, iso * axis.p)

function Base.show(io::IO, ::MIME"text/plain", axis::RotAxis)
    println(io, summary(axis), ":")
    @printf(io, "  direction: % 8f, % 8f, % 8f", axis.v...)
    if !iszero(axis.p)
        @printf(io, "\n  position : % 8f, % 8f, % 8f", axis.p...)
    end
end

struct MoveAxis{T} <: Axis{T}
    v::Vec{3,T}
    function MoveAxis{T}(v::AbstractVector) where {T}
        n = normalize(v)
        new{T}(n)
    end
end
MoveAxis(args...) = MoveAxis{Float64}(args...)
MoveAxis{T}(x::Real, y::Real, z::Real) where {T} = MoveAxis{T}(Vec{3,T}(x, y, z))

function (axis::MoveAxis)(distance::Number)
    Isometry(axis.v * distance)
end

Base.:*(iso::Isometry, axis::MoveAxis) = MoveAxis(iso * axis.v, iso * axis.p)

function Base.show(io::IO, ::MIME"text/plain", axis::MoveAxis)
    println(io, summary(axis), ":")
    @printf(io, "  shift: % 8f, % 8f, % 8f", axis.v...)
end

struct ScrewAxis{T} <: Axis{T}
    v::Vec{3,T}
    p::Point{3,T}
    t::T
    function ScrewAxis{T}(v::AbstractVector, p::AbstractVector, t::Real) where {T}
        n = normalize(v)
        pn = p - n * dot(n, p)
        new{T}(n, pn, t)
    end
end
ScrewAxis(args...) = ScrewAxis{Float64}(args...)
ScrewAxis{T}(v::AbstractVector, t::Real = 0) where {T} = ScrewAxis{T}(v, zero(Point{3,T}), t)
ScrewAxis{T}(x::Real, y::Real, z::Real, t::Real = 0) where {T} = ScrewAxis{T}(Vec{3,T}(x, y, z), t)
ScrewAxis(axis::RotAxis{T}) where {T} = ScrewAxis{T}(axis.v, axis.p, 0)

function (axis::ScrewAxis)(angle::Real)
    rot = AngleAxis(angle, axis.v..., false)
    trans = axis.p - rot * axis.p + axis.v * angle * axis.t
    Isometry(rot, trans)
end

function Base.show(io::IO, ::MIME"text/plain", axis::ScrewAxis)
    println(io, summary(axis), ":")
    @printf(io, "  direction: % 8f, % 8f, % 8f\n", axis.v...)
    @printf(io, "  period   : % 8f", 2pi * axis.t)
    if !iszero(axis.p)
        @printf(io, "\n  position : % 8f, % 8f, % 8f", axis.p...)
    end
end

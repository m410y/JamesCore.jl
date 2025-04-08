export Detector

struct Detector{T}
    M::SMatrix{3,2,T,6}
    p::Point{3,T}
    function Detector{T}(M::AbstractMatrix, p::AbstractVector) where {T}
        new{T}(SMatrix{3,2,T,6}(M), Point{3,T}(p))
    end
end
Detector(args...) = Detector{Float64}(args...)
Detector{T}(ex::AbstractVector, ey::AbstractVector, p::AbstractVector) where {T} = Detector{T}([ex ey], p)

(detector::Detector)(xy::AbstractVector) = detector.M * xy + detector.p
(detector::Detector)(x::Real, y::Real) = detector(Vec2(x, y))

Base.:*(iso::Isometry, detector::Detector) = Detector(iso * detector.M, iso * detector.p)

function Base.show(io::IO, ::MIME"text/plain", detector::Detector)
    ex, ey = eachcol(detector.M)
    println(io, summary(detector), ":")
    @printf(io, "  zero  : % 8f, % 8f, % 8f\n", detector.p...)
    @printf(io, "  x line: % 8f, % 8f, % 8f\n", ex...)
    @printf(io, "  y line: % 8f, % 8f, % 8f", ey...)
end

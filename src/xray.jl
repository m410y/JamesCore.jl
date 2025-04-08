export XRay

struct XRay{T}
    k::Vec{3,T}
    p::Point{3,T}
    function XRay{T}(k::AbstractVector, p::AbstractVector) where {T}
        new{T}(Vec{3,T}(k), Point{3,T}(p))
    end
end
XRay(args...) = XRay{Float64}(args...)
XRay{T}(k::AbstractVector) where {T} = XRay{T}(k, zero(Point{3,T}))
XRay{T}(x::Real, y::Real, z::Real) where {T} = XRay{T}(Vec{3,T}(x, y, z))

function Base.show(io::IO, ::MIME"text/plain", xray::XRay)
    println(io, summary(xray), ":")
    @printf(io, "  wavevec : % 8f, % 8f, % 8f", xray.k...)
    if !iszero(xray.p)
        @printf(io, "\n  position: % 8f, % 8f, % 8f", xray.p...)
    end
end

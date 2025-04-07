struct Detector{T}
    size::NTuple{2,Integer}
    trans::AffineMap{SMatrix{3,2,T,6}, Vec3{T}}
end

function detector(size::NTuple{2,Integer}, p0::AbstractVector, ex::AbstractVector, ey::AbstractVector)
    amap = AffineMap(SMatrix{3,2,Float64,6}([ex ey]), Vec3{Float64}(p0))
    Detector{Float64}(size, amap)
end

(::IdentityTransformation)(detector::Detector) = detector
function (trans::LinearMap)(detector::Detector)
    Detector(detector.size, trans ∘ detector.trans)
end
function (trans::Translation)(detector::Detector)
    Detector(detector.size, trans ∘ detector.trans)
end
function (trans::AffineMap)(detector::Detector)
    Detector(detector.size, trans ∘ detector.trans)
end

(detector::Detector)(x::Number, y::Number) = detector.trans(Vec2(x, y))
(detector::Detector)(coord::AbstractVector) = detector.trans(coord)

# TODO: make it work for arbitrary transform
function intersect_coord(detector::Detector, p::AbstractVector, v::AbstractVector)
    _, coord... =
        [-Vec3(v) detector.trans.linear] \ (Vec3(p...) - detector.trans.translation)
    Vec2(coord...)
end

function Base.show(io::IO, ::MIME"text/plain", detector::Detector)
    p = detector.trans.translation
    ex, ey = eachcol(detector.trans.linear)
    println(io, summary(detector), ":")
    println(io, "  size: ", join(detector.size, "×"))
    @printf(io, "  zero position [mm]: %6.1f, %6.1f, %6.1f\n", p...)
    @printf(io, "  x line [μm]: %6.1f, %6.1f, %6.1f\n", (1e3 * ex)...)
    @printf(io, "  y line [μm]: %6.1f, %6.1f, %6.1f", (1e3 * ey)...)
end

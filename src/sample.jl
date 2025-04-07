export Sample, SingleCrystal, centered_crystal

abstract type Sample end

struct SingleCrystal{T} <: Sample
    p::Point3{T}
    UB::Mat3{T}
end

centered_crystal(UB::AbstractMatrix) =
    SingleCrystal(Point3(0.0, 0.0, 0.0), Mat3{Float64}(UB))

(trans::IdentityTransformation)(cryst::SingleCrystal) = cryst
function (trans::LinearMap)(cryst::SingleCrystal)
    SingleCrystal(trans(cryst.p), trans(cryst.UB))
end
function (trans::Translation)(cryst::SingleCrystal)
    SingleCrystal(trans(cryst.p), cryst.UB)
end
function (trans::AffineMap)(cryst::SingleCrystal)
    SingleCrystal(trans(cryst.p), trans.linear * cryst.UB)
end

function Base.show(io::IO, ::MIME"text/plain", cryst::SingleCrystal)
    println(io, summary(cryst), ":")
    @printf(io, "  position [μm]: %6.1f, %6.1f, %6.1f\n", (1e3 * cryst.p)...)
    println(io, "  orientation matrix (UB) [keV]:")
    for row in eachrow(cryst.UB)
        @printf(io, "    %6.3f %6.3f %6.3f\n", (1e-3 * row)...)
    end
end

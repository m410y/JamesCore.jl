export SingleCrystal

struct SingleCrystal{T}
    UB::Mat3{T}
    p::Point{3,T}
    function SingleCrystal{T}(UB::AbstractMatrix, p::AbstractVector) where {T}
        new{T}(Mat3{T}(UB), Point{3,T}(p))
    end
end
SingleCrystal(args...) = SingleCrystal{Float64}(args...)
SingleCrystal{T}(UB::AbstractMatrix) where {T} = SingleCrystal{T}(UB, zero(Point{3,T}))

Base.:*(iso::Isometry, cryst::SingleCrystal) = SingleCrystal(iso * cryst.UB, iso * cryst.p)

function Base.show(io::IO, ::MIME"text/plain", cryst::SingleCrystal)
    row1, row2, row3 = eachrow(cryst.UB)
    println(io, summary(cryst), ":")
    println(io, "  orientation matrix (UB):")
    @printf(io, "    % 8f % 8f % 8f\n", row1...)
    @printf(io, "    % 8f % 8f % 8f\n", row2...)
    @printf(io, "    % 8f % 8f % 8f", row3...)
    if !iszero(cryst.p)
        @printf(io, "\n  position: % 8f, % 8f, % 8f\n", cryst.p...)
    end
end

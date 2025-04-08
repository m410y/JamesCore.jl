struct Isometry{T}
    R::QuatRotation{T}
    t::Vec{3,T}
    function Isometry{T}(R::Rotation{3}, t::AbstractVector) where {T}
        new{T}(QuatRotation{T}(R), Vec{3,T}(t))
    end
end
Isometry(args...) = Isometry{Float64}(args...)
Isometry{T}(R::Rotation{3}) where {T} = Isometry{T}(R, zero(Vec{3,T}))
Isometry{T}(t::AbstractVector) where {T} = Isometry{T}(one(QuatRotation{T}), t)

Base.one(Isometry) = Isometry(one(QuatRotation), zero(Vec3))
Base.:*(iso₁::Isometry, iso₂::Isometry) = Isometry(iso₁.R * iso₂.R, iso₁.R * iso₂.t + iso₁.t)
Base.:*(rot::Rotation{3}, iso::Isometry) = Isometry(rot * iso.R, rot * iso.t)
Base.:*(iso::Isometry, rot::Rotation{3}) = Isometry(iso.R * rot, iso.t)
Base.:*(iso::Isometry, v::AbstractVecOrMat) = iso.R * v
Base.:*(iso::Isometry, p::Point3) = iso.R * p + iso.t

export XRay, unpolarized_xray, centered_unpolarized_xray

struct XRay{T}
    p::Point3{T}
    k::Vec3{T}
end

(trans::IdentityTransformation)(xray::XRay) = xray
function (trans::LinearMap)(xray::XRay)
    XRay(trans(xray.p), trans(xray.k))
end
function (trans::Translation)(xray::XRay)
    XRay(trans(xray.p), xray.k)
end
function (trans::AffineMap)(xray::XRay)
    XRay(trans(xray.p), trans.linear * xray.k)
end

unpolarized_xray(p::AbstractVector, k::AbstractVector) = XRay{Float64}(p, k)
centered_unpolarized_xray(k::AbstractVector) = unpolarized_xray(zeros(3), k)
centered_unpolarized_xray(kx::Number, ky::Number, kz::Number) = unpolarized_xray(zeros(3), Vec3(kx, ky, kz))

function Base.show(io::IO, ::MIME"text/plain", xray::XRay)
    println(io, summary(xray), ":")
    @printf(io, "  position [μm]: %6.1f, %6.1f, %6.1f\n", (1e3 * xray.p)...)
    @printf(io, "  wavevec [keV]: %6.3f, %6.3f, %6.3f", (1e-3 * xray.k)...)
end

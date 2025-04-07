export Goniometer, goniometer, fix_angle

struct Goniometer{N,T}
    axes::NTuple{N,Axis{T}}
    prelim::Transformation
end

# TODO: optimize
function goniometer(
    axes::Vararg{Union{Transformation,Axis}};
    prelim = IdentityTransformation(),
)
    active_axes = Axis[]
    for axis in reverse(axes)
        if axis isa Transformation
            prelim = prelim ∘ axis
        else
            push!(active_axes, prelim(axis))
        end
    end
    Goniometer(Tuple(reverse(active_axes)), prelim)
end

# TODO: optimize
function fix_angle(gonio::Goniometer, (n, angle))
    axes = Any[gonio.axes...]
    axes[n] = axes[n](angle)
    goniometer(axes..., prelim = gonio.prelim)
end

function (gonio::Goniometer{N})(angles::Vararg{Number,N}) where {N}
    trans = gonio.prelim
    for n = 1:N
        trans = gonio.axes[n](angles[n]) ∘ trans
    end
    trans
end

function Base.show(io::IO, ::MIME"text/plain", gonio::Goniometer{N}) where {N}
    println(io, summary(gonio), ":")
    for (n, axis) in enumerate(gonio.axes)
        println(io, "  Axis $n:")
        @printf(io, "    position [μm]: %6.2f, %6.2f, %6.2f\n", (1e3 * axis.p)...)
        @printf(io, "    direction    : %6.3f, %6.3f, %6.3f\n", axis.v...)
    end
end

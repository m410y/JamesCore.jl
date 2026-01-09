"""
Abstract type to separate transformations Vec, Mat and Point fields.
"""
abstract type RigidObject end

(t::LinearMap)(obj::T) where {T<:RigidObject} = T(
    (
        fieldtype(T, name) <: Union{RigidObject,Vec,Mat} ? t(getfield(obj, name)) :
        getfield(obj, name) for name in fieldnames(T)
    )...,
)
(t::Translation)(obj::T) where {T<:RigidObject} = T(
    (
        fieldtype(T, name) <: Union{RigidObject,Point} ? t(getfield(obj, name)) :
        getfield(obj, name) for name in fieldnames(T)
    )...,
)

abstract type Axis <: RigidObject end

"""
    RotAxis{T<:Real}

Affine rotation axis. Uses function-like argument to generate affine transformation.
"""
struct RotAxis{T<:Real} <: Axis
    v::Vec3{T}
    p::Point3{T}
    RotAxis{T}(v::AbstractVector, p::AbstractVector = zero(Point3{T})) where {T} =
        new{T}(Vec3{T}(normalize(v)), Point3{T}(p))
end
RotAxis{T}(str::AbstractString) where {T<:Real} = RotAxis{T}(str2dir(str))

RotAxis(v::AbstractVector) = RotAxis{eltype(v)}(v)
RotAxis(v::AbstractVector, p::AbstractVector) = RotAxis{promote_type(eltype(v), eltype(p))}(v, p)
RotAxis(str::AbstractString) = RotAxis(Vec3(str))

# axis rotation generation
function (axis::RotAxis{T})(angle::Number) where {T}
    recenter(AngleAxis{T}(angle, axis.v..., false), axis.p)
end

"""
    TransAxis{T<:Real}

Affine translation axis. Uses function-like argument to generate translation transformation.
"""
struct TransAxis{T<:Real} <: Axis
    v::Vec3{T}
    TransAxis{T}(v::AbstractVector) where {T} =
        new{T}(Vec3{T}(normalize(v)))
end
TransAxis{T}(str::AbstractString) where {T<:Real} = TransAxis{T}(str2dir(str))

TransAxis(v::AbstractVector) = TransAxis{eltype(v)}(v)
TransAxis(v::AbstractVector, p::AbstractVector) = TransAxis{promote_type(eltype(v), eltype(p))}(v, p)
TransAxis(str::AbstractString) = TransAxis(Vec3(str))

# axis translation generation
function (axis::TransAxis{T})(distance::Number) where {T}
    Translation(axis.v * distance)
end

"""
    angle(a::AbstractVector, b::AbstractVector)

Returns angle between vectors.
"""
function Base.angle(a::AbstractVector, b::AbstractVector)
    atan(norm(cross(a, b)), dot(a, b))
end

"""
    fix_axes(axes, fixed)

Takes indexible `Axis` collection and dict-like collection of `index => parameter` pairs.
Returns resulting `Transformation` and `Vector` of residual axes.
"""
fix_axes(axes, fixed) = fix_axes(axes, Base.ImmutableDict(fixed))
fix_axes(axes, fixed::Union{AbstractVector,Tuple}) = fix_axes(axes, Base.ImmutableDict((i => el for (i, el) in enumerate(fixed))...))

function fix_axes(axes, fixed::Base.ImmutableDict)
    trans = IdentityTransformation()
    res = []
    for i in reverse(eachindex(axes))
        if haskey(fixed, i)
            trans = trans ∘ axes[i](fixed[i])
        else
            pushfirst!(res, trans(axes[i]))
        end
    end
    isempty(res) ? trans : (trans, res)
end


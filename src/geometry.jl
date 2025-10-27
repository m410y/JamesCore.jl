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
    str_to_dir(s::AbstractString)

Convert usual direction notation to vector.
"""
function str2dir(s::AbstractString)
    s == "x" ? Vec(1, 0 ,0) :
    s == "y" ? Vec(0, 1 ,0) :
    s == "z" ? Vec(0, 0 ,1) :
    s == "-x" ? Vec(-1, 0 ,0) :
    s == "-y" ? Vec(0, -1 ,0) :
    s == "-z" ? Vec(0, 0 ,-1) : error("String not supported")
end
Vec3{T}(str::AbstractString) where {T} = Vec3{T}(str2dir(str))
Vec3(str::AbstractString) = Vec3(str2dir(str))

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
RotAxis(args...) = RotAxis{Float64}(args...)
RotAxis{T}(str::AbstractString) where {T<:Real} = RotAxis{T}(str2dir(str))

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
TransAxis(args...) = TransAxis{Float64}(args...)
TransAxis{T}(str::AbstractString) where {T<:Real} = TransAxis{T}(str2dir(str))

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
    fix_angles(axes, fixed)

Takes indexible `Axis` collection and collection of `index => parameter` pairs.
Returns `Vector` of resulting axes and residual `Transformation`.
"""
function fix_axes_params(axes, fixed) 
    fixed = Dict(fixed)
    new_axes = Axis[]
    trans = IdentityTransformation()
    for i in reverse(eachindex(axes))
        if haskey(fixed, i)
            trans = trans ∘ axes[i](fixed[i])
        else
            push!(new_axes, trans(axes[i]))
        end
    end
    new_axes, trans
end

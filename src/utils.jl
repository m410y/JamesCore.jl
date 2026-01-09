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


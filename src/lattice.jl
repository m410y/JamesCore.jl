"""
    MillerIterator{N,T<:Integer,K<:Real}

Simple iterator over all interger points (aka miller indices) `v` with `dot(v, Q, v) ≤ rr`.
"""
struct MillerIterator{N,T<:Integer,K<:Real}
    Q::Mat{N,N,K}
    rr::K
    hkls::CartesianIndices{N,NTuple{N,UnitRange{T}}}

    function MillerIterator{N,T,K}(Q::AbstractMatrix, r::Real) where {N,T<:Integer,K<:Real}
        if !isposdef(Q)
            throw(ArgumentError("Matrix must be positive definite"))
        end
        q_min = minimum(svdvals(Q))
        idx_max = T(floor(abs(r) / q_min))
        hkls = CartesianIndices(Tuple(-idx_max:idx_max for _ in 1:N))
        new{N,T,K}(Mat{N,N,K}(Q), r^2, hkls)
    end
end

function MillerIterator(T::Type{<:Integer}, Q::AbstractMatrix{<:Real}, r::Real)
    N = size(Q, 1)
    if size(Q, 2) != N
        throw(DimensionMismatch("Not square matrix"))
    end
    MillerIterator{N,T,promote_type(eltype(Q),typeof(r))}(Q, r)
end

MillerIterator(Q::AbstractMatrix{<:Real}, r::Real) = MillerIterator(Int, Q, r)

function Base.iterate(iter::MillerIterator{N,T}) where {N,T}
    next = iterate(iter.hkls)
    while next != nothing
        (item, state) = next
        v = Vec{N,T}(Tuple(item))
        if !iszero(v) && dot(v, iter.Q, v) ≤ iter.rr
            return v, state
        end
        next = iterate(iter, state)
    end
    nothing
end

function Base.iterate(iter::MillerIterator{N,T}, state) where {N,T}
    next = iterate(iter.hkls, state)
    while next != nothing
        (item, state) = next
        v = Vec{N,T}(Tuple(item))
        if !iszero(v) && dot(v, iter.Q, v) ≤ iter.rr
            return v, state
        end
        next = iterate(iter.hkls, state)
    end
    nothing
end

Base.IteratorSize(::MillerIterator) = Base.SizeUnknown()
Base.eltype(::MillerIterator{N,T}) where {N,T} = Vec{N,T}

Base.isdone(iter::MillerIterator) = isnothing(iterate(iter))
Base.isdone(iter::MillerIterator, state) = isnothing(iterate(iter, state))


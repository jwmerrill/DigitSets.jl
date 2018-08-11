__precompile__()
module DigitSets

    import Base: <, <=, ⊊, ⊈

    # Bitmask is used as an indirection mechanism to allow us to
    # construct e.g. a DigitSet containing the single digit "3"
    # as DigitSet(3), while also providing a way to construct
    # a DigitSet directly from the binary representation of an
    # integer.
    struct Bitmask{T<:Integer}
        data::T
    end

    struct DigitSet
        d::UInt16
        DigitSet(b::Bitmask) = new(b.data)
    end

    # Not strictly necessary, but I'd like to keep the logic for single
    # element set construction as simple as possible.
    function DigitSet(n::Integer)
        d = UInt16(0) | UInt16(1 << (n - 1))
        DigitSet(Bitmask(d))
    end

    DigitSet() = DigitSet(Bitmask(0))

    function DigitSet(itr)
        d = UInt16(0)
        # For each digit in a, set the corresponding
        # bit in d to 1.
        for n in itr
            d |= UInt16(1 << (n - 1))
        end
        DigitSet(Bitmask(d))
    end

    function DigitSet(ns::Integer...)
        DigitSet(ns)
    end

    # Allow iterating over the members of a digit set
    Base.start(ds::DigitSet) = (ds.d, 0)
    function Base.next(ds::DigitSet, state)
      (d, n) = state
      shift = 1 + trailing_zeros(d)
      n += shift
      d >>= shift
      return (n, (d, n))
    end
    Base.done(ds::DigitSet, state) = state[1] <= 0
    Base.length(ds::DigitSet) = count_ones(ds.d)
    Base.in(n, ds::DigitSet) = (ds.d & (1 << (n - 1))) != 0
    Base.isempty(ds::DigitSet) = ds.d == 0
    Base.eltype(::Type{DigitSet}) = Int

    function Base.show(io::IO, ds::DigitSet)
      print(io, "DigitSet")
      print(io, "(")
      join(io, ds, ",")
      print(io, ")")
    end

    # Set operations
    Base.union(a::DigitSet, b::DigitSet) = DigitSet(Bitmask(a.d | b.d))
    Base.intersect(a::DigitSet, b::DigitSet) = DigitSet(Bitmask(a.d & b.d))
    Base.symdiff(a::DigitSet, b::DigitSet) = DigitSet(Bitmask(xor(a.d, b.d)))
    Base.setdiff(a::DigitSet, b::DigitSet) = DigitSet(Bitmask(a.d & (~b.d)))

    # Variadic versions of union, intersect, and symdiff. All of these
    # are associative.
    function Base.union(a::DigitSet, bs::DigitSet...)
        for b in bs
            a = union(a, b)
        end
        a
    end

    function Base.intersect(a::DigitSet, bs::DigitSet...)
        for b in bs
            a = intersect(a, b)
        end
        a
    end

    function Base.symdiff(a::DigitSet, bs::DigitSet...)
        for b in bs
            a = symdiff(a, b)
        end
    end

    # Ordering and subset relationships
    Base.issubset(a::DigitSet, b::DigitSet) = isempty(setdiff(a, b))
    <(a::DigitSet, b::DigitSet) = (length(a) < length(b)) && (a <= b)
    <=(a::DigitSet, b::DigitSet) = issubset(a, b)
    ⊊(a::DigitSet, b::DigitSet) = <(a, b)
    ⊈(a::DigitSet, b::DigitSet) = !⊆(a, b)

    export DigitSet

end

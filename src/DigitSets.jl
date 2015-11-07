__precompile__()
module DigitSets

    import Base: <, <=, ⊊, ⊈

    # RawDigitSet is used as an indirection mechanism to allow us to
    # construct a DigitSet from a single integer, while still making
    # it possible to also create a DigitSet from an unwrapped Int16
    # bitmask. It is not intended to be used by outside callers.
    immutable RawDigitSet
        d::Int16
    end

    immutable DigitSet
        d::Int16

        DigitSet(rds::RawDigitSet) = new(rds.d)
    end

    # Intentionally not exported, but you can use it as
    # DigitSets.fromBitmask(Int16(100))
    fromBitmask(d::Int16) = DigitSet(RawDigitSet(d))

    # Not strictly necessary, but I'd like to keep the logic for single
    # element set construction as simple as possible.
    function DigitSet(n::Integer)
        d = Int16(0) | Int16(1 << (n - 1))
        fromBitmask(d)
    end

    function DigitSet(itr)
        d = Int16(0)
        # For each digit in a, set the corresponding
        # bit in d to 1.
        for n in itr
            d |= Int16(1 << (n - 1))
        end
        fromBitmask(d)
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

    function Base.show(io::IO, ds::DigitSet)
      print(io, "DigitSet")
      print(io, "(")
      print_joined(io, ds, ",")
      print(io, ")")
    end

    # Set operations
    Base.union(a::DigitSet, b::DigitSet) = fromBitmask(a.d | b.d)
    Base.intersect(a::DigitSet, b::DigitSet) = fromBitmask(a.d & b.d)
    Base.symdiff(a::DigitSet, b::DigitSet) = fromBitmask(a.d $ b.d)
    Base.setdiff(a::DigitSet, b::DigitSet) = fromBitmask(a.d & (~b.d))

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

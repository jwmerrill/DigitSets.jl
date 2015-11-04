using DigitSets
using Base.Test

const a = DigitSet(1, 2, 7)
const b = DigitSet(2, 5)

@test length(a) == 3
@test length(b) == 2
@test !isempty(a)
@test isempty(DigitSet())
@test collect(Int, a) == [1, 2, 7]
@test collect(Int, b) == [2, 5]
@test 1 in a
@test 2 in a
@test 7 in a
@test !(5 in a)
@test 2 in b
@test 5 in b
@test !(7 in b)
@test a == DigitSet(collect(a))
@test b == DigitSet(collect(b))
@test DigitSet(1:9) == DigitSet(1, 2, 3, 4, 5, 6, 7, 8, 9)

@test union(a, b) == DigitSet(1, 2, 5, 7)
@test union(a, b) == union(b, a)
@test intersect(a, b) == DigitSet(2)
@test intersect(a, b) == intersect(b, a)
@test setdiff(a, b) == DigitSet(1, 7)
@test setdiff(b, a) == DigitSet(5)
@test symdiff(a, b) == DigitSet(1, 5, 7)
@test symdiff(a, b) == symdiff(b, a)
@test union(DigitSet(), a) == a
@test union(a, DigitSet()) == a
@test intersect(a, DigitSet()) == DigitSet()
@test intersect(DigitSet(), a) == DigitSet()
@test setdiff(a, DigitSet()) == a
@test setdiff(DigitSet(), a) == DigitSet()
@test symdiff(a, DigitSet()) == a
@test symdiff(DigitSet(), a) == a

@test issubset(a, a)
@test a ⊆ a
@test issubset(b, b)
@test b ⊆ b
@test !issubset(a, b)
@test a ⊈ b
@test !issubset(b, a)
@test b ⊈ a
@test issubset(DigitSet(), a)
@test DigitSet() ⊆ a
@test issubset(DigitSet(), b)
@test DigitSet() ⊆ b
@test issubset(DigitSet(), DigitSet())
@test DigitSet() ⊆ DigitSet()
@test !issubset(a, DigitSet())
@test a ⊈ DigitSet()
@test !issubset(b, DigitSet())
@test b ⊈ DigitSet()
@test issubset(DigitSet(1), a)
@test DigitSet(1) ⊆ a
@test issubset(DigitSet(1, 2), a)
@test DigitSet(1, 2) ⊆ a
@test issubset(DigitSet(5), b)
@test DigitSet(5) ⊆ b
@test !(a < a)
@test !(a ⊊ a)
@test !(a < b)
@test !(a ⊊ b)
@test DigitSet(1, 2) < a
@test DigitSet(1, 2) ⊊ a

@test (@sprintf "%s" a) == "DigitSet(1,2,7)"
@test (@sprintf "%s" DigitSet()) == "DigitSet()"


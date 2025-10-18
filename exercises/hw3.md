1.  Tree t ≅ t + (Tree t × Tree t)

2. For a, n ∈ N:
a^0 = 1
a^(n+1) = a^n x a

3. a: inl(True), inl(False), inr(∗)
Cardinality: 3

b: true, false, and *
cardinality: 3

4. a: Pairs (b , ∗) where b ∈ {True , False}:
(True , ∗), (False , ∗)
cardinality: 2

b: the constant function sending both True and False to ∗
cardinalty: 1

5. Too many meanings in one type, Unicode is hard, Security pitfalls, APIs should encode intent

6. No because self application forces a type equation τ = τ → σ which has no finite solution

7. x ∈ A iff XA​(x) = false

8. A function is a pure function if its result depends only on its inputs and it has no side effects.
we care because:
it has easier reasoning, proofs, better testing, caching/memoization, and refactoring.

9. Haskell marks effects in types so pure functions can’t mix with impure ones. Effects are values sequenced via monads and only run at the top level.

10. & is closer to inheritance, because a value of type A & B must have all the members of both A and B, like a subclass that combines its parents APIs in TypeScript’s structural type system
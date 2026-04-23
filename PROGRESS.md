# DarthSheaf Progress

## Completed ✓

### SCAL (Vector Scaling)
- **Implementation:** Recursive pattern matching with three cases (empty, single, multiple)
- **Tests:** All 3 passing (scales correctly, zero scalar, identity scalar)
- **Pattern:** `scal c [] = []` → `scal c (x:xs) = c*x : scal c xs`
- **Learning:** Loop structure, indexing, recursion foundation

### AXPY (Scaled Vector Addition)
- **Implementation:** Recursive pattern matching with two vectors
- **Tests:** All 3 passing (basic addition, alpha=0, alpha=1)
- **Pattern:** `axpy c [] [] = []` → `axpy c (x:xs) (y:ys) = c*x + y : axpy c xs ys`
- **Learning:** Memory fusion (avoided composing SCAL + ADD), reduction in single pass

### DOT (Dot Product)
- **Implementation:** Already provided as reference example
- **Uses:** `sum (zipWith (*) x y)` — clean functional approach
- **Tests:** All 3 passing (basic computation, zero vector, commutativity)

---

## To Do

### Phase 1: Core Operations (Reduction ops with numerical hazards)
- **DOTC** — Conjugate dot product (for API completeness; same as DOT for reals)
- **NRML2** — 2-norm with overflow/underflow handling (most complex reduction)
- **ASUM** — Sum of absolute values (simpler reduction, good stepping stone)

### Phase 2: Utilities
- **IAMAX** — Index of max absolute value (search operation)
- **COPY** — Copy vector (memory baseline)
- **SWAP** — Swap two vectors (immutability advantage demo)

### Phase 3: Advanced
- **ROT** — Givens rotation (parametric transformation)
- **ROTMG** — Generate rotation parameters (numerical robustness edge cases)

---

## Key Insights Learned

1. **Composition can be an elegant footgun:** AXPY could be written as `add (scal c x) y`, but that traverses the vector twice. Direct implementation in one pass is clearer and teaches memory access patterns.

2. **Pattern matching elegance:** Haskell's pattern matching makes the recursive structure of vector operations crystal clear. Compare `scal c (x:xs) = c*x : scal c xs` to imperative loop syntax.

3. **Compiler warnings are useful:** Non-exhaustive pattern matching caught the "what if vectors differ in length?" case, forcing explicit handling or documentation.

---

## Next Session Focus

Start with **NRML2** (2-norm). It's the first operation that demands numerical care:
- Risk of overflow when squaring large values
- Risk of underflow with small values
- Requires scaling strategy: `max(|x_i|) * sqrt(sum((x_i/max)^2))`

This operation teaches why BLAS kernels are complex—they solve real problems.

---

## Testing Strategy

- Tests are written **before** implementation (TDD)
- Each operation gets 3–5 test cases covering:
  - Basic correctness
  - Edge cases (zero vector, single element, empty)
  - Properties (commutativity, associativity, stability)
- QuickCheck properties can replace some manual tests later

---

## Build & Test

```bash
cabal build                              # Compile
cabal test --test-show-details=streaming # Run tests with details
cabal repl                               # Interactive REPL for experimentation
```

---

## Teaching Notes

This project follows the **sensei-halp** methodology (see SKILL.md):
- Three phases: Pseudocode (chat) → Python (.py) → Haskell (.hs)
- Idiom-locking: Once a learning path starts, stick with it (recursion vs. comprehensions)
- Learning by doing: Claude refuses to write code; student discovers through constraint-based guidance

Current idiomatic constraint: **Recursion only** (no list comprehensions or higher-order abstractions until explicitly changed).

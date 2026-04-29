# DarthSheaf Progress

## Completed ✓

### SCAL (Vector Scaling)
- **Implementation:** Recursive pattern matching — `scal c [] = []` → `scal c (x:xs) = c*x : scal c xs`
- **Tests:** Passing (scales correctly, zero scalar, identity scalar)
- **Learning:** Loop structure, recursion foundation, performance baseline

### AXPY (Scaled Vector Addition)
- **Implementation:** Recursive over two vectors simultaneously
- **Pattern:** `axpy c [] [] = []` → `axpy c (x:xs) (y:ys) = c*x + y : axpy c xs ys`
- **Tests:** Passing (basic addition, alpha=0, alpha=1)
- **Learning:** Memory fusion — single pass avoids double traversal of SCAL + ADD composition

### DOT (Dot Product)
- **Implementation:** Recursive accumulation — `dot (x:xs) (y:ys) = x*y + dot xs ys`
- **Tests:** Passing (basic computation, zero vector, commutativity)
- **Learning:** Reduction patterns, floating-point accumulation, summation order matters

### DOTC (Conjugate Dot Product)
- **Implementation:** `dotc = dot` (conjugation is identity for real vectors)
- **Tests:** Passing
- **Learning:** Why complex variants exist in BLAS; real case is trivially identical

### ASUM (Sum of Absolute Values)
- **Implementation:** Recursive — `asum (x:xs) = abs x + asum xs`
- **Tests:** Passing
- **Learning:** Simpler reduction than NRML2; no squaring means underflow is unlikely

### IAMAX (Index of Max Absolute Value)
- **Implementation:** Recursive search carrying the tail index, returns `Maybe Int`
- **Pattern:** Recurse on tail, compare head against `xs!!index`, adjust index
- **Tests:** Passing (basic, empty, single element)
- **Learning:** Search with index tracking, `Maybe` for empty case, 0-based indexing

### COPY (Copy Vector)
- **Implementation:** `copy = id` (identity — Haskell sharing makes copying free)
- **Learning:** Memory bandwidth baseline; immutability means "copy" is structural sharing

### SWAP (Swap Two Vectors)
- **Implementation:** `swap x y = (y, x)`
- **Learning:** Why Haskell's immutability is an advantage — no temporary buffer needed

### ROT (Givens Rotation)
- **Implementation:** `rot c s x y = (axpy 1 (scal c x) (scal s y), axpy (-1) (scal s x) (scal c y))`
- **Learning:** Parametric transformations, composed BLAS ops, coupled updates

---

## Remaining ⋯

### NRML2 (Euclidean 2-norm) — `= undefined`
- **Hazard:** Squaring can overflow (|x_i|² > 1e308) or underflow (|x_i|² < 1e-308)
- **Safe algorithm:** `max(|x_i|) * sqrt(Σ (x_i / max)²)`
- **Next focus:** This is the key numerical stability exercise

### ROTMG (Generate Givens Parameters) — `= undefined`
- Most numerically complex op in BLAS L1
- Implement last; requires careful scaling logic

---

## Key Insights

1. **Composition can be an elegant footgun:** AXPY written as `add (scal c x) y` traverses twice. Direct single-pass implementation is clearer and more efficient.

2. **Pattern matching elegance:** Recursive structure of vector ops maps cleanly to cons-cell decomposition. The base/recursive cases read like a math definition.

3. **Immutability as feature:** COPY is `id` and SWAP is a tuple flip — no mutation means no aliasing bugs possible.

4. **Compiler warnings are useful:** Non-exhaustive pattern matching catches differing-length vector cases, forcing explicit handling.

---

## Testing Strategy

- Tests written **before** implementation (TDD)
- Each op: 3–5 cases covering basic correctness, edge cases (empty, single element, zero), and properties
- QuickCheck properties for commutativity, associativity, stability

```bash
cabal build
cabal test --test-show-details=streaming
cabal repl
```

---

## Teaching Notes

Follows **sensei-halp** methodology (see SKILL.md):
- Three phases: Pseudocode → Python → Haskell
- **Current idiom lock: recursion-only** (no list comprehensions or higher-order abstractions)
- Claude refuses to write implementations; student discovers through constraint-based guidance

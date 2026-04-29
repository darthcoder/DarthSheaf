# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Teaching Methodology

This project uses the **sensei-halp** approach defined in `SKILL.md`. **Read SKILL.md first.** Key constraints:

1. **Three-phase learning:** Each concept goes Pseudocode (chat) → Python (.py file) → Haskell (.hs file). Do not skip phases.
2. **Idiom-locking:** Once Phase 2 begins, learning style is locked (recursion-only or comprehension-only). Student picks one path and walks it through all three phases. **Current idiom: recursion-only** (no list comprehensions or higher-order abstractions yet).
3. **No code generation:** Guide by constraint and analogy, never by writing implementations. When asked to write code, offer a smaller problem instead.
4. **Lazy-proofing:** If student skips a phase or pastes external code, drag them back to understanding first with smaller examples.

## Project Overview

**DarthSheaf:** Implement BLAS Level 1 operations (vector-vector) in pure Haskell, focusing on correctness, numerical stability, and pedagogical clarity.

**Philosophy:** This is a learning project, not production BLAS. Goal: understand why each operation matters and how numerical hazards arise. See `darthsheaf-scope.md` for portfolio context and timeline (September 1 deadline for October application).

## Quick Start

```bash
cabal build          # build the library
cabal test           # run the full test suite
cabal bench          # run benchmarks (if criterion is installed)
cabal repl           # open GHCi with the library loaded
hlint src/           # lint (if hlint is installed)
```

To run tests with detailed output:
```bash
cabal test --test-show-details=streaming
```

To explore tests interactively:
```bash
cabal repl test:darthsheaf-test
```

---

## Current State

**See `PROGRESS.md` for the canonical status tracker** (may lag behind actual code; verify against `BlasL1.hs`). It logs completed ops, test results, and learning insights per operation.

Quick snapshot:
- **Implemented:** SCAL, AXPY, DOT, DOTC, IAMAX, ASUM, COPY, SWAP, ROT (with tests)
- **Pending:** NRML2, ROTMG (`= undefined` stubs)

Note: PROGRESS.md lags significantly behind the code — trust `BlasL1.hs` over PROGRESS.md for actual status.
- `test/Main.hs` — Tests written for implemented ops; stubs for pending
- `bench/Main.hs` — Benchmark structure ready to fill in
- `tries.hs` — Scratchpad for learning patterns (in .gitignore)

## Architecture

**Public API:** `src/DarthSheaf.hs` re-exports all operations.

**Core operations:** `src/DarthSheaf/BlasL1.hs` — All 10 BLAS Level 1 ops, each with:
- Full type signature
- Comprehensive docstring explaining purpose and numerical hazards
- Learning focus (what concept it teaches)
- Implemented ops (SCAL, AXPY, DOT, DOTC, IAMAX, ASUM) as reference examples

**Higher-level algorithms track:** `src/DarthSheaf/CramerGeneral.hs` (and upcoming `LUGeneral.hs`, `CholeskyGeneral.hs`) form a second track: classical numerical methods from *Numerical Recipes*, reimplemented in pure Haskell. Conventions for this track:
- `type Matrix a = [[a]]` — dense matrix as list of rows
- Return types use `Either String result` for graceful failure (e.g., zero pivot, singular matrix)
- Module style: Haddock docstrings, exported types and functions — use `CramerGeneral.hs` as the reference

**Types (BLAS track):**
- `Vector = [Double]` — dense vector
- Indices are 0-based

**Operations (in learning order):**

| Status | Op | Signature | What It Does | Learning Focus |
|---|---|---|---|---|
| ✓ | **SCAL** | `scal :: Double -> Vector -> Vector` | Scale: `y := α·x` | Loop structure, baseline performance |
| ✓ | **AXPY** | `axpy :: Double -> Vector -> Vector -> Vector` | Add scaled: `y := α·x + y` | Memory access patterns, vectorization |
| ✓ | **DOT** | `dot :: Vector -> Vector -> Double` | Dot product: `Σ(x_i · y_i)` | Accumulation, numerical stability |
| ✓ | **DOTC** | `dotc :: Vector -> Vector -> Double` | Dot product (conjugate, for C) | Stability with complex numbers |
| ✓ | **IAMAX** | `iamax :: Vector -> Maybe Int` | Index of max absolute value | Search operations, index tracking |
| ✓ | **ASUM** | `asum :: Vector -> Double` | Sum of absolute values: `Σ\|x_i\|` | Simpler accumulation |
| ⋯ | **NRML2** | `nrml2 :: Vector -> Double` | 2-norm: `sqrt(Σ x_i²)` | Overflow/underflow handling |
| ✓ | **COPY** | `copy :: Vector -> Vector` | Copy vector | Memory bandwidth baseline |
| ✓ | **SWAP** | `swap :: Vector -> Vector -> (Vector, Vector)` | Swap two vectors in-place (Haskell: returns pair) | Memory aliasing, immutability |
| ✓ | **ROT** | `rot :: Double -> Double -> Vector -> Vector -> (Vector, Vector)` | Givens rotation | Parametric transformations |
| ⋯ | **ROTMG** | `rotmg :: Double -> Double -> Double -> Double -> (Double, Double, Double, Double)` | Generate Givens parameters | Numerical robustness edge cases |

---

## Development Workflow

### Adding/Updating an Operation

1. Implement in `src/DarthSheaf/BlasL1.hs` with a comment block explaining numerical hazards
2. Add QuickCheck properties in `test/Main.hs`
3. Add criterion benchmarks in `bench/Main.hs` (if benchmarking)
4. Re-test: `cabal test`
5. Compare performance: `cabal bench` (optional, but recommended for reduction ops)

### Testing Strategy

- **Correctness:** QuickCheck properties (commutativity, associativity, edge cases)
- **Stability:** Manual tests for overflow/underflow (especially NRML2)
- **Boundary conditions:** Empty vectors, single-element vectors, NaNs, infinities

### Benchmarking

Compare against:
- Pure Haskell list operations (baseline)
- `Data.Vector` operations (if using Vector library)
- BLAS itself (reference, not a goal to match)

---

## How to Work With This Project

When the student asks for help implementing an operation:

1. **Refuse to write implementations.** If asked to write code, offer a smaller problem instead. The student builds skill by doing, not reading.
2. **Reference docstrings.** Each operation in `BlasL1.hs` has full explanation, numerical hazards, and learning focus. These are your guides.
3. **Use implemented ops as references.** SCAL, AXPY, DOT, DOTC, IAMAX, ASUM are done—show them as patterns, not code to copy. Point to PROGRESS.md for insights on what each taught.
4. **Guide by constraint, not hints.** Don't explain the answer; constrain the problem. "What's the simplest case? How do you combine two results?" Let them discover the structure.
5. **Check the phase.** No file open? Phase 1 (pseudocode in chat). .py file selected? Phase 2 (Python). .hs file? Phase 3 (Haskell). If skipping phases, drag them back.
6. **Prefer sequential execution.** Avoid parallel tool calls; keep cognitive load low for both parties.
7. **Tests first, then code.** Student writes test assertions, then implementation. Use tests to reveal what's missing.

## Design Principles

1. **Correctness first** — numerical accuracy matters more than micro-optimizations
2. **Clarity over cleverness** — each operation should be readable and well-commented
3. **No external deps for core ops** — use only base Haskell; benchmarks can use criterion/quickcheck
4. **Immutability is a feature** — leverage Haskell's purity for correctness reasoning
5. **Document the hazards** — every reduction op needs a comment on numerical stability
6. **Learning by doing** — the student implements; Claude provides structure and feedback, not answers

---

## Deliverables

By end of timeline:
- [ ] All 10 ops implemented and tested (`src/DarthSheaf/BlasL1.hs`)
- [ ] QuickCheck properties covering correctness and edge cases
- [ ] `README.md` explaining why each op matters
- [ ] Blog post (~500+ words) on ONE op (e.g., DOT product stability)
- [ ] Example: use the ops to build a simple algorithm (e.g., vector normalization)
- [ ] Benchmarks showing reasonable performance vs. naive alternatives

---

## Reference Documents

- **`SKILL.md`** — The sensei-halp teaching framework. Read this to understand the three-phase approach and idiom-locking.
- **`PROGRESS.md`** — Canonical status tracker. Logs completed ops, test results, and learning insights per operation. Check this for current state.
- **`darthsheaf-scope.md`** — Portfolio context, timeline (September 1 deadline), and success criteria.

## Notes

- `Vector` is currently `[Double]` for simplicity; future: migrate to `Data.Vector.Unboxed` for performance
- Reduction operations (DOT, NRML2) warrant extra care for numerical stability
- ROTMG is the most complex; implement last
- Each operation should have 3–5 test cases minimum

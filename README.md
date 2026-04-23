# DarthSheaf: BLAS Level 1 in Pure Haskell

This is a **learning project**, not production code. The goal is to understand BLAS Level 1 operations (vector-vector) through implementation in pure Haskell, with a focus on correctness, numerical stability, and pedagogical clarity.

## Why This Matters

BLAS (Basic Linear Algebra Subprograms) is foundational to numerical computing. By implementing these operations from scratch, you learn:

- Why each operation matters and what problems it solves
- How floating-point arithmetic creates numerical hazards (overflow, underflow, precision loss)
- Why memory access patterns and reduction strategies matter for performance
- The bridge between mathematical elegance and computational reality

## Operations Implemented

| Op | Status | What It Does | Learning Focus |
|---|---|---|---|
| **SCAL** | ✓ | Scale: `y := α·x` | Loop structure, baseline performance |
| **AXPY** | ✓ | Add scaled: `y := α·x + y` | Memory access patterns, loop fusion |
| **DOT** | ✓ | Dot product: `Σ(x_i · y_i)` | Accumulation, numerical stability |
| **DOTC** | ⋯ | Dot product (conjugate) | Stability with complex numbers |
| **NRML2** | ⋯ | 2-norm: `sqrt(Σ x_i²)` | Overflow/underflow handling |
| **ASUM** | ⋯ | Sum of absolute values | Simpler accumulation |
| **IAMAX** | ⋯ | Index of max absolute value | Search operations |
| **COPY** | ⋯ | Copy vector | Memory bandwidth |
| **SWAP** | ⋯ | Swap two vectors | Memory aliasing |
| **ROT** | ⋯ | Givens rotation | Parametric transformations |
| **ROTMG** | ⋯ | Generate Givens parameters | Numerical robustness |

## Quick Start

```bash
cabal build          # build the library
cabal test           # run the full test suite
cabal repl           # open GHCi with the library loaded
```

To run tests with detailed output:
```bash
cabal test --test-show-details=streaming
```

## Project Philosophy

1. **Correctness first** — numerical accuracy matters more than micro-optimizations
2. **Clarity over cleverness** — each operation should be readable and well-commented
3. **Document the hazards** — every reduction operation includes notes on numerical stability
4. **Learning by doing** — this is a student project; implementations are built through understanding, not copying

## Architecture

- `src/DarthSheaf/BlasL1.hs` — All 10 BLAS Level 1 operations
- `src/DarthSheaf.hs` — Public API (re-exports all operations)
- `test/Main.hs` — QuickCheck properties and correctness tests
- `bench/Main.hs` — Performance benchmarks (criterion)

**Type:** `Vector = [Double]` (dense vector of floating-point numbers)

## Design Notes

- `Vector` is currently `[Double]` for simplicity; future versions may migrate to `Data.Vector.Unboxed` for performance
- No external dependencies for core operations (only base Haskell)
- Each operation includes a comprehensive docstring explaining its purpose and numerical hazards
- Tests drive development: assertions are written before implementation

## References

- See `darthsheaf-scope.md` for portfolio context and timeline
- See `SKILL.md` for the sensei-halp teaching methodology used in this project

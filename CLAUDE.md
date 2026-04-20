# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

**Load in GHCi (interactive REPL):**
```
ghci CramerGeneral.hs
```

**Compile with GHC:**
```
ghc CramerGeneral.hs
```

**Lint (if hlint is available):**
```
hlint CramerGeneral.hs
```

No build system (cabal/stack) is configured. The project is a single standalone module.

## Architecture

`CramerGeneral.hs` is a single Haskell module implementing **Cramer's Rule** for solving systems of linear equations `Ax = b`.

- `det` computes the determinant by summing over all `n!` permutations — this is O(n! · n) and not intended for large matrices.
- `cramer` is the primary API: returns `Nothing` when `det(A) = 0` (singular), otherwise `Just` the solution vector.
- `replaceCol` is a helper used internally by `cramer` to construct the modified matrices `A_j`.
- `BangPatterns` is enabled for strict evaluation on accumulator patterns.

The `permutations` function from `Data.List` generates all permutations of column indices; `Data.Map.Strict` is imported but currently unused.

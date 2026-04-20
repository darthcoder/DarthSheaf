# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```
cabal build          # build the library
cabal test           # run the test suite
cabal repl           # open GHCi with the library loaded
cabal repl test:dartsheaf-test   # open GHCi in test context
hlint src/           # lint (if hlint is installed)
```

To run a single test file directly: `cabal test --test-show-details=streaming`.

## Architecture

DarthSheaf is an extensible Haskell linear algebra library. The public API is re-exported through `src/DarthSheaf.hs`; each algorithm lives in its own module under `src/DarthSheaf/`.

**Current modules:**
- `DarthSheaf.CramerGeneral` — Cramer's Rule solver for n×n systems (`cramer :: Matrix -> Vector -> Maybe Vector`). Uses a permutation-sum determinant (O(n!·n)) — correct but only practical for small n.

**Adding a new algorithm:**
1. Create `src/DarthSheaf/YourModule.hs` with `module DarthSheaf.YourModule where`.
2. Add it to `exposed-modules` in `DarthSheaf.cabal`.
3. Re-export it from `src/DarthSheaf.hs`.
4. Add tests in `test/Main.hs`.

**Types** (`Matrix = [[Double]]`, `Vector = [Double]`) are defined in `DarthSheaf.CramerGeneral` and shared across modules.

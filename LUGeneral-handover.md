# Task
Implement `LUGeneral.hs` for the DarthSheaf pure Haskell numerical library.

# Context
DarthSheaf is a pure Haskell reimplementation of Numerical Recipes. Two modules already live:
- `CramerGeneral.hs` — Cramer's Rule, exact, O(n! × n), uses `[[a]]` as Matrix
- `CholeskyGeneral.hs` — Cholesky decomposition, SPD gate + solver, same representation

Existing convention:
```haskell
type Matrix a = [[a]]
```
Return types use `Either String` for graceful failure. READMEs quote the original mathematician.

# What to build
Doolittle LU decomposition — **no partial pivoting** (deliberate tradeoff: fast on meaningful matrices, breaks gracefully on random ones).

## Types
```haskell
type Matrix a = [[a]]

data LUFactorization a = LUFactorization
  { luPacked :: Matrix a
    -- L lives BELOW the diagonal (implicit unit 1s, never stored)
    -- U lives ON and ABOVE the diagonal
  , luSize   :: Int
  }
```

## Core function
```haskell
doolittle :: (Fractional a, Eq a) => Matrix a -> Either String (LUFactorization a)
```
- Returns `Left "zero pivot at row k"` on zero pivot (where k is 0-indexed)
- Returns `Right (LUFactorization packed n)` on success

## Derived functions
```haskell
-- Forward substitution: solve Ly = b (L is unit lower triangular)
forwardSub :: (Fractional a) => Matrix a -> [a] -> [a]

-- Back substitution: solve Ux = y
backSub :: (Fractional a) => Matrix a -> [a] -> [a]

-- Full solver: given LU factorization, solve Ax = b
luSolve :: (Fractional a, Eq a) => LUFactorization a -> [a] -> Either String [a]

-- Determinant: product of U's diagonal (the packed matrix's diagonal)
luDeterminant :: (Fractional a, Eq a) => LUFactorization a -> a
```

# Algorithm (Doolittle fill loop)
For k = 0 to n-1:
1. Fill U's row k:
   `U[k][j] = A[k][j] - sum(L[k][m] * U[m][j] for m in 0..k-1)` for j >= k
2. Check pivot: if `U[k][k] == 0` return `Left`
3. Fill L's column k:
   `L[i][k] = (A[i][k] - sum(L[i][m] * U[m][k] for m in 0..k-1)) / U[k][k]` for i > k
4. Pack into single matrix: L below diagonal, U on and above

# Constraints
- Pure Haskell, no external numerical libraries
- `[[a]]` representation throughout — no vectors, no arrays
- `Fractional a, Eq a` constraint only — no `Ord` needed
- No partial pivoting — zero pivot is a `Left`, not a recovery path
- Follow existing module style from `CramerGeneral.hs` (check that file for exports, module header, Haddock style)
- README section should quote Doolittle or a relevant numerical methods figure — match the Cramer README's character

# Done when
- [ ] `doolittle` compiles and returns correct packed matrix for a 3×3 example
- [ ] `luSolve` produces correct solution vector
- [ ] `luDeterminant` matches `CramerGeneral` determinant on same input
- [ ] Zero pivot returns `Left` with row index in message
- [ ] Module exports clean — same pattern as `CramerGeneral.hs`
- [ ] README updated with `LUGeneral` row in the NR roadmap table (see below)

# README addition (NR roadmap table)
Add or update this table in `README.md`:

```markdown
## North Star

DarthSheaf is a pure Haskell reimplementation of *Numerical Recipes* —
the classical numerical methods canon, rebuilt without apology in a
strongly-typed functional setting.

### Roadmap (NR chapters as modules)

| Module | Method | Status |
|---|---|---|
| `CramerGeneral` | Cramer's Rule (exact, O(n! × n)) | ✅ Live |
| `CholeskyGeneral` | Cholesky decomposition (SPD gate + solver) | ✅ Live |
| `LUGeneral` | Doolittle LU (no pivoting, fast on meaningful matrices) | 🔨 In progress |
| `SVDGeneral` | Singular Value Decomposition | ⬜ Planned |
| `QRGeneral` | QR factorization | ⬜ Planned |
| `FFTGeneral` | Fast Fourier Transform | ⬜ Planned |
```

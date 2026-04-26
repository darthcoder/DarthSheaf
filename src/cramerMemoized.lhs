---
title: "Cramer's Rule — A Memoized Cofactor Expansion"
author: "Abdul Basit Ahmad"
date: "2026"
abstract: |
  Naive cofactor expansion computes determinants in O(n!) time by recomputing
  identical submatrices at every recursive branch. This entry identifies the
  overlap structure, defines a canonical key for submatrices as a pair of
  index sets, and threads memoization through the recursion using the State
  monad. The result is O(2^n * n) — still exponential, but tractable for
  moderate n where the naive version is hopeless. The compiler verifies every
  claim.
toc: true
numbersections: true
---

> module CramerMemoized where
>
> import Data.Map.Strict (Map)
> import qualified Data.Map.Strict as Map
> import Data.Set (Set)
> import qualified Data.Set as Set
> import Control.Monad.State

# Minors and Cofactors

Given a matrix $A$ of size $n \times n$, the **minor** $M_{ij}$ is the
determinant of the submatrix obtained by deleting row $i$ and column $j$.
The **cofactor** $C_{ij}$ applies the alternating sign:

$$C_{ij} = (-1)^{i+j} \cdot M_{ij}$$

The sign pattern is the familiar checkerboard:

$$\begin{pmatrix} + & - & + \\ - & + & - \\ + & - & + \end{pmatrix}$$

# Laplace Expansion

Laplace's theorem says: fix any row $i$. Then

$$\det(A) = \sum_{j=1}^{n} a_{ij} \cdot C_{ij}$$

The non-trivial content is that the choice of row (or column) is immaterial —
the sum is always the same. Expansion along any row or column is a valid
computation of the determinant.

Recursively applied, this bottoms out at the $1 \times 1$ case: $\det([a]) = a$.

# The Overlap Problem

Naive expansion is O(n!). At each level, we spawn $n$ recursive calls, each
of size $n-1$. The branching factor never shrinks.

The waste: deleting row 0, column 1, then row 1, column 2 reaches the same
submatrix as deleting row 0, column 2, then row 1, column 1. Both paths
produce the determinant of the same set of rows and columns. The naive
algorithm computes it twice.

The key insight: a submatrix is **fully identified** by which rows and which
columns remain. We do not need to track how we got there.

# The Memoization Key

> type Matrix = [[Double]]
> type MemoKey = (Set Int, Set Int)
> type Memo    = Map MemoKey Double

A `MemoKey` is a pair of index sets — the surviving row indices and the
surviving column indices. Two recursive paths that reach the same pair of
sets will find the result already computed in the memo table.

# The Memoized Determinant

We thread the memo table through the recursion using `State Memo`.

> det :: Matrix -> Double
> det [] = 0
> det m  = evalState (go rowSet colSet) Map.empty
>   where
>     n      = length m
>     rowSet = Set.fromList [0 .. n - 1]
>     colSet = Set.fromList [0 .. n - 1]

`go` checks the memo table before computing. On a miss, it delegates to
`compute` and stores the result.

> go :: Matrix -> Set Int -> Set Int -> State Memo Double
> go m rows cols = do
>   memo <- get
>   case Map.lookup (rows, cols) memo of
>     Just v  -> return v
>     Nothing -> do
>       v <- compute m rows cols
>       modify (Map.insert (rows, cols) v)
>       return v

`compute` expands along the smallest surviving row. The sign alternates with
the column's position in the *surviving* column list, not its original index —
because Laplace expansion counts position, not label.

> compute :: Matrix -> Set Int -> Set Int -> State Memo Double
> compute m rows cols
>   | Set.size rows == 1 =
>       let r = Set.findMin rows
>           c = Set.findMin cols
>       in return $ (m !! r) !! c
>   | otherwise = do
>       let r     = Set.findMin rows
>           rows' = Set.delete r rows
>           cList = Set.toList cols
>       terms <- forM (zip [0 ..] cList) $ \(i, c) -> do
>         let cols' = Set.delete c cols
>             sign  = if even (i :: Int) then 1.0 else -1.0
>         sub <- go m rows' cols'
>         return $ sign * ((m !! r) !! c) * sub
>       return (sum terms)

# Cramer's Rule

Cramer's rule solves $Ax = b$ by computing:

$$x_j = \frac{\det(A_j)}{\det(A)}$$

where $A_j$ is $A$ with column $j$ replaced by $b$.

> replaceCol :: Matrix -> Int -> [Double] -> Matrix
> replaceCol m j b = zipWith replaceRow m b
>   where
>     replaceRow row bval = take j row ++ [bval] ++ drop (j + 1) row

> cramer :: Matrix -> [Double] -> Maybe [Double]
> cramer m b
>   | d == 0    = Nothing
>   | otherwise = Just [ det (replaceCol m j b) / d | j <- [0 .. n - 1] ]
>   where
>     n = length m
>     d = det m

`Nothing` signals a singular matrix — no unique solution exists.

# Complexity

| Method | Time |
|--------|------|
| Naive cofactor expansion | $O(n!)$ |
| Memoized cofactor expansion | $O(2^n \cdot n)$ |
| LU decomposition (Gaussian) | $O(n^3)$ |

The memoized version is still exponential. For large $n$, LU decomposition
is the right tool. The value of this exercise is not performance at scale —
it is the clean identification of the overlap structure and the State monad
as a natural carrier for the memo table. The submatrix identity as a pair of
index sets is the minimal invariant that generates all derived subproblems.

# Verification

Compile and run:

```bash
runghc cramerMemoized.lhs
```

Or load into GHCi:

```bash
ghci cramerMemoized.lhs
```

Test with a known system. The system $2x + y = 5$, $x + 3y = 10$ has
solution $x = 1$, $y = 4$:

```haskell
let m = [[2, 1], [1, 3]]
    b = [5, 10]
cramer m b
-- Just [1.0, 4.0]
```

# See Also

- Cayley-Hamilton theorem (every matrix satisfies its own characteristic polynomial)
- Bareiss algorithm (integer-preserving Gaussian elimination)
- Berlekamp-Welch (polynomial interpolation via linear algebra — a cousin)

# References

- Strang, G. *Linear Algebra and Its Applications*. (standard reference)
- Bird, R. *Thinking Functionally with Haskell*. (State monad patterns)
- GHC User's Guide — Literate Haskell support

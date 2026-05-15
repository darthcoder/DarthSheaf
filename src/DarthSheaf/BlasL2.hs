{- |
Module      : DarthSheaf.BlasL2
Description : BLAS Level 2 operations (matrix-vector) in pure Haskell
Copyright   : (c) 2026
License     : MIT

This module implements the core BLAS Level 2 operations: matrix-vector multiplies,
rank-1 and rank-2 updates, triangular multiplies, and triangular solves. Each
operation is annotated with its numerical hazards and learning focus.

Type aliases:
  - Vector = [Double]    (re-exported from "DarthSheaf.BlasL1")
  - Matrix = [[Double]]  (row-major: outer list is rows, inner list is the row's entries)

Design principles:
  1. Correctness first — accuracy and shape compatibility matter
  2. Clarity — reductions and updates spelled out, not point-free
  3. Reuse — Level 2 ops are built on Level 1 ops (DOT, AXPY, SCAL, ...)
  4. Document hazards — every reduction/solve needs a stability note

NOTE: All operations are currently stubs (= 'undefined'). They are the next
weights for the student to lift. See 'SKILL.md' for the three-phase methodology.
-}
module DarthSheaf.BlasL2 (
    -- * Types
    Vector,
    Matrix,
    UpLo (..),
    Trans (..),

    -- * GEMV: General matrix-vector multiply
    gemv,

    -- * GER: General rank-1 update
    ger,

    -- * TRMV: Triangular matrix-vector multiply
    trmv,

    -- * TRSV: Triangular solve
    trsv,

    -- * SYMV: Symmetric matrix-vector multiply
    symv,

    -- * SYR: Symmetric rank-1 update
    syr,

    -- * SYR2: Symmetric rank-2 update
    syr2,
) where

import DarthSheaf.BlasL1 (Vector)

-- | Dense matrix in row-major form: a list of rows, each row a list of doubles.
--   For an m-by-n matrix, the outer list has length m and each inner list has length n.
type Matrix = [[Double]]

-- | Which triangle of a (symmetric or triangular) matrix to read.
data UpLo = Upper | Lower
    deriving (Eq, Show)

-- | Whether to apply the transpose of the matrix before the multiply.
data Trans = NoTrans | Trans
    deriving (Eq, Show)

-- ============================================================================
-- GEMV: y := alpha * A * x + beta * y
-- ============================================================================

{- |
General matrix-vector multiply.

    gemv alpha A x beta y = alpha * A * x + beta * y

Shapes (for an m-by-n matrix A):
  - A has m rows, each of length n
  - x has length n
  - y has length m
  - result has length m

The simplest case is alpha=1, beta=0, which reduces to plain matrix-vector
multiply: y := A * x. Each entry of the output is the dot product of one row
of A with x. Build the general form up in stages — get the plain multiply
working first, then add the scaling.

Numerical hazard: Moderate. Each output entry is a 'dot' of a row with x, so
the same accumulation hazards from L1 'dot' apply (rounding error scales with
n). For ill-conditioned A, results can be sensitive to summation order.

Learning focus: Building Level 2 on top of Level 1 ('dot', 'axpy', 'scal'),
row-major traversal, scaling combinations, the αAx + βy idiom that recurs
throughout numerical linear algebra.
-}
gemv :: Double -> Matrix -> Vector -> Double -> Vector -> Vector
gemv = undefined

-- ============================================================================
-- GER: A := alpha * x * y^T + A   (rank-1 update)
-- ============================================================================

{- |
General rank-1 update of a matrix.

    ger alpha x y A = alpha * (x * y^T) + A

The outer product x * y^T is the matrix whose (i, j) entry is x_i * y_j.
If x has length m and y has length n, the result is m-by-n, matching A.

This is the dual of 'gemv': 'gemv' contracts a matrix against a vector to
produce a vector; 'ger' takes two vectors and expands them into a matrix.
Rank-1 updates show up everywhere — LU decomposition, BFGS, Householder
reflections.

Numerical hazard: Low per element (single multiply + add), but accumulating
many rank-1 updates can drift; see compensated updates if precision matters.

Learning focus: Outer products, row-vs-column thinking, why "rank-1" matters
(the update has a one-dimensional image), how 'ger' composes with 'gemv' to
build higher-rank operations.
-}
ger :: Double -> Vector -> Vector -> Matrix -> Matrix
ger = undefined

-- ============================================================================
-- TRMV: x := T * x   (T triangular)
-- ============================================================================

{- |
Triangular matrix-vector multiply.

    trmv Upper T x = U * x   where U is the upper triangle of T
    trmv Lower T x = L * x   where L is the lower triangle of T

T is square (n-by-n) and x has length n. Only the triangle indicated by the
'UpLo' flag is read; the other triangle is ignored (it does not need to be
zero). The diagonal is part of the triangle being read.

In imperative BLAS this is in-place. In pure Haskell we return a new vector.

Numerical hazard: Same as 'dot' (each output entry is a partial dot product
across the chosen triangle). Lower triangle starts with x_0 alone, then adds
one more term per row; upper triangle does the same from the bottom up.

Learning focus: Triangular access patterns, the difference between upper and
lower traversal, why triangular structure is exploitable (half the work of a
full multiply), preparation for 'trsv' and for LU / Cholesky algorithms.
-}
trmv :: UpLo -> Matrix -> Vector -> Vector
trmv = undefined

-- ============================================================================
-- TRSV: solve T * x = b   (T triangular)
-- ============================================================================

{- |
Triangular solve.

    trsv Upper U b = x   such that U * x = b   (back substitution)
    trsv Lower L b = x   such that L * x = b   (forward substitution)

T is n-by-n and b has length n. Only the indicated triangle of T is read.
The diagonal must be nonzero — zero on the diagonal means a singular system.

This is one of the most useful Level 2 ops: once you have an LU or Cholesky
factorization, every solve is two 'trsv' calls.

Numerical hazard: High when the triangle is ill-conditioned (small diagonal
entries amplify error). Forward error scales with the condition number of T.
No pivoting happens here — the caller is responsible for choosing a well-
conditioned factorization upstream.

Learning focus: Back- and forward-substitution as the inverse of 'trmv',
the role of the diagonal in solvability, how singular cases surface, why
factorization-then-solve is the standard idiom in dense linear algebra.
-}
trsv :: UpLo -> Matrix -> Vector -> Vector
trsv = undefined

-- ============================================================================
-- SYMV: y := alpha * A * x + beta * y   (A symmetric)
-- ============================================================================

{- |
Symmetric matrix-vector multiply.

    symv uplo alpha A x beta y = alpha * A * x + beta * y

A is symmetric (A == A^T), n-by-n. Only the triangle indicated by 'UpLo' is
read; the other triangle is assumed to mirror it. Conceptually identical to
'gemv' on a symmetric A, but reads ~half the data.

Numerical hazard: Same as 'gemv'. Symmetry is a storage and access
optimization, not a stability one.

Learning focus: Exploiting symmetry without materializing the full matrix,
why "read only one triangle" is a real performance lever, the conceptual
bridge between general and symmetric algorithms.
-}
symv :: UpLo -> Double -> Matrix -> Vector -> Double -> Vector -> Vector
symv = undefined

-- ============================================================================
-- SYR: A := alpha * x * x^T + A   (symmetric rank-1 update)
-- ============================================================================

{- |
Symmetric rank-1 update.

    syr uplo alpha x A = alpha * (x * x^T) + A

The outer product x * x^T is symmetric, so the update preserves the symmetry
of A. Only the triangle indicated by 'UpLo' is written; the other triangle
of the result is unspecified (typically left as-is from A's input).

This is the symmetric specialization of 'ger' with y == x.

Numerical hazard: Low per element, same as 'ger'. Repeated 'syr' updates are
the core of algorithms like Cholesky-from-scratch and BFGS-symmetric variants.

Learning focus: How symmetry constrains the update, why x * x^T is always
symmetric and positive semi-definite, the half-matrix write pattern.
-}
syr :: UpLo -> Double -> Vector -> Matrix -> Matrix
syr = undefined

-- ============================================================================
-- SYR2: A := alpha * (x * y^T + y * x^T) + A   (symmetric rank-2 update)
-- ============================================================================

{- |
Symmetric rank-2 update.

    syr2 uplo alpha x y A = alpha * (x * y^T + y * x^T) + A

The bracketed term is symmetric for any x, y, so the update preserves the
symmetry of A. Only the triangle indicated by 'UpLo' is written.

Rank-2 updates are central to symmetric eigenvalue algorithms (e.g., the
symmetric QR / Lanczos / Householder tridiagonalization use this exact shape).

Numerical hazard: Low per element. As with 'syr', accumulated drift across
many updates can matter for long iterative algorithms.

Learning focus: Why "rank-2" is the natural step up from rank-1 in the
symmetric world (rank-1 with y != x is not symmetric; symmetrizing gives
rank-2), and how this op composes into Householder/Givens-style algorithms.
-}
syr2 :: UpLo -> Double -> Vector -> Vector -> Matrix -> Matrix
syr2 = undefined

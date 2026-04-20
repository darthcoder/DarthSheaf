{-# LANGUAGE BangPatterns #-}

module CramerGeneral where

import Data.List (permutations)
import qualified Data.Map.Strict as M

type Matrix = [[Double]]
type Vector = [Double]

-- Count inversions in a permutation
inversions :: [Int] -> Int
inversions xs = length [(i,j) | (i,xi) <- zip [0..] xs, (j,xj) <- zip [0..] xs, i < j, xi > xj]

-- Sign of permutation
permSign :: [Int] -> Double
permSign perm = if even (inversions perm) then 1 else -1

-- Determinant via permutation-inversion formula
-- For an n×n matrix, sum over all n! permutations
det :: Matrix -> Double
det mat
  | null mat = error "Empty matrix"
  | not (all (\row -> length row == n) mat) = error "Non-square or ragged matrix"
  | otherwise = sum [permSign perm * product [mat !! i !! (perm !! i) | i <- [0..n-1]]
                    | perm <- permutations [0..n-1]]
  where
    n = length mat

-- Replace column j with vector v
replaceCol :: Matrix -> Int -> Vector -> Matrix
replaceCol mat j v
  | length mat /= length v = error "Dimension mismatch"
  | otherwise = [[if c == j then v !! r else mat !! r !! c | c <- [0..n-1]] | r <- [0..n-1]]
  where
    n = length mat

-- Cramer's rule: x_j = det(A_j) / det(A) where A_j has column j replaced by b
cramer :: Matrix -> Vector -> Maybe Vector
cramer a b
  | length a /= length b = error "Dimension mismatch"
  | detA == 0 = Nothing
  | otherwise = Just [det (replaceCol a j b) / detA | j <- [0..n-1]]
  where
    n = length a
    detA = det a

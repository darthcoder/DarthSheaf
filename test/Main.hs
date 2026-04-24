{-# LANGUAGE ScopedTypeVariables #-}

module Main (main) where

import Test.Hspec
-- import Test.Hspec.QuickCheck
-- import Test.QuickCheck
import DarthSheaf

main :: IO ()
main = hspec $ do
    -- ========================================================================
    -- SCAL: Vector scaling
    -- ========================================================================
    describe "scal" $ do
        it "scales vector by scalar" $ do
            scal 2.0 [1.0, 2.0, 3.0] `shouldBe` [2.0, 4.0, 6.0]

        it "scaling by zero gives zero vector" $ do
            scal 0 [1.0, 2.0, 3.0] `shouldBe` [0.0, 0.0, 0.0]
        it "scaling by one is identity" $ do
            scal 1 [1.0, 2.0, 3.0] `shouldBe` [1.0, 2.0, 3.0]
    -- ========================================================================
    -- AXPY: Scaled add (y := alpha*x + y)
    -- ========================================================================
    describe "axpy" $ do
        it "adds scaled vector to another" $ do
            axpy 2.0 [1.0, 1.0, 1.0] [2.0, 2.0, 2.0] `shouldBe` [4.0, 4.0, 4.0]
        it "axpy with alpha=0 returns y unchanged" $ do
            axpy 0.0  [1.0, 1.0, 1.0] [2.0, 2.0, 2.0] `shouldBe` [2.0, 2.0, 2.0]
        it "axpy with alpha=1 is vector addition" $ do
            axpy 1.0  [1.0, 1.0, 1.0] [2.0, 2.0, 2.0] `shouldBe` [3.0, 3.0, 3.0]

    -- ========================================================================
    -- DOT: Dot product
    -- ========================================================================
    describe "dot" $ do
        it "computes dot product" $ do
            dot [1.0, 2.0, 3.0] [4.0, 5.0, 6.0] `shouldBe` 32.0

        it "dot product with zero vector is zero" $ do
            dot [0.0, 0.0] [1.0, 2.0] `shouldBe` 0.0

        it "dot product is commutative" $ do
            dot [1.0, 2.0] [3.0, 4.0] `shouldBe` dot [3.0, 4.0] [1.0, 2.0]

    -- ========================================================================
    -- DOTC: Conjugate dot product (same as DOT for reals)
    -- ========================================================================
    describe "dotc" $ do
        it "for real vectors, equals dot" $ do
            dot [1.0, 2.0, 3.0] [4.0, 5.0, 6.0] `shouldBe` 32.0

    -- ========================================================================
    -- NRML2: 2-norm (Euclidean norm)
    -- ========================================================================
    describe "nrml2" $ do
        it "computes norm of [3, 4]" $ do
            pendingWith "TODO: implement nrml2"

        it "norm of zero vector is zero" $ do
            pendingWith "TODO: implement nrml2"

        it "norm is always non-negative" $ do
            pendingWith "TODO: implement nrml2"

    -- ========================================================================
    -- ASUM: Sum of absolute values
    -- ========================================================================
    describe "asum" $ do
        it "sums absolute values" $ do
            asum [1.0, -1.0, 1.0]  `shouldBe` 3.0
        it "asum of zeros is zero" $ do
            asum [0.0, -0.0, 0.0]  `shouldBe` 0.0

        it "asum is non-negative" $ do
            asum  [0.0, 0.0, -1.0] `shouldBe` 1.0
    -- ========================================================================
    -- IAMAX: Index of maximum absolute value
    -- ========================================================================
    describe "iamax" $ do
        it "finds index of max absolute value" $ do
            pendingWith "TODO: implement iamax"

        it "returns Nothing for empty vector" $ do
            pendingWith "TODO: implement iamax"

        it "finds first max if duplicates" $ do
            pendingWith "TODO: implement iamax"

    -- ========================================================================
    -- COPY: Copy vector
    -- ========================================================================
    describe "copy" $ do
        it "copies a vector" $ do
            pendingWith "TODO: implement copy"

        it "copy of empty is empty" $ do
            pendingWith "TODO: implement copy"

    -- ========================================================================
    -- SWAP: Swap vectors
    -- ========================================================================
    describe "swap" $ do
        it "swaps two vectors" $ do
            pendingWith "TODO: implement swap"

        it "double swap is identity" $ do
            pendingWith "TODO: implement swap"

    -- ========================================================================
    -- ROT: Givens rotation
    -- ========================================================================
    describe "rot" $ do
        it "identity rotation (c=1, s=0) leaves vectors unchanged" $ do
            pendingWith "TODO: implement rot"

        it "90-degree rotation (c=0, s=1) swaps and negates" $ do
            pendingWith "TODO: implement rot"

    -- ========================================================================
    -- ROTMG: Generate Givens rotation
    -- ========================================================================
    describe "rotmg" $ do
        it "generates valid rotation for (3, 4)" $ do
            pendingWith "TODO: implement rotmg"

        it "orthogonality property holds" $ do
            pendingWith "TODO: implement rotmg"

        it "handles zero inputs" $ do
            pendingWith "TODO: implement rotmg"

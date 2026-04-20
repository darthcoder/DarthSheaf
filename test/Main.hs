module Main (main) where

import Test.Hspec
import DarthSheaf

main :: IO ()
main = hspec $ do
    describe "cramer" $ do
        it "solves a 2x2 system" $ do
            let a = [[2, 1], [1, 3]]
                b = [5, 10]
            cramer a b `shouldBe` Just [1.0, 3.0]

        it "returns Nothing for a singular matrix" $ do
            let a = [[1, 2], [2, 4]]
                b = [3, 6]
            cramer a b `shouldBe` Nothing

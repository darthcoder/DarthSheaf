module Main (main) where

import Criterion.Main
import DarthSheaf

main :: IO ()
main = defaultMain
    [ bgroup "SCAL"
        [ bench "small (10)"   $ nf (scal 2.0) (replicate 10 1.0)
        , bench "medium (100)" $ nf (scal 2.0) (replicate 100 1.0)
        , bench "large (1000)" $ nf (scal 2.0) (replicate 1000 1.0)
        ]
    , bgroup "AXPY"
        [ bench "small (10)"   $ nf (uncurry (axpy 2.0)) (replicate 10 1.0, replicate 10 2.0)
        , bench "medium (100)" $ nf (uncurry (axpy 2.0)) (replicate 100 1.0, replicate 100 2.0)
        , bench "large (1000)" $ nf (uncurry (axpy 2.0)) (replicate 1000 1.0, replicate 1000 2.0)
        ]
    , bgroup "DOT"
        [ bench "small (10)"   $ nf (uncurry dot) (replicate 10 1.0, replicate 10 2.0)
        , bench "medium (100)" $ nf (uncurry dot) (replicate 100 1.0, replicate 100 2.0)
        , bench "large (1000)" $ nf (uncurry dot) (replicate 1000 1.0, replicate 1000 2.0)
        ]
    , bgroup "NRML2"
        [ bench "small (10)"   $ nf nrml2 (replicate 10 1.0)
        , bench "medium (100)" $ nf nrml2 (replicate 100 1.0)
        , bench "large (1000)" $ nf nrml2 (replicate 1000 1.0)
        ]
    , bgroup "ASUM"
        [ bench "small (10)"   $ nf asum (replicate 10 1.0)
        , bench "medium (100)" $ nf asum (replicate 100 1.0)
        , bench "large (1000)" $ nf asum (replicate 1000 1.0)
        ]
    , bgroup "IAMAX"
        [ bench "small (10)"   $ nf iamax (replicate 10 1.0)
        , bench "medium (100)" $ nf iamax (replicate 100 1.0)
        , bench "large (1000)" $ nf iamax (replicate 1000 1.0)
        ]
    ]

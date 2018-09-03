module Main where

  import Chapter2
  import Chapter4
  import Training
  import Data.Matrix
  import Data.Typeable
  import System.Random

  main :: IO()
  main = do
    generator <- newStdGen

    let expected = 0.0
    let inputs = [0, 1]

    let inputWeights = randomWeights generator (length inputs) 3
    let hiddenWeights = randomWeights generator 3 1
    let outputWeights = randomWeights generator 1 1

    let outputs = activate inputs [inputWeights, hiddenWeights, outputWeights]

    print inputs
    print outputs

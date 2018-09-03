module Main where

  import Chapter2
  import Chapter4
  import Training
  import Data.Matrix
  import Data.Typeable
  import System.Random

  main :: IO()
  main = do
    print $ "myIsEmpty: " ++ show (myLength "Hello world!")
    print $ "myIsEmpty: " ++ show (myIsEmpty "Hello world!")

    let roomA = Location 4 "Room A" []
    let roomB = Location 5 "Room B" []

    let floor1 = Location 1 "Floor 1" [roomA, roomB]
    let floor2 = Location 2 "Floor 2" [roomA, roomB]
    let floor3 = Location 3 "Floor 3" [roomA, roomB]

    let workspace = Location 0 "Newcastle Office" [floor1, floor2]

    print $ findWorkspace 5 [workspace]

    let expected = 0.0
    let inputs = [0, 1]

    generator <- newStdGen

    let inputWeights = randomWeights generator (length inputs) 3
    let hiddenWeights = randomWeights generator 3 4
    let hiddenWeights2 = randomWeights generator 4 3
    let outputWeights = randomWeights generator 3 1

    let outputs = activate inputs [inputWeights, hiddenWeights, hiddenWeights2, outputWeights]

    let c = cost expected (head (toList outputs))

    print inputs
    print outputs

    print $ "expected: " ++ (show expected) ++ ", actual: " ++ (show $ head (toList outputs)) ++ ", cost: " ++ (show c)

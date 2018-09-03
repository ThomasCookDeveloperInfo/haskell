module Training (randomWeights, activate, forwardPass) where

  import Data.Matrix
  import System.Random

  leakyRelu :: Double -> Double
  leakyRelu a | a > 0.0 = a
              | otherwise = 0.01 * a

  activate :: [Double] -> [Matrix Double] -> Matrix Double
  activate i weights = outputs where
    inputSize = length i
    inputs = fromList 1 inputSize i
    outputs = forwardPass inputs weights

  forwardPass :: Matrix Double -> [Matrix Double] -> Matrix Double
  forwardPass inputs weights
    | length weights == 1 = mapPos (\(row, col) a -> leakyRelu a) (multStd2 inputs (head weights))
    | otherwise = forwardPass (mapPos (\(row, col) a -> leakyRelu a) (multStd2 inputs (head weights))) (tail weights)

  randomWeights :: (RandomGen g) => g -> Int -> Int -> Matrix Double
  randomWeights generator inputSize outputSize = weights where
    weights = matrix inputSize outputSize (\(col, row) -> (randomList generator (10000))!!(col * row))

  randomList :: (RandomGen g) => g -> Int -> [Double]
  randomList generator size = take size $ randomRs (-1.0, 1.0) generator

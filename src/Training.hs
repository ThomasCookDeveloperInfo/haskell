module Training (randomWeights, activate, cost) where

  import Data.Matrix
  import System.Random

  activate :: [Double] -> [Matrix Double] -> Matrix Double
  activate i weights = outputs where
    inputSize = length i
    inputs = fromList 1 inputSize i
    outputs = forwardPass inputs weights where
      forwardPass inputs weights
        | length weights == 1 = squashedOutputs
        | otherwise = forwardPass (squashedOutputs) (tail weights)
        where
          squashedOutputs = mapPos (\(row, col) a -> leakyRelu a) layerOutputs
          layerOutputs = multStd2 inputs (head weights)
          leakyRelu a
            | a > 0.0 = a
            | otherwise = 0.01 * a

  randomWeights :: (RandomGen g) => g -> Int -> Int -> Matrix Double
  randomWeights generator inputSize outputSize = weights where
    weights = matrix inputSize outputSize (\(col, row) -> (take 10000 $ randomRs (-1.0, 1.0) generator)!!(col * row))

  cost :: Double -> Double -> Double
  cost expected actual = expected - actual

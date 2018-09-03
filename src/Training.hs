module Training (forwardPass) where

  import Data.Matrix
  import System.Random

  leakyRelu :: Double -> Double
  leakyRelu a | a > 0.0 = a
              | otherwise = 0.01 * a

  forwardPass :: (RandomGen g) => g -> [Double] -> Int -> Int -> Matrix Double
  forwardPass generator i hiddenSize outputSize = outputs where
    inputSize = length i
    inputs = fromList 1 inputSize  i
    outputs = forwardPassLayer hiddenOutputs outputWeights where
      outputWeights = randomWeights generator outputSize 1
      hiddenOutputs = forwardPassLayer inputOutputs hiddenWeights where
        hiddenWeights = randomWeights generator hiddenSize outputSize
        inputOutputs = forwardPassLayer inputs inputWeights where
          inputWeights = randomWeights generator inputSize hiddenSize


  forwardPassLayer :: Matrix Double -> Matrix Double -> Matrix Double
  forwardPassLayer inputs weights = outputs where
    outputs = mapPos (\(row, col) a -> leakyRelu a) multipliedMatrix where
      multipliedMatrix = multStd2 inputs weights

  randomWeights :: (RandomGen g) => g -> Int -> Int -> Matrix Double
  randomWeights generator inputSize outputSize = weights where
    weights = matrix inputSize outputSize (\(col, row) -> (randomList generator (10000))!!(col * row))

  randomList :: (RandomGen g) => g -> Int -> [Double]
  randomList generator size = take size $ randomRs (-1.0, 1.0) generator

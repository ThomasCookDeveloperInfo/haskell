module Training (forwardPass) where

  import Data.Matrix
  import System.Random

  leakyRelu :: Double -> Double
  leakyRelu a | a > 0.0 = a
              | otherwise = 0.01 * a

  forwardPass :: [Double] -> Int -> Int -> Matrix Double
  forwardPass i hiddenSize outputSize = outputs where
    inputSize = length i
    inputs = fromList 1 inputSize  i
    outputs = forwardPassLayer hiddenOutputs outputWeights where
      outputWeights = randomWeights outputSize 1
      hiddenOutputs = forwardPassLayer inputOutputs hiddenWeights where
        hiddenWeights = randomWeights hiddenSize outputSize
        inputOutputs = forwardPassLayer inputs inputWeights where
          inputWeights = randomWeights inputSize hiddenSize


  forwardPassLayer :: Matrix Double -> Matrix Double -> Matrix Double
  forwardPassLayer inputs weights = outputs where
    outputs = mapPos (\(row, col) a -> leakyRelu a) multipliedMatrix where
      multipliedMatrix = multStd2 inputs weights

  randomWeights :: Int -> Int -> Matrix Double
  randomWeights inputSize outputSize = weights where
    weights = matrix inputSize outputSize (\(col, row) -> random!!(col * row)) where
      random = randomList (inputSize * outputSize)


  randomList :: Int -> [Double]
  randomList size = randoms (mkStdGen size) :: [Double]

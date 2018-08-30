module Training (randomInputs,
                 randomWeights,
                 forwardPassLayer) where

  import Numeric.Matrix
  import System.Random

  leakyRelu :: Double -> Double
  leakyRelu a | a > 0.0 = a
              | otherwise = 0.01 * a

  forwardPassLayer :: Matrix Double -> Matrix Double -> Matrix Double
  forwardPassLayer inputs weights = outputs where
    outputs = Numeric.Matrix.map leakyRelu multipliedMatrix where
      multipliedMatrix = inputs `times` weights

  randomWeights :: Int -> Int -> Matrix Double
  randomWeights inputSize outputSize = weights where
    weights = matrix (inputSize, outputSize) (\(x, y) -> random!!(x*y)) where
      random = randomList (inputSize * outputSize)

  randomInputs :: Int -> Matrix Double
  randomInputs inputSize = inputs where
    inputs = matrix (inputSize, 1) (\(x, y) -> random!!(x * y)) where
      random = randomList inputSize

  randomList :: Int -> [Double]
  randomList seed = randoms (mkStdGen seed) :: [Double]

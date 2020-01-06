module Kmeans(
  example
) where

import Data.List
import Data.Function
import System.Random

data KmeansState = KmeansState {
  clusters :: [Point],
  centroids :: [Point]
} deriving (Show, Eq)

data Point = Point {
  x :: Int,
  y :: Int,
  color :: Color
} deriving (Show, Eq)

data Color = None
  | Black
  | Red
  | Green
  | Blue
  deriving (Show, Eq, Enum)

assignClusters :: KmeansState -> KmeansState
assignClusters kmeansState =
  KmeansState newClusters (centroids kmeansState) where

    newClusters = map selectColor $ clusters kmeansState

    selectColor point =
      Point x' y' color' where
        x' = x point
        y' = y point
        color' = color closestCentroid
        closestCentroid = minimumBy comparator $ centroids kmeansState
        comparator = compare `on` euclidianDistance point

    euclidianDistance pointA pointB =
      sqrt (fromIntegral x' + fromIntegral y') where
        x' = x pointA ^ 2
        y' = y pointA ^ 2

shiftCentroids :: KmeansState -> KmeansState
shiftCentroids kmeansState =
  KmeansState (clusters kmeansState) newCentroids where
    newCentroids = map shiftCentroid (centroids kmeansState)

    shiftCentroid centroid =
      Point x' y' (color centroid) where
        x' = mean xs
        y' = mean ys
        mean nums = sum nums `div` length nums
        xs = map x sameColors
        ys = map y sameColors
        sameColors = filter sameColor (clusters kmeansState)
        sameColor pointA = color pointA == color centroid

kmeans :: (RandomGen g) => g -> Int -> [Point] -> KmeansState
kmeans randGen numClusters unclustered = cluster $ KmeansState unclustered initialCentroids where
  cluster kmeansState
    | shiftCentroids (assignClusters kmeansState) == kmeansState = kmeansState
    | otherwise = cluster $ shiftCentroids (assignClusters kmeansState)

  initialCentroids =
    map createCentroid [0..numClusters] where
      createCentroid _ = Point x' y' color'
      x' = fst $ randomR (minWidth, maxWidth) randGen
      y' = fst $ randomR (minHeight, maxHeight) randGen
      minWidth = minimum $ map x unclustered
      maxWidth = maximum $ map x unclustered
      minHeight = minimum $ map y unclustered
      maxHeight = maximum $ map y unclustered
      color' = toEnum $ fst $ randomR (0, numClusters) randGen

numClusters = 3

example :: IO ()
example = do
  let pointA = Point 10 10 None
  let pointB = Point 200 200 None
  let input = [pointA, pointB]

  randGen <- getStdGen

  let kmeansResult = kmeans randGen numClusters input

  print kmeansResult

module Kmeans(
  example
) where

import Data.List
import Data.Function
import System.Random
import Control.Monad.State
import Control.Applicative

data KmeansState = KmeansState {
  clusters :: [Point],
  centroids :: [Point]
} deriving (Show, Eq)

data Point = Point {
  x :: Int,
  y :: Int,
  color :: Color
} deriving (Show, Eq)

data Color = Black
  | Red
  | Green
  | Blue
  deriving (Show, Eq, Enum, Bounded)

instance Random Color where
  random g = case randomR (0, 3) g of
    (r, g') -> (toEnum r, g')
  randomR (a, b) g = case randomR (fromEnum a, fromEnum b) g of
    (r, g') -> (toEnum r, g')

instance Random Point where
  randomR (Point xl yl cl, Point xr yr cr) g =
    let (x, g1) = randomR (xl, xr) g
        (y, g2) = randomR (yl, yr) g1
        (c, g3) = randomR (cl, cr) g2
    in (Point x y c, g3)
  random g =
    let (x, g1) = random g
        (y, g2) = random g1
        (c, g3) = random g2
    in (Point x y c, g3)

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
        xs = map x sameColors
        ys = map y sameColors
        mean nums = sum nums `div` length nums
        sameColors = filter sameColor (clusters kmeansState)
        sameColor pointA = color pointA == color centroid

kmeans :: [Point]-> [Point] -> KmeansState
kmeans unclustered initialCentroids = cluster $ KmeansState unclustered initialCentroids where
  cluster kmeansState
    | shiftCentroids (assignClusters kmeansState) == kmeansState = kmeansState
    | otherwise = cluster $ shiftCentroids (assignClusters kmeansState)

filterIndexed :: (a -> Int -> Bool) -> [a] -> [a]
filterIndexed pred xs = [x | (x, i) <- zip xs [0..], pred x i]

numClusters = 4

example :: IO ()
example = do

  let pointA = Point 10 10 Black
  let pointB = Point 200 200 Black
  let pointC = Point 37 90 Black
  let pointD = Point 68 130 Black
  let pointE = Point 85 20 Black
  let pointF = Point 12 300 Black
  let pointF = Point 2000 1200 Black
  let unclusteredData = [pointA, pointB, pointC, pointD, pointE, pointF]

  let minWidth = minimum $ map x unclusteredData
  let maxWidth = maximum $ map x unclusteredData
  let minHeight = minimum $ map y unclusteredData
  let maxHeight = maximum $ map y unclusteredData

  randGen <- getStdGen

  let initialCentroids = take numClusters $ randomRs (Point minWidth minHeight minBound, Point maxWidth maxHeight maxBound) randGen

  let initiallyClusteredData = map (\(Point x y _) -> Point x y (color (head initialCentroids))) unclusteredData

  let kmeansResult = kmeans unclusteredData initiallyClusteredData

  putStrLn $ "Clustered Data: " ++ show kmeansResult

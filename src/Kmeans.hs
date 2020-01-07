module Kmeans(
  KmeansState(..),
  Point(..),
  Color(..),
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

data Color = None
  | Black
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
        x' = (x pointA - x pointB) ^ 2
        y' = (y pointA - y pointB) ^ 2

shiftCentroids :: KmeansState -> KmeansState
shiftCentroids kmeansState =
  KmeansState (clusters kmeansState) newCentroids where
    newCentroids = map shiftCentroid (centroids kmeansState)

    shiftCentroid centroid =
      Point x' y' (color centroid) where
        x' = if null xs then x centroid else mean xs
        y' = if null ys then y centroid else mean ys
        mean nums = sum nums `div` length nums
        xs = map x sameColors
        ys = map y sameColors
        sameColors = filter sameColor (clusters kmeansState)
        sameColor pointA = color pointA == color centroid

kmeans :: [Point]-> [Point] -> KmeansState
kmeans unclustered initialCentroids = cluster $ KmeansState unclustered initialCentroids where
  cluster kmeansState
    | shiftCentroids (assignClusters kmeansState) == kmeansState = kmeansState
    | otherwise = cluster $ shiftCentroids (assignClusters kmeansState)

numClusters = 2

example :: IO KmeansState
example = do

  let pointA = Point 10 10 None
  let pointB = Point 30 15 None
  let pointC = Point 45 30 None
  let pointD = Point 5 20 None
  let pointE = Point 45 10 None
  let pointF = Point 35 15 None
  let pointG = Point 5 60 None

  let pointA' = Point 100 100 None
  let pointB' = Point 110 110 None
  let pointC' = Point 100 110 None
  let pointD' = Point 110 120 None
  let pointE' = Point 120 120 None
  let pointF' = Point 140 130 None
  let pointG' = Point 50 80 None
  let unclusteredData = [pointA, pointB, pointC, pointD, pointE, pointF, pointG, pointA', pointB', pointC', pointD', pointE', pointF', pointG']

  let minWidth = minimum $ map x unclusteredData
  let maxWidth = maximum $ map x unclusteredData
  let minHeight = minimum $ map y unclusteredData
  let maxHeight = maximum $ map y unclusteredData

  randGen <- getStdGen

  let randomPoints = map (unclusteredData!!) (take numClusters $ randomRs (0, length unclusteredData) randGen)

  let initialCentroids = zipWith (curry (\(index, Point x y _) -> Point x y $ toEnum index)) [1..] randomPoints

  putStrLn $ "Initial centroids: " ++ show initialCentroids

  putStrLn $ "Unclustered data: " ++ show unclusteredData

  return (assignClusters $ KmeansState unclusteredData initialCentroids)

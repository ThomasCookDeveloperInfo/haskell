module Kmeans(
  KmeansState(..),
  Point(..),
  Color(..),
  kmeans
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

z :: (Point -> a) -> [Point] -> [a]
z = map

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
            x' = abs (x pointA - x pointB) ^ 2
            y' = abs (y pointA - y pointB) ^ 2

shiftCentroids :: KmeansState -> KmeansState
shiftCentroids kmeansState =
  KmeansState (clusters kmeansState) newCentroids where
    newCentroids = map shiftCentroid (centroids kmeansState)
    shiftCentroid centroid =
      Point x' y' (color centroid) where
        x' = mean xs
        y' = mean ys
        mean nums = sum nums `div` numCount where
          numCount = if null nums then 1 else length nums
        xs = map x sameColors
        ys = map y sameColors
        sameColors = filter sameColor (clusters kmeansState)
        sameColor point = color point == color centroid

kmeans' :: [Point]-> [Point] -> KmeansState
kmeans' unclustered initialCentroids = cluster $ KmeansState unclustered initialCentroids where
  cluster kmeansState
    | newKmeansState == kmeansState = kmeansState
    | otherwise = cluster newKmeansState
    where newKmeansState = shiftCentroids (assignClusters kmeansState)

kmeans :: Int -> [Point] -> IO KmeansState
kmeans numClusters unclusteredData = do
  let minWidth = minimum $ map x unclusteredData
  let maxWidth = maximum $ map x unclusteredData
  let minHeight = minimum $ map y unclusteredData
  let maxHeight = maximum $ map y unclusteredData
  randGen <- getStdGen
  let randomPoints = map (unclusteredData!!) (take numClusters $ randomRs (0, length unclusteredData) randGen)
  let initialCentroids = zipWith (curry (\(index, Point x y _) -> Point x y $ toEnum index)) [1..] randomPoints
  return (kmeans' unclusteredData initialCentroids)

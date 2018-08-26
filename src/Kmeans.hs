module Kmeans (Cluster) where

  import qualified Data.Map.Strict as Map
  import Data.List (minimumBy, genericLength, transpose)
  import Data.Ord (comparing)

  type Vec = [Float]
  type Cluster = [Vec]

  kMeansIteration :: [Vec] -> [Vec] -> [Cluster]
  kMeansIteration pts = clusterize . fixPoint iteration
    where
      iteration = map centroid . clusterize

      clusterize centroids = Map.elems $ foldr add m0 pts
        where add x = Map.insertWith (++) (centroids `nearestTo` x) [x]
              m0 = Map.unions $ map (`Map.singleton` []) centroids

  nearestTo :: [Vec] -> Vec -> Vec
  nearestTo pts x =  minimumBy (comparing (distance x)) pts

  distance :: Vec -> Vec -> Float
  distance a b = sum $ map (^2) $ zipWith (-) a b

  centroid :: [Vec] -> Vec
  centroid = map mean . transpose
    where  mean pts = sum pts / genericLength pts

  fixPoint :: Eq a => (a -> a) -> a -> a
  fixPoint f x = if x == fx then x else fixPoint f fx where fx = f x

{-# LANGUAGE RecordWildCards #-}
module Algorithms(
  Point(..),
  readGraphFromFile
) where

import Data.List.Split
import Text.Regex.Posix
import Control.Monad
import Data.List
import Data.Function
import Control.Monad.IO.Class
import System.Random
import Random

graphRegex = "[0-9]+"

type Graph = [Point]

data Color = None

data Point = Point {
  x :: Int,
  y :: Int,
  fillColor :: Color
}

readGraphFromFile :: String -> IO Graph
readGraphFromFile filePath = do
  fileContents <- readFile filePath
  let csvs =  getAllTextMatches (fileContents =~ graphRegex) :: [String]
  let pairs = convertListToTupleList csvs
  return (map pairToPoint pairs) where
    pairToPoint pair = Point x y None where
      x = read (fst pair)
      y = read (snd pair)

convertListToTupleList :: [a] -> [(a, a)]
convertListToTupleList [] = []
convertListToTupleList (k:v:t) = (k, v) : convertListToTupleList t

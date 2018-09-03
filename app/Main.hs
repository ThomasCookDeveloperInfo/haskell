module Main where

import Chapter2
import Chapter4
import Training
import Data.Typeable

main :: IO()
main = do
  print $ "myIsEmpty: " ++ show (myLength "Hello world!")
  print $ "myIsEmpty: " ++ show (myIsEmpty "Hello world!")

  let roomA = Location 4 "Room A" []
  let roomB = Location 5 "Room B" []

  let floor1 = Location 1 "Floor 1" [roomA, roomB]
  let floor2 = Location 2 "Floor 2" [roomA, roomB]
  let floor3 = Location 3 "Floor 3" [roomA, roomB]

  let workspace = Location 0 "Newcastle Office" [floor1, floor2]

  print $ findWorkspace 5 [workspace]

  let inputs = [1, 2, 3, 4, 5, 6]
  let outputs = forwardPass inputs 2 1

  print inputs
  print outputs

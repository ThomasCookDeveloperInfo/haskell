module Main where

import Lib
import Data.Typeable

main :: IO()
main = do
  let exampleTuple = ("test", True)
  let exampleTriple = ([1, 2, 3], "test", ['t', 'e', 's', 't'])
  let exampleList = [1, 2, 3]
  let exampleListOfList = [[True], [False, False]]
  let typeOfTuple = typeOf exampleTuple

  putStrLn ("tuple: " ++ (show(exampleTuple)))
  putStrLn ("triple: " ++(show(exampleTriple)))
  putStrLn ("head list: " ++ (show(head(exampleList))))
  putStrLn ("tail list: " ++ (show(tail(exampleList))))
  putStrLn ("head list of list: " ++ (show(head(exampleListOfList))))
  putStrLn ("tail of list of list: " ++ (show(tail(exampleListOfList))))
  putStrLn ("type of tuple: " ++ show(typeOf(exampleTuple)))

  name <- getLine
  let greeting = greet name
  putStrLn greeting

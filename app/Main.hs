module Main where

import Lib

main :: IO()
main = do
  putStrLn "What's your name?"
  name <- getLine
  let greeting = greet name
  putStrLn greeting

module Chapter4 (myLength, myIsEmpty) where

  myLength :: [a] -> Int
  myLength = foldr (\x y -> y + 1) 0

  myIsEmpty :: [a] -> Bool
  myIsEmpty = null

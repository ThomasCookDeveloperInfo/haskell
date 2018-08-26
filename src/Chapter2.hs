module Chapter2 (findWorkspace, Workspace (..)) where

  import Data.Maybe

  data Workspace = Location {
    key :: Int,
    name :: String,
    locations :: [Workspace]
  } deriving Show

  findWorkspace :: Int -> [Workspace] -> Maybe Workspace
  findWorkspace find children
    | null y && null x = Nothing
    | not (null x) = Just (head x)
    | otherwise = findWorkspace find y
    where x = filter (\a -> key a == find) children
          y = concatMap locations children

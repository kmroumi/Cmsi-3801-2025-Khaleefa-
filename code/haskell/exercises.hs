module Exercises
  ( firstThenApply
  , powers
  , meaningfulLineCount
  , volume
  , surfaceArea
  , insert
  , contains
  , size
  , inorder
  , change
  , Shape(..)
  , BST(Empty)
  ) where

import Data.Char (isSpace)
import Data.List (find)
import Data.Map (Map)
import qualified Data.Map.Strict as M

firstThenApply :: [a] -> (a -> Bool) -> (a -> b) -> Maybe b
firstThenApply xs p f = f <$> find p xs

powers :: Integral a => a -> [a]
powers base = iterate ((* base)) 1

meaningfulLineCount :: FilePath -> IO Int
meaningfulLineCount path = do
  contents <- readFile path
  let ls :: [String]
      ls = lines contents
      isMeaningful :: String -> Bool
      isMeaningful s =
        case dropWhile isSpace s of
          ""     -> False
          '#':_  -> False
          _      -> True
  pure (length (filter isMeaningful ls))

data Shape
  = Sphere Double
  | Box Double Double Double
  deriving (Eq)

instance Show Shape where
  show (Sphere r)  = "Sphere " ++ show r
  show (Box w l d) = "Box "    ++ show w ++ " " ++ show l ++ " " ++ show d

volume :: Shape -> Double
volume (Sphere r)  = (4 / 3) * pi * r * r * r
volume (Box w l d) = w * l * d

surfaceArea :: Shape -> Double
surfaceArea (Sphere r)  = 4 * pi * r * r
surfaceArea (Box w l d) = 2 * (w * l + w * d + l * d)

data BST a
  = Empty
  | Node (BST a) a (BST a)

instance Show a => Show (BST a) where
  show Empty = "()"
  show (Node l v r) =
    "(" ++ leftPart ++ show v ++ rightPart ++ ")"
    where
      leftPart  = case l of
                    Empty -> ""
                    _     -> show l
      rightPart = case r of
                    Empty -> ""
                    _     -> show r

insert :: Ord a => a -> BST a -> BST a
insert x Empty = Node Empty x Empty
insert x (Node l v r)
  | x == v    = Node l v r
  | x <  v    = Node (insert x l) v r
  | otherwise = Node l v (insert x r)

contains :: Ord a => a -> BST a -> Bool
contains _ Empty = False
contains x (Node l v r)
  | x == v    = True
  | x <  v    = contains x l
  | otherwise = contains x r

size :: BST a -> Int
size Empty        = 0
size (Node l _ r) = 1 + size l + size r

inorder :: BST a -> [a]
inorder Empty        = []
inorder (Node l v r) = inorder l ++ [v] ++ inorder r

change :: Integer -> Either String (Map Integer Integer)
change amount
  | amount < 0 = Left "amount must be nonnegative"
  | otherwise  =
      let (q, r1) = amount `divMod` 25
          (d, r2) = r1     `divMod` 10
          (n, p)  = r2     `divMod` 5
      in Right (M.fromList [(25, q), (10, d), (5, n), (1, p)])

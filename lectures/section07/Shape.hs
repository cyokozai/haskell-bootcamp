module Shapes (Point(..), Shape(..), area)where

data Point = Point Float Float deriving (Show)

data Shape = Circle Point Float |
             Rectangle Point Point deriving (Show)

area :: Shape -> Float
area (Circle _ r) = pi * r ^ 2
area (Rectangle (Point x1 y1) (Point x2 y2)) = (x2 - x1) * (y2 - y1)

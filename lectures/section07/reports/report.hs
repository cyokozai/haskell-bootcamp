module Shapes where


-- 問1

data Point = Point Float Float deriving (Show, Eq)

data Shape
  = Circle Point Float
  | Rectangle Point Point
  | Triangle Point Point Point
  deriving (Show, Eq)


-- 問2

area :: Shape -> Float
area (Circle _ r) = pi * r ^ 2
area (Rectangle (Point x1 y1) (Point x2 y2)) = abs (x2 - x1) * abs (y2 - y1)
area (Triangle (Point x1 y1) (Point x2 y2) (Point x3 y3)) =
  abs ((x2 - x1) * (y3 - y1) - (x3 - x1) * (y2 - y1)) / 2


-- 問3

data Vector3 a = Vector3 a a a deriving (Show, Eq)

vplus :: Num a => Vector3 a -> Vector3 a -> Vector3 a
vplus (Vector3 a b c) (Vector3 d e f) = Vector3 (a + d) (b + e) (c + f)

vminus :: Num a => Vector3 a -> Vector3 a -> Vector3 a
vminus (Vector3 a b c) (Vector3 d e f) = Vector3 (a - d) (b - e) (c - f)

-- スカラー倍
vscale :: Num a => a -> Vector3 a -> Vector3 a
vscale k (Vector3 a b c) = Vector3 (k * a) (k * b) (k * c)

-- 内積
dot :: Num a => Vector3 a -> Vector3 a -> a
dot (Vector3 a b c) (Vector3 d e f) = a * d + b * e + c * f

-- 外積
cross :: Num a => Vector3 a -> Vector3 a -> Vector3 a
cross (Vector3 a b c) (Vector3 d e f) =
  Vector3 (b * f - c * e) (c * d - a * f) (a * e - b * d)

-- ノルム
norm :: Floating a => Vector3 a -> a
norm v = sqrt (dot v v)


-- 問4

data Interval = Interval Int Int deriving (Show, Eq)

infixl 6 +!, -!

(+!) :: Interval -> Interval -> Interval
Interval al au +! Interval bl bu = Interval (al + bl) (au + bu)

(-!) :: Interval -> Interval -> Interval
Interval al au -! Interval bl bu = Interval (al - bu) (au - bl)


-- 問5

data IntervalG a = IntervalG a a deriving (Show, Eq)

infixl 6 +!!, -!!

(+!!) :: Num a => IntervalG a -> IntervalG a -> IntervalG a
IntervalG al au +!! IntervalG bl bu = IntervalG (al + bl) (au + bu)

(-!!) :: Num a => IntervalG a -> IntervalG a -> IntervalG a
IntervalG al au -!! IntervalG bl bu = IntervalG (al - bu) (au - bl)
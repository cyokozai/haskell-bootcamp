import Control.Exception (SomeException, evaluate, try)

data Point = Point Float Float deriving (Show)

data Shape = Circle Point Float | Rectangle Point Point deriving (Show)

area :: Shape -> Float
area (Circle _ r) = pi * r ^ 2
area (Rectangle (Point x1 y1) (Point x2 y2)) = abs (x2 - x1) * abs (y2 - y1)

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問1 area 長方形" (area (Rectangle (Point 0 0) (Point 100 100))) 10000.0
  check "問1 area 円" (area (Circle (Point 0 0) 24)) 1809.5574
  check "問1 area 円 (中心は面積に影響しない)" (area (Circle (Point 10 20) 10)) (area (Circle (Point 0 0) 10))
  check "問1 area 長方形 (頂点の順が逆)" (area (Rectangle (Point 100 100) (Point 0 0))) 10000.0
  check "問1 area 長方形 (幅 0)" (area (Rectangle (Point 3 0) (Point 3 5))) 0.0

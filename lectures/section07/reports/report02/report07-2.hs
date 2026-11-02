import Control.Exception (SomeException, evaluate, try)

data Point = Point Float Float deriving (Show, Eq)

data Shape = Circle Point Float | Rectangle Point Point deriving (Show, Eq)

nudge :: Shape -> Float -> Float -> Shape
nudge (Circle (Point x y) r) a b = Circle (Point (x + a) (y + b)) r
nudge (Rectangle (Point x1 y1) (Point x2 y2)) a b =
  Rectangle (Point (x1 + a) (y1 + b)) (Point (x2 + a) (y2 + b))

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問2 nudge 円" (nudge (Circle (Point 34 34) 10) 5 10) (Circle (Point 39 44) 10)
  check "問2 nudge 円 (表示)" (show (nudge (Circle (Point 34 34) 10) 5 10)) "Circle (Point 39.0 44.0) 10.0"
  check "問2 nudge 長方形" (nudge (Rectangle (Point 0 0) (Point 100 100)) 5 10) (Rectangle (Point 5 10) (Point 105 110))
  check "問2 nudge 長方形 (負の向き)" (nudge (Rectangle (Point 0 0) (Point 2 3)) (-1) (-1)) (Rectangle (Point (-1) (-1)) (Point 1 2))
  check "問2 nudge 0 0 は動かさない" (nudge (Circle (Point 1 2) 3) 0 0) (Circle (Point 1 2) 3)

import Control.Exception (SomeException, evaluate, try)
import Shape
import qualified Shape.Circle as Circle
import qualified Shape.Rectangle as Rectangle

rectAreaFor :: Double -> Double -> Double
rectAreaFor w h = Rectangle.area w h

circleAreaFor :: Double -> Double
circleAreaFor r = Circle.area r

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問1 Shape.rectangleArea" (rectangleArea 3 4) 12
  check "問1 Shape.rectanglePerimeter" (rectanglePerimeter 3 4) 14
  check "問1 Shape.circleArea" (circleArea 2) (pi * 4)
  check "問1 Shape.circumference" (circumference 1) (2 * pi)
  check "問1 Shape.Rectangle.area" (Rectangle.area 3 4) 12
  check "問1 Shape.Rectangle.perimeter" (Rectangle.perimeter 3 4) 14
  check "問1 Shape.Circle.area" (Circle.area 2) (pi * 4)
  check "問1 Shape.Circle.circumference" (Circle.circumference 1) (2 * pi)
  check "問1 rectAreaFor" (rectAreaFor 3 4) 12
  check "問1 rectAreaFor (小数)" (rectAreaFor 2.5 4) 10
  check "問1 circleAreaFor" (circleAreaFor 2) (pi * 4)
  check "問1 circleAreaFor (半径 0.5)" (circleAreaFor 0.5) (pi / 4)

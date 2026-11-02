-- 第6回 課題 解答例 問1 Shape モジュールを作成し，Shape.Rectangle モジュールと
--   Shape.Circle モジュールを各々作成したうえで，関数 rectAreaFor と
--   関数 circleAreaFor を Main.hs に作成せよ
--   ghci> rectAreaFor 3 4    ==> 12.0
--   ghci> circleAreaFor 2    ==> 12.566370614359172   (pi * 2 * 2)
--
-- このディレクトリの構成 (階層モジュールはディレクトリで表す):
--   Main.hs              -- このファイル (rectAreaFor / circleAreaFor とテスト)
--   Shape.hs             -- module Shape
--   Shape/Rectangle.hs   -- module Shape.Rectangle
--   Shape/Circle.hs      -- module Shape.Circle
--
-- 実行: cd lectures/section06/reports/report01 && runghc Main.hs
-- 対話: cd lectures/section06/reports/report01 && ghci Main.hs

import Control.Exception (SomeException, evaluate, try)
import Shape
import qualified Shape.Circle as Circle
import qualified Shape.Rectangle as Rectangle

-- 幅 w, 高さ h の長方形の面積 (Shape.Rectangle の area を使う)
rectAreaFor :: Double -> Double -> Double
rectAreaFor w h = Rectangle.area w h

-- 半径 r の円の面積 (Shape.Circle の area を使う)
circleAreaFor :: Double -> Double
circleAreaFor r = Circle.area r

-- ===================================================================
-- 動作確認
-- ===================================================================
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

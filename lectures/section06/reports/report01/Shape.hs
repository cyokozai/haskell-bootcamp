-- 第6回 課題 解答例 問1 (1) Shape モジュール
--   長方形と円の面積・周長を求める関数を 1 つのモジュールにまとめる。
--   ghci> rectangleArea 3 4         ==> 12.0
--   ghci> rectanglePerimeter 3 4    ==> 14.0
--   ghci> circleArea 2              ==> 12.566370614359172   (pi * 2 * 2)
--   ghci> circumference 1           ==> 6.283185307179586    (2 * pi * 1)

module Shape
  ( rectangleArea,
    rectanglePerimeter,
    circleArea,
    circumference,
  )
where

-- 幅 w, 高さ h の長方形の面積
rectangleArea :: Double -> Double -> Double
rectangleArea w h = w * h

-- 幅 w, 高さ h の長方形の周長
rectanglePerimeter :: Double -> Double -> Double
rectanglePerimeter w h = 2 * (w + h)

-- 半径 r の円の面積
circleArea :: Double -> Double
circleArea r = pi * r * r

-- 半径 r の円周の長さ
circumference :: Double -> Double
circumference r = 2 * pi * r

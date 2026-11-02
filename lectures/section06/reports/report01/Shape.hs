-- 第6回 課題 問1 (1) Shape モジュール
--   長方形と円の面積・周長を求める関数を 1 つのモジュールにまとめる。
--   ghci> rectangleArea 3 4         ==> 12.0
--   ghci> rectanglePerimeter 3 4    ==> 14.0
--   ghci> circleArea 2              ==> 12.566370614359172   (pi * 2 * 2)
--   ghci> circumference 1           ==> 6.283185307179586    (2 * pi * 1)
--
-- undefined を自分の実装に書き換えること。モジュール宣言・型宣言は変更しないこと。

module Shape
  ( rectangleArea,
    rectanglePerimeter,
    circleArea,
    circumference,
  )
where

-- 幅 w, 高さ h の長方形の面積
rectangleArea :: Double -> Double -> Double
rectangleArea = undefined

-- 幅 w, 高さ h の長方形の周長
rectanglePerimeter :: Double -> Double -> Double
rectanglePerimeter = undefined

-- 半径 r の円の面積
circleArea :: Double -> Double
circleArea = undefined

-- 半径 r の円周の長さ
circumference :: Double -> Double
circumference = undefined

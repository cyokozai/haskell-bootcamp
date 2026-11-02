-- 第6回 課題 解答例 問1 (2) Shape.Rectangle モジュール (階層モジュール)
--   ファイルは Shape/Rectangle.hs に置き、モジュール名は Shape.Rectangle とする。
--   ghci> area 3 4         ==> 12.0
--   ghci> perimeter 3 4    ==> 14.0

module Shape.Rectangle
  ( area,
    perimeter,
  )
where

-- 幅 w, 高さ h の長方形の面積
area :: Double -> Double -> Double
area w h = w * h

-- 幅 w, 高さ h の長方形の周長
perimeter :: Double -> Double -> Double
perimeter w h = 2 * (w + h)

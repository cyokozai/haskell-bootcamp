-- 第6回 課題 問1 (3) Shape.Circle モジュール (階層モジュール)
--   ファイルは Shape/Circle.hs に置き、モジュール名は Shape.Circle とする。
--   Shape.Rectangle にも area という同名の関数があるので、
--   両方を使う側 (Main.hs) では qualified import で区別する。
--   ghci> area 2             ==> 12.566370614359172   (pi * 2 * 2)
--   ghci> circumference 1    ==> 6.283185307179586    (2 * pi * 1)
--
-- undefined を自分の実装に書き換えること。モジュール宣言・型宣言は変更しないこと。

module Shape.Circle
  ( area,
    circumference,
  )
where

-- 半径 r の円の面積
area :: Double -> Double
area = undefined

-- 半径 r の円周の長さ
circumference :: Double -> Double
circumference = undefined

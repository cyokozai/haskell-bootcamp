module Shape.Rectangle (area, perimeter) where

area :: Double -> Double -> Double
area w h = w * h

perimeter :: Double -> Double -> Double
perimeter w h = 2 * (w + h)

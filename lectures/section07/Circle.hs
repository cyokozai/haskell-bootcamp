module Shape.Circle (area, perimeter) where

area :: (Floating a) => a -> a
area redius = redius * redius * pi

perimeter :: (Floating a) => a -> a
perimeter redius = 2 * redius * pi
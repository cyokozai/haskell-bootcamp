module Shape (rectangleArea, rectanglePerimeter, circleArea, circumference) where

rectangleArea :: Double -> Double -> Double
rectangleArea w h = w * h

rectanglePerimeter :: Double -> Double -> Double
rectanglePerimeter w h = 2 * (w + h)

circleArea :: Double -> Double
circleArea r = pi * r * r

circumference :: Double -> Double
circumference r = 2 * pi * r

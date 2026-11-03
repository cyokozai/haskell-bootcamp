import qualified Shape.Rectangle as Rectangle
import qualified Shape.Circle as Circle

rectAreaFor :: (Num a) => [(a, a)] -> [a]
rectAreaFor d = map (\(width, height) -> Rectangle.area width height) d

circleAreaFor :: (Floating a) => [a] -> [a]
circleAreaFor d = map (\redius -> Circle.area redius) d

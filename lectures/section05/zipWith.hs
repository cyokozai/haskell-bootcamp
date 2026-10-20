-- 5.2 高階実演 zipWith を実装する

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys)
    = f x y : zipWith' f xs ys

-- 5.5 畳み込み foldr と foldl で map' を書く

map' :: (a -> b) -> [a] -> [b]
map' f xs = foldr (\x acc -> f x : acc) [] xs

mapL :: (a -> b) -> [a] -> [b]
mapL f xs = foldl (\acc x -> acc ++ [f x]) [] xs

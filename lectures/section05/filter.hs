-- 5.3 関数プログラマの道具箱 filter は述語を満たす要素だけを残す

import Prelude hiding (filter)

filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x:xs)
    | p x       = x : filter p xs
    | otherwise = filter p xs

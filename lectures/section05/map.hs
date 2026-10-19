-- 5.3 関数プログラマの道具箱 map はリストのすべての要素に関数を適用する

import Prelude hiding (map)

map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs

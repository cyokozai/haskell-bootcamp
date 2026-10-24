-- 5.2 高階実演 最初の2つの引数を入れ替える flip を実装する

flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y

flipWhere :: (a -> b -> c) -> (b -> a -> c)
flipWhere f = g
    where g x y = f y x

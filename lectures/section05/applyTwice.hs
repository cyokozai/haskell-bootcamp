-- 5.2 高階実演 関数を受け取り、2回適用する applyTwice

applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

multThree :: Int -> Int -> Int -> Int
multThree x y z = x * y * z

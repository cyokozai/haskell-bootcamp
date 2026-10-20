-- 5.7 関数合成 ポイントフリースタイル

sum' :: (Num a) => [a] -> a
sum' xs = foldl (+) 0 xs

sum'' :: (Num a) => [a] -> a
sum'' = foldl (+) 0

fn :: Double -> Integer
fn x = ceiling (negate (tan (cos (max 50 x))))

fn' :: Double -> Integer
fn' = ceiling . negate . tan . cos . max 50

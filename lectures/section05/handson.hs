-- 第5章 高階関数 ハンズオン用コード
--
-- 使い方:
--   $ cd lectures/section05
--   $ ghci handson.hs        -- 読み込んで起動
--   ghci> multThree 3 5 9    -- 関数を試す
--   ghci> :r                 -- ファイルを編集したら再読み込み
--   ghci> :t zipWith'        -- 型を確認
--   ghci> :q                 -- 終了
--
-- 各ハンズオン (H1〜H5) で使う定義を、教科書の節の順に並べています。

-- ===================================================================
-- 5.1 カリー化関数 (H1)
-- ===================================================================

multThree :: Int -> Int -> Int -> Int
multThree x y z = x * y * z

-- multThree 9 は「残り2つの引数を掛けて9倍する関数」
multTwoWithNine :: Int -> Int -> Int
multTwoWithNine = multThree 9

compareWithHundred :: Int -> Ordering
compareWithHundred = compare 100

-- セクション: 中置関数の片側だけに値を置いて括弧で囲む
divideByTen :: (Floating a) => a -> a
divideByTen = (/ 10)

isUpperAlphanum :: Char -> Bool
isUpperAlphanum = (`elem` ['A' .. 'Z'])

-- (-4) は「マイナス4」なので、4を引く関数は subtract で作る
minusFour :: Int -> Int
minusFour = subtract 4

-- ===================================================================
-- 5.2 高階実演 (H2 / 中間演習)
-- ===================================================================

-- 型の括弧は必須: 第1引数が「a -> a の関数」であることを表す
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x : xs) (y : ys) = f x y : zipWith' f xs ys

-- where 版
flipWhere :: (a -> b -> c) -> (b -> a -> c)
flipWhere f = g
  where
    g x y = f y x

-- カリー化を活かした簡潔版
flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y

-- ===================================================================
-- 5.3 関数プログラマの道具箱 (中間演習)
-- ===================================================================

-- Prelude の map / filter と名前がぶつからないよう ' を付ける
map'' :: (a -> b) -> [a] -> [b]
map'' _ [] = []
map'' f (x : xs) = f x : map'' f xs

filter'' :: (a -> Bool) -> [a] -> [a]
filter'' _ [] = []
filter'' p (x : xs)
  | p x = x : filter'' p xs
  | otherwise = filter'' p xs

-- 第4章のクイックソートを filter で書き直したもの
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x : xs) =
  let smallerOrEqual = filter (<= x) xs
      larger = filter (> x) xs
   in quicksort smallerOrEqual ++ [x] ++ quicksort larger

-- 10万以下で 3829 で割り切れる最大の数
largestDivisible :: Integer
largestDivisible = head (filter p [100000, 99999 ..])
  where
    p x = x `mod` 3829 == 0

-- 10000 より小さい奇数の平方数の和
oddSquares :: Integer
oddSquares = sum (takeWhile (< 10000) (filter odd (map (^ 2) [1 ..])))

-- コラッツ列
chain :: Integer -> [Integer]
chain 1 = [1]
chain n
  | even n = n : chain (n `div` 2)
  | odd n = n : chain (n * 3 + 1)

-- 1〜100 のうち、長さが 15 より長いコラッツ列の開始数の個数
numLongChains :: Int
numLongChains = length (filter isLong (map chain [1 .. 100]))
  where
    isLong xs = length xs > 15

-- map に2引数関数を渡すと「関数のリスト」ができる
listOfFuns :: [Integer -> Integer]
listOfFuns = map (*) [0 ..]

-- ===================================================================
-- 5.4 ラムダ式
-- ===================================================================

numLongChains' :: Int
numLongChains' = length (filter (\xs -> length xs > 15) (map chain [1 .. 100]))

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

addThree' :: Int -> Int -> Int -> Int
addThree' = \x -> \y -> \z -> x + y + z

flipLambda :: (a -> b -> c) -> b -> a -> c
flipLambda f = \x y -> f y x

-- ===================================================================
-- 5.5 畳み込み (H4)
-- ===================================================================

sumL :: (Num a) => [a] -> a
sumL xs = foldl (\acc x -> acc + x) 0 xs

-- カリー化により xs を省略できる
sumL' :: (Num a) => [a] -> a
sumL' = foldl (+) 0

mapR :: (a -> b) -> [a] -> [b]
mapR f xs = foldr (\x acc -> f x : acc) [] xs

-- foldl 版 (++ は : より遅いので、普通は foldr を使う)
mapL :: (a -> b) -> [a] -> [b]
mapL f xs = foldl (\acc x -> acc ++ [f x]) [] xs

elem' :: (Eq a) => a -> [a] -> Bool
elem' y ys = foldr (\x acc -> if x == y then True else acc) False ys

maximumF :: (Ord a) => [a] -> a
maximumF = foldl1 max

reverseF :: [a] -> [a]
reverseF = foldl (\acc x -> x : acc) []

reverseF' :: [a] -> [a]
reverseF' = foldl (flip (:)) []

productF :: (Num a) => [a] -> a
productF = foldl (*) 1

filterF :: (a -> Bool) -> [a] -> [a]
filterF p = foldr (\x acc -> if p x then x : acc else acc) []

lastF :: [a] -> a
lastF = foldl1 (\_ x -> x)

-- foldr は無限リストでも止まることがある
and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs

-- 自然数の平方根を小さい順に足して 1000 を超えるのは何個目か
sqrtSums :: Int
sqrtSums = length (takeWhile (< 1000) (scanl1 (+) (map sqrt [1 ..]))) + 1

-- ===================================================================
-- 5.6 $ を使った関数適用 / 5.7 関数合成 (H5)
-- ===================================================================

-- ghci> sum (filter (> 10) (map (*2) [2..10]))
-- ghci> sum $ filter (> 10) $ map (*2) [2..10]
-- ghci> map ($ 3) [(4+), (10*), (^2), sqrt]
-- ghci> map (negate . abs) [5,-3,-6,7,-3,2,-19,24]
-- ghci> map (negate . sum . tail) [[1..5],[3..6],[1..7]]

sumP :: (Num a) => [a] -> a
sumP xs = foldl (+) 0 xs

-- ポイントフリースタイル
sumP' :: (Num a) => [a] -> a
sumP' = foldl (+) 0

fn :: Double -> Integer
fn x = ceiling (negate (tan (cos (max 50 x))))

fn' :: Double -> Integer
fn' = ceiling . negate . tan . cos . max 50

oddSquareSum :: Integer
oddSquareSum = sum (takeWhile (< 10000) (filter odd (map (^ 2) [1 ..])))

oddSquareSum' :: Integer
oddSquareSum' = sum . takeWhile (< 10000) . filter odd $ map (^ 2) [1 ..]

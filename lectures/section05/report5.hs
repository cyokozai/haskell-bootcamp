-- 第5回 課題 (第5章 高階関数)
--
-- 学籍番号:
-- 氏名:
--
-- 各問の undefined を自分の実装に書き換えて提出すること。
-- 型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report5.hs     -- 全問のテストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report5.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

-- -------------------------------------------------------------------
-- 問1 zipWith' を実装せよ (標準関数 zipWith は使用不可)
--   ghci> zipWith' (+) [4,2,5,6] [2,6,2,3]   ==> [6,8,7,9]
-- -------------------------------------------------------------------
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' = undefined

-- -------------------------------------------------------------------
-- 問2 flip' を実装せよ (標準関数 flip は使用不可)
--   ghci> flip' zip [1,2,3] "abc"   ==> [('a',1),('b',2),('c',3)]
-- -------------------------------------------------------------------
flip' :: (a -> b -> c) -> b -> a -> c
flip' = undefined

-- -------------------------------------------------------------------
-- 問3 1 から 100 までの数のうち、長さが 15 より長いコラッツ列の
--     開始数はいくつあるか。map と filter を使って求めよ
--
--   コラッツ列: 1 なら終了 / 偶数なら 2 で割る / 奇数なら 3 倍して 1 を足す
--   ghci> chain 10   ==> [10,5,16,8,4,2,1]
-- -------------------------------------------------------------------
chain :: Integer -> [Integer]
chain = undefined

numLongChains :: Int
numLongChains = undefined

-- -------------------------------------------------------------------
-- 問4 foldr を使って map' と filter' を実装せよ
-- -------------------------------------------------------------------
map' :: (a -> b) -> [a] -> [b]
map' = undefined

filter' :: (a -> Bool) -> [a] -> [a]
filter' = undefined

-- -------------------------------------------------------------------
-- 問5 畳み込みを使って maximum' と reverse' を実装せよ
--     (第4回の再帰版と比べてみよう)
-- -------------------------------------------------------------------
maximum' :: (Ord a) => [a] -> a
maximum' = undefined

reverse' :: [a] -> [a]
reverse' = undefined

-- -------------------------------------------------------------------
-- 問6 自然数の平方根を小さい順に足していったとき、
--     和が 1000 を超えるのは何個目か。scanl1 と takeWhile を使って求めよ
-- -------------------------------------------------------------------
sqrtSums :: Int
sqrtSums = undefined

-- -------------------------------------------------------------------
-- 問7 次の関数を $ と . を使って書き換えよ
--   oddSquareSum = sum (takeWhile (<10000) (filter odd (map (^2) [1..])))
-- 発展: fn x = ceiling (negate (tan (cos (max 50 x))))
--       をポイントフリースタイル (引数 x を書かない形) で書け
-- -------------------------------------------------------------------
oddSquareSum :: Integer
oddSquareSum = undefined

fn :: Double -> Integer
fn = undefined

-- ===================================================================
-- 動作確認 (ここから下は変更しないこと)
-- ===================================================================
check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問1 zipWith'" (zipWith' (+) [4, 2, 5, 6] [2, 6, 2, 3 :: Int]) [6, 8, 7, 9]
  check "問1 zipWith' (長さ違い)" (zipWith' max [6, 3, 2, 1] [7, 3, 1, 5, 9 :: Int]) [7, 3, 2, 5]
  check "問2 flip'" (flip' zip [1, 2, 3 :: Int] "abc") [('a', 1), ('b', 2), ('c', 3)]
  check "問2 flip' div" (zipWith (flip' div) [2, 2 ..] [10, 8, 6, 4, 2 :: Int]) [5, 4, 3, 2, 1]
  check "問3 chain 10" (chain 10) [10, 5, 16, 8, 4, 2, 1]
  check "問3 numLongChains" numLongChains 66
  check "問4 map'" (map' (+ 3) [1, 2, 3 :: Int]) [4, 5, 6]
  check "問4 filter'" (filter' even [1 .. 10 :: Int]) [2, 4, 6, 8, 10]
  check "問5 maximum'" (maximum' [3, 9, 2, 7 :: Int]) 9
  check "問5 reverse'" (reverse' [3, 4, 5, 6 :: Int]) [6, 5, 4, 3]
  check "問6 sqrtSums" sqrtSums 131
  check "問7 oddSquareSum" oddSquareSum 166650
  check "問7 fn" (map fn [0, 49, 50, 51, 100]) (map fnOrig [0, 49, 50, 51, 100])
  where
    fnOrig x = ceiling (negate (tan (cos (max 50 x)))) :: Integer

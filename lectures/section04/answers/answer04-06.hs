{-# LANGUAGE BangPatterns #-}
-- 問6) 末尾再帰について調べて、x の n 乗を計算するプログラムを
--      末尾再帰最適化が可能となるように作成せよ
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-06.hs
--   ghci> powerTail 2 10
--   1024
--   ghci> fastPowerTail 2 100
--   ghci> main
--
-- スタックを小さくして違いを見る（GHCi の起動オプションで指定する）:
--   ghci +RTS -K1m -RTS lectures/section04/answers/answer04-06.hs
--   ghci> power 1 1000000           -- 末尾再帰でない        → *** Exception: stack overflow
--   ghci> powerTailLazy 1 1000000   -- 末尾再帰だが遅延したまま → *** Exception: stack overflow
--   ghci> powerTail 1 1000000       -- 末尾再帰 + 正格        → 1
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-06.hs

-- 比較用: 問4 の版（末尾再帰ではない）
--   power x n = x * power x (n - 1)
--   再帰呼び出しの「後に」x * ... が残るので、呼び出しごとにスタックが積まれる
power :: Integer -> Integer -> Integer
power _ 0 = 1
power x n = x * power x (n - 1)

-- 失敗例: 形は末尾再帰だが、累積引数 acc が遅延評価のまま
--   go (acc * x) の acc * x はすぐには計算されず、
--   ((((1 * x) * x) * x) ...) という未評価の式（サンク）が n 段積み上がる。
--   最後に acc を表示するとき、この式を一気に評価するのでスタックを使い切る
powerTailLazy :: Integer -> Integer -> Integer
powerTailLazy x n = go 1 n
  where
    go acc 0 = acc
    go acc k = go (acc * x) (k - 1)

-- 解答例: 末尾再帰 + 累積引数を正格評価（BangPatterns）
--   !acc と書くと、go に入る時点で acc が評価済みの値になる。
--   再帰呼び出しが関数の最後の処理なので、GHC はループ（ジャンプ）として実行できる
powerTail :: Integer -> Integer -> Integer
powerTail x n
  | n < 0     = error "n must be non-negative"
  | otherwise = go 1 n
  where
    go !acc 0 = acc
    go !acc k = go (acc * x) (k - 1)

-- 別解: 拡張を使わず seq で正格にする版
--   a `seq` b は「a を評価してから b を返す」
powerTailSeq :: Integer -> Integer -> Integer
powerTailSeq x n = go 1 n
  where
    go acc 0 = acc
    go acc k = let acc' = acc * x in acc' `seq` go acc' (k - 1)

-- 発展: 問5 の高速化と末尾再帰を組み合わせた版
--   常に acc * b^k == x^n が成り立つように (acc, b, k) を更新していく
fastPowerTail :: Integer -> Integer -> Integer
fastPowerTail x n
  | n < 0     = error "n must be non-negative"
  | otherwise = go 1 x n
  where
    go !acc _ 0 = acc
    go !acc !b k
      | even k    = go acc       (b * b) (k `div` 2)
      | otherwise = go (acc * b) b       (k - 1)

main :: IO ()
main = do
  putStrLn $ "powerTail     2 10  = " ++ show (powerTail 2 10)
  putStrLn $ "powerTailSeq  2 10  = " ++ show (powerTailSeq 2 10)
  putStrLn $ "fastPowerTail 2 10  = " ++ show (fastPowerTail 2 10)
  putStrLn $ "fastPowerTail 2 100 = " ++ show (fastPowerTail 2 100)
  putStrLn $ "all equal to 7^77 : "
    ++ show (all (== (7 :: Integer) ^ (77 :: Int)) [power 7 77, powerTailLazy 7 77, powerTail 7 77, powerTailSeq 7 77, fastPowerTail 7 77])
  putStrLn $ "powerTail 1 1000000 = " ++ show (powerTail 1 1000000)

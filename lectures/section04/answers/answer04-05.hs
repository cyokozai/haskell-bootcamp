-- 問5) x の n 乗を次のアルゴリズムで高速化せよ
--   a^0      = 1
--   a^{2n}   = (a*a)^n      , n > 0
--   a^{2n+1} = a * (a^{2n})
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-05.hs
--   ghci> fastPower 2 10
--   1024
--   ghci> :set +s
--   ghci> power 3 100000 `mod` 10
--   ghci> fastPower 3 100000 `mod` 10
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-05.hs

-- 比較用: 問4 の素朴な版
power :: Integer -> Integer -> Integer
power _ 0 = 1
power x n
  | n < 0     = error "n must be non-negative"
  | otherwise = x * power x (n - 1)

-- 解答例: 3 本の式をそのままパターンとガードに対応させる
fastPower :: Integer -> Integer -> Integer
fastPower _ 0 = 1                                     -- a^0      = 1
fastPower a n
  | n < 0     = error "n must be non-negative"
  | even n    = fastPower (a * a) (n `div` 2)         -- a^{2n}   = (a*a)^n
  | otherwise = a * fastPower a (n - 1)               -- a^{2n+1} = a * a^{2n}

-- 掛け算の回数を数える関数（計算量の比較用）
powerMuls :: Integer -> Integer
powerMuls 0 = 0
powerMuls n = 1 + powerMuls (n - 1)

fastPowerMuls :: Integer -> Integer
fastPowerMuls 0 = 0
fastPowerMuls n
  | even n    = 1 + fastPowerMuls (n `div` 2)
  | otherwise = 1 + fastPowerMuls (n - 1)

main :: IO ()
main = do
  putStrLn $ "fastPower 2 10  = " ++ show (fastPower 2 10)
  putStrLn $ "fastPower 3 0   = " ++ show (fastPower 3 0)
  putStrLn $ "fastPower 2 100 = " ++ show (fastPower 2 100)
  putStrLn $ "power 7 77 == fastPower 7 77 : " ++ show (power 7 77 == fastPower 7 77)
  putStrLn ""
  putStrLn "n        | muls (power)       | muls (fastPower)"
  mapM_ (\n -> putStrLn $ pad 8 (show n) ++ " | " ++ pad 18 (show (powerMuls n)) ++ " | " ++ show (fastPowerMuls n))
        [10, 100, 1000, 1000000]
  where
    pad k s = s ++ replicate (k - length s) ' '

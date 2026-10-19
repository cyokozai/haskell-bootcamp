-- 問4) x と n を整数とした際に、x の n 乗を計算するプログラムを作成せよ
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-04.hs
--   ghci> power 2 10
--   1024
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-04.hs

-- 解答例: x^0 = 1, x^n = x * x^(n-1) をそのまま書く
-- Int だと 2^63 以上で桁あふれするので、多倍長整数の Integer を使う
power :: Integer -> Integer -> Integer
power _ 0 = 1
power x n
  | n < 0     = error "n must be non-negative"
  | otherwise = x * power x (n - 1)

main :: IO ()
main = do
  putStrLn $ "power 2 10  = " ++ show (power 2 10)
  putStrLn $ "power 3 0   = " ++ show (power 3 0)
  putStrLn $ "power (-2) 3 = " ++ show (power (-2) 3)
  putStrLn $ "power 2 100 = " ++ show (power 2 100)
  putStrLn $ "2 ^ 100     = " ++ show (2 ^ (100 :: Int) :: Integer) ++ "  (same as the standard ^)"

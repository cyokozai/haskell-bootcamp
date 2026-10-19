-- 問1) maximum' 関数を実装せよ
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-01.hs
--   ghci> maximum' [3, 1, 4, 1, 5, 9, 2, 6]
--   9
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-01.hs

-- 解答例: ガードと where を使う版（教科書の書き方）
maximum' :: (Ord a) => [a] -> a
maximum' []  = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs)
  | x > maxTail = x
  | otherwise   = maxTail
  where maxTail = maximum' xs

-- 別解: max 関数で 2 つずつ比べる版
maximum'' :: (Ord a) => [a] -> a
maximum'' []     = error "maximum of empty list"
maximum'' [x]    = x
maximum'' (x:xs) = max x (maximum'' xs)

main :: IO ()
main = do
  putStrLn $ "maximum'  [3,1,4,1,5,9,2,6] = " ++ show (maximum' [3, 1, 4, 1, 5, 9, 2, 6 :: Int])
  putStrLn $ "maximum'' [3,1,4,1,5,9,2,6] = " ++ show (maximum'' [3, 1, 4, 1, 5, 9, 2, 6 :: Int])
  putStrLn $ "maximum'  \"haskell\"         = " ++ show (maximum' "haskell")
  putStrLn $ "maximum'  [-5,-2,-9]        = " ++ show (maximum' [-5, -2, -9 :: Int])

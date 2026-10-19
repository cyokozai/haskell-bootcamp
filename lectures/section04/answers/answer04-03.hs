-- 問3) クイックソートを実装せよ
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-03.hs
--   ghci> quicksort [10, 2, 5, 3, 1, 6, 7, 4, 2, 3, 4, 8, 9]
--   [1,2,2,3,3,4,4,5,6,7,8,9,10]
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-03.hs

-- 解答例: 先頭要素を基準値（ピボット）にして、小さい側・大きい側に分けて再帰
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort smallerOrEqual ++ [x] ++ quicksort larger
  where
    smallerOrEqual = [a | a <- xs, a <= x]
    larger         = [a | a <- xs, a > x]

main :: IO ()
main = do
  putStrLn $ "quicksort [10,2,5,3,1,6,7,4,2,3,4,8,9] = "
    ++ show (quicksort [10, 2, 5, 3, 1, 6, 7, 4, 2, 3, 4, 8, 9 :: Int])
  putStrLn $ "quicksort \"the quick brown fox\"     = "
    ++ show (quicksort "the quick brown fox")
  putStrLn $ "quicksort []                           = "
    ++ show (quicksort ([] :: [Int]))

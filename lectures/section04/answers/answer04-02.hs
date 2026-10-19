-- 問2) reverse' 関数を実装せよ
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-02.hs
--   ghci> reverse' [1, 2, 3, 4, 5]
--   [5,4,3,2,1]
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-02.hs

-- 解答例: 先頭を取り出して、残りを反転したものの末尾に付ける
reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]

-- 別解: 累積引数を使う版（++ を使わないので速い。問6 の末尾再帰の予習）
reverseAcc :: [a] -> [a]
reverseAcc xs = go [] xs
  where
    go acc []     = acc
    go acc (y:ys) = go (y : acc) ys

main :: IO ()
main = do
  putStrLn $ "reverse'   [1,2,3,4,5] = " ++ show (reverse' [1, 2, 3, 4, 5 :: Int])
  putStrLn $ "reverseAcc [1,2,3,4,5] = " ++ show (reverseAcc [1, 2, 3, 4, 5 :: Int])
  putStrLn $ "reverse'   \"haskell\"   = " ++ show (reverse' "haskell")
  putStrLn $ "reverse'   []          = " ++ show (reverse' ([] :: [Int]))

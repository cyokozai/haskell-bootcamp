-- 問7) 関数 f :: a -> b とリスト [a] を受け取り、
--      リスト [f(a)] を返す関数 myflist を作成せよ（標準関数 map 等は使用不可）
--
-- GHCi での実行:
--   ghci> :l lectures/section04/answers/answer04-07.hs
--   ghci> myflist f [1..10]
--   [2,4,6,8,10,12,14,16,18,20]
--   ghci> myflist (+ 1) [1, 2, 3]
--   [2,3,4]
--   ghci> :t myflist
--   myflist :: (a -> b) -> [a] -> [b]
--   ghci> main
--
-- ターミナルから一括実行:
--   runghc lectures/section04/answers/answer04-07.hs

-- 解答例: 空リストなら空リスト、そうでなければ先頭に関数 g を適用して残りは再帰
--   （引数名を g にしているのは、下で定義する f と名前が重ならないようにするため）
myflist :: (a -> b) -> [a] -> [b]
myflist _ []     = []
myflist g (x:xs) = g x : myflist g xs

-- 問題文の例で使う関数
f :: Int -> Int
f x = 2 * x

main :: IO ()
main = do
  putStrLn $ "myflist f [1..10]         = " ++ show (myflist f [1 .. 10])
  putStrLn $ "myflist (+ 1) [1,2,3]     = " ++ show (myflist (+ 1) [1, 2, 3 :: Int])
  putStrLn $ "myflist show [1,2,3]      = " ++ show (myflist show [1, 2, 3 :: Int])
  putStrLn $ "myflist even [1,2,3,4]    = " ++ show (myflist even [1, 2, 3, 4 :: Int])
  putStrLn $ "myflist f []              = " ++ show (myflist f [])

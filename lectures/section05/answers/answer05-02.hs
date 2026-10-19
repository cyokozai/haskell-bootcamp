-- 第5回 課題 解答例 問2 foldr を使って map' と filter' を実装せよ
--   ghci> map' (+3) [1,2,3]        ==> [4,5,6]
--   ghci> filter' even [1..10]     ==> [2,4,6,8,10]
--
-- 実行: runghc answers/answer05-02.hs
-- 対話: ghci answers/answer05-02.hs

import Control.Exception (SomeException, evaluate, try)

map' :: (a -> b) -> [a] -> [b]
map' f = foldr (\x acc -> f x : acc) []

filter' :: (a -> Bool) -> [a] -> [a]
filter' p = foldr (\x acc -> if p x then x : acc else acc) []

-- ===================================================================
-- 動作確認 (report05-02.hs と同じテスト)
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
  check "問2 map'" (map' (+ 3) [1, 2, 3 :: Int]) [4, 5, 6]
  check "問2 filter'" (filter' even [1 .. 10 :: Int]) [2, 4, 6, 8, 10]

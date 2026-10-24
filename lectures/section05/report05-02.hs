-- 第5回 課題 問2 foldr を使って map' と filter' を実装せよ
--   ghci> map' (+3) [1,2,3]        ==> [4,5,6]
--   ghci> filter' even [1..10]     ==> [2,4,6,8,10]
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report05-02.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report05-02.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

map' :: (a -> b) -> [a] -> [b]
map' = undefined

filter' :: (a -> Bool) -> [a] -> [a]
filter' = undefined

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
  check "問2 map'" (map' (+ 3) [1, 2, 3 :: Int]) [4, 5, 6]
  check "問2 filter'" (filter' even [1 .. 10 :: Int]) [2, 4, 6, 8, 10]

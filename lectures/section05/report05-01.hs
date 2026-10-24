-- 第5回 課題 問1 zipWith' を実装せよ (標準関数 zipWith は使用不可)
--   ghci> zipWith' (+) [4,2,5,6] [2,6,2,3]   ==> [6,8,7,9]
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report05-01.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report05-01.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' = undefined

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

-- 第5回 課題 解答例 問3 次の関数を $ と . を使って書き換えよ
--   oddSquareSum = sum (takeWhile (<10000) (filter odd (map (^2) [1..])))
-- 発展: fn x = ceiling (negate (tan (cos (max 50 x))))
--       をポイントフリースタイル (引数 x を書かない形) で書け
--
-- 実行: runghc answers/answer05-03.hs
-- 対話: ghci answers/answer05-03.hs

import Control.Exception (SomeException, evaluate, try)

oddSquareSum :: Integer
oddSquareSum = sum . takeWhile (< 10000) . filter odd $ map (^ 2) [1 ..]

fn :: Double -> Integer
fn = ceiling . negate . tan . cos . max 50

-- ===================================================================
-- 動作確認 (report05-03.hs と同じテスト)
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
  check "問3 oddSquareSum" oddSquareSum 166650
  check "問3 fn (発展)" (map fn [0, 49, 50, 51, 100]) (map fnOrig [0, 49, 50, 51, 100])
  where
    fnOrig x = ceiling (negate (tan (cos (max 50 x)))) :: Integer

-- 第6回 課題 問8 内積を計算する関数 dotproduct2 を末尾再帰を使って作成せよ
--   ghci> dotproduct2 [1..10] [2..11]   ==> 440
--
-- 2 つのリストの長さが違う場合は、短い方に合わせる (zipWith と同じ)。
--
-- 実行: runghc reports/report08/report08.hs
-- 対話: ghci reports/report08/report08.hs

import Control.Exception (SomeException, evaluate, try)

-- 補助関数 go に累積引数 acc (ここまでの和) を持たせる。
-- go の再帰呼び出しが関数の最後の処理なので末尾再帰になっている。
-- ただし Haskell は遅延評価なので、acc + x * y はその場では計算されず
-- 「未評価の式 (thunk)」として積み上がっていく (問9 を参照)。
dotproduct2 :: (Num a) => [a] -> [a] -> a
dotproduct2 = go 0
  where
    go acc (x : xs) (y : ys) = go (acc + x * y) xs ys
    go acc _ _ = acc

-- ===================================================================
-- 動作確認
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
  check "問8 dotproduct2" (dotproduct2 [1 .. 10] [2 .. 11 :: Integer]) 440
  check "問8 dotproduct2 (長さ違い)" (dotproduct2 [1, 2, 3] [4, 5 :: Integer]) 14
  check "問8 dotproduct2 (空リスト)" (dotproduct2 [] [1, 2, 3 :: Integer]) 0
  check "問8 dotproduct2 (Double)" (dotproduct2 [0.5, 1.5] [2.0, 4.0 :: Double]) 7.0

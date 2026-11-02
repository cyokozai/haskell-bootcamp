-- 第6回 課題 問7 内積を計算する関数 dotproduct を (通常の) 再帰を使って作成せよ
--   ghci> dotproduct [1..10] [2..11]   ==> 440
--
-- 2 つのリストの長さが違う場合は、短い方に合わせる (zipWith と同じ)。
--   ghci> dotproduct [1,2,3] [4,5]     ==> 14   (= 1*4 + 2*5)
--
-- 検算: [1..10] と [2..11] の内積は Σ k(k+1) (k = 1..10)。
--   Σ k(k+1) = n(n+1)(n+2)/3 なので 10*11*12/3 = 440。
--
-- 実行: runghc reports/report07/report07.hs
-- 対話: ghci reports/report07/report07.hs

import Control.Exception (SomeException, evaluate, try)

-- x*y を足してから残りの内積を足す。再帰呼び出しの結果に (+) を
-- かける形なので末尾再帰ではない (呼び出しごとに足し算が積み残る)。
dotproduct :: (Num a) => [a] -> [a] -> a
dotproduct (x : xs) (y : ys) = x * y + dotproduct xs ys
dotproduct _ _ = 0

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
  check "問7 dotproduct" (dotproduct [1 .. 10] [2 .. 11 :: Integer]) 440
  check "問7 dotproduct (長さ違い)" (dotproduct [1, 2, 3] [4, 5 :: Integer]) 14
  check "問7 dotproduct (空リスト)" (dotproduct [] [1, 2, 3 :: Integer]) 0
  check "問7 dotproduct (Double)" (dotproduct [0.5, 1.5] [2.0, 4.0 :: Double]) 7.0

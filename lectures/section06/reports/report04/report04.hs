-- 第6回 課題 問4 各桁の数の合計が N になる最初の自然数を知りたい。
--   先ほどの firstTo 関数 (下に参考として載せてある) は N が大きくなると非常に遅い。
--   そこで、N が 100 や 1000 のような場合でも 1 秒以内に求めたい。
--   firstTo' :: Int -> Integer を実装せよ
--   ghci> firstTo' 40     ==> 49999
--   ghci> firstTo' 100    ==> 199999999999
--
-- 実行: runghc reports/report04/report04.hs
-- 対話: ghci reports/report04/report04.hs

import Control.Exception (SomeException, evaluate, try)
import Data.Char (digitToInt)
import Data.List (find)

firstTo' :: Int -> Integer
firstTo' n
  | n <= 0 = error "firstTo': n は 1 以上の自然数を与えること"
  | r == 0 = nines
  | otherwise = toInteger r * 10 ^ q + nines
  where
    (q, r) = n `divMod` 9
    nines = 10 ^ q - 1 -- 9 が q 個並んだ数 (q = 0 なら 0)

-- 考え方:
--   1 桁の最大は 9 なので、桁和 n を作るには少なくとも ceiling (n / 9) 桁が必要。
--   桁数が少ないほど数は小さいので、まず桁数を最小にする。
--   桁数が同じなら上の桁ほど小さい方がよいので、余り n `mod` 9 を先頭に置き、
--   その後ろに 9 を n `div` 9 個並べる (余りが 0 なら 9 だけを並べる)。
--   例: n = 40 = 4 + 9 * 4  ==> 4 9999 = 49999
--   1 から順に調べる firstTo と違い、計算量は桁数 (n / 9 程度) に比例するだけなので
--   n = 1000 でも一瞬で求まる。
--   n <= 0 には条件を満たす自然数が無いので error とする。

-- ===================================================================
-- 参考: 教科書 6 章の firstTo (1 から順に調べるので N が大きいと非常に遅い)
-- ===================================================================
digitSum :: Integer -> Int
digitSum = sum . map digitToInt . show

firstTo :: Int -> Maybe Integer
firstTo n = find (\x -> digitSum x == n) [1 ..]

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
  check "問4 firstTo' 1" (firstTo' 1) 1
  check "問4 firstTo' 27" (firstTo' 27) 999
  check "問4 firstTo' 40" (firstTo' 40) 49999
  check "問4 firstTo' 1..50 が firstTo と一致" (map (Just . firstTo') [1 .. 50]) (map firstTo [1 .. 50])
  check "問4 firstTo' 100" (firstTo' 100) 199999999999
  check "問4 firstTo' 1000 の桁和" (digitSum (firstTo' 1000)) 1000
  check "問4 firstTo' 1000 の桁数" (length (show (firstTo' 1000))) 112

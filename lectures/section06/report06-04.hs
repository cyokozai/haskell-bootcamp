-- 第6回 課題 問4 各桁の数の合計が N になる最初の自然数を知りたい。
--   教科書の firstTo 関数 (下に参考として載せてある) は N が大きくなると非常に遅い。
--   そこで、N が 100 や 1000 のような場合でも 1 秒以内に求めたい。
--   firstTo' :: Int -> Integer を実装せよ
--   ghci> firstTo' 40     ==> 49999
--   ghci> firstTo' 100    ==> 199999999999
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report06-04.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report06-04.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)
import Data.Char (digitToInt)
import Data.List (find)

firstTo' :: Int -> Integer
firstTo' = undefined

-- ===================================================================
-- 参考: 教科書 6 章の firstTo (1 から順に調べるので N が大きいと非常に遅い)
-- ===================================================================
digitSum :: Integer -> Int
digitSum = sum . map digitToInt . show

firstTo :: Int -> Maybe Integer
firstTo n = find (\x -> digitSum x == n) [1 ..]

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
  check "問4 firstTo' 1" (firstTo' 1) 1
  check "問4 firstTo' 27" (firstTo' 27) 999
  check "問4 firstTo' 40" (firstTo' 40) 49999
  check "問4 firstTo' 1..50 が firstTo と一致" (map (Just . firstTo') [1 .. 50]) (map firstTo [1 .. 50])
  check "問4 firstTo' 100" (firstTo' 100) 199999999999
  check "問4 firstTo' 1000 の桁和" (digitSum (firstTo' 1000)) 1000
  check "問4 firstTo' 1000 の桁数" (length (show (firstTo' 1000))) 112

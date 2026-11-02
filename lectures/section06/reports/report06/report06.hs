-- 第6回 課題 問6 Map.fromListWith を使用して、6章2節1 (単語を数える) の wordNums を
--   sort なしで実装せよ
--   教科書の wordNums:
--     wordNums :: String -> [(String, Int)]
--     wordNums = map (\ws -> (head ws, length ws)) . group . sort . words
--   ghci> wordNums "wa wa wee wa"   ==> [("wa",3),("wee",1)]
--
-- 実行: runghc reports/report06/report06.hs
-- 対話: ghci reports/report06/report06.hs

import Control.Exception (SomeException, evaluate, try)
import qualified Data.List as List
import qualified Data.Map as Map

-- 1. words で単語に分け、各単語を (単語, 1) の組にする。
-- 2. Map.fromListWith (+) は同じキーが出てきたら値を (+) でまとめるので、
--    単語ごとの出現回数の Map ができる。
-- 3. Map.toList で [(単語, 回数)] のリストに戻す。
-- Map はキーの順序 (Ord) で要素を保持し、Map.toList はキーの昇順でリストを返す。
-- そのため sort を呼ばなくても、教科書の版と同じく単語の辞書順に並んだ結果になる。
wordNums :: String -> [(String, Int)]
wordNums = Map.toList . Map.fromListWith (+) . map (\w -> (w, 1)) . words

-- ===================================================================
-- 動作確認
-- ===================================================================

-- 教科書の wordNums (sort を使う版)。結果の比較にだけ使う。
wordNumsBook :: String -> [(String, Int)]
wordNumsBook = map (\ws -> (head ws, length ws)) . List.group . List.sort . words

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問6 wordNums" (wordNums "wa wa wee wa") [("wa", 3), ("wee", 1)]
  check "問6 wordNums (教科書の版と同じ結果)" (wordNums text) (wordNumsBook text)
  check "問6 wordNums (空文字列)" (wordNums "") []
  where
    text = "the quick brown fox jumps over the lazy dog the end fox"

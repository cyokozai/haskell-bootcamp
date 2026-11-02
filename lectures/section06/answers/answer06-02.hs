-- 第6回 課題 解答例 問2 重複している単語のみ，出現回数の多い順に出現回数と単語のペアをリスト化したい，
--   duplicateWordCount :: String -> [(Int, String)] を実装せよ
--   ghci> duplicateWordCount "a b a c b a d"   ==> [(3,"a"),(2,"b")]
-- 仕様:
--   - 単語は words で区切る (空白・改行で区切られた文字列を 1 単語とする)
--   - 出現回数が 2 以上の単語だけを残す (重複がなければ [])
--   - 出現回数の多い順に並べる。出現回数が同じときは単語の辞書順 (昇順) に並べる
--
-- 実行: runghc answers/answer06-02.hs
-- 対話: ghci answers/answer06-02.hs

import Control.Exception (SomeException, evaluate, try)
import Data.List (group, sort, sortOn)
import Data.Ord (Down (..))

-- words で単語に分け、sort で同じ単語を隣り合わせにしてから group でまとめる。
-- 各グループの長さが出現回数。2 回以上のものだけ残し、
-- (出現回数の降順, 単語の昇順) をキーにして並べ替える。
duplicateWordCount :: String -> [(Int, String)]
duplicateWordCount =
  sortOn (\(n, w) -> (Down n, w))
    . filter (\(n, _) -> n >= 2)
    . map (\ws -> (length ws, head ws))
    . group
    . sort
    . words

-- ===================================================================
-- 動作確認 (report06-02.hs と同じテスト)
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
  check "問2 duplicateWordCount" (duplicateWordCount "a b a c b a d") [(3, "a"), (2, "b")]
  check "問2 duplicateWordCount (重複なし)" (duplicateWordCount "one two three") []
  check "問2 duplicateWordCount (空文字列)" (duplicateWordCount "") []
  check "問2 duplicateWordCount (同数は辞書順)" (duplicateWordCount "pear apple pear apple kiwi") [(2, "apple"), (2, "pear")]
  check "問2 duplicateWordCount (空白・改行)" (duplicateWordCount "  to be\nor not  to be ") [(2, "be"), (2, "to")]

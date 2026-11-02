-- 第6回 課題 問2 重複している単語のみ，出現回数の多い順に出現回数と単語のペアをリスト化したい，
--   duplicateWordCount :: String -> [(Int, String)] を実装せよ
--   ghci> duplicateWordCount "a b a c b a d"   ==> [(3,"a"),(2,"b")]
-- 仕様:
--   - 単語は words で区切る (空白・改行で区切られた文字列を 1 単語とする)
--   - 出現回数が 2 以上の単語だけを残す (重複がなければ [])
--   - 出現回数の多い順に並べる。出現回数が同じときは単語の辞書順 (昇順) に並べる
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report06-02.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report06-02.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

duplicateWordCount :: String -> [(Int, String)]
duplicateWordCount = undefined

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
  check "問2 duplicateWordCount" (duplicateWordCount "a b a c b a d") [(3, "a"), (2, "b")]
  check "問2 duplicateWordCount (重複なし)" (duplicateWordCount "one two three") []
  check "問2 duplicateWordCount (空文字列)" (duplicateWordCount "") []
  check "問2 duplicateWordCount (同数は辞書順)" (duplicateWordCount "pear apple pear apple kiwi") [(2, "apple"), (2, "pear")]
  check "問2 duplicateWordCount (空白・改行)" (duplicateWordCount "  to be\nor not  to be ") [(2, "be"), (2, "to")]

-- 第6回 課題 問5 String で表現された電話番号を受け取って Int リストに変換して返す関数
--   string2digits を、digitToInt と isDigit を使って作成せよ
--   ghci> string2digits "948-554-4389"   ==> [9,4,8,5,5,4,4,3,8,9]
--
-- 実行: runghc reports/report05/report05.hs
-- 対話: ghci reports/report05/report05.hs

import Control.Exception (SomeException, evaluate, try)
import Data.Char (digitToInt, isDigit)

-- filter isDigit で '0'〜'9' だけを残してから、map digitToInt で数値に変える。
-- digitToInt は 16 進数の 'a'〜'f' ('A'〜'F') も 10〜15 に変換してしまい、
-- それ以外の文字 ('-' や ' ' など) ではエラーになる。
-- そのため先に isDigit で 10 進の数字だけに絞っておく必要がある。
string2digits :: String -> [Int]
string2digits = map digitToInt . filter isDigit

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
  check "問5 string2digits" (string2digits "948-554-4389") [9, 4, 8, 5, 5, 4, 4, 3, 8, 9]
  check "問5 string2digits (括弧と空白)" (string2digits "(03) 1234-5678") [0, 3, 1, 2, 3, 4, 5, 6, 7, 8]
  check "問5 string2digits (英字は捨てる)" (string2digits "tel: 0120-abc-99") [0, 1, 2, 0, 9, 9]
  check "問5 string2digits (空文字列)" (string2digits "") []

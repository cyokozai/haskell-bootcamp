import Control.Exception (SomeException, evaluate, try)
import Data.List (group, sort, sortOn)
import Data.Ord (Down (..))

duplicateWordCount :: String -> [(Int, String)]
duplicateWordCount = sortOn (\(n, w) -> (Down n, w)) . filter (\(n, _) -> n >= 2) . map (\ws@(w : _) -> (length ws, w)) . group . sort . words

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[" ++ replicate 2 '-' ++ "] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問2 duplicateWordCount" (duplicateWordCount "a b a c b a d") [(3, "a"), (2, "b")]
  check "問2 duplicateWordCount (重複なし)" (duplicateWordCount "one two three") []
  check "問2 duplicateWordCount (空文字列)" (duplicateWordCount "") []
  check "問2 duplicateWordCount (同数は辞書順)" (duplicateWordCount "pear apple pear apple kiwi") [(2, "apple"), (2, "pear")]
  check "問2 duplicateWordCount (空白・改行)" (duplicateWordCount "  to be\nor not  to be ") [(2, "be"), (2, "to")]

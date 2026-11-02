import Control.Exception (SomeException, evaluate, try)
import qualified Data.List as List
import qualified Data.Map as Map

wordNums :: String -> [(String, Int)]
wordNums = Map.toList . Map.fromListWith (+) . map (\w -> (w, 1)) . words

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

import Control.Exception (SomeException, evaluate, try)
import Data.Char (digitToInt, isDigit)

string2digits :: String -> [Int]
string2digits = map digitToInt . filter isDigit

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

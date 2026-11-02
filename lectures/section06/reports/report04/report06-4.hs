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
    nines = 10 ^ q - 1

digitSum :: Integer -> Int
digitSum = sum . map digitToInt . show

firstTo :: Int -> Maybe Integer
firstTo n = find (\x -> digitSum x == n) [1 ..]

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

import Control.Exception (SomeException, evaluate, try)
import Data.List (isPrefixOf, tails)

infixHeadIndexList :: Eq a => [a] -> [a] -> [Int]
infixHeadIndexList xs ys = [i | (i, t) <- zip [0 ..] (tails ys), xs `isPrefixOf` t]

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問3 infixHeadIndexList" (infixHeadIndexList "cat" "im a cat burglar cat") [5, 17]
  check "問3 infixHeadIndexList (見つからない)" (infixHeadIndexList "dog" "im a cat burglar cat") []
  check "問3 infixHeadIndexList (数値)" (infixHeadIndexList [3, 4] [1, 2, 3, 4, 3, 4 :: Int]) [2, 4]
  check "問3 infixHeadIndexList (重なり)" (infixHeadIndexList "aa" "aaaa") [0, 1, 2]
  check "問3 infixHeadIndexList (空を探す)" (infixHeadIndexList "" "abc") [0, 1, 2, 3]

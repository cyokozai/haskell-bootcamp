import Control.Exception (SomeException, evaluate, try)

dotproduct2 :: (Num a) => [a] -> [a] -> a
dotproduct2 = go 0
  where
    go acc (x : xs) (y : ys) = go (acc + x * y) xs ys
    go acc _ _ = acc

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問8 dotproduct2" (dotproduct2 [1 .. 10] [2 .. 11 :: Integer]) 440
  check "問8 dotproduct2 (長さ違い)" (dotproduct2 [1, 2, 3] [4, 5 :: Integer]) 14
  check "問8 dotproduct2 (空リスト)" (dotproduct2 [] [1, 2, 3 :: Integer]) 0
  check "問8 dotproduct2 (Double)" (dotproduct2 [0.5, 1.5] [2.0, 4.0 :: Double]) 7.0

import Control.Exception (SomeException, evaluate, try)

dotproduct :: (Num a) => [a] -> [a] -> a
dotproduct (x : xs) (y : ys) = x * y + dotproduct xs ys
dotproduct _ _ = 0

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問7 dotproduct" (dotproduct [1 .. 10] [2 .. 11 :: Integer]) 440
  check "問7 dotproduct (長さ違い)" (dotproduct [1, 2, 3] [4, 5 :: Integer]) 14
  check "問7 dotproduct (空リスト)" (dotproduct [] [1, 2, 3 :: Integer]) 0
  check "問7 dotproduct (Double)" (dotproduct [0.5, 1.5] [2.0, 4.0 :: Double]) 7.0

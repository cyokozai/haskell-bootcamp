import Control.Exception (SomeException, evaluate, try)

dotproduct2 :: (Num a) => [a] -> [a] -> a
dotproduct2 = go 0
  where
    go acc (x : xs) (y : ys) = go (acc + x * y) xs ys
    go acc _ _ = acc

dotproduct3 :: (Num a) => [a] -> [a] -> a
dotproduct3 = go 0
  where
    go acc (x : xs) (y : ys) = let acc' = acc + x * y in acc' `seq` go acc' xs ys
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
  check "問9 dotproduct3" (dotproduct3 [1 .. 10] [2 .. 11 :: Integer]) 440
  check "問9 dotproduct3 (長さ違い)" (dotproduct3 [1, 2, 3] [4, 5 :: Integer]) 14
  check "問9 dotproduct3 (空リスト)" (dotproduct3 [] [1, 2, 3 :: Integer]) 0
  check "問9 dotproduct3 (Double)" (dotproduct3 [0.5, 1.5] [2.0, 4.0 :: Double]) 7.0
  check "問9 dotproduct3 (10^6 要素)" (dotproduct3 [1 .. 1000000] [2 .. 1000001 :: Integer]) 333334333334000000
  check "問9 dotproduct2 と一致" (dotproduct2 [1 .. 1000 :: Integer] [2 .. 1001]) (dotproduct3 [1 .. 1000] [2 .. 1001])

import Control.Exception (SomeException, evaluate, try)

data Vector a = Vector a a a deriving (Show, Eq)

vplus :: (Num a) => Vector a -> Vector a -> Vector a
vplus (Vector i j k) (Vector l m n) = Vector (i + l) (j + m) (k + n)

dotProd :: (Num a) => Vector a -> Vector a -> a
dotProd (Vector i j k) (Vector l m n) = i * l + j * m + k * n

vmult :: (Num a) => Vector a -> a -> Vector a
vmult (Vector i j k) m = Vector (i * m) (j * m) (k * m)

check :: (Eq a, Show a) => String -> a -> a -> IO ()
check name actual expected = do
  r <- try (evaluate (actual == expected)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  check "問3 vplus" (Vector 1 2 3 `vplus` Vector 4 5 (6 :: Int)) (Vector 5 7 9)
  check "問3 dotProd" (Vector 1 2 3 `dotProd` Vector 4 5 (6 :: Int)) 32
  check "問3 vmult" (Vector 1 2 (3 :: Int) `vmult` 4) (Vector 4 8 12)
  check "問3 vplus (Double)" (Vector 0.5 1 1.5 `vplus` Vector 0.5 1 (1.5 :: Double)) (Vector 1 2 3)
  check "問3 dotProd (直交)" (Vector 1 0 0 `dotProd` Vector 0 1 (0 :: Integer)) 0
  check "問3 vmult (0 倍)" (Vector 7 8 (9 :: Int) `vmult` 0) (Vector 0 0 0)

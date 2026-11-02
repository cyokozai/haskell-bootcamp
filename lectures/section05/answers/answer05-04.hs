-- 第5回 課題 解答例 問4 関数 f を渡すとその導関数 f' を返す関数 deriv を定義せよ。
--   なお、deriv は関数を戻り値として返す関数である。
--   ghci> f' = deriv (\x -> x^2)
--   ghci> f' 20     ==> 40.00009999970189
-- ヒント: f'(x) の近似は (f(x + h) - f(x)) / h。h = 0.0001 くらいとする。
--
-- 実行: runghc answers/answer05-04.hs
-- 対話: ghci answers/answer05-04.hs

import Control.Exception (SomeException, evaluate, try)

deriv :: (Fractional a) => (a -> a) -> (a -> a)
deriv f = \x -> (f (x + h) - f x) / h
  where
    h = 0.0001

-- カリー化により deriv f x = (f (x + h) - f x) / h と書いても同じ意味になる
-- (型の右側の括弧 (a -> a) は飾りで、a -> a -> a と同じ型)。
-- 中心差分 (f (x + h) - f (x - h)) / (2 * h) の方が誤差は小さい。

-- ===================================================================
-- 動作確認 (report05-04.hs と同じテスト)
-- ===================================================================
checkApprox :: String -> Double -> Double -> Double -> IO ()
checkApprox name eps actual expected = do
  r <- try (evaluate (abs (actual - expected) < eps)) :: IO (Either SomeException Bool)
  putStrLn $ case r of
    Right True -> "[OK] " ++ name
    Right False -> "[NG] " ++ name ++ "  got: " ++ show actual ++ "  expected: " ++ show expected ++ " (誤差 " ++ show eps ++ " 以内)"
    Left _ -> "[--] " ++ name ++ "  (未実装またはエラー)"

main :: IO ()
main = do
  checkApprox "問4 deriv (x^2) 20" 1e-3 (deriv (\x -> x ^ (2 :: Int)) 20) 40
  checkApprox "問4 deriv (3x+1) 5" 1e-3 (deriv (\x -> 3 * x + 1) 5) 3
  checkApprox "問4 deriv sin 0" 1e-3 (deriv sin 0) 1
  checkApprox "問4 f' = deriv (x^3) を 2 で" 1e-2 (f' 2) 12
  where
    f' = deriv (\x -> x ^ (3 :: Int))

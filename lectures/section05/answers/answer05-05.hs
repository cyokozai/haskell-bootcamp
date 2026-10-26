-- 第5回 課題 解答例 問5 Newton 法を行う関数 newton を作成せよ
--   newton :: Fractional a => (a -> a) -> a -> a
--   1 つ目の引数は f(x) = 0 となる関数 f、2 つ目の引数は Newton 法の初期値。
--   Newton 法の止め方は 10 回繰り返したら終了とする。
--   ghci> newton (\x -> x*x - 2.0) 1.0     ==> 1.414213562373095
-- 導関数には問4 の deriv を使う。問4 の解答をこのファイルにもコピーすること
-- (このファイル単独で runghc できるようにするため)。
--
-- 実行: runghc answers/answer05-05.hs
-- 対話: ghci answers/answer05-05.hs

module Main (main, deriv, newton, newtonRec) where

import Control.Exception (SomeException, evaluate, try)

-- 問4 の解答 (そのままコピー)
deriv :: (Fractional a) => (a -> a) -> (a -> a)
deriv f = \x -> (f (x + h) - f x) / h
  where
    h = 0.0001

-- 更新式 x_{n+1} = x_n - f(x_n) / f'(x_n) を step にした。
-- iterate step x0 は [x0, step x0, step (step x0), ...] の無限リスト。
-- 遅延評価なので !! 10 で取り出す「10 回適用した値」だけが計算される。
newton :: (Fractional a) => (a -> a) -> a -> a
newton f x0 = iterate step x0 !! 10
  where
    step x = x - f x / deriv f x

-- 別解: 残り回数を数えながら再帰する版。
-- 10 に (:: Int) を付けて go の回数の型だけを Int に決めている。
newtonRec :: (Fractional a) => (a -> a) -> a -> a
newtonRec f x0 = go (10 :: Int) x0
  where
    go 0 x = x
    go n x = go (n - 1) (x - f x / deriv f x)

-- ===================================================================
-- 動作確認 (report05-05.hs と同じテスト)
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
  checkApprox "問5 newton (x^2 - 2) 1.0 = √2" 1e-9 (newton (\x -> x * x - 2.0) 1.0) (sqrt 2)
  checkApprox "問5 newton (x^3 - 27) 1.0 = 3" 1e-6 (newton (\x -> x ^ (3 :: Int) - 27) 1.0) 3
  checkApprox "問5 newton (cos x - x) 1.0" 1e-9 (newton (\x -> cos x - x) 1.0) 0.7390851332151607
  -- x^2 = 0 は重根なので Newton 法でも 1 回ごとに約半分にしか縮まらない。10 回で約 1/2^10
  checkApprox "問5 10 回で止まる (x^2 の重根は 1/2 ずつしか近づかない)" 2e-4 (newton (\x -> x ^ (2 :: Int)) 1.0) (1 / 1024)

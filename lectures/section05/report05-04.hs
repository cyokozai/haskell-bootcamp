-- 第5回 課題 問4 関数 f を渡すとその導関数 f' を返す関数 deriv を定義せよ。
--   なお、deriv は関数を戻り値として返す関数である。
--   ghci> f' = deriv (\x -> x^2)
--   ghci> f' 20     ==> 40.00009999970189
-- ヒント: f'(x) の近似は (f(x + h) - f(x)) / h。h = 0.0001 くらいとする。
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report05-04.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report05-04.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

deriv :: (Fractional a) => (a -> a) -> (a -> a)
deriv = undefined

-- ===================================================================
-- 動作確認 (ここから下は変更しないこと)
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

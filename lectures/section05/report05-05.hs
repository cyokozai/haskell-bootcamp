-- 第5回 課題 問5 Newton 法を行う関数 newton を作成せよ
--   newton :: Fractional a => (a -> a) -> a -> a
--   1 つ目の引数は f(x) = 0 となる関数 f、2 つ目の引数は Newton 法の初期値。
--   Newton 法の止め方は 10 回繰り返したら終了とする。
--   ghci> newton (\x -> x*x - 2.0) 1.0     ==> 1.414213562373095
-- 導関数には問4 の deriv を使う。問4 の解答をこのファイルにもコピーすること
-- (このファイル単独で runghc できるようにするため)。
--
-- 学籍番号:
-- 氏名:
--
-- undefined を自分の実装に書き換えて提出すること。型宣言は変更しないこと。
--
-- 動作確認:
--   $ runghc report05-05.hs     -- テストを実行 ([OK] / [NG] / [--] が表示される)
--   $ ghci report05-05.hs       -- 対話的に試す (編集後は :r で再読み込み)

import Control.Exception (SomeException, evaluate, try)

deriv :: (Fractional a) => (a -> a) -> (a -> a)
deriv = undefined

newton :: (Fractional a) => (a -> a) -> a -> a
newton = undefined

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
  checkApprox "問5 newton (x^2 - 2) 1.0 = √2" 1e-9 (newton (\x -> x * x - 2.0) 1.0) (sqrt 2)
  checkApprox "問5 newton (x^3 - 27) 1.0 = 3" 1e-6 (newton (\x -> x ^ 3 - 27) 1.0) 3
  checkApprox "問5 newton (cos x - x) 1.0" 1e-9 (newton (\x -> cos x - x) 1.0) 0.7390851332151607
  -- x^2 = 0 は重根なので Newton 法でも 1 回ごとに約半分にしか縮まらない。10 回で約 1/2^10
  checkApprox "問5 10 回で止まる (x^2 の重根は 1/2 ずつしか近づかない)" 2e-4 (newton (\x -> x ^ 2) 1.0) (1 / 1024)

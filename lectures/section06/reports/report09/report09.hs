-- 第6回 課題 問9 seq を用いて内積を計算する関数 dotproduct3 を末尾再帰を使って作成せよ
--   問7 は末尾再帰ではないため、stack overflow が起きる。
--   問8 は通常のコンパイル言語ならば正格評価のため stack overflow が起きないはずだが、
--   Haskell は正格評価ではなく遅延評価であるため、必要になるまで計算せず、
--   stack overflow が起きる。そこで、部分的に遅延評価から正格評価に切り替えられる
--   関数 seq を用いて、内積を計算する関数 dotproduct3 を末尾再帰を使って作成せよ。
--   ghci> dotproduct3 [1..10] [2..11]                     ==> 440
--   ghci> dotproduct2 [1..100000000] [2..100000001]
--   *** Exception: stack overflow
--   ghci> dotproduct3 [1..100000000] [2..100000001]
--   333333343333333400000000
--
-- 2 つのリストの長さが違う場合は、短い方に合わせる (zipWith と同じ)。
--
-- 検算: [1..n] と [2..n+1] の内積は Σ k(k+1) (k = 1..n) = n(n+1)(n+2)/3。
--   n = 10^8 のとき 10^8 * 100000001 * 100000002 / 3
--                 = 10^8 * 100000001 * 33333334
--                 = 333333343333333400000000
--   n = 10^6 のとき 10^6 * 1000001 * 1000002 / 3 = 333334333334000000
--
-- 実行: runghc reports/report09/report09.hs
-- 対話: ghci reports/report09/report09.hs
--
-- stack overflow の再現について
--   GHC 8.8 以降は既定のスタック上限 (-K) が物理メモリの 80% なので、
--   問題文のとおりに打っても stack overflow にならず、メモリを大量に使って
--   答えが出る (または先にメモリが尽きる) ことが多い。
--   再現するには RTS オプション +RTS -K<サイズ> でスタック上限を小さくする
--   (GHC 9.10.3 で確認。要素数 10^6 なら -K8m で十分に再現する)。
--
--     $ ghci reports/report09/report09.hs +RTS -K8m
--     ghci> dotproduct2 [1..1000000] [2..1000001]
--     *** Exception: stack overflow
--     ghci> dotproduct3 [1..1000000] [2..1000001]
--     333334333334000000
--
--   (同じく ghci reports/report07/report07.hs +RTS -K8m で、問7 の dotproduct も
--    dotproduct [1..1000000] [2..1000001] で stack overflow になる)
--
--   なお ghc -O (最適化) でコンパイルすると、GHC の正格性解析が
--   「acc は最後に必ず使われる」ことを見抜いて dotproduct2 の累積引数も
--   毎回計算するようになるため、+RTS -K1m でも dotproduct2 が通ってしまう。
--   seq の効果を確かめるときは、最適化なしの ghci / runghc (または ghc -O0) で試すこと。

import Control.Exception (SomeException, evaluate, try)

-- 比較用: 問8 の dotproduct2 (累積引数 acc が thunk のまま積み上がる)。
--   go 0 [1,2,..] [2,3,..]
--   = go (0 + 1*2) ..
--   = go ((0 + 1*2) + 2*3) ..
--   = ... 最後に acc を使うときに、入れ子になった足し算を一気に評価するので
--   入れ子の深さ (= 要素数) だけスタックを使う。
dotproduct2 :: (Num a) => [a] -> [a] -> a
dotproduct2 = go 0
  where
    go acc (x : xs) (y : ys) = go (acc + x * y) xs ys
    go acc _ _ = acc

-- seq a b は「a を (弱頭部正規形まで) 評価してから b を返す」。
-- 次の go を呼ぶ前に acc' を数値まで計算させるので、thunk が積み上がらず、
-- 一定のスタックで最後まで計算できる。
-- (Data.List の foldl' も、内部で同じように seq を使って累積値を毎回評価している。
--  dotproduct3 xs ys = foldl' (+) 0 (zipWith (*) xs ys) と同じ振る舞いになる)
dotproduct3 :: (Num a) => [a] -> [a] -> a
dotproduct3 = go 0
  where
    go acc (x : xs) (y : ys) = let acc' = acc + x * y in acc' `seq` go acc' xs ys
    go acc _ _ = acc

-- ===================================================================
-- 動作確認
-- ===================================================================
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

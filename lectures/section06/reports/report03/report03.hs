-- 第6回 課題 解答例 問3 1つ目のリストが2つ目のリストのどこに含まれているか知りたい．
--   infixHeadIndexList :: Eq a => [a] -> [a] -> [Int] を実装せよ．
--   ghci> infixHeadIndexList "cat" "im a cat burglar cat"   ==> [5,17]
--
-- 仕様:
--   1つ目のリストが2つ目のリストに現れる位置の先頭インデックス (0 始まり) を
--   昇順に並べたリストを返す．見つからなければ [] を返す．
--   重なって現れる場合もそれぞれ数える．
--     infixHeadIndexList "aa" "aaaa"   ==> [0,1,2]
--   空リストを探した場合は，あらゆる位置 (末尾の直後も含む) に現れるとみなす．
--     infixHeadIndexList "" "abc"      ==> [0,1,2,3]
--
-- 実行: runghc reports/report03/report03.hs
-- 対話: ghci reports/report03/report03.hs

import Control.Exception (SomeException, evaluate, try)
import Data.List (isPrefixOf, tails)

-- tails ys で「各位置から始まる残りのリスト」を作り，[0..] と zip して位置を付ける．
-- 残りのリストの先頭が xs と一致する (isPrefixOf) 位置だけを集める．
-- 教科書の isIn (any (needle `isPrefixOf`) (tails haystack)) を，
-- 「含まれるか」から「どこに含まれるか」へ広げたもの．
-- tails ys は末尾に [] を含むので，xs が空なら (length ys + 1) 個の位置すべてが返る．
infixHeadIndexList :: Eq a => [a] -> [a] -> [Int]
infixHeadIndexList xs ys = [i | (i, t) <- zip [0 ..] (tails ys), xs `isPrefixOf` t]

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
  check "問3 infixHeadIndexList" (infixHeadIndexList "cat" "im a cat burglar cat") [5, 17]
  check "問3 infixHeadIndexList (見つからない)" (infixHeadIndexList "dog" "im a cat burglar cat") []
  check "問3 infixHeadIndexList (数値)" (infixHeadIndexList [3, 4] [1, 2, 3, 4, 3, 4 :: Int]) [2, 4]
  check "問3 infixHeadIndexList (重なり)" (infixHeadIndexList "aa" "aaaa") [0, 1, 2]
  check "問3 infixHeadIndexList (空を探す)" (infixHeadIndexList "" "abc") [0, 1, 2, 3]

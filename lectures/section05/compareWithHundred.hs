-- 5.1 カリー化関数 部分適用で新しい関数を作る

compareWithHundred :: Int -> Ordering
compareWithHundred = compare 100

compareWithHundred' :: Int -> Ordering
compareWithHundred' x = compare 100 x

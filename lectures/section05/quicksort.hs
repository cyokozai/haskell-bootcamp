-- 5.3 関数プログラマの道具箱 第4章のクイックソートを filter で書く

quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let smallerOrEqual = filter (<= x) xs
        larger = filter (> x) xs
    in  quicksort smallerOrEqual
          ++ [x] ++ quicksort larger

-- 5.3 関数プログラマの道具箱 10万以下で 3829 で割り切れる最大の数を求める

largestDivisible :: Integer
largestDivisible = head (filter p [100000,99999..])
    where p x = x `mod` 3829 == 0

-- 問2) 非整数nの階乗を再帰で求めるプログラムを作成せよ。
factorial :: Int -> Int
factorial 0 = 1
factorial n | n < 0 = error "n must be non-negative"
factorial n = n * factorial (n - 1)
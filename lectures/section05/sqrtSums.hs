-- 5.5 畳み込み 平方根の和が 1000 を超えるのは何個目かを求める

sqrtSums :: Int
sqrtSums = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]))) + 1

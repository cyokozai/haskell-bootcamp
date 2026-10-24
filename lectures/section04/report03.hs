quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort smallerOrEqual ++ [x] ++ quicksort larger
  where
    smallerOrEqual = [a | a <- xs, a <= x]
    larger         = [a | a <- xs, a > x]
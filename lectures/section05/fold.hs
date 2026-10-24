and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs

and'' :: [Bool] -> Bool
and'' xs = foldl (&&) True xs
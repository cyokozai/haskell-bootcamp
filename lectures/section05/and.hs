-- 5.5 畳み込み 無限リストを畳み込む

import Prelude hiding ((&&))

and' :: [Bool] -> Bool
and' xs = foldr (&&) True xs

(&&) :: Bool -> Bool -> Bool
True  && x = x
False && _ = False

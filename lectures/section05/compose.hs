-- 5.7 関数合成 関数合成演算子 .

import Prelude hiding ((.))

(.) :: (b -> c) -> (a -> b) -> a -> c
f . g = \x -> f (g x)
infixr 9 .

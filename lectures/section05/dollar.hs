-- 5.6 $ を使った関数適用 関数適用演算子 $

import Prelude hiding (($))

($) :: (a -> b) -> a -> b
f $ x = f x
infixr 0 $

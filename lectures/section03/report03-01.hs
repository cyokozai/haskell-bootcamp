-- 問1) 7の時だけ特別なメッセージを返す関数を作成せよ。
saysevens :: Int -> String
saysevens 7 = "Seven"
saysevens x = "Something else"
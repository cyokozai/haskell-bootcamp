第5章 高階関数 予習ノート
=========================

発表者が第4章（再帰）と第5章（高階関数）を短時間で身につけるためのノート。 上から順に、GHCi で実際に打ち込みながら読む。

```bash
cd lectures/section05
ghci handson.hs     # 第5章のコードをすべて読み込んだ状態で起動
```

-	編集したら `:r`、型を見るなら `:t 式`、終了は `:q`
-	各節の最後に **確認問題** がある。答えはこのノートの末尾

---

0. 前提：第3章の道具（5分で復習）
---------------------------------

第5章のコードには、第3章の構文がそのまま出てくる。

| 構文           | 例                                       | 意味                              |
|----------------|------------------------------------------|-----------------------------------|
| パターンマッチ | `f [] = ...` / `f (x:xs) = ...`          | 引数の形で分岐。上から順に試す    |
| ガード         | `\| even n = ...` / `\| otherwise = ...` | 条件で分岐。`otherwise` は `True` |
| where          | `where isLong xs = length xs > 15`       | その定義の中だけで使う名前        |
| let            | `let a = 1 in a + 2`                     | 式の中で名前を付ける              |
| `_`            | `zipWith' _ [] _ = []`                   | 使わない引数                      |

`x:xs` は「先頭 `x` と残り `xs`」。`[1,2,3]` は `1:(2:(3:[]))` の略記。

---

1. 第4章：再帰（30分）
----------------------

### 1.1 再帰とは

関数の定義の中で、その関数自身を呼び出すこと。問題を **同じ種類の小さな問題** に分ける。

-	**基底部**：再帰せずに答えが決まる場合（たいてい空リストや 0）
-	**再帰部**：小さくした問題を自分自身に解かせ、その答えを使って全体の答えを作る

### 1.2 maximum'

```haskell
maximum' :: (Ord a) => [a] -> a
maximum' [] = error "maximum of empty list!"
maximum' [x] = x                          -- 基底部：要素1つならそれが最大
maximum' (x:xs) = max x (maximum' xs)     -- 再帰部：先頭と「残りの最大」の大きいほう
```

`maximum' [2,5,1]` の展開：

```text
maximum' [2,5,1]
= max 2 (maximum' [5,1])
= max 2 (max 5 (maximum' [1]))
= max 2 (max 5 1)
= max 2 5
= 5
```

`(Ord a) =>` は「`a` は大小比較できる型」という制約。これがあるので `max` が使える。

### 1.3 第4章のそのほかの再帰関数

```haskell
replicate' :: Int -> a -> [a]
replicate' n x
    | n <= 0    = []                       -- 基底部
    | otherwise = x : replicate' (n-1) x   -- 1つ付けて、残り n-1 個

take' :: Int -> [a] -> [a]
take' n _
    | n <= 0 = []
take' _ [] = []
take' n (x:xs) = x : take' (n-1) xs

reverse' :: [a] -> [a]
reverse' [] = []
reverse' (x:xs) = reverse' xs ++ [x]      -- 残りを逆順にして、末尾に先頭を付ける

repeat' :: a -> [a]
repeat' x = x : repeat' x                 -- 基底部なし（無限リスト）

zip' :: [a] -> [b] -> [(a,b)]
zip' _ [] = []
zip' [] _ = []
zip' (x:xs) (y:ys) = (x,y) : zip' xs ys

elem' :: (Eq a) => a -> [a] -> Bool
elem' _ [] = False
elem' a (x:xs)
    | a == x    = True
    | otherwise = a `elem'` xs
```

`take 3 (repeat' 5)` が `[5,5,5]` になるのは **遅延評価** のおかげ。必要な分しか計算しない。

### 1.4 クイックソート

```haskell
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) =
    let smallerOrEqual = [a | a <- xs, a <= x]
        larger = [a | a <- xs, a > x]
    in  quicksort smallerOrEqual ++ [x] ++ quicksort larger
```

先頭 `x` をピボットにし、「`x` 以下」と「`x` より大きい」に分けて、それぞれを再帰でソートしてつなぐ。

### 1.5 再帰の定石

1.	再帰に頼らない自明な解を持つ **基底部** から書く
2.	問題を小さな部分問題に分け、自分自身に解かせる
3.	部分問題の答えが正しいと信じて、全体の答えを組み立てる（全体の動きを追いかけなくてよい）

### 第4章の確認問題

-	**Q4-1** `replicate' 3 'a'` を手で展開して結果を書け
-	**Q4-2** `reverse'` の再帰部を `reverse' (x:xs) = x : reverse' xs` と書くと、結果はどうなるか

---

2. 5.1 カリー化関数（20分）
---------------------------

### 2.1 すべての関数は引数を1つしかとらない

`max 4 5` は、実際には次の2段階で計算される。

1.	`max 4` を計算 → 「4 と比べて大きいほうを返す関数」ができる
2.	その関数を `5` に適用 → `5`

	```haskell
	ghci> :t max
	max :: Ord a => a -> a -> a
	ghci> :t max 4
	max 4 :: (Ord a, Num a) => a -> a     -- 引数が1つ減った
	```

型の `->` は **右結合**。`a -> a -> a` は `a -> (a -> a)`：「`a` を受け取って、`a -> a` という関数を返す」。 一方、関数適用（スペース）は **左結合**。`max 4 5` は `(max 4) 5`。

この仕組みを **カリー化** と呼び、引数を一部だけ渡すことを **部分適用** と呼ぶ。

### 2.2 multThree で確かめる

```haskell
multThree :: Int -> Int -> Int -> Int    -- Int -> (Int -> (Int -> Int))
multThree x y z = x * y * z
```

| 式                | 型                         | 意味                 |
|-------------------|----------------------------|----------------------|
| `multThree`       | `Int -> Int -> Int -> Int` | 3つ掛ける            |
| `multThree 3`     | `Int -> Int -> Int`        | 3 と残り2つを掛ける  |
| `multThree 3 5`   | `Int -> Int`               | 15 と残り1つを掛ける |
| `multThree 3 5 9` | `Int`                      | 135                  |

GHCi で `:t multThree 3` などを打って確認する。

### 2.3 部分適用で関数を定義する

```haskell
compareWithHundred :: Int -> Ordering
compareWithHundred x = compare 100 x
```

両辺の右端に同じ `x` があるので消せる：

```haskell
compareWithHundred = compare 100
```

この「右端の引数を消す」変形は 5.5 と 5.7 で何度も出てくる（**ポイントフリースタイル**）。

### 2.4 セクション

中置関数（`+`、`/`、バッククォートで囲んだ `elem` など）は、片側だけ値を入れて括弧で囲むと部分適用できる。

| セクション | 意味                  | 例                             |
|------------|-----------------------|--------------------------------|
| `(/10)`    | `\x -> x / 10`        | `(/10) 200` → `20.0`           |
| `(10/)`    | `\x -> 10 / x`        | `(10/) 200` → `5.0e-2`（0.05） |
| `(++ "!")` | 後ろに `"!"` を付ける |                                |
| `("!" ++)` | 前に `"!"` を付ける   |                                |

`elem` のような名前の関数も、バッククォートで囲めば同じようにセクションにできる。次は「大文字かどうか」を返す関数になる。

```haskell
isUpperAlphanum = (`elem` ['A'..'Z'])
```

**落とし穴**：`(-4)` は「マイナス4」という数。4を引く関数は `(subtract 4)`。

### 2.5 関数は表示できない

```haskell
ghci> multThree 3 4
error: No instance for (Show (Int -> Int)) ...
```

`multThree 3 4` は `Int -> Int` という **関数** なので、GHCi はそれを文字列にする方法を知らない。 「引数が足りていない」ときによく見るエラーなので、メッセージを覚えておく。

### 5.1 の確認問題

-	**Q1-1** `:t (subtract 4)` と `:t (-4)` の違いを説明せよ
-	**Q1-2** `map (multThree 2 3) [1,2,3]` の結果は？

---

3. 5.2 高階実演（15分）
-----------------------

**高階関数**：関数を引数にとる、または関数を返す関数。

### 3.1 applyTwice

```haskell
applyTwice :: (a -> a) -> a -> a
applyTwice f x = f (f x)
```

型の括弧 `(a -> a)` が「第1引数は関数」を表す。括弧がないと `a -> a -> a -> a` になり、意味が変わる。

### 3.2 zipWith'

```haskell
zipWith' :: (a -> b -> c) -> [a] -> [b] -> [c]
zipWith' _ [] _ = []
zipWith' _ _ [] = []
zipWith' f (x:xs) (y:ys) = f x y : zipWith' f xs ys
```

第4章の `zip'` と比べると、`(x,y)` が `f x y` に変わっただけ。「何をするか」を引数で受け取れるのが高階関数の強み。

### 3.3 flip'

```haskell
flip' :: (a -> b -> c) -> b -> a -> c
flip' f y x = f x y
```

型 `(a -> b -> c) -> (b -> a -> c)` の右側の括弧は省略できる（`->` が右結合だから）。 すると「関数 `f` と、`y`、`x` の3つを受け取る」と読めるので、上のように書ける。

```haskell
ghci> zipWith (flip' div) [2,2..] [10,8,6,4,2]
[5,4,3,2,1]                     -- div 10 2, div 8 2, ...
```

### 5.2 の確認問題

-	**Q2-1** `applyTwice (multThree 2 2) 9` が 144 になる理由を説明せよ
-	**Q2-2** `zipWith' (++) ["a","b"] ["x","y","z"]` の結果は？

---

4. 5.3 関数プログラマの道具箱（25分）
-------------------------------------

### 4.1 map と filter

```haskell
map :: (a -> b) -> [a] -> [b]
map _ [] = []
map f (x:xs) = f x : map f xs

filter :: (a -> Bool) -> [a] -> [a]
filter _ [] = []
filter p (x:xs)
    | p x       = x : filter p xs
    | otherwise = filter p xs
```

-	`map`：全要素を **変換**
-	`filter`：**述語**（`Bool` を返す関数）を満たす要素だけ **選別**

リスト内包表記と対応している：

| 高階関数                        | リスト内包表記                   |
|---------------------------------|----------------------------------|
| `map (+3) xs`                   | `[x+3 \| x <- xs]`               |
| `filter even xs`                | `[x \| x <- xs, even x]`         |
| `filter (<15) (filter even xs)` | `[x \| x <- xs, x < 15, even x]` |

どちらを使ってもよい。読みやすいほうを選ぶ。

### 4.2 遅延評価と takeWhile

```haskell
largestDivisible = head (filter p [100000,99999..])
    where p x = x `mod` 3829 == 0
```

降順のリストを `filter` して `head` を取るので、最初に見つかった時点で計算が終わる。

`takeWhile p xs`：先頭から `p` を満たす間だけ取り出し、満たさない要素が来たら **止まる**。 無限リストと組み合わせるときは `filter` ではなく `takeWhile` を使う（`filter` は最後まで探し続ける）。

```haskell
ghci> sum (takeWhile (<10000) (filter odd (map (^2) [1..])))
166650
```

右から読む：`[1..]` → 2乗 → 奇数だけ → 10000 未満の間だけ → 合計。

### 4.3 コラッツ列

```haskell
chain :: Integer -> [Integer]
chain 1 = [1]
chain n
    | even n = n : chain (n `div` 2)
    | odd n  = n : chain (n * 3 + 1)

numLongChains :: Int
numLongChains = length (filter isLong (map chain [1..100]))
    where isLong xs = length xs > 15
```

1.	`map chain [1..100]`：100本のコラッツ列（リストのリスト）
2.	`filter isLong`：長さが15より長いものだけ
3.	`length`：その本数 → **66**

教科書の問題文は「15以上」だが、コードは `> 15`。講義ではコードに合わせる（`>= 15` にすると答えが変わるので、質問されたら説明できるようにしておく）。

### 4.4 関数のリスト

```haskell
ghci> let listOfFuns = map (*) [0..]
ghci> (listOfFuns !! 4) 5
20
```

`(*)` に1つだけ与えると1引数関数になるので、`map (*) [0..]` は `[(0*),(1*),(2*),...]` という **関数のリスト**。

### 5.3 の確認問題

-	**Q3-1** `filter (>3) (map (*2) [1..5])` の結果は？
-	**Q3-2** `takeWhile (<10) [1,3,12,2]` と `filter (<10) [1,3,12,2]` の違いは？

---

5. 5.4 ラムダ式（10分）
-----------------------

その場限りの名前のない関数。`\引数 -> 本体`。

```haskell
numLongChains = length (filter (\xs -> length xs > 15) (map chain [1..100]))
```

-	複数の引数：`\a b -> (a * 30 + 3) / b`
-	パターンマッチ：`\(a,b) -> a + b`（パターンは1つだけ。合わないとランタイムエラー）
-	**不要なラムダは書かない**：`\x -> x + 3` より `(+3)` のほうが読みやすい

カリー化のおかげで、次の2つは同じ：

```haskell
addThree x y z = x + y + z
addThree = \x -> \y -> \z -> x + y + z
```

### 5.4 の確認問題

-	**Q4L-1** `map (\x -> x * 2 + 1) [1,2,3]` の結果は？ ラムダを使わずに書けるか？

---

6. 5.5 畳み込み（30分）※最重要
------------------------------

### 6.1 なぜ畳み込みか

第4章の再帰関数は、ほぼ次の形をしている：

```haskell
f [] = 初期値
f (x:xs) = x と (f xs) を組み合わせる
```

この「組み合わせ方」と「初期値」だけを渡せば済むようにしたのが **畳み込み**。

### 6.2 foldl（左畳み込み）

```haskell
foldl :: (acc -> x -> acc) -> acc -> [x] -> acc   -- 型変数名をわかりやすく変えた
```

```haskell
sum' xs = foldl (\acc x -> acc + x) 0 xs
```

| ステップ | acc | x | 新しい acc |
|----------|-----|---|------------|
| 1        | 0   | 3 | 3          |
| 2        | 3   | 5 | 8          |
| 3        | 8   | 2 | 10         |
| 4        | 10  | 1 | 11         |

`\acc x -> acc + x` は `(+)` と同じ。さらに右端の `xs` を消すと `sum' = foldl (+) 0`。

### 6.3 foldr（右畳み込み）

```haskell
foldr :: (x -> acc -> acc) -> acc -> [x] -> acc
```

ラムダの引数の順番が **逆**（`\x acc`）。結果は右から畳んだように見える：

```text
foldr f z [3,4,5,6] = f 3 (f 4 (f 5 (f 6 z)))
foldl g z [3,4,5,6] = g (g (g (g z 3) 4) 5) 6
```

**リストを作るときは foldr**：`x : acc` で先頭に付けるだけで順番が保たれる。 `foldl` だと `acc ++ [f x]` と末尾に付けることになり、`++` は遅い。

```haskell
map' f = foldr (\x acc -> f x : acc) []
filter' p = foldr (\x acc -> if p x then x : acc else acc) []
elem' y = foldr (\x acc -> if x == y then True else acc) False
```

### 6.4 foldl1 / foldr1

初期値を渡さず、リストの最初（最後）の要素を初期値にする。空リストだとエラー。

```haskell
maximum' = foldl1 max
last' = foldl1 (\_ x -> x)
```

### 6.5 第4章と比べる

| 関数     | 第4章（再帰）         | 第5章（畳み込み）             |
|----------|-----------------------|-------------------------------|
| maximum' | `max x (maximum' xs)` | `foldl1 max`                  |
| reverse' | `reverse' xs ++ [x]`  | `foldl (flip (:)) []`         |
| elem'    | ガードで比較して再帰  | `foldr (\x acc -> ...) False` |

`reverse'` の `flip (:)`：`(:)` は `x : acc` だが、foldl のラムダは `\acc x`。引数の順を入れ替えればそのまま使える。

### 6.6 foldr は無限リストでも止まることがある

```haskell
and' xs = foldr (&&) True xs
and' (repeat False)   -- False && (False && ...) → 最初の False で確定 → False
```

`&&` は第1引数が `False` なら第2引数を見ない。遅延評価なので残りは計算されない。 `foldl` は最後まで見ないと結果を返せないので、無限リストでは止まらない。

### 6.7 スキャン

畳み込みの **途中経過** をすべてリストで返す。

```haskell
ghci> scanl (+) 0 [3,5,2,1]
[0,3,8,10,11]       -- 最後が foldl の結果
ghci> scanr (+) 0 [3,5,2,1]
[11,8,3,1,0]        -- 先頭が foldr の結果
```

```haskell
sqrtSums = length (takeWhile (<1000) (scanl1 (+) (map sqrt [1..]))) + 1   -- 131
```

和は単調に増えるので `takeWhile` で切れる。1000 未満の和が 130 個 → 131 個目で超える。

### 5.5 の確認問題

-	**Q5-1** `foldr (\x acc -> x * 2 : acc) [] [1,2,3]` の結果は？
-	**Q5-2** `product'` を `foldl` で書け。初期値は何か？
-	**Q5-3** `scanl1 max [3,1,4,1,5]` の結果は？

---

7. 5.6 `$` と 5.7 関数合成（25分）
----------------------------------

### 7.1 `$`

```haskell
($) :: (a -> b) -> a -> b
f $ x = f x
```

意味は普通の関数適用と同じだが、**優先順位が最低で右結合**。「ここから行末までを括弧で囲む」と読めばよい。

```haskell
sum (filter (> 10) (map (*2) [2..10]))
sum $ filter (> 10) $ map (*2) [2..10]      -- 同じ
```

`($ 3)` は「関数を受け取って 3 に適用する関数」。`map ($ 3) [(4+), (10*)]` → `[7,30]`。

### 7.2 関数合成 `.`

```haskell
(.) :: (b -> c) -> (a -> b) -> a -> c
f . g = \x -> f (g x)
```

**右から順に適用**。`negate . sum . tail` は「tail → sum → negate」。

`$` との違い：

-	`.` は **関数と関数** をつないで新しい関数を作る
-	`$` は **関数を値に** 適用する

	```haskell
	sum . replicate 5 $ max 6.7 8.9     -- OK: (sum . replicate 5) を max 6.7 8.9 に適用
	sum . replicate 5 . max 6.7 8.9     -- NG: max 6.7 8.9 は数（関数ではない）
	```

### 7.3 括弧の多い式を書き直す手順

```haskell
replicate 2 (product (map (*3) (zipWith max [1,2] [4,5])))
```

1.	一番内側の関数と引数：`zipWith max [1,2] [4,5]`
2.	その前の関数を `$` でつなぐ：`map (*3) $ zipWith max [1,2] [4,5]`
3.	さらに前の関数は `.` で合成：`product . map (*3) $ ...`
4.	繰り返す：`replicate 2 . product . map (*3) $ zipWith max [1,2] [4,5]`

### 7.4 ポイントフリースタイル

関数定義の一時変数（ポイント）を書かないスタイル。

```haskell
fn x = ceiling (negate (tan (cos (max 50 x))))
fn = ceiling . negate . tan . cos . max 50
```

`x` は括弧の奥にあるのでそのままでは消せないが、関数合成で書き直すと右端に出てきて消せる。 長くなりすぎたら `let` で途中に名前を付けて分割する。

### 5.6・5.7 の確認問題

-	**Q7-1** `map (negate . abs) [1,-2,3]` の結果は？
-	**Q7-2** `f x = sum (map (*2) (filter odd x))` をポイントフリースタイルで書け

---

8. 発表前チェックリスト
-----------------------

-	[ ] `runghc report5_answer.hs` で全問 `[OK]` を確認した
-	[ ] `ghci handson.hs` でスライドの ghci 例をすべて打ってみた
-	[ ] 次の質問に答えられる
	-	部分適用とカリー化の違いは？（カリー化＝関数の仕組み、部分適用＝その使い方）
	-	`foldl` と `foldr` はどう使い分ける？（リストを作るなら foldr、無限リストも foldr）
	-	`$` と `.` の違いは？（値に適用 / 関数をつなぐ）
	-	`(-4)` が関数にならないのはなぜ？
	-	なぜ `filter` ではなく `takeWhile` を使うのか？

---

確認問題の答え
--------------

| 問    | 答え                                                                               |
|-------|------------------------------------------------------------------------------------|
| Q4-1  | `'a' : replicate' 2 'a'` → `'a':'a':'a':[]` → `"aaa"`                              |
| Q4-2  | 元のリストがそのまま返る（先頭を先頭に付け直しているだけなので、順番が変わらない） |
| Q1-1  | `subtract 4` は `Num a => a -> a`（関数）、`(-4)` は `Num a => a`（数）            |
| Q1-2  | `[6,12,18]`                                                                        |
| Q2-1  | `multThree 2 2` は「4倍する関数」。9 → 36 → 144                                    |
| Q2-2  | `["ax","by"]`（短いほうに合わせる）                                                |
| Q3-1  | `[4,6,8,10]`                                                                       |
| Q3-2  | `takeWhile` は 12 で止まり `[1,3]`、`filter` は最後まで見て `[1,3,2]`              |
| Q4L-1 | `[3,5,7]`。`map ((+1) . (*2)) [1,2,3]` とも書ける                                  |
| Q5-1  | `[2,4,6]`                                                                          |
| Q5-2  | `product' = foldl (*) 1`。初期値は 1（掛け算の単位元）                             |
| Q5-3  | `[3,3,4,4,5]`                                                                      |
| Q7-1  | `[-1,-2,-3]`                                                                       |
| Q7-2  | `f = sum . map (*2) . filter odd`                                                  |

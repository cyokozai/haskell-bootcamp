# 第4回 課題（再帰）回答例と解説

| 問 | ファイル | 内容 |
|---|---|---|
| 問1 | [answer04-01.hs](answer04-01.hs) | `maximum'` |
| 問2 | [answer04-02.hs](answer04-02.hs) | `reverse'` |
| 問3 | [answer04-03.hs](answer04-03.hs) | クイックソート |
| 問4 | [answer04-04.hs](answer04-04.hs) | x の n 乗（素朴な再帰） |
| 問5 | [answer04-05.hs](answer04-05.hs) | x の n 乗（高速化） |
| 問6 | [answer04-06.hs](answer04-06.hs) | x の n 乗（末尾再帰） |
| 問7 | [answer04-07.hs](answer04-07.hs) | `myflist`（自作 map） |

## 実行方法

以下はすべてリポジトリのルート（`haskell-bootcamp/`）で実行する前提です。

### GHCi で `:l` を使う

```bash
ghci
```

```text
ghci> :l lectures/section04/answers/answer04-01.hs   -- ファイルを読み込む
[1 of 2] Compiling Main             ( lectures/section04/answers/answer04-01.hs, interpreted )
Ok, one module loaded.
ghci> maximum' [3, 1, 4, 1, 5, 9, 2, 6]              -- 関数を呼ぶ
9
ghci> :t maximum'                                     -- 型を確認する
maximum' :: Ord a => [a] -> a
ghci> main                                            -- ファイル内の動作確認をまとめて実行
ghci> :r                                              -- ファイルを編集したら再読み込み
ghci> :q                                              -- 終了
```

| コマンド | 意味 |
|---|---|
| `:l <ファイル>` | ファイルを読み込む（`:load` の省略形）。別のファイルを `:l` すると前のファイルの定義は消える |
| `:r` | 最後に読み込んだファイルを再読み込み（`:reload`）。エディタで直したあとに使う |
| `:t <式>` | 式の型を表示（`:type`） |
| `:set +s` | 以後、式ごとに実行時間とメモリ割り当て量を表示する（問5 の比較で使う） |
| `:q` | GHCi を終了 |

GHCi の起動と同時に読み込むこともできます。

```bash
ghci lectures/section04/answers/answer04-01.hs
```

### ファイルを一括実行する

各ファイルには動作確認用の `main` を入れてあるので、`runghc` でそのまま実行できます。

```bash
runghc lectures/section04/answers/answer04-01.hs
```

---

## 問1 `maximum'`

```haskell
maximum' :: (Ord a) => [a] -> a
maximum' []  = error "maximum of empty list"
maximum' [x] = x
maximum' (x:xs)
  | x > maxTail = x
  | otherwise   = maxTail
  where maxTail = maximum' xs
```

```text
ghci> :l lectures/section04/answers/answer04-01.hs
ghci> maximum' [3, 1, 4, 1, 5, 9, 2, 6]
9
ghci> maximum' "haskell"
's'
```

**解説**

再帰関数は「**基底部（それ以上分解しない場合）**」と「**再帰部（問題を小さくして自分を呼ぶ場合）**」の 2 つで書きます。

- 基底部: 要素が 1 つ `[x]` なら、その `x` が最大値
- 再帰部: `(x:xs)` に分解し、「残り `xs` の最大値」と先頭 `x` のうち大きいほう
- 空リストには最大値が無いので `error` にします（標準の `maximum` も同じ挙動）

型の `(Ord a) =>` は「`a` は大小比較できる型」という制約です。`>` を使うので必要で、これがあるので数値でも文字でも動きます。

別解 `maximum''` は、2 値の大きいほうを返す `max` を使ってガードを 1 行にまとめた版です。

```text
maximum'' [2, 5, 1]
= max 2 (maximum'' [5, 1])
= max 2 (max 5 (maximum'' [1]))
= max 2 (max 5 1)
= max 2 5
= 5
```

---

## 問2 `reverse'`

```haskell
reverse' :: [a] -> [a]
reverse' []     = []
reverse' (x:xs) = reverse' xs ++ [x]
```

```text
ghci> :l lectures/section04/answers/answer04-02.hs
ghci> reverse' [1, 2, 3, 4, 5]
[5,4,3,2,1]
```

**解説**

- 基底部: 空リストの反転は空リスト
- 再帰部: 「残りを反転したもの」の**末尾**に先頭 `x` を付ける

```text
reverse' [1, 2, 3]
= reverse' [2, 3] ++ [1]
= (reverse' [3] ++ [2]) ++ [1]
= ((reverse' [] ++ [3]) ++ [2]) ++ [1]
= [3, 2, 1]
```

`[x]` と角括弧で囲んでいるのは、`++` が「リスト同士」をつなぐ演算子だからです（`xs ++ x` は型エラー）。

**注意点**: `++` は左側のリストを最後までたどるので、この書き方は長さ n のリストに対して約 n²/2 回の処理が必要です。
別解 `reverseAcc` は、結果を貯めていく**累積引数** `acc` を使い、先頭への追加 `:`（一定時間）だけで書いています。

```text
go []        [1, 2, 3]
go [1]       [2, 3]
go [2, 1]    [3]
go [3, 2, 1] []      → [3, 2, 1]
```

この「累積引数に結果を貯めながら最後に自分を呼ぶ」形が、問6 の末尾再帰そのものです。

---

## 問3 クイックソート

```haskell
quicksort :: (Ord a) => [a] -> [a]
quicksort [] = []
quicksort (x:xs) = quicksort smallerOrEqual ++ [x] ++ quicksort larger
  where
    smallerOrEqual = [a | a <- xs, a <= x]
    larger         = [a | a <- xs, a > x]
```

```text
ghci> :l lectures/section04/answers/answer04-03.hs
ghci> quicksort [10, 2, 5, 3, 1, 6, 7, 4, 2, 3, 4, 8, 9]
[1,2,2,3,3,4,4,5,6,7,8,9,10]
```

**解説**

クイックソートの考え方は「基準値（ピボット）を 1 つ選び、それより小さいもの・大きいものに分けて、それぞれをソートしてつなぐ」です。

- 基底部: 空リストはソート済み
- 再帰部: 先頭 `x` をピボットとし、
  - `x` 以下の要素 → `quicksort` してピボットの**左**へ
  - `x` より大きい要素 → `quicksort` してピボットの**右**へ

```text
quicksort [3, 1, 4, 2]
= quicksort [1, 2] ++ [3] ++ quicksort [4]
= (quicksort [] ++ [1] ++ quicksort [2]) ++ [3] ++ [4]
= [1, 2, 3, 4]
```

分け方には第1回で習った**リスト内包表記**を使っています。
片方を `<=`、もう片方を `>` にしているのは、**ピボットと同じ値**（上の例の 2 や 3 など）を取りこぼさず、二重にも数えないためです。両方 `<` / `>` にすると重複要素が消えてしまいます。

---

## 問4 x の n 乗（素朴な再帰）

```haskell
power :: Integer -> Integer -> Integer
power _ 0 = 1
power x n
  | n < 0     = error "n must be non-negative"
  | otherwise = x * power x (n - 1)
```

```text
ghci> :l lectures/section04/answers/answer04-04.hs
ghci> power 2 10
1024
ghci> power 2 100
1267650600228229401496703205376
```

**解説**

数学の定義 x⁰ = 1、xⁿ = x × xⁿ⁻¹ をそのままパターンマッチで書いています。

- `power _ 0 = 1`: `_` は「どんな値でもよく、使わない」引数
- 負の n は整数の範囲では定義できない（結果が分数になる）ので `error` にしています。
  これが無いと `n` が `-1, -2, ...` と減り続けて止まりません

型を `Int` ではなく `Integer` にしているのは、`Int` が 64 ビット固定で `2^63` 以上を表せないためです。
`Integer` は桁数に上限が無い多倍長整数です。

```text
ghci> 2 ^ 64 :: Int
0                       -- 桁あふれ
ghci> 2 ^ 64 :: Integer
18446744073709551616
```

この方法は n 回掛け算をするので、計算量は **O(n)** です。

---

## 問5 x の n 乗（高速化：繰り返し二乗法）

```haskell
fastPower :: Integer -> Integer -> Integer
fastPower _ 0 = 1                                     -- a^0      = 1
fastPower a n
  | n < 0     = error "n must be non-negative"
  | even n    = fastPower (a * a) (n `div` 2)         -- a^{2n}   = (a*a)^n
  | otherwise = a * fastPower a (n - 1)               -- a^{2n+1} = a * a^{2n}
```

```text
ghci> :l lectures/section04/answers/answer04-05.hs
ghci> fastPower 2 10
1024
ghci> :set +s
ghci> power 3 100000 `mod` 10
1
(0.78 secs, 1,024,922,104 bytes)
ghci> fastPower 3 100000 `mod` 10
1
(0.00 secs, 199,736 bytes)
```

（時間はマシンによって変わります）

**解説**

問題文の 3 本の式が、そのまま 3 つの場合分けに対応しています。

| 式 | Haskell |
|---|---|
| a⁰ = 1 | `fastPower _ 0 = 1` |
| a²ⁿ = (a·a)ⁿ | `even n` のとき `fastPower (a * a) (n `div` 2)` |
| a²ⁿ⁺¹ = a · a²ⁿ | 奇数のとき `a * fastPower a (n - 1)` |

- `even n` は「n が偶数か」を返す関数
- `` n `div` 2 `` は整数の割り算（`/` は小数の割り算なので整数には使えない）

**なぜ速いのか**: n が偶数なら 1 回の掛け算で n が**半分**になります。
奇数のときは 1 引いて偶数にするだけなので、2 ステップに 1 回は必ず半分になります。
つまり掛け算の回数は高々 2·log₂n 回程度で、計算量は **O(log n)** です。

```text
fastPower 2 10
= fastPower 4 5          -- 10 は偶数: (2*2)^5
= 4 * fastPower 4 4      -- 5 は奇数
= 4 * fastPower 16 2     -- 4 は偶数: (4*4)^2
= 4 * fastPower 256 1    -- 2 は偶数: (16*16)^1
= 4 * (256 * fastPower 256 0)
= 4 * (256 * 1)
= 1024
```

`main` を実行すると掛け算の回数の比較表が出ます。

```text
n        | muls (power)       | muls (fastPower)
10       | 10                 | 5
100      | 100                | 9
1000     | 1000               | 15
1000000  | 1000000            | 26
```

n = 100 万で 100 万回対 26 回です。

---

## 問6 末尾再帰

### 末尾再帰とは

**再帰呼び出しが、関数の「最後の処理」になっている再帰**のことです。

```haskell
-- 末尾再帰ではない（問4）
power x n = x * power x (n - 1)
--          ^^^ 再帰呼び出しの「あと」に x * ... が残っている

-- 末尾再帰
go acc k = go (acc * x) (k - 1)
--         ^^ 再帰呼び出しの結果をそのまま返すだけ
```

問4 の `power` は、`power x (n - 1)` の結果が返ってきてから `x *` を計算する必要があるため、
「戻ってきたら x を掛ける」という予定を呼び出しのたびに**スタック**に積みます。n が大きいとスタックが足りなくなります。

末尾再帰なら呼び出し後にやることが何も無いので、今の呼び出しの情報を捨てて**ループ（ジャンプ）に置き換えられます**。これが**末尾再帰最適化（末尾呼び出し最適化）**です。
末尾再帰にするには、途中結果を**累積引数**（ここでは `acc`）として次の呼び出しに渡していきます。

### Haskell ではそのままでは効かない理由：遅延評価

```haskell
-- 形は末尾再帰だが、うまくいかない版
powerTailLazy x n = go 1 n
  where
    go acc 0 = acc
    go acc k = go (acc * x) (k - 1)
```

Haskell は**遅延評価**なので、`acc * x` は「必要になるまで計算しない」まま次に渡されます。その結果、

```text
go 1 3
go (1 * x) 2
go ((1 * x) * x) 1
go (((1 * x) * x) * x) 0
→ (((1 * x) * x) * x)       -- ここで初めて計算される
```

と未評価の式（**サンク**）が n 段積み上がり、最後にそれを評価するときに結局スタックを使い切ります。
これが問題文の「Haskell は末尾再帰最適化は基本的にはそのままではできない」の意味です。
再帰呼び出し自体はループになっていても、**累積引数の中身が計算されていない**のが原因です。

### 解答例：累積引数を正格評価する

```haskell
{-# LANGUAGE BangPatterns #-}

powerTail :: Integer -> Integer -> Integer
powerTail x n
  | n < 0     = error "n must be non-negative"
  | otherwise = go 1 n
  where
    go !acc 0 = acc
    go !acc k = go (acc * x) (k - 1)
```

`!acc`（**バンパターン**）は「`go` に入る時点で `acc` を評価しておく」という指定です。
ファイル先頭の `{-# LANGUAGE BangPatterns #-}` でこの書き方を有効にしています。
これで `acc` には常に計算済みの数値が入り、サンクが積み上がりません。

拡張を使わない別解として `seq` もあります。`` a `seq` b `` は「a を評価してから b を返す」関数です。

```haskell
powerTailSeq x n = go 1 n
  where
    go acc 0 = acc
    go acc k = let acc' = acc * x in acc' `seq` go acc' (k - 1)
```

### 実際に違いを見る

GHCi の起動時にスタック上限を 1MB に絞ると、3 つの違いがはっきり出ます。

```bash
ghci +RTS -K1m -RTS lectures/section04/answers/answer04-06.hs
```

```text
ghci> power 1 1000000            -- 末尾再帰でない
*** Exception: stack overflow
ghci> powerTailLazy 1 1000000    -- 末尾再帰だが遅延したまま
*** Exception: stack overflow
ghci> powerTail 1 1000000        -- 末尾再帰 + 正格評価
1
```

（`x = 1` にしているのは、結果の数を小さく保って再帰の深さだけを比べるためです）

**補足**: `ghc -O2` で最適化コンパイルすると、GHC の**正格性解析**が「`acc` は最後に必ず使われるので先に計算してよい」と判断し、`powerTailLazy` もスタックを使わずに動きます。
ただし最適化に任せた結果なので保証はありません。確実にしたいときは `!` や `seq` で明示します。
同じ理由で、標準ライブラリでは `foldl` より正格版の `foldl'` を使うのが定石です。

### 発展：問5 と組み合わせる

```haskell
fastPowerTail :: Integer -> Integer -> Integer
fastPowerTail x n
  | n < 0     = error "n must be non-negative"
  | otherwise = go 1 x n
  where
    go !acc _ 0 = acc
    go !acc !b k
      | even k    = go acc       (b * b) (k `div` 2)
      | otherwise = go (acc * b) b       (k - 1)
```

問5 の `fastPower` も、奇数のときの `a * fastPower ...` が末尾再帰ではありません。
こちらは「**acc × bᵏ が常に xⁿ に等しい**」という関係を保ったまま `(acc, b, k)` を更新し、k = 0 になったら `acc` が答え、という形にしています。O(log n) かつ末尾再帰です。

```text
go 1    2   10    -- 1 * 2^10   = 1024
go 1    4   5     -- 1 * 4^5    = 1024
go 4    4   4     -- 4 * 4^4    = 1024
go 4    16  2     -- 4 * 16^2   = 1024
go 4    256 1     -- 4 * 256^1  = 1024
go 1024 256 0     -- 1024 * 256^0 → acc = 1024
```

---

## 問7 `myflist`（自作 map）

```haskell
myflist :: (a -> b) -> [a] -> [b]
myflist _ []     = []
myflist g (x:xs) = g x : myflist g xs

f :: Int -> Int
f x = 2 * x
```

```text
ghci> :l lectures/section04/answers/answer04-07.hs
ghci> myflist f [1..10]
[2,4,6,8,10,12,14,16,18,20]
ghci> myflist (+ 1) [1, 2, 3]
[2,3,4]
ghci> myflist show [1, 2, 3]
["1","2","3"]
ghci> :t myflist
myflist :: (a -> b) -> [a] -> [b]
```

**解説**

- 基底部: 空リストに何を適用しても空リスト（関数は使わないので `_`）
- 再帰部: 先頭 `x` に関数を適用した `g x` を、残りを再帰で処理したリストの先頭に `:` で付ける

```text
myflist f [1, 2, 3]
= f 1 : myflist f [2, 3]
= f 1 : (f 2 : myflist f [3])
= f 1 : (f 2 : (f 3 : myflist f []))
= 2 : 4 : 6 : []
= [2, 4, 6]
```

ポイントは型 `(a -> b) -> [a] -> [b]` です。

- 第1引数 `(a -> b)` が「**関数そのもの**」。括弧が付いているのは、関数を 1 つの引数として受け取るため
- `a` と `b` は別の型変数なので、`show`（数値 → 文字列）や `even`（数値 → 真偽値）のように**型を変える関数**も渡せる
- `(+ 1)` のように演算子に片方だけ引数を与えた**セクション**も、1 引数の関数として渡せる

関数を引数に取る関数を**高階関数**と呼びます。この `myflist` は標準関数 `map` と同じもので、次回以降の高階関数の章の入口になります。

ファイルでは、引数名を `f` ではなく `g` にしています。下で定義している `f x = 2 * x` と名前が重なると、`-Wall` を付けたときに「名前の隠蔽（shadowing）」の警告が出るためです（動作は同じです）。

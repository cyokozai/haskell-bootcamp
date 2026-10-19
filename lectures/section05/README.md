Section 05: 第5章 高階関数
==========================

アルゴリズム特論 第5回（110分）の講義資料。教科書「すごいHaskellたのしく学ぼう!」第5章に沿って進める。

ファイル
--------

| ファイル             | 内容                                                              |
|----------------------|-------------------------------------------------------------------|
| `slides.md`          | Marp スライド（60枚、ハンズオン・中間演習入り）                   |
| `theme/cyokozai.css` | Marp テーマ（普段使いの Google Slides テンプレートを CSS で再現） |
| `assets/avatar.png`  | 表紙のアバター                                                    |
| `notes.md`           | 予習ノート（第4章の復習＋第5章の解説、確認問題つき）              |
| `handson.hs`         | 第5章のコード一式。`ghci handson.hs` で講義中の例をすべて試せる   |
| `report5.hs`         | 第5回 課題テンプレート（配布用）。`runghc report5.hs` で採点      |
| `report5_answer.hs`  | 課題の解答例                                                      |

時間配分
--------

| 時間      | 内容                       | 手を動かす        |
|-----------|----------------------------|-------------------|
| 0:00–0:05 | 導入・第4章の振り返り      | H0 準備           |
| 0:05–0:20 | 5.1 カリー化関数           | H1（3分）         |
| 0:20–0:30 | 5.2 高階実演               |                   |
| 0:30–0:45 | 5.3 関数プログラマの道具箱 |                   |
| 0:45–0:50 | 5.4 ラムダ式               |                   |
| 0:50–1:00 | 前半のまとめ演習（問1）    | 10分              |
| 1:00–1:05 | 休憩                       |                   |
| 1:05–1:25 | 5.5 畳み込み               | H4（5分、問2）    |
| 1:25–1:30 | 5.6 `$`                    |                   |
| 1:30–1:42 | 5.7 関数合成               | H5（4分、問3）    |
| 1:42–1:50 | まとめ・課題の説明         |                   |

スライドのビルド
----------------

`lectures/section05` で実行する。設定は `.marprc.yml`（HTML 有効・テーマ読み込み）。

```bash
cd lectures/section05
sh fetch-illustrations.sh                                          # 挿絵を取得（初回のみ）
npx @marp-team/marp-cli@latest slides.md -o slides.html          # HTML
npx @marp-team/marp-cli@latest slides.md --pdf -o slides.pdf      # PDF
npx @marp-team/marp-cli@latest -s .                               # プレビューサーバ
```

挿絵は[いらすとや](https://www.irasutoya.com/)の素材。素材の再配布は禁止されているため `assets/irasutoya/` はリポジトリに含めず、`fetch-illustrations.sh` で取得する。

VS Code の Marp 拡張でプレビューする場合は、`.vscode/settings.json`（devcontainer の外）と devcontainer の設定で `markdown.marp.themes` と `markdown.marp.html: "all"` を指定済み。

Haskell コードの確認
--------------------

```bash
runghc report5_answer.hs   # 全問 [OK] になること
runghc report5.hs          # 配布時は全問 [--]（未実装）
ghci handson.hs            # スライドの ghci 例を試す
```

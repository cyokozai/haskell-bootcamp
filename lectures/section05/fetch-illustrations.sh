#!/bin/sh
# スライドの挿絵（いらすとや https://www.irasutoya.com/）を assets/irasutoya/ に取得する。
# いらすとやは素材の再配布を禁じているため、画像はリポジトリに含めず、ビルド前にこのスクリプトで取得する。
#   $ sh fetch-illustrations.sh
set -eu
cd "$(dirname "$0")"
mkdir -p assets/irasutoya

fetch() {
  [ -f "assets/irasutoya/$1" ] || curl -fsSL -o "assets/irasutoya/$1" "$2"
}

# 工場のイラスト https://www.irasutoya.com/2013/02/blog-post_476.html
fetch building_koujou_entotsu.png 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEiLenXi0CxAGpzrQJt8J8s820wIvhIvDGdfgTGBOn3RlnmnBcOQsE9IxAbLJACDnKfhqCL9gWAkNI10iY66QGRzzWppiojSXW6y7-tGfq7ChXHfTpQVF5ChhH0OuK605AoJTslgCaBt9jsj/s400/building_koujou_entotsu.png'
# 洗濯物をたたんでいる人のイラスト https://www.irasutoya.com/2013/12/blog-post_1465.html
fetch sentaku_tatamu.png 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEhoo7eSEc6u2Mrh8-HosCsLB1Qdb_YuN3KNuPoEaKB5r_jnStoi04BbQnloWKc_sKJvgyOkVGVpa67jEYyjXIUPWerqir7gAMKtzfFNTaY7SA1sfrF1fXj3Ib4g_42aN2hSgpEuQoQfGDZ2/s450/sentaku_tatamu.png'
# 工場のベルトコンベアのイラスト https://www.irasutoya.com/2020/09/blog-post_44.html
fetch koujou_machine.png 'https://blogger.googleusercontent.com/img/b/R29vZ2xl/AVvXsEivXWO4M9AAl_uJR0v5AtmjfWMK8CGi3ziei5p0NGcv5vOOARc0LkO8Nq6f6i2Lmcg_zn9RmNcPO6VYFDfJ4ub0pb0O4G1twfAZ6rzFyBLFacv3tp9pkKVbrwOW6LhnbZC2ghn7D9JD6ZTv/s500/koujou_machine.png'

ls -l assets/irasutoya

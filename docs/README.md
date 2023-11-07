# LinariaからVanilla-extractへの移行メモ

## vanilla-extractについて
### セレクタ問題
vanilla-extractではセレクタの利用が制限される。`div > &`は使えると思うが、`& > div`のように自分以外の要素にスタイルを当てるようなセレクタの利用は制限されている。そのため、例えば隣接セレクタの`& + li`などの使用も制限されている。

### linariaとの比較、利点
- linariaだとstyleとcssの使い分けがあった。vanilla-extractだとこの使い分けがなくなりそう。

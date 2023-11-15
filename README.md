### How to use
```
ruby [script_name] [filename]
```
#### example
- convert-react-tag.rb
```
ruby convert-react-tag.rb example/site/components/templates/site-layout/site-layout.tsx
```
-> site-layout.tsxが上書きされる。バックアップ用にsite-layout.tsx.bakを用意してある。

- convert-css-style.rb
```
ruby convert-react-tag.rb example/site/components/templates/site-layout/site-layout.tsx
```
-> site-layout.css.tsが作成される。

### 実際の作業例
- src/site以下のファイルに`convert-css-style.rb`を適用する場合
* 順番通りにコマンドを適用すること。スクリプトの関係上順番が前後すると生成が上手くいかないかもしれない。
1. <filename>.css.tsを生成する
```
find src/site -type f -name "*.tsx" | xargs -I{} ruby convert-css-style.rb '{}'
```
2. tsxファイルについてバックアップファイルを作成する
```
find src/site -type f -name "*.tsx" | xargs -I{} cp '{}' '{}.bak'
```
3. <filename>.tsxファイルにconvert-react-tag.rbを適用する
```
find src/site -type f -name "*.tsx" | xargs -I{} ruby convert-react-tag.rb '{}'
```

### convert-react-tag.rb
`<SiteMain>`のようなタグを`<div className={siteMainStyle}>`に変更するスクリプト。タグの属性にすでに`className`が設定されている場合は手動で修正する必要がある。

### convert-css-style.rb

### /common/aomのcss移行作業
- 例: /common/aomの"box"(枠)のstylesファイルのパスを抜き出す場合
```sh
git ls-files | grep styles | grep "/box" 
```
上のコマンドでパスを抜き出して、パイプとxargsを使ってscriptに渡す。つまり、
```sh
git ls-files | grep styles | grep "/box" | xargs -I{} ruby convert-aom-style.rb {}
```

さらに、tsxファイルのインポート先を以下のcssファイルに変えたい。
```diff
-import "./article-box-styles";
+import "./article-box.css";
```
そこで以下のワンライナーを使う。

```sh
ruby -i -pe '$_.gsub!("-styles", ".css") if $_ =~ /import .*-styles/' <filepath>
```

このワンライナーを前述のファイルパスを書き出すコマンドと、パイプとxargsで繋げる。

```sh
git ls-files | grep tsx | grep "/box" | xargs -I{} ruby -i -pe '$_.gsub!("-styles", ".css") if $_ =~ /import .*-styles/' {}
```

最後に`-styles.ts`ファイルを削除する。

削除する際は念のため書き出されるファイルパスが正しいものか確かめること。`git ls-files`によるファイルパス生成のため、リポジトリ内のパスしか生成しないはずであるが、万が一にもリポジトリ外のパスをrmに渡すと、渡された方のファイルは二度と復元できない。
```sh
git ls-files | grep styles | grep "/box" | xargs rm
```

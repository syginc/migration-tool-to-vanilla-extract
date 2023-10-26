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

### 実作業
- src/site以下のファイルに`convert-css-style.rb`を適用する場合
```
find src/site -type f -name "*.tsx" | xargs -I{} ruby convert-css-style.rb '{}'
```

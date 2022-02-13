# search_component
nuxtのcomponentの使用状況確認するファイル

## 使い方
`target_dir`に検索するnuxtのディレクトリをセットする

```
ruby search_component.rb component_name
```

## 備考
- componentを呼んでいる親のcomponentはpagesまでは探索しない
- 試験項目作成用なので、どこで呼んでいるかだけいったん表示

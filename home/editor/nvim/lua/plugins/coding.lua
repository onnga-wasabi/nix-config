return {
  -- 補完候補のドキュメント（Nix の option なら 型・説明・デフォルト）を自動表示する。
  -- nixd の `K`(hover) は AST のノード種別しか出さず弱いので、
  -- 「何が設定できて何なのか」は補完メニュー横のドキュメント欄で見る。
  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 150,
        },
      },
    },
  },
}

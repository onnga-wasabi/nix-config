-- Mason を完全に無効化する。
-- LSP/formatter/linter のバイナリは nix(home.packages)で宣言的に入れて PATH から使うため、
-- Mason による命令的なインストール & 「入っているもの全部を自動有効化」を止める。
-- LazyVim は `LazyVim.has("mason-lspconfig.nvim")` のガードがあるので、無効化しても安全に動作し、
-- 各 lang extra で明示したサーバーだけが vim.lsp.enable() で有効化される。
return {
  { "mason-org/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },
  { "jay-babu/mason-nvim-dap.nvim", enabled = false },
}

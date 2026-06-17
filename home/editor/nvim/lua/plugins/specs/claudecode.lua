-- Claude Code を Neovim と連携させる（avante の置き換え）。
-- 本物の Claude Code(CLI/ネイティブ版)を nvim のターミナル分割で起動し、
-- 公式 IDE 拡張と同じ WebSocket プロトコルで接続する:
--   ・選択範囲やバッファを @mention として Claude に送る
--   ・Claude の編集が nvim の diff として出て accept / reject できる
-- バイナリは PATH の `claude`(~/.local/bin、ネイティブ自動更新版)を使う。
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file from tree",
        ft = { "snacks_picker_list", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- 差分の承認/却下
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },
}

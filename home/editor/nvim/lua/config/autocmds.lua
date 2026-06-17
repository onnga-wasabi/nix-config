-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Open memo file
vim.cmd("autocmd!")
vim.api.nvim_create_user_command("Memo", function(_)
  vim.cmd("e " .. "~/._/memo/memo.md")
end, {})
-- }}} end of Util Functions

-- cusor 記憶
vim.cmd([[
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif
]])

-- refer to: https://lsifrontend.blog.fc2.com/blog-entry-356.html?sp
function _G.EBufdelete()
  local currentBufNum = vim.fn.bufnr("%")
  local alternateBufNum = vim.fn.bufnr("#")

  if vim.fn.buflisted(alternateBufNum) == 1 then
    vim.cmd("buffer #")
  else
    vim.cmd("bnext")
  end

  if vim.fn.buflisted(currentBufNum) == 1 then
    vim.cmd("silent bwipeout " .. currentBufNum)
    -- bwipeoutに失敗した場合はウインドウ上のバッファを復元
    if vim.fn.bufloaded(currentBufNum) ~= 0 then
      vim.cmd("buffer " .. currentBufNum)
    end
  end
end

-- snacks dashboard の WinResized バグ対策。
-- dashboard を開いたまま別ウィンドウを閉じると、内部の WinResized オートコマンドが
-- 既に無効になったウィンドウ id で nvim_win_get_width を呼んで落ちる
-- （snacks/dashboard.lua の D:size() に有効性チェックが無い。上流最新でも未修正）。
-- クラスメソッド D.size をガード版に差し替えて握りつぶす。実行時パッチなので
-- プラグイン更新でも壊れず、上流が直しても（有効なら orig を呼ぶだけで）無害。
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    local ok, dashboard = pcall(require, "snacks.dashboard")
    if not ok or not dashboard.Dashboard then
      return
    end
    local orig_size = dashboard.Dashboard.size
    function dashboard.Dashboard.size(self)
      if not (self.win and vim.api.nvim_win_is_valid(self.win)) then
        -- 直前のサイズを返せば deep_equal が真になり再描画（=エラー）を回避できる
        return self._size or { width = 0, height = 0 }
      end
      return orig_size(self)
    end
  end,
})

-- im-select を使ってノーマルモード移行時に IME を OFF にする
local im_select_group = vim.api.nvim_create_augroup("im_select", { clear = true })

vim.api.nvim_create_autocmd({ "InsertLeave", "CmdlineLeave" }, {
  group = im_select_group,
  pattern = "*",
  callback = function()
    -- Mac のデフォルト英語入力ソース "com.apple.keylayout.ABC" に切り替え
    vim.fn.system("im-select com.apple.keylayout.ABC")
  end,
})

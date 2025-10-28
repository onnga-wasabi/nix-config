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

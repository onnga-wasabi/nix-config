-- Mappings {{{

vim.g.mapleader = " " -- Set <Space> as <Leader>
vim.g.omni_sql_no_default_maps = 1

--- @param mode string Mode short-name (map command prefix: "n", "i", "v", "x", …)
---             or "!" for `:map!`, or empty string for `:map`. "ia", "ca" or
---             "!a" for abbreviation in Insert mode, Cmdline mode, or both,
---             respectively
--- @param lhs string Left-hand-side `{lhs}` of the mapping.
--- @param rhs string Right-hand-side `{rhs}` of the mapping.
function set_keymap(mode, lhs, rhs)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, lhs, rhs, opts)
end
-- basic shortcuts
set_keymap("n", "<c-w>n", "<nop>")
set_keymap("n", "s", "<nop>")
set_keymap("n", "j", "gj")
set_keymap("n", "k", "gk")
set_keymap("n", "*", "*``")
set_keymap("n", "#", "#``")
set_keymap("n", "<c-c>", "<cmd>noh<cr>:w<cr>")
set_keymap("n", "<a-p>", '<cmd>lua vim.notify("Current file: " .. vim.fn.expand("%"))<cr>')
set_keymap("n", "<leader>r", "<cmd>source ~/.config/nvim/init.lua<cr>")
set_keymap("n", '<leader>"', 'gg"+yG')
-- windows and buffers
set_keymap("n", "<c-w>v", "<c-w>v<c-w>l")
set_keymap("n", "<c-w>s", "<c-w>s<c-w>j")

set_keymap("n", "<c-w>l", "<cmd>silent! w<cr><c-w>l")
set_keymap("n", "<c-w>j", "<cmd>silent! w<cr><c-w>j")
set_keymap("n", "<c-w>k", "<cmd>silent! w<cr><c-w>k")
set_keymap("n", "<c-w>h", "<cmd>silent! w<cr><c-w>h")
set_keymap("n", "<c-o>", "<cmd>silent! w<cr><c-o>")
set_keymap("n", "<c-s>", "<cmd>silent! w<cr><c-i>")

set_keymap("v", "<c-w>l", "<cmd>silent! w<cr><c-w>l")
set_keymap("v", "<c-w>j", "<cmd>silent! w<cr><c-w>j")
set_keymap("v", "<c-w>k", "<cmd>silent! w<cr><c-w>k")
set_keymap("v", "<c-w>h", "<cmd>silent! w<cr><c-w>h")
set_keymap("v", "<c-o>", "<cmd>silent! w<cr><c-o>")
set_keymap("v", "<c-s>", "<cmd>silent! w<cr><c-i>")

-- cursor
set_keymap("n", "<c-f>", "<c-f>zz")
set_keymap("n", "<c-b>", "<c-b>zz")
set_keymap("v", "<c-f>", "<c-f>zz")
set_keymap("v", "<c-b>", "<c-b>zz")

set_keymap("n", "sp", "<cmd>bn<cr>")
set_keymap("n", "sn", "<cmd>bp<cr>")

set_keymap("i", "<c-c>", "<esc>")

set_keymap("v", "<", "<gv")
set_keymap("v", ">", ">gv")

-- Terminals
set_keymap("t", "<c-n>", "<c-\\><c-n>")
-- }}} end of Mappings

-- Util Functions {{{
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
set_keymap("n", ",", "<cmd>silent! w<cr><cmd>lua EBufdelete()<cr>")

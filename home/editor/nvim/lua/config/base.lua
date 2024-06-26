-- Mappings {{{
local opts = { noremap = true, silent = true }
local set_keymap = vim.api.nvim_set_keymap

vim.g.mapleader = " " -- Set <Space> as <Leader>
vim.g.omni_sql_no_default_maps = 1

-- basic shortcuts
set_keymap("n", "<c-w>n", "<nop>", opts)
set_keymap("n", "s", "<nop>", opts)
set_keymap("n", "j", "gj", opts)
set_keymap("n", "k", "gk", opts)
set_keymap("n", "*", "*``", opts)
set_keymap("n", "#", "#``", opts)
set_keymap("n", "<c-c>", "<cmd>noh<cr>:w<cr>", opts)
set_keymap("n", "<c-p>", '<cmd>lua vim.notify("Current file: " .. vim.fn.expand("%"))<cr>', opts)
set_keymap("n", "<leader>r", "<cmd>source ~/.config/nvim/init.lua<cr>", opts)
set_keymap("n", '<leader>"', 'gg"+yG', opts)

-- windows and buffers
set_keymap("n", "<c-w>v", "<c-w>v<c-w>l", opts)
set_keymap("n", "<c-w>s", "<c-w>s<c-w>j", opts)

set_keymap("n", "<c-w>l", "<cmd>silent! w<cr><c-w>l", opts)
set_keymap("n", "<c-w>j", "<cmd>silent! w<cr><c-w>j", opts)
set_keymap("n", "<c-w>k", "<cmd>silent! w<cr><c-w>k", opts)
set_keymap("n", "<c-w>h", "<cmd>silent! w<cr><c-w>h", opts)
set_keymap("n", "<c-o>", "<cmd>silent! w<cr><c-o>", opts)
set_keymap("n", "<c-s>", "<cmd>silent! w<cr><c-i>", opts)

set_keymap("v", "<c-w>l", "<cmd>silent! w<cr><c-w>l", opts)
set_keymap("v", "<c-w>j", "<cmd>silent! w<cr><c-w>j", opts)
set_keymap("v", "<c-w>k", "<cmd>silent! w<cr><c-w>k", opts)
set_keymap("v", "<c-w>h", "<cmd>silent! w<cr><c-w>h", opts)
set_keymap("v", "<c-o>", "<cmd>silent! w<cr><c-o>", opts)
set_keymap("v", "<c-s>", "<cmd>silent! w<cr><c-i>", opts)

-- cursor
set_keymap("n", "<c-f>", "<c-f>zz", opts)
set_keymap("n", "<c-b>", "<c-b>zz", opts)
set_keymap("v", "<c-f>", "<c-f>zz", opts)
set_keymap("v", "<c-b>", "<c-b>zz", opts)

set_keymap("n", "sp", "<cmd>bn<cr>", opts)
set_keymap("n", "sn", "<cmd>bp<cr>", opts)

set_keymap("i", "<c-c>", "<esc>", opts)

set_keymap("v", "<", "<gv", opts)
set_keymap("v", ">", ">gv", opts)

-- Terminals
set_keymap("t", "<c-n>", "<c-\\><c-n>", opts)
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
set_keymap("n", ",", "<cmd>silent! w<cr><cmd>lua EBufdelete()<cr>", opts)

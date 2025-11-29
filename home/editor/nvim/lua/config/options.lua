-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Encoding
vim.o.encoding = "utf-8"
vim.o.fileencoding = "utf-8"

-- Backup
vim.o.backup = false
vim.o.writebackup = false
vim.o.swapfile = false

-- Timing
vim.o.timeoutlen = 300
vim.o.updatetime = 300
vim.o.redrawtime = 5000

-- File read
vim.o.autoread = true

-- Window
vim.o.title = true

-- Search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Indentation
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.cindent = true
vim.o.expandtab = true

-- UI
vim.o.termguicolors = true
vim.o.cursorline = true
vim.o.number = true
vim.o.numberwidth = 4
vim.o.wrap = false
vim.o.showtabline = 4
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.laststatus = 3
-- vim.o.ambiwidth = "double"
vim.o.conceallevel = 2

-- Columns
vim.o.signcolumn = "yes"

-- Performance
vim.o.history = 1000

-- LazyVim Default Options left
-- https://www.lazyvim.org/configuration/general

-- LazyVim auto format
vim.g.autoformat = false

-- Enforce LazyVim-Extras
vim.g.lazyvim_picker = "telescope"

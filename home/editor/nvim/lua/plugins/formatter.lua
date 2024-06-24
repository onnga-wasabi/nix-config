return {
	-- https://github.com/mhartington/formatter.nvim
	"mhartington/formatter.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{ "<m-F>", "<cmd>Format<cr>" },
	},
	config = function()
		-- Utilities for creating configurations
		local util = require("formatter.util")

		-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
		require("formatter").setup({
			-- Enable or disable logging
			logging = true,
			-- Set the log level
			log_level = vim.log.levels.WARN,
			-- All formatter configurations are opt-in
			filetype = {
				lua = {
					-- Formatter configurations for filetype "lua" go here
					-- and will be executed in order
					require("formatter.filetypes.lua").stylua,
				},
				go = {
					require("formatter.filetypes.go").gofmt,
				},
				sql = {
					{
						exe = "sqlfluff",
						args = {
							"fix",
							"--dialect",
							"postgres",
							"-q",
							"-f",
							"-",
						},
						stdin = true,
						ignore_exitcode = true,
					},
				},
				sh = {
					require("formatter.filetypes.sh").shfmt,
				},
				zsh = {
					require("formatter.filetypes.sh").shfmt,
				},
				json = {
					require("formatter.filetypes.json").fixjson,
				},
				python = {
					require("formatter.filetypes.python").black,
				},
				proto = {
					require("formatter.filetypes.proto").buf_format,
				},
				javascript = {
					require("formatter.filetypes.javascript").prettier,
				},
				typescript = {
					require("formatter.filetypes.typescript").prettier,
				},
				typescriptreact = {
					require("formatter.filetypes.typescriptreact").prettier,
				},
				nix = {
					require("formatter.filetypes.nix").nixpkgs_fmt,
				},
				terraform = {
					require("formatter.filetypes.terraform").terraformfmt,
				},
				-- Use the special "*" filetype for defining formatter configurations on
				-- any filetype
				-- ["*"] = {
				-- 	-- "formatter.filetypes.any" defines default configurations for any
				-- 	-- filetype
				-- 	require("formatter.filetypes.any").remove_trailing_whitespace,
				-- },
			},
		})
	end,
}

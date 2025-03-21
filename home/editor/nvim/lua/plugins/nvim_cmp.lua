return {
	-- https://github.com/hrsh7th/nvim-cmp
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-buffer",
		"onsails/lspkind.nvim",
		{
			-- https://github.com/MattiasMTS/cmp-dbee/issues/18
			"MattiasMTS/cmp-dbee",
			commit = "0feabc1",
			dependencies = {
				{ "kndndrj/nvim-dbee" },
			},
			ft = "sql",
			opts = {},
		},
		{
			"rinx/cmp-skkeleton",
			dependencies = {
				"vim-skk/skkeleton",
			},
		},
	},
	config = function()
		local cmp = require("cmp")
		local lspkind = require("lspkind")

		opts = {
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<c-b>"] = cmp.mapping.scroll_docs(-4),
				["<c-f>"] = cmp.mapping.scroll_docs(4),
				["<c-e>"] = cmp.mapping.abort(),
				["<c-y>"] = cmp.mapping.confirm(), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
			}),
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "cmp-dbee" },
				{ name = "skkeleton" },
			}, {
				{ name = "buffer" },
			}),
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				-- refer to: https://github.com/onsails/lspkind.nvim
				format = lspkind.cmp_format({
					mode = "symbol", -- show only symbol annotations
					maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
					ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					-- The function below will be called before any actual modifications from lspkind
					-- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
					-- before = function (entry, vim_item)
					--   return vim_item
					-- end
				}),
			},
		}

		cmp.setup(opts)
	end,
}

return {
	-- https://github.com/neovim/nvim-lspconfig
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
	},
	config = function()
		-- mason
		local ok, mason = pcall(require, "mason")
		if ok then
			mason.setup()
		else
			return
		end

		local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
		if ok then
			mason_lspconfig.setup()
		else
			return
		end

		-- lspconfig
		local ok, lspconfig = pcall(require, "lspconfig")
		if not ok then
			return
		end
		local lsp_util = require("lspconfig/util")

		lspconfig.rnix.setup({})

		lspconfig.bufls.setup({})

		lspconfig.metals.setup({})

		lspconfig.pyright.setup({})

		lspconfig.vimls.setup({})

		lspconfig.gopls.setup({
			cmd = { "gopls", "serve" },
			filetypes = { "go", "gomod" },
			root_dir = lsp_util.root_pattern("go.work", "go.mod", ".git"),
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
				},
			},
		})

		lspconfig.golangci_lint_ls.setup({
			filetypes = { "go", "gomod" },
		})

		lspconfig.terraformls.setup({
			filetypes = {
				"terraform",
				-- ignore tfvars
				-- "terraform-vars",
			},
		})

		lspconfig.clangd.setup({
			filetypes = {
				"c",
				"cpp",
				"objc",
				"objcpp",
				"cuda",
			},
		})

		lspconfig.sqlls.setup({})

		lspconfig.yamlls.setup({})

		lspconfig.opencl_ls.setup({})

		lspconfig.texlab.setup({})

		lspconfig.volar.setup({
			filetypes = { "javascript", "javascriptreact", "vue" },
			init_options = {
				languageFeatures = {
					diagnostics = false,
				},
			},
		})

		lspconfig.bufls.setup({})

		lspconfig.html.setup({})
		lspconfig.marksman.setup({})

		lspconfig.jdtls.setup({})

		lspconfig.tsserver.setup({
			filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
			cmd = { "typescript-language-server", "--stdio" },
		})

		lspconfig.kotlin_language_server.setup({})

		lspconfig.groovyls.setup({})

		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					runtime = {
						-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
					},
					diagnostics = {
						-- Get the language server to recognize the `vim` global
						enable = false,
					},
					workspace = {
						-- Make the server aware of Neovim runtime files
						library = vim.api.nvim_get_runtime_file("", true),
						checkThirdParty = false, -- refer to: https://github.com/neovim/nvim-lspconfig/issues/1700#issuecomment-1033127328
					},
					-- Do not send telemetry data containing a randomized but unique identifier
					telemetry = {
						enable = false,
					},
				},
			},
		})

		lspconfig.ruby_lsp.setup({
			filetypes = {
				"ruby",
				"Brewfile",
			},
		})

		lspconfig.emmet_ls.setup({
			filetypes = {
				"html",
				"typescriptreact",
				"javascriptreact",
				"css",
				"sass",
				"scss",
				"less",
				"javascript",
				"typescript",
				"markdown",
			},
		})
	end,
}

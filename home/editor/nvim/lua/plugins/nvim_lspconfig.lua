return {
	-- https://github.com/neovim/nvim-lspconfig
	"neovim/nvim-lspconfig",
	event = { "VimEnter" },
	dependencies = {
		{
			-- https://www.lazyvim.org/plugins/lsp
			"williamboman/mason.nvim",
			cmd = "Mason",
			build = ":MasonUpdate",
			opts_extend = { "ensure_installed" },
			opts = {
				ensure_installed = {
					"buf",
					"buf-language-server",
					"clangd",
					"dockerfile-language-server",
					"emmet-ls",
					"eslint_d",
					"flake8",
					"golangci-lint",
					"golangci-lint-langserver",
					"gopls",
					"groovy-language-server",
					"isort",
					-- "jdtls",
					"kotlin-language-server",
					"ltex-ls",
					"lua-language-server",
					"marksman",
					"opencl-language-server",
					"prettier",
					"pyright",
					"robotframework-lsp",
					"ruby-lsp",
					"shfmt",
					"stylua",
					"taplo",
					"terraform-ls",
					"texlab",
					"typescript-language-server",
					"vim-language-server",
					"yaml-language-server",
					"yamlfmt",
					"yamllint",
					"rnix-lsp",
					"nil",
					"nixpkgs-fmt",
				},
			},
			config = function(_, opts)
				require("mason").setup(opts)
				local mr = require("mason-registry")
				local function ensure_installed()
					for _, tool in ipairs(opts.ensure_installed) do
						local p = mr.get_package(tool)
						if not p:is_installed() then
							p:install()
						end
					end
				end
				if mr.refresh then
					mr.refresh(ensure_installed)
				else
					ensure_installed()
				end
			end,
		},
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
	},
	keys = {
		{ "<A-l>", "<cmd>LspStop<cr><cmd>LspRestart<cr>" },
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
		lspconfig.nil_ls.setup({})

		lspconfig.bufls.setup({})

		-- see metasl.lua
		--
		-- lspconfig.jdtls.setup({})
		-- lspconfig.metals.setup({
		-- 	filetypes = { "scala", "sbt" },
		-- })

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

		lspconfig.ts_ls.setup({
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

		vim.lsp.set_log_level("ERROR")
		-- vim.lsp.set_log_level("OFF")
	end,
}

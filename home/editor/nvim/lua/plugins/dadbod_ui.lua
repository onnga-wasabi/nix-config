return {
	"kristijanhusak/vim-dadbod-ui",
	dependencies = {
		{ "tpope/vim-dadbod", lazy = true },
		{ "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		-- Your DBUI configuration
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_execute_on_save = 0
		vim.g.db_ui_use_nvim_notify = 1
	end,
	keys = {
		{
			"<c-s>",
			':<C-u>execute "normal \\<Plug>(DBUI_ExecuteQuery)"<CR>',
			mode = "n",
		},
	},
}

return {
	-- https://github.com/nvimdev/lspsaga.nvim
	"nvimdev/lspsaga.nvim",
	event = { "LspAttach" },
	opts = {
		ui = {
			theme = "round",
			border = "rounded",
			title = true,
			winblend = 10,
			expand = "",
			collapse = "",
			preview = " ",
			code_action = "💡",
			diagnostic = "🐞",
			incoming = " ",
			outgoing = " ",
			colors = {
				--float window normal bakcground color
				normal_bg = "#1d1536",
				--title background color
				title_bg = "#afd700",
			},
			kind = {},
		},
		diagnostic = {
			show_code_action = false,
			show_source = true,
			jump_num_shortcut = false,
			keys = {
				exec_action = "o",
				quit = "q",
				go_action = "g",
			},
		},
		code_action = {
			num_shortcut = true,
			keys = {
				quit = "q",
				exec = "<CR>",
			},
		},
		lightbulb = {
			enable = false,
			enable_in_insert = true,
			-- cache_code_action = true,
			sign = true,
			sign_priority = 40,
			virtual_text = true,
		},
		preview = {
			lines_above = 0,
			lines_below = 10,
		},
		scroll_preview = {
			scroll_down = "<C-f>",
			scroll_up = "<C-b>",
		},
		request_timeout = 2000,
		finder = {
			keys = {
				toggle_or_open = { "o", "<CR>" },
				vsplit = "s",
				split = "i",
				tabe = "t",
				quit = { "q", "<ESC>" },
			},
		},
		definition = {
			width = 0.8,
			height = 0.8,
			keys = {
				edit = "<C-c>o",
				vsplit = "<C-c>v",
				split = "<C-c>i",
				tabe = "<C-c>t",
				quit = "q",
				close = "<Esc>",
			},
		},
		rename = {
			in_select = false,
			autosave = false,
			protject_max_width = 0.8,
			protject_max_height = 0.8,
			keys = {
				quit = "<esc>",
				exec = "<cr>",
				select = "x",
			},
		},
		symbol_in_winbar = {
			enable = true,
			separator = " ",
			hide_keyword = true,
			show_file = true,
			folder_level = 2,
			respect_root = false,
			color_mode = true,
		},
		outline = {
			win_position = "right",
			win_with = "",
			win_width = 30,
			show_detail = false,
			auto_preview = false,
			auto_refresh = false,
			auto_close = true,
			custom_sort = nil,
			keys = {
				jump = "o",
				expand_collapse = "u",
				quit = "<ESC>",
			},
		},
		callhierarchy = {
			keys = {
				edit = "<cr>",
				vsplit = "v",
				split = "s",
				tabe = nil,
				jump = nil,
				close = {
					"<ESC>",
					"<c-w>h",
					"<c-w>j",
					"<c-w>k",
					"<c-w>l",
				},
				toggle_or_req = { "t", "o" },
				shuttle = "<c-w><c-w>",
			},
		},
		server_filetype_map = {},
	},
	keys = {
		{ "<A-g>a", "<cmd>Lspsaga code_action<cr>" },
		{ "<A-g>r", "<cmd>Lspsaga rename ++project mode=n<cr>" },
		{ "<A-g>d", "<cmd>Lspsaga peek_definition<cr>" },

		{ "gh", "<cmd>Lspsaga finder def+imp+ref<cr>" },
		{ "gd", "<cmd>Lspsaga goto_definition<cr>" },
		{ "gxl", "<cmd>Lspsaga show_line_diagnostics<cr>" },
		{ "gxc", "<cmd>Lspsaga show_cursor_diagnosticscr>" },
		{ "K", "<cmd>Lspsaga hover_doc<cr>" },
	},
}

return {
	-- https://github.com/nvimdev/lspsaga.nvim
	"nvimdev/lspsaga.nvim",
	event = { "BufReadPre", "BufNewFile" },
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
			edit = { "o", "<CR>" },
			vsplit = "s",
			split = "i",
			tabe = "t",
			quit = { "q", "<ESC>" },
		},
		definition = {
			edit = "<C-c>o",
			vsplit = "<C-c>v",
			split = "<C-c>i",
			tabe = "<C-c>t",
			quit = "q",
			close = "<Esc>",
		},
		rename = {
			quit = "<C-c>",
			exec = "<CR>",
			mark = "x",
			confirm = "<CR>",
			in_select = true,
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
			show_detail = false,
			keys = {
				edit = "e",
				vsplit = "s",
				split = "i",
				tabe = "t",
				jump = "o",
				quit = "<ESC>",
				expand_collapse = "u",
			},
		},
		server_filetype_map = {},
	},
	keys = {
		{ "<A-g>h", "<cmd>Lspsaga lsp_finder<cr>" },
		{ "<A-g>a", "<cmd>Lspsaga code_action<cr>" },
		{ "<A-g>r", "<cmd>Lspsaga rename<cr>" },
		{ "gxl", "<cmd>Lspsaga show_line_diagnostics<cr>" },
		{ "gxc", "<cmd>Lspsaga show_cursor_diagnosticscr>" },
		{ "K", "<cmd>Lspsaga hover_doc<cr>" },
	},
}

return {
	-- https://github.com/kndndrj/nvim-dbee
	"kndndrj/nvim-dbee",
	event = { "VeryLazy" },
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "<A-d>", "<cmd>lua require('dbee').toggle()<cr>" },
	},
	build = function()
		-- Install tries to automatically detect the install method.
		-- if it fails, try calling it with one of these parameters:
		--    "curl", "wget", "bitsadmin", "go"
		require("dbee").install()
	end,
	config = function()
		local dbee = require("dbee")
		local opts = { -- refer to: https://github.com/kndndrj/nvim-dbee/blob/master/lua/dbee/config.lua
			-- you can specify an optional default connection id and it will be the active one
			-- when dbee starts
			default_connection = os.getenv("DBEE_DEFAULT_CONNECTION"),
			-- loads connections from files and environment variables
			sources = {
				require("dbee.sources").FileSource:new(os.getenv("XDG_STATE_HOME") .. "/nvim/dbee/persistence.json"),
			},
			-- extra table helpers per connection type
			-- every helper value is a go-template with values set for
			-- "Table", "Schema" and "Materialization"
			extra_helpers = {
				-- example:
				["postgres"] = {
					["List"] = "select * from {{ .Table }} limit 10",
				},
			},
			-- options passed to floating windows - :h nvim_open_win()
			float_options = {},

			-- drawer window config
			drawer = {
				-- these two option settings can be added to all UI elements and
				-- allow for passing specific window/buffer options.
				-- Note that you probably shouldn't be passing buffer options, since
				-- the functionality of the plugin might rely on them.
				-- TL;DR: only use this if you know what you are doing!
				window_options = {},
				buffer_options = {},

				-- show help or not
				disable_help = false,
				-- mappings for the buffer
				mappings = {
					-- manually refresh drawer
					{ key = "r", mode = "n", action = "refresh" },
					-- actions perform different stuff depending on the node:
					-- action_1 opens a note or executes a helper
					{ key = "<CR>", mode = "n", action = "action_1" },
					-- action_2 renames a note or sets the connection as active manually
					{ key = "cw", mode = "n", action = "action_2" },
					-- action_3 deletes a note or connection (removes connection from the file if you configured it like so)
					{ key = "dd", mode = "n", action = "action_3" },
					-- these are self-explanatory:
					-- { key = "c", mode = "n", action = "collapse" },
					-- { key = "e", mode = "n", action = "expand" },
					{ key = "o", mode = "n", action = "toggle" },
					-- mappings for menu popups:
					{ key = "<CR>", mode = "n", action = "menu_confirm" },
					{ key = "y", mode = "n", action = "menu_yank" },
					{ key = "<Esc>", mode = "n", action = "menu_close" },
					{ key = "q", mode = "n", action = "menu_close" },
				},
				-- icon settings:
				disable_candies = false,
				candies = {
					-- these are what's available for now:
					history = {
						icon = "",
						icon_highlight = "Constant",
						text_highlight = "",
					},
					note = {
						icon = "",
						icon_highlight = "Character",
						text_highlight = "",
					},
					connection = {
						icon = "󱘖",
						icon_highlight = "SpecialChar",
						text_highlight = "",
					},
					database_switch = {
						icon = "",
						icon_highlight = "Character",
					},
					table = {
						icon = "",
						icon_highlight = "Conditional",
						text_highlight = "",
					},
					view = {
						icon = "",
						icon_highlight = "Debug",
						text_highlight = "",
					},
					column = {
						icon = "󰠵",
						icon_highlight = "WarningMsg",
						text_highlight = "",
					},
					add = {
						icon = "",
						icon_highlight = "String",
						text_highlight = "String",
					},
					edit = {
						icon = "󰏫",
						icon_highlight = "Directory",
						text_highlight = "Directory",
					},
					remove = {
						icon = "󰆴",
						icon_highlight = "SpellBad",
						text_highlight = "SpellBad",
					},
					help = {
						icon = "󰋖",
						icon_highlight = "Title",
						text_highlight = "Title",
					},
					source = {
						icon = "󰃖",
						icon_highlight = "MoreMsg",
						text_highlight = "MoreMsg",
					},

					-- if there is no type
					-- use this for normal nodes...
					none = {
						icon = " ",
					},
					-- ...and use this for nodes with children
					none_dir = {
						icon = "",
						icon_highlight = "NonText",
					},

					-- chevron icons for expanded/closed nodes
					node_expanded = {
						icon = "",
						icon_highlight = "NonText",
					},
					node_closed = {
						icon = "",
						icon_highlight = "NonText",
					},
				},
			},

			-- results window config
			result = {
				-- see drawer comment.
				window_options = {},
				buffer_options = {},

				-- number of rows in the results set to display per page
				page_size = 100,

				-- progress (loading) screen options
				progress = {
					-- spinner to use in progress display
					spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
					-- prefix to display before the timer
					text_prefix = "Executing...",
				},

				-- mappings for the buffer
				mappings = {
					-- next/previous page
					{ key = "L", mode = "", action = "page_next" },
					{ key = "H", mode = "", action = "page_prev" },
					{ key = "E", mode = "", action = "page_last" },
					{ key = "F", mode = "", action = "page_first" },
					-- yank rows as csv/json
					{ key = "yaj", mode = "n", action = "yank_current_json" },
					{ key = "yaj", mode = "v", action = "yank_selection_json" },
					{ key = "yaJ", mode = "", action = "yank_all_json" },
					{ key = "yac", mode = "n", action = "yank_current_csv" },
					{ key = "yac", mode = "v", action = "yank_selection_csv" },
					{ key = "yaC", mode = "", action = "yank_all_csv" },

					-- cancel current call execution
					{ key = "C", mode = "", action = "cancel_call" },
				},
			},

			-- editor window config
			editor = {
				-- see drawer comment.
				window_options = {},
				buffer_options = {},

				-- directory where to store the scratchpads.
				directory = os.getenv("DBEE_NOTES") or os.getenv("XDG_STATE_HOME") .. "/nvim/dbee/notes",

				-- mappings for the buffer
				mappings = {
					-- run what's currently selected on the active connection
					{ key = "BB", mode = "v", action = "run_selection" },
					-- run the whole file on the active connection
					{ key = "BB", mode = "n", action = "run_file" },
				},
			},

			-- call log window config
			call_log = {
				-- see drawer comment.
				window_options = {},
				buffer_options = {},

				-- mappings for the buffer
				mappings = {
					-- show the result of the currently selected call record
					{ key = "<CR>", mode = "", action = "show_result" },
					-- cancel the currently selected call (if its still executing)
					{ key = "C", mode = "", action = "cancel_call" },
				},

				-- candies (icons and highlights)
				disable_candies = false,
				candies = {
					-- all of these represent call states
					unknown = {
						icon = "", -- this or first letters of state
						icon_highlight = "NonText", -- highlight of the state
						text_highlight = "", -- highlight of the rest of the line
					},
					executing = {
						icon = "󰑐",
						icon_highlight = "Constant",
						text_highlight = "Constant",
					},
					executing_failed = {
						icon = "󰑐",
						icon_highlight = "Error",
						text_highlight = "",
					},
					retrieving = {
						icon = "",
						icon_highlight = "String",
						text_highlight = "String",
					},
					retrieving_failed = {
						icon = "",
						icon_highlight = "Error",
						text_highlight = "",
					},
					archived = {
						icon = "",
						icon_highlight = "Title",
						text_highlight = "",
					},
					archive_failed = {
						icon = "",
						icon_highlight = "Error",
						text_highlight = "",
					},
					canceled = {
						icon = "",
						icon_highlight = "Error",
						text_highlight = "",
					},
				},
			},

			-- window layout
			window_layout = require("dbee.layouts").Default:new(),
		}
		dbee.setup(opts)
	end,
}

-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"

-- config.font = wezterm.font("JetBrains Mono")
config.font_size = 15

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = "One Half Black (Gogh)"
config.colors = {
	background = "#1f2329", -- nvim の背景と一緒

	-- https://github.com/Gogh-Co/Gogh/blob/master/themes/One%20Half%20Black.yml
	ansi = {
		"#282C34", -- Black (Host)
		"#E06C75", -- Red (Syntax string)
		"#98C379", -- Green (Command)
		"#E5C07B", -- Yellow (Command second)
		"#61AFEF", -- Blue (Path)
		"#C678DD", -- Magenta (Syntax var)
		"#56B6C2", -- Cyan (Prompt)
		"#DCDFE4", -- White
	},

	brights = {
		"#BDBCBD", -- Bright Black
		"#E06C75", -- Bright Red (Command error)
		"#98C379", -- Bright Green (Exec)
		"#E5C07B", -- Bright Yellow
		"#61AFEF", -- Bright Blue (Folder)
		"#C678DD", -- Bright Magenta
		"#56B6C2", -- Bright Cyan
		"#DCDFE4", -- Bright White
	},
}

-- Optoion/Alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- image
-- config.enable_kitty_graphics = true

-- and finally, return the configuration to wezterm
return config

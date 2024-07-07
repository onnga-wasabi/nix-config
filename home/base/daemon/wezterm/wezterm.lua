-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.window_decorations = "RESIZE"

config.font = wezterm.font("JetBrains Mono")
config.font_size = 16

-- For example, changing the color scheme:
-- config.color_scheme = 'AdventureTime'
config.color_scheme = "One Half Black (Gogh)"
config.colors = {
	background = "#1f2329", -- nvim の背景と一緒
}

-- Optoion/Alt
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false

-- image
config.enable_kitty_graphics = true

-- and finally, return the configuration to wezterm
return config

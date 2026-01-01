-- Pull in the wezterm API
local wezterm = require("wezterm")

-- ウィンドウフォーカス時に IME を英数に切り替える
wezterm.on("window-focus-changed", function(window, pane)
	-- window:is_focused() を使用して、フォーカスを得た時のみ実行する
	if window:is_focused() then
		-- Nix 経由で im-select を入れている場合、パスが通っていればこれで動作します
		local _success, _stdout, _stderr = wezterm.run_child_process({ "im-select", "com.apple.keylayout.ABC" })
	end
end)

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

-- ime
--
-- config.use_ime = true
config.use_ime = true -- 結局打ちにくいので raycast で打ってコピペがいいよ
-- terminal でめっちゃ日本語打つとき
-- config.macos_forward_to_ime_modifier_mask = "CTRL"
-- config.keys = {
-- 	{ key = "q", mods = "CTRL", action = wezterm.action({ SendString = "\x11" }) },
-- }
--
config.front_end = "WebGpu"
config.enable_wayland = false

-- and finally, return the configuration to wezterm
return config

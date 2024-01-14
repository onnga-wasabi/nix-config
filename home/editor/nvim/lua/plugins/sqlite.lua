return { -- nix home-manager でも管理
	-- https://github.com/kkharji/sqlite.lua
	"kkharji/sqlite.lua",
	config = function()
		-- なんかだめっぴいな
		vim.g.sqlite_clib_path = vim.fn.system("fd libsqlite3.0.dylib /nix/store | tail -n 1")
	end,
}

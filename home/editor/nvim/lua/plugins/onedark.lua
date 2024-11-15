return {
	-- https://github.com/joshdick/onedark.vim
	"navarasu/onedark.nvim",
	config = function()
		require("onedark").setup({
			style = "darker",
		})
		require("onedark").load()
	end,
}

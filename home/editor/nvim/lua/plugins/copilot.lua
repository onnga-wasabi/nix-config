return {
	-- https://github.com/github/copilot.vim
	"github/copilot.vim",
	config = function()
		vim.g.copilot_filetypes = {
			markdown = false,
		}
	end,
}

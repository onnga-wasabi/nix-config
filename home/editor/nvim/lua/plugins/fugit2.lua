return {
	-- https://github.com/SuperBo/fugit2.nvim
	"SuperBo/fugit2.nvim",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-tree/nvim-web-devicons",
		"nvim-lua/plenary.nvim",
		{
			"chrisgrieser/nvim-tinygit", -- optional: for Github PR view
			dependencies = { "stevearc/dressing.nvim" },
		},
	},
	cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
	opts = {
		width = 70,
		libgit2_path = os.getenv("LIBGIT2"),
	},
}

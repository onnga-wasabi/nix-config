return {
	-- https://github.com/MeanderingProgrammer/markdown.nvim
	"MeanderingProgrammer/markdown.nvim",
	name = "render-markdown", -- Only needed if you have another plugin named markdown.nvim
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	opts = {
		-- Capture groups that get pulled from markdown, these are later used to
		-- modify how the file gets rendered
		markdown_query = [[
        (atx_heading [
            (atx_h1_marker)
            (atx_h2_marker)
            (atx_h3_marker)
            (atx_h4_marker)
            (atx_h5_marker)
            (atx_h6_marker)
        ] @heading)

        (fenced_code_block) @code

        (list_marker_plus) @list_marker
        (list_marker_minus) @list_marker
        (list_marker_star) @list_marker

        (pipe_table_header) @table_head
        (pipe_table_delimiter_row) @table_delim
        (pipe_table_row) @table_row
    ]],
		-- Filetypes this plugin will run on
		file_types = { "markdown" },
		-- vim modes that will show a rendered view of the markdown file, all other
		-- modes will be uneffected by this plugin
		render_modes = { "n", "c" },
		-- Characters that will replace the # at the start of markdown headings
		headings = { "󰲡", "󰲣", "󰲥", "󰲧", "󰲩", "󰲫" },
		-- Character to use for the bullet point in lists
		bullet = "○",
		highlights = {
			heading = {
				-- Used for rendering heading line backgrounds
				backgrounds = { "DiffAdd", "DiffChange", "DiffDelete" },
				-- Used for rendering the foreground of the heading character only
				foregrounds = {
					"markdownH1",
					"markdownH2",
					"markdownH3",
					"markdownH4",
					"markdownH5",
					"markdownH6",
				},
			},
			-- Used when displaying code blocks
			code = "ColorColumn",
			-- Used when displaying bullet points in list
			bullet = "Normal",
			table = {
				-- Used when displaying header in a markdown table
				head = "@markup.heading",
				-- Used when displaying non header rows in a markdown table
				row = "Normal",
			},
			latex = "Special",
		},
	},
}

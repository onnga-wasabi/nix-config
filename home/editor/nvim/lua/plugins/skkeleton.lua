return {
	{
		-- https://github.com/vim-skk/skkeleton
		"vim-skk/skkeleton",
		dependencies = {
			"vim-denops/denops.vim",
		},
		config = function()
			-- XDG_DATA_HOME os を環境変数から読みこむ
			data_dir = os.getenv("XDG_DATA_HOME")
			vim.fn["skkeleton#config"]({
				eggLikeNewline = true,
				globalDictionaries = {
					data_dir .. "/skk/SKK-JISYO.assoc",
					data_dir .. "/skk/SKK-JISYO.edict",
					data_dir .. "/skk/SKK-JISYO.fullname",
					data_dir .. "/skk/SKK-JISYO.geo",
					data_dir .. "/skk/SKK-JISYO.itaiji",
					data_dir .. "/skk/SKK-JISYO.itaiji.JIS3_4",
					data_dir .. "/skk/SKK-JISYO.jinmei",
					data_dir .. "/skk/SKK-JISYO.JIS2",
					data_dir .. "/skk/SKK-JISYO.JIS3_4",
					data_dir .. "/skk/SKK-JISYO.JIS2004",
					data_dir .. "/skk/SKK-JISYO.L",
					data_dir .. "/skk/SKK-JISYO.law",
					data_dir .. "/skk/SKK-JISYO.mazegaki",
					data_dir .. "/skk/SKK-JISYO.office.zipcode",
					data_dir .. "/skk/SKK-JISYO.propernoun",
					data_dir .. "/skk/SKK-JISYO.station",
					data_dir .. "/skk/SKK-JISYO.zipcode",
				},
				sources = {
					"skk_dictionary",
					-- "deno_kv",
					-- "google_japanese_input",
				},
			})
			vim.fn["skkeleton#register_keymap"]("input", ";", "henkanPoint")
			vim.fn["skkeleton#register_keymap"]("input", "l", "")
		end,
		keys = {
			{ "<C-j>", "<Plug>(skkeleton-enable)", mode = "i" },
			{ "<C-l>", "<Plug>(skkeleton-disable)", mode = "i" },
		},
	},
	{
		-- https://github.com/delphinus/skkeleton_indicator.nvim
		"delphinus/skkeleton_indicator.nvim",
		opts = {},
	},
	{
		-- 日本語の入力をしつつ
		-- https://github.com/yasunori0418/statusline_skk.vim
		"yasunori0418/statusline_skk.vim",
		init = function()
			vim.cmd([[
                let g:lightline_skk_announce = v:true
            ]])
		end,
		config = function() end,
	},
}

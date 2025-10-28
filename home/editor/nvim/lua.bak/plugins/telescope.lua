return {
  -- https://github.com/nvim-telescope/telescope.nvim
  "nvim-telescope/telescope.nvim",
  event = "BufEnter",
  dependencies = {
    "nvim-telescope/telescope-frecency.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-lua/plenary.nvim",
    "stevearc/aerial.nvim",
    "gbprod/yanky.nvim",
    "AckslD/nvim-neoclip.lua",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-dap.nvim",
  },
  opts = {
    defaults = {
      layout_strategy = "vertical",
      layout_config = {
        bottom_pane = {
          height = 25,
          preview_cutoff = 120,
          prompt_position = "top",
        },
        center = {
          height = 0.99,
          preview_cutoff = 40,
          prompt_position = "top",
          width = 0.9,
        },
        cursor = {
          height = 0.9,
          preview_cutoff = 40,
          width = 0.8,
        },
        horizontal = {
          height = 0.9,
          preview_cutoff = 120,
          prompt_position = "bottom",
          width = 0.8,
        },
        vertical = {
          height = 0.95, -- function(_, _, max_lines) return max_lines end,
          preview_height = 0.7,
          preview_cutoff = 0,
          prompt_position = "bottom",
          mirror = true,
          width = 0.9,
        },
      },
      initial_mode = "insert",
      file_ignore_patterns = {
        "node_modules/",
        "submodules/",
        "bundle/",
        "tmux-powerline/",
        "%.git/",
        "%.tmp/*",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.zip",
        "%.tar",
        "%.tar.gz",
        ".tmp/",
        "%.gradle/",
        "%.metals/",
        "%.class",
        "%.jar",
        "%.csv",
        "%mocks/",
        "_mock.go",
        "%.pb.go",
        "%.pyi",
        "%__pycache__/*",
        "%.xlsx",
        "%.ipynb",
        "%target/",
      },
      winblend = 5,
    },
    extensions = {
      aerial = {
        -- Display symbols as <root>.<parent>.<symbol>
        show_nesting = {
          ["_"] = false, -- This key will be the default
          json = true, -- You can set the option for specific filetypes
          yaml = true,
        },
      },
      fzf = {
        fuzzy = true, -- false will only do exact matching
        override_generic_sorter = true, -- override the generic sorter
        override_file_sorter = true, -- override the file sorter
        case_mode = "smart_case", -- or "ignore_case" or "respect_case" the default case_mode is "smart_case"
      },
    },
  },
  config = function(_, opts)
    local telescope = require("telescope")

    -- telescope.load_extension("frecency")
    telescope.load_extension("file_browser")
    telescope.load_extension("aerial")
    telescope.load_extension("neoclip")

    telescope.setup(opts)
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    telescope.load_extension("fzf")
  end,
}

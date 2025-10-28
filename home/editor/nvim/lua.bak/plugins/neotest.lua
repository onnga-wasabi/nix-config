return {
  {
    -- https://github.com/nvim-neotest/neotest
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-treesitter/nvim-treesitter",

      -- language specific with configuration
      {
        -- https://github.com/nvim-neotest/neotest-plenary
        "nvim-neotest/neotest-plenary",
      },
      {
        -- https://github.com/nvim-neotest/neotest-jest
        "nvim-neotest/neotest-jest",
      },
      {
        -- https://github.com/nvim-neotest/neotest-python
        "nvim-neotest/neotest-python",
      },
      {
        -- https://github.com/fredrikaverpil/neotest-golang
        "fredrikaverpil/neotest-golang",
      },
      {
        -- https://github.com/rcasia/neotest-java
        "rcasia/neotest-java",
      },
      {
        -- https://github.com/stevanmilic/neotest-scala
        "stevanmilic/neotest-scala",
      },

      -- DAP
      {
        -- https://github.com/mfussenegger/nvim-dap
        "mfussenegger/nvim-dap",
        dependencies = {
          -- {
          -- 	"microsoft/vscode-js-debug",
          -- 	lazy = true,
          -- 	build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
          -- },
          -- {
          -- 	"mxsdev/nvim-dap-vscode-js",
          -- 	opts = {
          -- 		-- vscde-js-debug に依存
          -- 		debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
          -- 		adapters = {
          -- 			"pwa-node",
          -- 			"pwa-chrome",
          -- 			"pwa-msedge",
          -- 			"node-terminal",
          -- 			"pwa-extensionHost",
          -- 		},
          -- 	},
          -- },
        },
        config = function()
          local dap = require("dap")

          dap.configurations["typescriptreact"] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Debug Jest Tests",
              -- trace = true, -- include debugger info
              runtimeExecutable = "node",
              runtimeArgs = {
                "./node_modules/jest/bin/jest.js",
                "--runInBand",
                "--testTimeout=15000",
                "--forceExit",
              },
              rootPath = "${workspaceFolder}",
              cwd = "${workspaceFolder}",
              console = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
              resolveSourceMapLocations = {
                "${workspaceFolder}/**",
                "!**/node_modules/**",
              },
            },
          }
        end,
      },
    },
    config = function()
      local opt
      local neotest = require("neotest")
      local config = {
        adapters = {
          require("neotest-jest"),
          require("neotest-python")({
            dap = { justMyCode = false },
          }),
          require("neotest-golang")({
            go_test_args = {
              "-v",
              "-race",
              "-p",
              "16",
              "-coverprofile=" .. vim.fn.getcwd() .. "/coverage.out",
            },
          }),
          require("neotest-plenary"),
          require("neotest-scala")({ -- https://github.com/stevanmilic/neotest-scala?tab=readme-ov-file#configuration
            -- Command line arguments for runner
            -- Can also be a function to return dynamic values
            args = { "test" },
            -- Runner to use. Will use bloop by default.
            -- Can be a function to return dynamic value.
            -- For backwards compatibility, it also tries to read the vim-test scala config.
            -- Possibly values bloop|sbt.
            runner = "sbt",
            -- Test framework to use. Will use utest by default.
            -- Can be a function to return dynamic value.
            -- Possibly values utest|munit|scalatest.
            framework = "scalatest",
          }),
        },
        -- default configuration below
        benchmark = {
          enabled = true,
        },
        consumers = {},
        default_strategy = "integrated",
        diagnostic = {
          enabled = true,
          severity = 1,
        },
        discovery = {
          concurrent = 0,
          enabled = true,
        },
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
          options = {},
        },
        highlights = {
          adapter_name = "NeotestAdapterName",
          border = "NeotestBorder",
          dir = "NeotestDir",
          expand_marker = "NeotestExpandMarker",
          failed = "NeotestFailed",
          file = "NeotestFile",
          focused = "NeotestFocused",
          indent = "NeotestIndent",
          marked = "NeotestMarked",
          namespace = "NeotestNamespace",
          passed = "NeotestPassed",
          running = "NeotestRunning",
          select_win = "NeotestWinSelect",
          skipped = "NeotestSkipped",
          target = "NeotestTarget",
          test = "NeotestTest",
          unknown = "NeotestUnknown",
          watching = "NeotestWatching",
        },
        icons = {
          child_indent = "│",
          child_prefix = "├",
          collapsed = "─",
          expanded = "╮",
          failed = "",
          final_child_indent = " ",
          final_child_prefix = "╰",
          non_collapsible = "─",
          notify = "",
          passed = "",
          running = "",
          running_animated = { "/", "|", "\\", "-", "/", "|", "\\", "-" },
          skipped = "",
          unknown = "",
          watching = "",
        },
        jump = {
          enabled = true,
        },
        log_level = vim.log.levels.TRACE,
        output = {
          enabled = true,
          open_on_run = true,
        },
        output_panel = {
          enabled = true,
          open = "botright split | resize 15",
        },
        projects = {},
        quickfix = {
          enabled = true,
          open = false,
        },
        run = {
          enabled = true,
        },
        running = {
          concurrent = true,
        },
        state = {
          enabled = true,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = false,
        },
        strategies = {
          integrated = {
            height = 40,
            width = 120,
          },
        },
        summary = {
          animated = true,
          enabled = true,
          expand_errors = true,
          follow = true,
          mappings = {
            attach = "a",
            clear_marked = "M",
            clear_target = "T",
            debug = "d",
            debug_marked = "D",
            expand = { "<CR>", "<2-LeftMouse>" },
            expand_all = "e",
            help = "?",
            jumpto = "i",
            mark = "m",
            next_failed = "J",
            output = "o",
            prev_failed = "K",
            run = "r",
            run_marked = "R",
            short = "O",
            stop = "u",
            target = "t",
            watch = "w",
          },
          open = "botright vsplit | vertical resize 50",
        },
      }
      neotest.setup(config)
    end,
    keys = {
      --{
      --	"<leader>dr",
      --	function()
      --		require("dap").run_last()
      --	end,
      --},
      --{
      --	"<leader>dc",
      --	function()
      --		require("dap").continue()
      --	end,
      --},
      --{
      --	"<leader>db",
      --	function()
      --		require("dap").toggle_breakpoint()
      --	end,
      --},
      -- {
      -- 	"<leader>ds",
      -- 	function()
      -- 		require("neotest").run.run({ strategy = "dap" })
      -- 	end,
      -- },
      { -- current scope
        "<leader><leader>",
        function()
          require("neotest").run.run()
        end,
      },
      { -- current file
        "<leader>tf",
        function()
          require("neotest").run.run(vim.fn.expand("%"))
        end,
      },
      {
        "<leader>to",
        function()
          require("neotest").output.open({ enter = true })
        end,
      },
      {
        "<leader>ts",
        function()
          require("neotest").summary.toggle()
        end,
      },
    },
  },
  {
    -- https://github.com/andythigpen/nvim-coverage
    "andythigpen/nvim-coverage",
    opts = {
      commands = true, -- create commands
      highlights = {
        -- customize highlight groups created by the plugin
        covered = { fg = "#C3E88D" }, -- supports style, fg, bg, sp (see :h highlight-gui)
        uncovered = { fg = "#F07178" },
      },
      signs = {
        -- use your own highlight groups or text markers
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        -- customize the summary pop-up
        -- min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
      },
      lang = {
        -- customize language specific settings
      },
    },
  },
}

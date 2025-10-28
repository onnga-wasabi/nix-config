return {
  -- https://github.com/CopilotC-Nvim/CopilotChat.nvim
  "CopilotC-Nvim/CopilotChat.nvim",
  branch = "canary",
  requires = {
    { "github/copilot.vim" },
    { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
  },
  keys = {
    { "<m-c>", "<cmd>CopilotChatToggle<cr>" },
  },
  config = function()
    local opts = {
      debug = true, -- Enable debug logging

      -- default selection (visual or line)
      selection = function(source)
        local select = require("CopilotChat.select")
        return select.visual(source) or select.line(source)
      end,

      -- default prompts
      prompts = {
        Explain = {
          prompt = "/COPILOT_EXPLAIN 選択部分をステップバイステップで説明してください。",
          selection = selection,
        },
        Review = {
          prompt = "/COPILOT_REVIEW Review the selected code.",
          selection = selection,
          callback = function(response, source)
            local ns = vim.api.nvim_create_namespace("copilot_review")
            local diagnostics = {}
            for line in response:gmatch("[^\r\n]+") do
              if line:find("^line=") then
                local start_line = nil
                local end_line = nil
                local message = nil
                local single_match, message_match = line:match("^line=(%d+): (.*)$")
                if not single_match then
                  local start_match, end_match, m_message_match = line:match("^line=(%d+)-(%d+): (.*)$")
                  if start_match and end_match then
                    start_line = tonumber(start_match)
                    end_line = tonumber(end_match)
                    message = m_message_match
                  end
                else
                  start_line = tonumber(single_match)
                  end_line = start_line
                  message = message_match
                end

                if start_line and end_line then
                  table.insert(diagnostics, {
                    lnum = start_line - 1,
                    end_lnum = end_line - 1,
                    col = 0,
                    message = message,
                    severity = vim.diagnostic.severity.WARN,
                    source = "Copilot Review",
                  })
                end
              end
            end
            vim.diagnostic.set(ns, source.bufnr, diagnostics)
          end,
        },
        Fix = {
          prompt = "/COPILOT_GENERATE There is a problem in this code. Rewrite the code to show it with the bug fixed.",
          selection = selection,
        },
        Optimize = {
          prompt = "/COPILOT_GENERATE Optimize the selected code to improve performance and readablilty.",
          selection = selection,
        },
        Docs = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection.",
          selection = selection,
        },
        DocsJa = {
          prompt = "/COPILOT_GENERATE Please add documentation comment for the selection. In Japanese.",
          selection = selection,
        },
        Tests = {
          prompt = "/COPILOT_GENERATE テストコードを作成してください。",
          selection = selection,
        },
        Translate = {
          prompt = "/COPILOT_GENERATE Translate the active selection to Engish.",
          description = "Translate the active selection to Engish.",
          selection = selection,
        },
        TranslateJa = {
          prompt = "/COPILOT_GENERATE 選択部分を日本語訳してください。",
          description = "Translate the active selection to Japanese.",
          selection = selection,
        },
      },

      -- default window options
      window = {
        layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
        width = 0.8, -- fractional width of parent, or absolute width in columns when > 1
        height = 0.8, -- fractional height of parent, or absolute height in rows when > 1
        -- Options below only apply to floating windows
        relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
        border = "rounded", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
        row = nil, -- row position of the window, default is centered
        col = nil, -- column position of the window, default is centered
        title = "Copilot Chat", -- title of chat window
        footer = nil, -- footer of chat window
        zindex = 1, -- determines if window is on top or below other floating windows
      },

      -- default mappings
      mappings = {
        complete = {
          detail = "Use @<Tab> or /<Tab> for options.",
          insert = "<Tab>",
        },
        close = {
          normal = "q",
          insert = "<C-c>",
        },
        reset = {
          normal = "",
          insert = "",
        },
        submit_prompt = {
          normal = "<CR>",
          insert = "<C-m>",
        },
        accept_diff = {
          normal = "<C-y>",
          insert = "<C-y>",
        },
        yank_diff = {
          normal = "gy",
        },
        show_diff = {
          normal = "gd",
        },
        show_system_prompt = {
          normal = "gp",
        },
        show_user_selection = {
          normal = "gs",
        },
      },
    }
    require("CopilotChat").setup(opts)

    local function copilot_chat_buffer()
      local input = vim.fn.input("Copilot Chat Buffer: ")
      if input ~= "" then
        require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
      end
    end

    vim.api.nvim_create_user_command("CopilotChatBuffer", function()
      copilot_chat_buffer()
    end, {})
  end,
}

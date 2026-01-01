return { -- https://www.lazyvim.org/plugins/formatting
  {
    "stevearc/conform.nvim",
    opts = {
      default_format_opts = {
        timeout_ms = 3000,
        async = false, -- not recommended to change
        quiet = false, -- not recommended to change
        lsp_format = "fallback", -- not recommended to change
      },
      formatters_by_ft = {
        json = { "fixjson" },
        sql = { "sqlfluff" },
        pgsql = { "sqlfluff" },
        python = { "ruff format" },
      },
    },
  },
}

-- flake のパス（~/nix-config を絶対パスに展開）
local flake = vim.fn.expand("~/nix-config")

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Bash/Shell（LazyVim に専用 lang extra が無いのでここで明示）
        bashls = {},
        nixd = {
          -- LSP本体は nix(home.packages) で入れているので Mason には任せない
          mason = false,
          settings = {
            nixd = {
              -- 補完で参照する nixpkgs（このflakeが使っている nixpkgs を評価）
              nixpkgs = {
                expr = ('import (builtins.getFlake "%s").inputs.nixpkgs { }'):format(flake),
              },
              options = {
                -- nix-darwin の option（system.*, services.* など）
                ["nix-darwin"] = {
                  expr = ('(builtins.getFlake "%s").darwinConfigurations.Darwin.options'):format(flake),
                },
                -- home-manager の option（home.*, programs.* など）
                home_manager = {
                  expr = ('(builtins.getFlake "%s").darwinConfigurations.Darwin.options.home-manager.users.type.getSubOptions []'):format(
                    flake
                  ),
                },
              },
              -- 既存の Taskfile と揃えて nixpkgs-fmt で整形
              formatting = {
                command = { "nixpkgs-fmt" },
              },
            },
          },
        },
      },
    },
  },
}

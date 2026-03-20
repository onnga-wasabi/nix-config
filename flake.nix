{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-tap = {
      url = "github:onnga-wasabi/homebrew-tap";
      flake = false;
    };

    ghx = {
      url = "github:onnga-wasabi/ghx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ self
    , nix-darwin
    , nixpkgs
    , home-manager
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
    , homebrew-tap
    , ghx
    , ...
    }:
    let
      configuration = { pkgs, ... }: {

        nix.enable = false;
        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh.enable = true;

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
        nixpkgs.overlays = [
          ghx.overlays.default
        ];
        nixpkgs.config = {
          allowUnfree = true;
          max-jobs = 4;
          binary-caches-parallel-connections = 4;
        };

        users.users.wasabi = {
          name = "wasabi";
          home = "/Users/wasabi";
          shell = pkgs.zsh;
        };

        # 必須設定
        system.primaryUser = "wasabi";
      };
    in
    let
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.wasabi = import ./home;
        }
        nix-homebrew.darwinModules.nix-homebrew

        {
          nix-homebrew = {
            enable = true;
            enableRosetta = false;
            user = "wasabi";
            # 既存の Homebrew（/opt/homebrew 等）が root 所有になっていると
            # home-manager 経由の `brew` 実行で `permission denied` になりがちです。
            # 既存インストールを正しい所有者へ自動移行します。
            autoMigrate = true;

            # Taps をここで宣言的に紐付けます
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "onnga-wasabi/homebrew-tap" = homebrew-tap;
            };

            # 手動追加は不可にして、Nix 宣言だけで taps を管理します。
            mutableTaps = false;
          };
        }
      ];
    in
    {
      darwinConfigurations = {
        Darwin = nix-darwin.lib.darwinSystem {
          modules = modules;
        };
      };
    };
}

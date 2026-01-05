{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # AeroSpace の Tap をソースとして定義
    # aerospace-tap = {
    #   url = "github:nikitabobko/homebrew-tap";
    #   flake = false;
    # };

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
  };

  outputs =
    inputs@{ self
    , nix-darwin
    , nixpkgs
    , home-manager
    , nix-homebrew
    , homebrew-core
    , homebrew-cask
      # , aerospace-tap # 引数に追加
    , ...
    }:
    let
      configuration = { pkgs, ... }: {

        # homebrew = {
        #   enable = true;
        #   taps = [
        #     "nikitabobko/tap"
        #   ];
        #   casks = [
        #     "aerospace"
        #   ];
        #   # 自動クリーンアップ有効
        #   onActivation.cleanup = "zap";
        # };

        nix.enable = false;
        nix.settings.experimental-features = "nix-command flakes";

        programs.zsh.enable = true;

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
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

            # Taps をここで宣言的に紐付けます
            taps = {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              # "nikitabobko/homebrew-tap" = aerospace-tap;
            };

            # 手動変更を禁止し、Nixが生成するリンクのみを使わせます
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

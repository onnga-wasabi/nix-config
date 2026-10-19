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
    , ghx
    , ...
    }:
    let
      configuration = { pkgs, ... }: {

        # nix 本体（daemon・/etc/nix/nix.conf）は nix-darwin では管理しない。
        # この状態では nix.settings は nix.conf に書き出されず黙って無視されるため、
        # experimental-features などは home-manager 側（home/nix.nix）で
        # ~/.config/nix/nix.conf に書く。
        nix.enable = false;

        programs.zsh.enable = true;
        # /etc/zshrc が `compinit`（-i なし）を実行すると、nix profile が
        # 別 uid 所有のため compinit の insecure directories プロンプトが出る。
        # グローバル compinit を無効化し、home-manager 側の
        # completionInit（compinit -i）に一本化する。
        programs.zsh.enableGlobalCompInit = false;

        system.configurationRevision = self.rev or self.dirtyRev or null;
        system.stateVersion = 5;
        nixpkgs.hostPlatform = "aarch64-darwin";
        nixpkgs.overlays = [
          ghx.overlays.default
        ];
        nixpkgs.config = {
          allowUnfree = true;
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
          # home.file が既存の実ファイル（例: ~/.claude/settings.json）を
          # 置き換える際、衝突でエラーにせず .hm-bak として退避する。
          home-manager.backupFileExtension = "hm-bak";
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
            };

            # 手動追加は不可にして、Nix 宣言だけで taps を管理します。
            mutableTaps = false;
          };
        }

        ({ config, ... }: {
          # brews/casks のパッケージ自体は nix-darwin 標準の homebrew モジュールで
          # 宣言管理する。nixpkgs にあるものは home.packages を優先し、ここには
          # nixpkgs で扱いにくい GUI アプリ（cask）等のみを置く方針。
          homebrew = {
            enable = true;
            onActivation = {
              # 宣言外の brew パッケージは apply 時に掃除する（完全宣言運用）。
              cleanup = "zap";
              autoUpdate = false;
              upgrade = false;
            };
            # cleanup="zap" は Brewfile に無い tap も untap しようとする。
            # tap は nix-homebrew 側で宣言しているので、その一覧を Brewfile へ
            # 引き継いで untap 対象から除外する（宣言元は nix-homebrew.taps 一箇所）。
            taps = builtins.attrNames config.nix-homebrew.taps;
            brews = [ ];
            casks = [
              "alt-tab"
              "bitwarden"
              "google-chrome"
              "monitorcontrol"
              "notion"
              "raycast"
              "slack"
              "zoom"
              "meetingbar"
            ];
            masApps = { };
          };
        })
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

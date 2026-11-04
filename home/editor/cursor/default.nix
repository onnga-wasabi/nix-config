{ pkgs
, lib
, ...
}:
let
  # Claude Code と同じ全体の指示とリポジトリの記憶を、Cursor のセッション開始時に文脈へ入れる。
  # 並列作業の担当の印・プロセスと漏れの検査は、Cursor が ~/.claude/settings.json のフックを
  # 読み込んで走らせるので、ここには置かない（二重に走る）。
  sessionContextHook = pkgs.writeShellApplication {
    name = "cursor-session-context-hook";
    runtimeInputs = with pkgs; [
      coreutils
      git
      gnused
      jq
    ];
    text = builtins.readFile ./session-context-hook.sh;
  };
  hooks = {
    version = 1;
    hooks = {
      sessionStart = [
        {
          command = "${sessionContextHook}/bin/cursor-session-context-hook";
          timeout = 10;
        }
      ];
    };
  };
  # npx で取る MCP サーバを、node を PATH に入れて起動するスクリプトにする。
  # Cursor を Finder から起動すると PATH に home-manager の profile が入らず、
  # npx を store path で直に指しても、パッケージの bin（`#!/usr/bin/env node`）が node を解決できない。
  # @latest だと apply と無関係に実体が変わるので、版は呼び出し側で固定する。
  # Cursor CLI は mcp.json の ${workspaceFolder} を展開しない場合があるので、そのまま来たら外して作業ディレクトリに任せる。
  npxServer = name: package: pkgs.writeShellScript name ''
    export PATH=${pkgs.nodejs_22}/bin:$PATH
    args=()
    for arg in "$@"; do
      [ "$arg" = "\''${workspaceFolder}" ] || args+=("$arg")
    done
    exec npx -y ${package} "''${args[@]}"
  '';
  # Cursor のグローバル MCP 設定。
  # 注意: このファイルは nix store への read-only symlink になるため、
  #   Cursor の Settings > MCP 画面からの追加・削除・トグルは書き込みに失敗する。
  #   サーバの増減はここを編集して `task apply` する。
  mcpServers = {
    # chrome-devtools-mcp は nixpkgs に無いので npx 経由で取得する。
    chrome-devtools = {
      command = "${npxServer "chrome-devtools-mcp" "chrome-devtools-mcp@1.7.0"}";
      # 普段使いのプロファイルを開かせない（使い捨ての user-data-dir で起動する）。
      args = [ "--isolated" ];
    };
    # Claude Code はリポジトリの .mcp.json から読むが、Cursor はプラグインの .mcp.json しか読まない。
    # Nx でないワークスペースでは道具が空になるだけなので、全体に置く。
    nx-mcp = {
      command = "${npxServer "nx-mcp" "nx-mcp@0.25.0"}";
      args = [ "\${workspaceFolder}" ];
    };
  };
in
{
  home.file.".cursor/mcp.json".text = builtins.toJSON { inherit mcpServers; };
  home.file.".cursor/hooks.json".text = builtins.toJSON hooks;

  # Claude Code の attribution（commit・pr を空）に合わせ、Cursor CLI もコミットと PR に印を付けない。
  # cli-config.json はログイン状態やモデル選択も書き込まれるので、symlink にせずこのキーだけ書き足す。
  # ログイン前でファイルが無いときは何もしない（ログイン後にもう一度 apply する）。
  home.activation.cursorCliAttribution = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    config="$HOME/.cursor/cli-config.json"
    if [ -f "$config" ]; then
      merged="$(mktemp)"
      ${pkgs.jq}/bin/jq '.attribution = {attributeCommitsToAgent: false, attributePRsToAgent: false}' "$config" > "$merged"
      run mv "$merged" "$config"
    fi
  '';
}

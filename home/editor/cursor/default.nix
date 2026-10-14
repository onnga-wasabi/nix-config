{ pkgs
, ...
}:
let
  # Cursor のグローバル MCP 設定。
  # 注意: このファイルは nix store への read-only symlink になるため、
  #   Cursor の Settings > MCP 画面からの追加・削除・トグルは書き込みに失敗する。
  #   サーバの増減はここを編集して `task apply` する。
  mcpServers = {
    # chrome-devtools-mcp は nixpkgs に無いので npx 経由で取得する。
    # Cursor を Finder から起動すると PATH に home-manager の profile が
    # 入らず `npx` を解決できないため、store path で直に指す。
    chrome-devtools = {
      command = "${pkgs.nodejs_22}/bin/npx";
      args = [
        "-y"
        # @latest だと apply と無関係に実体が変わるので版を固定する。
        "chrome-devtools-mcp@1.7.0"
        # 普段使いのプロファイルを開かせない（使い捨ての user-data-dir で起動する）。
        "--isolated"
      ];
    };
  };
in
{
  home.file.".cursor/mcp.json".text = builtins.toJSON { inherit mcpServers; };
}

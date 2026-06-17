{ ...
}:
let
  # Claude Code のグローバル設定。
  # バイナリは A 案(ネイティブ版 ~/.local/bin/claude・自動更新)を維持し、
  # ここでは「設定」だけを宣言的に管理する。
  # 注意: このファイルは nix store への read-only symlink になるため、
  #   Claude Code の /config や「always allow(user スコープ)」での書き込みは効かない。
  #   権限はここ(グローバル)では管理せず、プロジェクト単位の
  #   .claude/settings.local.json（nix 管理外・書き込み可能）に任せる方針。
  #   破壊的な本番操作の自動承認は特定リポジトリのローカル設定にのみ置く。
  settings = {
    attribution = {
      commit = "";
      pr = "";
    };
    theme = "auto";
    skipWorkflowUsageWarning = true;
    statusLine = {
      type = "command";
      command = "sh /Users/wasabi/.claude/statusline-command.sh";
    };
  };
in
{
  home.file.".claude/settings.json".text = builtins.toJSON settings;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/statusline-command.sh".source = ./statusline-command.sh;
}

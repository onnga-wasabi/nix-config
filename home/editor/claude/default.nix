{ pkgs
, ...
}:
let
  # 並列セッションの担当の印（PR 本文 1 行目の「担当:」）を、セッション開始時と push 後に確かめる。
  claimsHook = pkgs.writeShellApplication {
    name = "claude-claims-hook";
    runtimeInputs = with pkgs; [
      coreutils
      gawk
      gh
      git
      gnugrep
      gnused
      jq
    ];
    text = builtins.readFile ./claims-hook.sh;
  };
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
    model = "opus[1m]";
    editorMode = "normal";
    theme = "auto";
    # 差分パネル(/diff)はフルスクリーン表示でしか右側に出ない。
    # このファイルは read-only なので /tui では切り替えられず、ここで固定する。
    tui = "fullscreen";
    viewMode = "focus";
    spinnerTipsEnabled = false;
    skipWorkflowUsageWarning = true;
    hooks = {
      SessionStart = [
        {
          hooks = [
            {
              type = "command";
              command = "${claimsHook}/bin/claude-claims-hook session-start";
              timeout = 30;
            }
          ];
        }
      ];
      PostToolUse = [
        {
          matcher = "Bash|EnterWorktree";
          hooks = [
            {
              type = "command";
              command = "${claimsHook}/bin/claude-claims-hook post-tool";
              timeout = 15;
            }
          ];
        }
      ];
    };
    statusLine = {
      type = "command";
      command = "sh /Users/wasabi/.claude/statusline-command.sh";
    };
    # プラグインの「有効化フラグ」だけを宣言的に管理する（user スコープ）。
    # 注意: これは enable フラグにすぎず、本体は自動ダウンロードされない。
    #   本体は書き込み可能な ~/.claude/plugins/cache に別途取得が必要で、
    #   通常は `claude plugin install <name>@<marketplace> --scope user` が
    #   cache 取得と同時にこの enabledPlugins を書こうとする。だが本ファイルは
    #   read-only symlink なので install は書き込みに失敗する。
    #   運用: symlink を一時的に書き込み可能な実体へ差し替えて install で
    #   本体を cache に取得し、生成された enabledPlugins をここへ転記して
    #   `task apply` で symlink を復元する（本体キャッシュは nix 管理外で残る）。
    #   marketplace `claude-plugins-official` は既定登録済み。
    enabledPlugins = {
      "frontend-design@claude-plugins-official" = true;
      "feature-dev@claude-plugins-official" = true;
      "pr-review-toolkit@claude-plugins-official" = true;
      "commit-commands@claude-plugins-official" = true;
      "code-simplifier@claude-plugins-official" = true;
    };
  };
in
{
  home.file.".claude/settings.json".text = builtins.toJSON settings;
  home.file.".claude/CLAUDE.md".source = ./CLAUDE.md;
  home.file.".claude/statusline-command.sh".source = ./statusline-command.sh;
}

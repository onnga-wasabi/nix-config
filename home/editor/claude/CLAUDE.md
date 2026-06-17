# グローバル指示（全プロジェクト共通）

> このファイルは nix-config（`home/editor/claude/CLAUDE.md`）で管理されています。
> 変更は repo を編集して `task apply` で反映してください。

## 言語
- 回答は日本語で。コード内のコメントは周囲のスタイルに合わせる。

## この環境について
- macOS。システム・エディタ・CLIツールは **nix-darwin + home-manager の flake（`~/nix-config`）で宣言的に管理**している。
- ツールの導入を提案するときは、`brew install` や `npm -g` などの命令的インストールではなく、**flake（`home.packages` など）への追加**を優先する。
- エディタは Neovim（LazyVim）。LSP/formatter/linter は nix で供給し Mason は使っていない。

## 進め方
- 破壊的・不可逆な操作（削除・上書き・外部送信）は実行前に確認する。
- テストやビルドが失敗したらその出力とともに正直に報告する。

## git worktree
- **git worktree を積極的に使う。** 機能追加・バグ修正・リファクタ・実験など、ある程度まとまった作業を始めるときは、現在のチェックアウト（特に main など共有ブランチ）で直接作業せず、worktree を作って隔離する。
- 隔離した worktree で作業する場合は `EnterWorktree` ツールを使う（作業後は `ExitWorktree` で戻る）。
- 並行して複数の独立タスクを進めるときや、互いにファイルを書き換えてコンフリクトしそうなときは、サブエージェントを `isolation: "worktree"` で起動して作業を分離する。
- ちょっとした単発の編集・調査・読み取りだけのタスクでは無理に worktree を作らない。
- 作業が終わってマージ済み／不要になった worktree は、確認の上で片付ける。

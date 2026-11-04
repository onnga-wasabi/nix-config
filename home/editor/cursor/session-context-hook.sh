# Cursor の sessionStart フック。Claude Code と同じ全体の指示とリポジトリの記憶を文脈に入れる。
# Cursor は ~/.claude/CLAUDE.md も ~/.claude/projects/<repo>/memory も読まないため。
# 記憶は Claude Code の置き場所をそのまま使い、Cursor が書いたものも Claude Code から読める。

input="$(cat)"
root="$(jq -r '.workspace_roots[0] // empty' <<<"$input")"
root="${root:-${CURSOR_PROJECT_DIR:-}}"

ctx="# Claude Code と共有している指示と記憶

この端末では Claude Code と Cursor を併用している。全体の指示とリポジトリの記憶は Claude Code と同じものを使う。

## Claude Code の道具名の読み替え

指示や記憶に Claude Code の道具名が出てきたら、Cursor では次のように読み替える。

| Claude Code | Cursor |
| --- | --- |
| EnterWorktree / ExitWorktree | \`git worktree add\` で作業ツリーを作り、その中で作業する |
| ListAgents / SendMessage | 無い。ほかのセッションの持ち主はユーザーに聞く |
| TaskStop | 自分で起動したプロセスを、控えた PID で止める |
| Artifact | Canvas |
| Agent（サブエージェント） | Task（subagent） |"

if [ -f "$HOME/.claude/CLAUDE.md" ]; then
  ctx="$ctx

## 全体の指示（~/.claude/CLAUDE.md）

$(cat "$HOME/.claude/CLAUDE.md")"
fi

# 記憶は作業ツリーごとでなく、元のリポジトリの場所ごとに 1 つ。
common_dir="$(git -C "$root" rev-parse --path-format=absolute --git-common-dir 2>/dev/null || true)"
if [ -n "$common_dir" ]; then
  repo_root="$(dirname "$common_dir")"
  memory_dir="$HOME/.claude/projects/$(sed -E 's#[^A-Za-z0-9]#-#g' <<<"$repo_root")/memory"
  if [ -f "$memory_dir/MEMORY.md" ]; then
    ctx="$ctx

## このリポジトリの記憶（${memory_dir}）

記憶は 1 件 1 ファイルで、下は索引。作業に関係しそうな行があれば、そのファイルを読んでから従う。記憶は書かれた時点の事実なので、ファイル名・関数・フラグを勧める前に今もあるか確かめる。
覚えておくべきことを学んだら、同じ形式（frontmatter に name・description・metadata.type）で 1 ファイル書き、MEMORY.md に 1 行足す。同じ話題のファイルがあればそれを更新する。

$(cat "$memory_dir/MEMORY.md")"
  fi
fi

jq -n --arg ctx "$ctx" '{additional_context: $ctx}'

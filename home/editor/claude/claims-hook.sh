# 並列で動く Claude セッションが同じ作業を取り合わないための Claude Code フック。
# 持ち主は GitHub の PR で示す（着手したらすぐ下書き PR・本文の 1 行目に「担当: <セッション名>」）。
#
#   session-start : 開いている PR の担当と、PR を持たない worktree を文脈に出す
#   post-tool     : worktree を作った直後・push した直後に、そのブランチに PR が無ければ促す
#
# gh が使えない・GitHub の repo でないときは何も出さずに終わる（フックで作業を止めない）。

mode="${1:-}"
input="$(cat)"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
[ -n "$cwd" ] && cd "$cwd" 2>/dev/null || true

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

emit() {
  jq -n --arg event "$1" --arg ctx "$2" \
    '{hookSpecificOutput: {hookEventName: $event, additionalContext: $ctx}}'
}

open_prs() {
  timeout 10 gh pr list --state open --limit 100 \
    --json number,title,headRefName,isDraft,body 2>/dev/null
}

case "$mode" in
session-start)
  prs="$(open_prs)" || exit 0
  [ -n "$prs" ] || exit 0

  claimed="$(jq -r '.[]
    | (.body | split("\n")[0]) as $first
    | select($first | test("^担当[:：]"))
    | "- #\(.number) \($first) \(if .isDraft then "（下書き）" else "" end)\(.title)"' <<<"$prs")"
  unclaimed="$(jq -r '.[]
    | select((.body | split("\n")[0]) | test("^担当[:：]") | not)
    | "- #\(.number) \(.title)（\(.headRefName)）"' <<<"$prs")"

  pr_branches="$(jq -r '.[].headRefName' <<<"$prs")"
  merged_branches="$(timeout 10 gh pr list --state merged --limit 200 --json headRefName --jq '.[].headRefName' 2>/dev/null || true)"
  orphan_worktrees="$(git worktree list --porcelain | awk '/^branch /{sub("refs/heads/","",$2); print $2}' |
    while read -r b; do
      case "$b" in main | master) continue ;; esac
      grep -qxF "$b" <<<"$pr_branches" && continue
      if grep -qxF "$b" <<<"$merged_branches"; then
        echo "- ${b}（PR はマージ済み。worktree は確認のうえ片付けてよい）"
      else
        echo "- ${b}"
      fi
    done)"

  ctx="並列作業の決まり: 着手したらすぐ下書き PR を出し、本文の 1 行目に「担当: <ListAgents で見える自分のセッション名>」と書く。担当行のある PR は担当以外が触らない。引き継ぎメモの作業に手を付ける前は ListAgents で他セッションを見て SendMessage で持ち主を聞く。

担当のある PR:
${claimed:-（なし）}

担当行の無い PR（持ち主不明。触る前に聞く）:
${unclaimed:-（なし）}

PR の無い worktree（誰かが作業中かもしれない）:
${orphan_worktrees:-（なし）}"
  emit SessionStart "$ctx"
  ;;

post-tool)
  tool="$(jq -r '.tool_name // empty' <<<"$input")"
  if [ "$tool" = "Bash" ]; then
    jq -r '.tool_input.command // empty' <<<"$input" | grep -qE '(^|[;&|[:space:]])git( -C [^ ]+)? push' || exit 0
  elif [ "$tool" != "EnterWorktree" ]; then
    exit 0
  fi

  push_dir="$(jq -r '.tool_input.command // empty' <<<"$input" | sed -nE 's/.*git -C ([^ ]+) push.*/\1/p')"
  [ -n "$push_dir" ] && cd "$push_dir" 2>/dev/null
  branch="$(git branch --show-current 2>/dev/null)"
  case "$branch" in "" | main | master) exit 0 ;; esac

  count="$(timeout 10 gh pr list --state open --head "$branch" --json number --jq 'length' 2>/dev/null)" || exit 0
  [ "$count" = "0" ] || exit 0

  emit PostToolUse "ブランチ ${branch} にはまだ PR がありません。並列作業の決まりに従い、いま下書き PR（gh pr create --draft）を出し、本文の 1 行目に「担当: <ListAgents で見える自分のセッション名>」と書いてください。コミットがまだ無ければ git commit --allow-empty で足りる。"
  ;;
esac

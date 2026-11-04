# 並列で動く Claude セッションが同じ作業を取り合わないための Claude Code フック。
# Cursor も ~/.claude/settings.json のフックを読み込んで走らせる（入力に cursor_version が付く）。
# 持ち主は、着手時は他セッションへの連絡で、PR を出してからは本文の 1 行目「担当: <セッション名>」で示す。
# 空コミットの下書き PR は出さない（push のたびに Actions の CI が走り、課金がかさむ）。
#
#   session-start : 開いている PR の担当と、PR を持たない worktree を文脈に出す
#   post-tool     : worktree を作った直後は着手の連絡を、push した直後にそのブランチの PR が無ければ PR を促す
#
# gh が使えない・GitHub の repo でないときは何も出さずに終わる（フックで作業を止めない）。

mode="${1:-}"
input="$(cat)"
cursor="$(jq -r '.cursor_version // empty' <<<"$input")"
cwd="$(jq -r '.cwd // .workspace_roots[0] // empty' <<<"$input")"
[ -n "$cwd" ] && cd "$cwd" 2>/dev/null || true

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

# Cursor は入れ子の hookSpecificOutput を読まず、ListAgents・SendMessage も無い。
if [ -n "$cursor" ]; then
  session_id="$(jq -r '.session_id // .conversation_id // empty' <<<"$input")"
  claim_line="「担当: cursor-${session_id:0:8}」"
  announce="着手したら、何に取りかかるかをユーザーに伝える。"
  ask_owner="引き継ぎメモの作業に手を付ける前は、持ち主をユーザーに聞く。"
else
  claim_line="「担当: <ListAgents で見える自分のセッション名>」"
  announce="着手したら、ListAgents で見える他のセッション全員に SendMessage で何に取りかかるかを伝える。"
  ask_owner="引き継ぎメモの作業に手を付ける前は ListAgents で他セッションを見て SendMessage で持ち主を聞く。"
fi

emit() {
  if [ -n "$cursor" ]; then
    jq -n --arg ctx "$2" '{additional_context: $ctx}'
  else
    jq -n --arg event "$1" --arg ctx "$2" \
      '{hookSpecificOutput: {hookEventName: $event, additionalContext: $ctx}}'
  fi
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

  ctx="並列作業の決まり: ${announce}空コミットの下書き PR は出さない（push のたびに CI が走る）。PR は手元で形になってから出し、本文の 1 行目に${claim_line}と書く。担当行のある PR と、他のセッションが着手を伝えた作業は、担当以外が触らない。${ask_owner}

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
  if [ "$tool" = "Bash" ] || [ "$tool" = "Shell" ]; then
    jq -r '.tool_input.command // empty' <<<"$input" | grep -qE '(^|[;&|[:space:]])git( -C [^ ]+)? push' || exit 0
  elif [ "$tool" != "EnterWorktree" ]; then
    exit 0
  fi

  if [ "$tool" = "EnterWorktree" ]; then
    emit PostToolUse "並列作業の決まり: ${announce}PR はまだ出さない。手元で形になってから 1 回 push して出し、本文の 1 行目に${claim_line}と書く。"
    exit 0
  fi

  push_dir="$(jq -r '.tool_input.command // empty' <<<"$input" | sed -nE 's/.*git -C ([^ ]+) push.*/\1/p')"
  [ -n "$push_dir" ] && cd "$push_dir" 2>/dev/null
  branch="$(git branch --show-current 2>/dev/null)"
  case "$branch" in "" | main | master) exit 0 ;; esac

  count="$(timeout 10 gh pr list --state open --head "$branch" --json number --jq 'length' 2>/dev/null)" || exit 0
  [ "$count" = "0" ] || exit 0

  emit PostToolUse "ブランチ ${branch} にはまだ PR がありません。PR（gh pr create）を出し、本文の 1 行目に${claim_line}と書いてください。"
  ;;
esac

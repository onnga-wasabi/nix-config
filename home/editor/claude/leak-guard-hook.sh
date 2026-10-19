# Claude を使っていることが GitHub（PR・issue の本文やコメント、コミットメッセージ）に漏れないための PreToolUse フック。
# 書き込む Bash（gh の作成・編集・コメント、gh api の書き込み、git commit・push）を見て、
# コマンド本体・渡す本文ファイル・push するコミットのメッセージに Claude を示す語があれば拒否する。
# grep の「見つからない」で途中終了すると、検査を飛ばして通してしまうため。
set +o errexit +o pipefail
input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"
cwd="$(jq -r '.cwd // empty' <<<"$input")"
[ -n "$command" ] || exit 0

leak='claude|anthropic|co-authored-by|🤖'

gh_write='gh[[:space:]]+(pr|issue)[[:space:]]+(create|edit|comment|review|close|merge)|gh[[:space:]]+api[[:space:]].*(-X[[:space:]]*(POST|PATCH|PUT)|--method[[:space:]]+(POST|PATCH|PUT)|[[:space:]]-(f|F)[[:space:]]|--field|--raw-field|--input)|gh[[:space:]]+release[[:space:]]+(create|edit)'
git_commit='git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+(commit|tag[[:space:]]+-[am]|notes)'
git_push='git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push'

deny() {
  cat >&2 <<EOF
GitHub に Claude を使っていることが漏れる書き込みは使えません（$1）。
claude・anthropic・Co-Authored-By・🤖・claude.ai のリンク（セッション・artifact）を本文・コメント・コミットメッセージから外してください。
図や設計は本文に書き下し、ユーザーへ渡すリンクはチャットで渡します。
EOF
  exit 2
}

if grep -Eq "$gh_write|$git_commit" <<<"$command"; then
  # worktree（.claude/worktrees）や scratchpad（/tmp/claude-<uid>）のパス自体は本文ではないので外して見る。
  text="$(sed -E 's#[^[:space:]"'"'"'=]*(\.claude/|/claude-[0-9]+/)[^[:space:]"'"'"']*##g' <<<"$command")"
  grep -Eiq "$leak" <<<"$text" && deny "コマンドの本文"
  while IFS= read -r file; do
    file="${file/#\~/$HOME}"
    [ -n "$cwd" ] && [ "${file#/}" = "$file" ] && file="$cwd/$file"
    [ -f "$file" ] && grep -Eiq "$leak" "$file" && deny "本文ファイル $file"
  done < <(
    {
      grep -Eo -- '(--body-file|--file|--input|-F)[[:space:]=]+[^[:space:];&|]+' <<<"$command" | sed -E 's/^[^[:space:]=]+[[:space:]=]+//' | grep -v '='
      grep -Eo -- '=@[^[:space:];&|]+' <<<"$command" | sed -E 's/^=@//'
    } | sed -E 's/^["'"'"']//; s/["'"'"']$//' | grep -v -- '^-$'
  )
fi

if grep -Eq "$git_push" <<<"$command"; then
  dir="$(grep -Eo 'git[[:space:]]+-C[[:space:]]+[^[:space:]]+' <<<"$command" | head -1 | awk '{print $3}')"
  dir="${dir:-$cwd}"
  if [ -n "$dir" ] && git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
    base="$(git -C "$dir" rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null || echo origin/main)"
    if git -C "$dir" log --format=%B "$base..HEAD" 2>/dev/null | grep -Eiq "$leak"; then
      deny "push するコミットのメッセージ（$base..HEAD）"
    fi
  fi
fi
exit 0

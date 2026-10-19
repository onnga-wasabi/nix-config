# 並列で動く Claude セッションが、ほかのセッションのプロセス（signoff・uvicorn・next dev など）を
# 巻き込んで止めないための PreToolUse フック。名前の一致でプロセスを止める Bash を拒否する。
#
# 止めてよいのは自分で起動したものだけ：バックグラウンドのタスクは TaskStop、控えた PID は kill <PID>。

input="$(cat)"
command="$(jq -r '.tool_input.command // empty' <<<"$input")"
[ -n "$command" ] || exit 0

by_name='(^|[;&|(`[:space:]])(pkill|killall)([[:space:]]|$)'
pgrep_to_kill='pgrep[^;&]*\|[[:space:]]*xargs[[:space:]]+(-[^[:space:]]+[[:space:]]+)*kill([[:space:]]|$)'
kill_of_pgrep='kill[^;&|]*\$\([[:space:]]*pgrep'

if grep -Eq -e "$by_name" -e "$pgrep_to_kill" -e "$kill_of_pgrep" <<<"$command"; then
  cat >&2 <<'EOF'
名前の一致でプロセスを止めるコマンドは使えません（pkill・killall・pgrep から kill）。
ほかのセッションの signoff・API・画面を巻き込みます。
自分で起動したバックグラウンドのタスクは TaskStop で、自分で控えた PID は kill <PID> で止めてください。
EOF
  exit 2
fi
exit 0

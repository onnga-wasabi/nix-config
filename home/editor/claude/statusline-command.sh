#!/bin/sh
# Claude Code statusLine command
# 1 行目: 自分のセッション名 | 場所（リポジトリ・worktree）とブランチ | ctx | 5h・7d の使用量
# 2 行目: このセッションのいまの作業（haiku の要約）
# 3 行目〜: ほかのセッション（● 作業中 / ○ 待機）といまの作業
# 記号は端末によって 2 桁幅で描かれるので、後ろに空白を 1 つ置いて重ならないようにする。

input=$(cat)
j() { echo "$input" | jq -r "$1 // empty"; }

sid=$(j '.session_id')
cwd=$(j '.workspace.current_dir // .cwd')
ctx=$(j '.context_window.used_percentage')
h5=$(j '.rate_limits.five_hour.used_percentage')
h5_reset=$(j '.rate_limits.five_hour.resets_at')
d7=$(j '.rate_limits.seven_day.used_percentage')

SEP='   \033[90m|\033[0m   '

# 使用率で色を変える（〜59 緑・60〜84 黄・85〜 赤）
pct() {
  n=$(printf '%.0f' "$1")
  if [ "$n" -ge 85 ]; then c=31; elif [ "$n" -ge 60 ]; then c=33; else c=32; fi
  printf '\033[%sm%s%%\033[0m' "$c" "$n"
}

agents=$(claude agents --json 2>/dev/null)

# 自分の名前（ListAgents・SendMessage の宛先と同じ）
me=$(echo "$agents" | jq -r --arg s "$sid" '.[]? | select(.sessionId==$s) | .name' 2>/dev/null)
[ -n "$me" ] && printf '\033[1;34m%s\033[0m' "$me"

# 場所: リポジトリ名。worktree の中なら「リポジトリ / wt:名前」。ブランチは worktree の名前と違うときだけ出す
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi
wt=""
case "$cwd" in
  */.claude/worktrees/*)
    repo=$(basename "${cwd%%/.claude/worktrees/*}")
    wt=${cwd#*/.claude/worktrees/}; wt=${wt%%/*}
    place="${repo}  ⎇ ${wt}" ;;
  "") place="" ;;
  *)
    top=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    place=$(basename "${top:-$cwd}") ;;
esac
if [ -n "$place" ]; then
  printf "$SEP"'\033[36m%s\033[0m' "$place"
  case "$branch" in
    ""|"$wt"|"worktree-$wt") ;;
    *) printf '  \033[32m(%s)\033[0m' "$branch" ;;
  esac
fi

[ -n "$ctx" ] && printf "$SEP"'\033[90mctx\033[0m %s' "$(pct "$ctx")"

if [ -n "$h5" ]; then
  printf "$SEP"'\033[90m5h\033[0m %s' "$(pct "$h5")"
  if [ -n "$h5_reset" ]; then
    at=$(date -d "@$h5_reset" +%H:%M 2>/dev/null || date -r "$h5_reset" +%H:%M 2>/dev/null)
    [ -n "$at" ] && printf '  \033[90m→ %s\033[0m' "$at"
  fi
fi
[ -n "$d7" ] && printf "$SEP"'\033[90m7d\033[0m %s' "$(pct "$d7")"
printf '\n'

# いまの作業の要約。手元の書き置きを出すだけで、古ければ裏で statusline-summarize.sh に作り直させる
cache_dir="$HOME/.cache/claude-statusline"
summary_of() {
  s=$1; tr=$2
  [ -n "$tr" ] || tr=$(ls "$HOME"/.claude/projects/*/"$s".jsonl 2>/dev/null | head -n 1)
  c="$cache_dir/$s.summary"
  # 止まったまま残った lock は 3 分で捨てる
  [ -d "$cache_dir/$s.lock" ] && [ -n "$(find "$cache_dir/$s.lock" -maxdepth 0 -mmin +3 2>/dev/null)" ] \
    && rmdir "$cache_dir/$s.lock" 2>/dev/null
  if [ -n "$tr" ] && [ -f "$tr" ]; then
    if [ ! -f "$c" ] || { [ "$tr" -nt "$c" ] && [ -n "$(find "$c" -mmin +2 2>/dev/null)" ]; }; then
      nohup sh "$HOME/.claude/statusline-summarize.sh" "$s" "$tr" >/dev/null 2>&1 &
    fi
  fi
  [ -f "$c" ] && head -n 1 "$c"
}

mine=$(summary_of "$sid" "$(j '.transcript_path')")
[ -n "$mine" ] && printf '\033[90mnow:\033[0m    %s\n' "$mine"

# ほかのセッション
echo "$agents" | jq -r --arg s "$sid" '
  [.[]? | select(.sessionId != $s and .kind == "interactive")]
  | sort_by(.name)[]
  | "\(.sessionId)\t\(.status)\t\(.name)"' 2>/dev/null |
while IFS="$(printf '\t')" read -r osid ostatus oname; do
  if [ "$ostatus" = busy ]; then mark='\033[33m● \033[0m'; else mark='\033[90m○ \033[0m'; fi
  osum=$(summary_of "$osid" "")
  printf '\033[90mothers:\033[0m %b%-24s \033[90m%s\033[0m\n' "$mark" "$oname" "$osum"
done

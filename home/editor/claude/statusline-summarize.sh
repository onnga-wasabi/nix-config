#!/bin/sh
# セッションのいまの作業を 1 行に要約して、ステータスバー用に書き置く。
# statusline-command.sh が裏で起こす。使い方: statusline-summarize.sh <session_id> <transcript.jsonl>
# 直近のユーザーの依頼と Claude の返答だけを haiku に渡す。hook・ツールは読み込ませない。

sid=$1
transcript=$2
dir="$HOME/.cache/claude-statusline"
out="$dir/$sid.summary"
lock="$dir/$sid.lock"

mkdir -p "$dir"
# 同じセッションの要約を重ねて走らせない
mkdir "$lock" 2>/dev/null || exit 0
trap 'rmdir "$lock"' EXIT

[ -f "$transcript" ] || exit 0

# 途中で切れた先頭の行や壊れた行は飛ばす
recent=$(tail -c 600000 "$transcript" | jq -R -r 'fromjson? // empty |
  if .type == "last-prompt" then "依頼: " + (.lastPrompt | .[0:300])
  elif .type == "assistant" then
    ([.message.content[]? | select(.type == "text") | .text] | join(" ")
     | if length > 0 then "Claude: " + .[0:300] else empty end)
  else empty end' 2>/dev/null | awk '!seen[$0]++' | tail -n 8)

[ -n "$recent" ] || exit 0

summary=$(printf '%s\n' "以下はコーディング用のエージェントと人のやり取りの最近の部分。いまこのセッションが取り組んでいる作業を、日本語 30 文字以内の 1 行で書いて。前置き・句点・引用符は付けない。

$recent" | claude -p --model haiku --no-session-persistence --setting-sources "" --tools "" 2>/dev/null \
  | tr -d '\r' | head -n 1 | cut -c1-120)

[ -n "$summary" ] && printf '%s\n' "$summary" > "$out.tmp" && mv "$out.tmp" "$out"

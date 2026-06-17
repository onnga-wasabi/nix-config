#!/bin/sh
# Claude Code statusLine command
# p10k (classic) 風: user@host  dir  git-branch | model  context%

input=$(cat)

user=$(whoami)
host=$(hostname -s)
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')

# git branch (skip optional locks)
branch=""
if [ -n "$cwd" ] && [ -d "$cwd" ]; then
  branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# context usage
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# --- build output ---
# Part1: user@host
printf '\033[33m%s@%s\033[0m' "$user" "$host"

# Part2: directory (replace $HOME with ~)
if [ -n "$cwd" ]; then
  home_dir=$(echo ~)
  display_dir="${cwd#$home_dir}"
  if [ "$display_dir" != "$cwd" ]; then
    display_dir="~$display_dir"
  fi
  printf '  \033[36m%s\033[0m' "$display_dir"
fi

# Part3: git branch
if [ -n "$branch" ]; then
  printf '  \033[32m %s\033[0m' "$branch"
fi

# separator
printf '  \033[90m|\033[0m'

# Part4: model
if [ -n "$model" ]; then
  printf '  \033[35m%s\033[0m' "$model"
fi

# Part5: context usage
if [ -n "$used" ]; then
  printf '  \033[90mctx: %s%%\033[0m' "$(printf '%.0f' "$used")"
fi

printf '\n'

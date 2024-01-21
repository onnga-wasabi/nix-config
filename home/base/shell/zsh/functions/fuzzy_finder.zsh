# Functions
zd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
zgd() {
  local dir
  local workdir
  if [[ $1 ]] then;
      workdir=$1
  else
      workdir=${HOME}/"workspace"
  fi
  dir=$(rg --files --hidden --follow --glob "**/.git/*" $workdir | rev | cut -d '/' -f 3- | rev | sort | uniq | fzf +m) &&
  cd "$dir"
}


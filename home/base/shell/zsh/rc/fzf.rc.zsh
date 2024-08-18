# fzf
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!**/.git/*"'
export FZF_DEFAULT_OPTS="
    --height 80% --reverse --border=sharp --margin=0,1
    --color=light
"

# for finding files in current directories
export FZF_CTRL_T_COMMAND='rg --files --follow -g "!Library/*" --glob "!**/.git/*"'
export FZF_CTRL_T_OPTS="
    --preview 'bat  --color=always --style=header,grid {}'
    --preview-window=right:60%
"

export FZF_CTRL_R_OPTS="
    --preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'
"

source <(fzf --zsh)

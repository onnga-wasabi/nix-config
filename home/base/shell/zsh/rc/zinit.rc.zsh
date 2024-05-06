ZINIT_HOME="${XDG_DATA_HOME}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"

source "${ZINIT_HOME}/zinit.zsh"

# prompt theming
zinit ice depth=1
zinit light romkatv/powerlevel10k

# prompt syntax highlight
zinit light zsh-users/zsh-syntax-highlighting

# history search
# zinit light robobenklein/zdharma-history-search-multi-word

# ls
# zinit light zpm-zsh/ls # エイリアスとか


# zsh-yarn-completions
zinit ice atload"zpcdreplay" atclone'./zplug.zsh'
zinit light g-plane/zsh-yarn-autocompletions

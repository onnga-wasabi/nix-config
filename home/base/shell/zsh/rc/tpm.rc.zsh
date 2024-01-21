# Tmux Plugin Manger のインストールは力技使う
if [[ ! -d "${HOME}/.tmux/plugins/tpm" ]]; then
  git clone https://github.com/tmux-plugins/tpm.git "${HOME}/.tmux/plugins/tpm"
fi


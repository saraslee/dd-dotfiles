export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(git zshmarks)

# update automatically without asking
zstyle ':omz:update' mode auto

source $ZSH/oh-my-zsh.sh
source ~/.my-aliases

eval "$(direnv hook zsh)"

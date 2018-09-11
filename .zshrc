export ZSH="/home/james/.oh-my-zsh"
ZSH_THEME="spaceship"
plugins=(
  archlinux
  git
  docker
  fzf-zsh # https://github.com/Wyntau/fzf-zsh
  httpie
  node
  npm
  python
  yarn
  zsh-autosuggestions # https://github.com/zsh-users/zsh-autosuggestions
  zsh-syntax-highlighting # https://github.com/zsh-users/zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh
fpath=($fpath "/home/james/.zfunctions")

# Set Spaceship ZSH as a prompt
autoload -U promptinit; promptinit
prompt spaceship

# npm added to path (we ran `npm config set prefix '~/.npm-global'` to change our location)
export PATH=/home/james/.npm-global/bin:$PATH

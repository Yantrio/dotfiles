# ───────────── zsh config loader ─────────────
ZSH_CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"

for file in \
  prompt \
  history \
  options \
  completion \
  keybindings \
  editor \
  path \
  fzf \
  ghq-cmux \
  ssh-agent \
  aliases \
  mise \
  pi
 do
  [[ -r "$ZSH_CONFIG_DIR/$file.zsh" ]] && source "$ZSH_CONFIG_DIR/$file.zsh"
done

unset file

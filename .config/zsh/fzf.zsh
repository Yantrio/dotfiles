# ───────────── fzf ─────────────
# brew install fzf && $(brew --prefix)/opt/fzf/install
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
# Use ripgrep/fd if installed (faster, respects .gitignore)
command -v fd >/dev/null && export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
[ -n "$FZF_DEFAULT_COMMAND" ] && export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

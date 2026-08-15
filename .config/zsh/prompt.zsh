# ───────────── Pure prompt ─────────────
# Sources for prompt_pure_setup, in priority order:
#   1. Homebrew (macOS: brew install pure)
#   2. Manual clone at ~/.local/share/zsh/pure (git clone sindresorhus/pure)
#   3. Distro packages that land Pure in the default $fpath (e.g. AUR zsh-pure-prompt)
# If none are present, fall through silently.
if command -v brew >/dev/null 2>&1; then
    fpath+=("$(brew --prefix)/share/zsh/site-functions")
fi
[[ -d "$HOME/.local/share/zsh/pure" ]] && fpath+=("$HOME/.local/share/zsh/pure")
autoload -U promptinit && promptinit
(( $+functions[prompt_pure_setup] )) && prompt pure

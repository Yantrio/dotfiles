# ───────────── PATH ─────────────
export GOPATH="$HOME/go"
export PNPM_HOME="$HOME/Library/pnpm"

path=(
  /opt/homebrew/bin
  "$HOME/.local/bin"
  "$HOME/.local/share/mise/shims"
  "$GOPATH/bin"
  "$PNPM_HOME"
  $path
)
typeset -U path  # dedupe

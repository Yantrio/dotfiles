# ───────────── Completion ─────────────
autoload -Uz compinit
# Cache compdump for the day — avoids rebuilding on every shell start
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive

# ───────────── ghq + fzf integration ─────────────
# brew install ghq fzf
# Jump to any cloned repo: hit Ctrl-G
export GHQ_ROOT="$HOME/ghq"

# Put the CURRENT cmux workspace into its org's sidebar group, creating the
# group if it doesn't exist (named after the ghq org slug, e.g. spacelift-io).
# $1 = ghq path (host/org/repo). No-op outside cmux.
function _cmux_group_by_org() {
  [[ -n "$CMUX_WORKSPACE_ID" ]] || return
  command -v cmux >/dev/null 2>&1 || command -v jq >/dev/null 2>&1 || return
  local parts=(${(s:/:)1})                          # (host org repo ...)
  (( ${#parts} >= 3 )) || return
  local org="${parts[2]}" reponame="${parts[3]}"

  # Name the workspace after the bare repo — the group header already shows org.
  cmux rename-workspace "$reponame" >/dev/null 2>&1

  # Find the group by name; add if it exists, otherwise create it from this ws.
  local gref
  gref=$(cmux workspace-group list --json 2>/dev/null \
    | jq -r --arg n "$org" 'first(.groups[] | select(.name==$n) | .ref) // empty')
  if [[ -n "$gref" ]]; then
    cmux workspace-group add --group "$gref" --workspace "$CMUX_WORKSPACE_ID" >/dev/null 2>&1
  else
    cmux workspace-group create --name "$org" --from "$CMUX_WORKSPACE_ID" >/dev/null 2>&1
  fi
}

# Lay out the panes for a freshly-jumped repo. This shell (the pane where ^G was
# hit) is already cd'd into the repo and becomes the RIGHT-hand terminal.
#   - Left pane: nvim on the repo (focused).
#   - Some orgs also get an agent pane stacked above the right terminal:
#       spacelift-io -> claude   (always)
#       opentofu     -> opencode (only if AI-USAGE-POLICY.md is at the repo root)
# $1 = ghq path (host/org/repo), $2 = repo dir. No-op outside cmux.
function _cmux_open_layout() {
  [[ -n "$CMUX_WORKSPACE_ID" ]] || return
  command -v cmux >/dev/null 2>&1 && command -v jq >/dev/null 2>&1 || return
  local dir="$2"
  local parts=(${(s:/:)1}) org
  org="${parts[2]}"

  local agent=""
  case "$org" in
    spacelift-io) agent="claude" ;;
    opentofu)     [[ -f "$dir/AI-USAGE-POLICY.md" ]] && agent="opencode" ;;
  esac

  # Left pane: nvim (focused).
  local lsurf
  lsurf=$(cmux new-split left --focus true --json 2>/dev/null | jq -r '.surface_ref // empty')
  [[ -n "$lsurf" ]] && cmux send --surface "$lsurf" "cd ${(q)dir} && nvim .\n" >/dev/null 2>&1

  # Agent orgs: split the right pane so the agent sits on top and this shell
  # drops to the bottom terminal.
  if [[ -n "$agent" ]]; then
    local tsurf
    tsurf=$(cmux new-split up --focus false --json 2>/dev/null | jq -r '.surface_ref // empty')
    [[ -n "$tsurf" ]] && cmux send --surface "$tsurf" "cd ${(q)dir} && ${agent}\n" >/dev/null 2>&1
  fi
}

# Selection-frequency store for ghq-fzf. Format: "count<TAB>repo" per line.
GHQ_FZF_FREQ="${GHQ_FZF_FREQ:-$HOME/.cache/ghq-fzf-freq}"

# `ghq list` ordered by how often each repo has been picked (desc), with
# never-picked repos falling to the bottom alphabetically. ghq stays the source
# of truth so new repos appear and deleted ones drop off automatically.
function _ghq_list_by_freq() {
  ghq list | awk -v freq="$GHQ_FZF_FREQ" '
    BEGIN { FS = OFS = "\t"
      while ((getline line < freq) > 0) {
        n = index(line, "\t"); count[substr(line, n + 1)] = substr(line, 1, n - 1) + 0
      }
    }
    { print count[$0] + 0, $0 }
  ' | sort -t$'\t' -k1,1nr -k2,2 | cut -f2-
}

# Increment the pick count for the chosen repo.
function _ghq_bump_freq() {
  local repo=$1 tmp
  mkdir -p "${GHQ_FZF_FREQ:h}"; touch "$GHQ_FZF_FREQ"
  tmp=$(mktemp) || return
  awk -v repo="$repo" 'BEGIN { FS = OFS = "\t" }
    { if ($2 == repo) { $1 = $1 + 1; found = 1 } print }
    END { if (!found) print 1, repo }
  ' "$GHQ_FZF_FREQ" > "$tmp" && mv "$tmp" "$GHQ_FZF_FREQ"
}

function ghq-fzf() {
  local repo dir
  # Single-quoted so $FZF_PREVIEW_COLUMNS / $(ghq root) are evaluated by fzf's
  # preview shell, not zsh. glow needs -s (else it falls back to the plain
  # "notty" style when piped) and CLICOLOR_FORCE=1 (else termenv emits no color).
  # --tiebreak=index keeps frequency order as the tiebreaker once you type.
  repo=$(_ghq_list_by_freq | fzf --tiebreak=index --preview 'CLICOLOR_FORCE=1 glow -s dark -w ${FZF_PREVIEW_COLUMNS:-80} $(ghq root)/{}/README.md 2>/dev/null || ls -la $(ghq root)/{}') || return
  _ghq_bump_freq "$repo"
  dir="$(ghq root)/$repo"
  cd "$dir"
  _cmux_group_by_org "$repo"
  _cmux_open_layout "$repo" "$dir"
  zle reset-prompt
}
zle -N ghq-fzf
bindkey '^G' ghq-fzf

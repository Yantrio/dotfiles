# ───────────── ssh-agent ─────────────
# Prefer Homebrew's ssh-agent on macOS (Apple's doesn't support FIDO2 keys).
# Elsewhere, use whichever ssh-agent is on PATH.
if [[ -x /opt/homebrew/bin/ssh-agent ]]; then
    _ssh_agent_bin=/opt/homebrew/bin/ssh-agent
else
    _ssh_agent_bin=$(command -v ssh-agent)
fi

if [[ -n "$_ssh_agent_bin" ]] && { [[ -z "$SSH_AGENT_PID" ]] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; }; then
    eval "$("$_ssh_agent_bin" -s)" > /dev/null
fi

unset _ssh_agent_bin

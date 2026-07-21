# ───────────── ssh-agent ─────────────
# Use Homebrew's ssh-agent (Apple's doesn't support FIDO2 keys)
if [ -z "$SSH_AGENT_PID" ] || ! kill -0 "$SSH_AGENT_PID" 2>/dev/null; then
    eval "$(/opt/homebrew/bin/ssh-agent -s)" > /dev/null
fi

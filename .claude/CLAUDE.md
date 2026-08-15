# Yantrio conventions

Rules for every Claude Code session on any Yantrio machine (Arch dev box, Mac dev box, homelab). On first-session setup on a fresh machine, install the marketplace:

    /plugin marketplace add Yantrio/skills

The **yantrio-skills** plugins below (`pwa-stack`, `bws-secrets`, `proxmox-api`, `npmplus`, `arch-devbox`, `arch-theme`, `yadm-dotfiles`, `proxmox-healthcheck`) hold the detail — this file holds the always-apply rules. Per-repo `CLAUDE.md` files can extend or override for a specific project.

## Repos

1. **All new repos are private by default.** Bootstrap with:
   ```
   gh repo create <name> --private --clone --source=. --push
   ```
   Making a repo public is an explicit decision — never the default.

2. **Clone with `ghq get <url>`.** Never `git clone` to arbitrary paths. Repos live at `~/ghq/<host>/<owner>/<repo>` and are enumerable via `ghq list`.

## Web-app deploys

3. **Cloudflare Pages, Git-connected only.** Every push to `main` auto-builds and deploys; every PR gets a preview URL. Manual `wrangler pages deploy` is for emergencies only — if used, re-push to `main` immediately so it doesn't drift.

4. **Custom domain on `<name>.yantr.io` from day one.** Set up before the first URL is shared — no one sees the raw `<hash>.pages.dev`.

Full stack recipe in the **pwa-stack** skill (React 19 + Vite + Tailwind v4 + shadcn + Supabase).

## Secrets

5. **Machine tokens in `bws`** (Bitwarden Secrets Manager), **user credentials in `bw`** (Bitwarden Password Manager). Don't mix them.

6. **Never emit secret values to tool output.** No `echo $TOKEN`, no `bws secret list --output table`, no `cat` on any file in `~/.config/zsh/conf.d/`. Full forbidden-command list and correct patterns are in the **bws-secrets** skill.

## Machine setup

7. **Dotfiles live in yadm.** Origin: `git@github.com:Yantrio/dotfiles.git`. Per-machine overrides + secrets go in `~/.config/zsh/conf.d/*.zsh` (gitignored, auto-loaded by the modular zsh loader). See the **yadm-dotfiles** skill.

## Cross-human communication — DO NOT post as me

8. **Never emit a message a human other than me will read**, with these exceptions:

   - **Owned repos** (`Yantrio/*` on GitHub; anything under `git.home.yantr.io/yantrio/*`): free to `gh pr create` / `gh pr comment` / `gh issue comment` / `gh pr review` / merge / close. No external humans see these.
   - **Third-party repos**: draft the message body + a one-line summary of what it says and why, then let **me** send it. Do not run `gh pr create` / `gh pr comment` / `gh issue comment` / `gh pr review` on repos I don't own.
   - **Social media, Slack, email, Discord, any messaging surface** (via CLI or MCP): never send. Draft if asked, but I send.

   Read-only inspection everywhere is fine (`gh pr view`, `gh issue view`, viewing comments, feeds, etc.). The boundary is **emission**, not observation.

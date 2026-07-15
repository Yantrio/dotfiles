---
name: check-config
description: Verify this Neovim config is healthy after changes — headless startup check, stylua, lazy.nvim state, plugin load smoke test. Use after editing the config or when something seems broken.
---

# Check the config

Run these in order; stop and fix at the first failure.

## 1. Startup errors

```sh
nvim --headless "+lua print('startup ok')" +qa
```

Any Lua error in `init.lua`, `lua/config/*`, or an eagerly-loaded plugin spec
prints to stderr. A clean run prints only `startup ok`.

## 2. Style

```sh
~/.local/share/nvim/mason/bin/stylua --check lua init.lua
```

stylua is Mason-installed and not on PATH. Format-on-save is intentionally
disabled for Lua in this config, so it must be run manually. The repo has
some pre-existing drift — when checking a change, only care about the files
that were edited.

## 3. Plugin manager state

```sh
nvim --headless "+Lazy! sync" +qa
```

This installs missing plugins and updates `lazy-lock.json`. If the diff shows
unexpected `lazy-lock.json` changes (plugins you didn't touch), flag it rather
than committing blindly.

## 4. Smoke-test lazy-loaded plugins you changed

Lazy-loaded specs (`event`/`keys`/`cmd`) don't run at startup, so step 1
doesn't cover them:

```sh
nvim --headless "+Lazy! load <plugin-name>" +qa
```

## 5. Health checks (when something still misbehaves)

```sh
nvim --headless "+checkhealth lazy" "+w! /tmp/health.txt" +qa && cat /tmp/health.txt
```

Swap `lazy` for `vim.lsp`, `mason`, `conform`, `nvim-treesitter`, etc. as
relevant. Headless checkhealth writes into a buffer, hence the `:w!` dance.

## Notes

- Treesitter tracks the `main` branch; parser problems usually want
  `nvim --headless "+TSUpdate" +qa`.
- LSP issues: open a real file of the filetype and check `:LspInfo` — many
  servers only start with a workspace/file context, so headless checks can't
  prove an LSP works.

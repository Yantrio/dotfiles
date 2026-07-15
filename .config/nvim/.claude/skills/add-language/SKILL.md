---
name: add-language
description: Wire up full support for a new language in this Neovim config — LSP server, formatter, format-on-save, linter, and treesitter parser. Use when asked to add/support a language (e.g. "set up Rust", "add Python support").
---

# Add language support

A language touches up to four places. Skip any the user doesn't need, but ask
yourself about each one.

## 1. LSP — `lua/plugins/lsp.lua`

Default path: servers installed through Mason auto-enable with default
settings via mason-lspconfig. So usually the only step is installing it:

```sh
nvim --headless "+MasonInstall <server-name>" +qa
```

Only touch `lsp.lua` when defaults aren't enough:
- Add a `vim.lsp.config('<server>', { ... })` override for custom settings
  (see `lua_ls`, `harper_ls` for the pattern).
- A server NOT managed by Mason (local binary, like `tofu_ls`) needs both the
  `vim.lsp.config` with an explicit `cmd` AND `vim.lsp.enable('<server>')`.

Keep the "only override when needed" comment block in that file intact — it
documents this contract.

## 2. Formatter — `lua/config/formatters.lua`

Add `filetype = { 'formatter' }` to the returned table. This file is the
single source of truth: conform consumes it, and mason-tool-installer derives
installs from it. Reuse the shared `prettier` local for prettier-family
filetypes.

**Format-on-save is a separate, deliberate opt-in**: the whitelist in
`lua/plugins/conform.lua` (`enabled_filetypes`). Ask whether the new filetype
should format on save; if yes, add it there too. Lua is intentionally NOT in
the whitelist.

## 3. Linter — `lua/plugins/lint.lua`

Only if the language has a linter worth running outside the LSP. Add to
`linters_by_ft`. If the linter needs argument surgery, follow the
golangci-lint example in that file and comment *why*.

## 4. Treesitter — `lua/plugins/treesitter.lua`

Usually nothing to do: parsers auto-install on first FileType event. Only add
the parser name to the eager `parsers` list if the filetype matters at first
launch (config-adjacent languages like lua/vimdoc). Note this config tracks
the treesitter `main` branch — use `require('nvim-treesitter').install(...)`,
never the old `ensure_installed` option.

## Verify

```sh
~/.local/share/nvim/mason/bin/stylua lua init.lua
nvim --headless "+lua print('ok')" +qa    # no startup errors
```

Then open a real file of that filetype and check `:LspInfo`, `:ConformInfo`,
and (if linting) save the file and look for diagnostics.

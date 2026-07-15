# AGENTS.md — James's Neovim config

This started as a kickstart.nvim fork and has been refactored into a multi-file
layout. It targets the latest stable/nightly Neovim (some code assumes >= 0.12,
e.g. built-in treesitter incremental selection). Plugins are managed by
lazy.nvim and `lazy-lock.json` is committed — never delete or hand-edit it.

## Layout

```
init.lua                  -- only require()s the config.* modules, nothing else
lua/config/
  options.lua             -- vim.o / vim.g settings (leader = <space>)
  keymaps.lua             -- global, plugin-free keymaps only
  autocmds.lua            -- global autocmds
  diagnostics.lua         -- vim.diagnostic.config
  formatters.lua          -- SINGLE SOURCE OF TRUTH: filetype -> formatter list
  lazy.lua                -- lazy.nvim bootstrap + setup({ import = 'plugins' })
lua/plugins/<name>.lua    -- one plugin per file, auto-imported by lazy.nvim
```

Rules of thumb:
- One plugin (plus its tightly-coupled dependencies) per file in `lua/plugins/`,
  named after the plugin (`telescope.lua`, `blink.lua`). New files are picked up
  automatically — never register plugins anywhere else.
- Plugin-specific keymaps live in that plugin's spec file (via `keys = {}` or
  inside `config`), NOT in `lua/config/keymaps.lua`. Keymaps that depend on an
  LSP client attach inside an `LspAttach` autocmd with `buffer = event.buf`.
- Cross-cutting data goes in `lua/config/` and gets required from plugin specs
  (see how `conform.lua` does `formatters_by_ft = require 'config.formatters'`).

## Code style

`stylua.toml` is authoritative: 2-space indent, 160 columns, single quotes,
`call_parentheses = "None"`, `collapse_simple_statement = "Always"`. In
practice that means:

```lua
require 'config.options'                  -- no parens on string-only calls
require('telescope').setup { ... }       -- no parens on table-only calls
if not client then return end             -- simple statements collapse to one line
```

Run stylua after editing — it's Mason-installed and not on PATH:

```sh
~/.local/share/nvim/mason/bin/stylua lua init.lua
```

Note format-on-save is deliberately NOT enabled for Lua (see the whitelist in
`lua/plugins/conform.lua`), so don't rely on it. The repo has some
pre-existing stylua drift; only reformat files you're already touching.

Comments explain *why*, not *what* — workarounds, upstream quirks, and
non-obvious decisions get a comment block (see the golangci-lint path-mode note
in `lint.lua` or the gotestsum rationale in `neotest.lua`). Don't narrate code.

## Plugin spec conventions

- Prefer `opts = {}` over `config = function()`; only use `config` when real
  logic is needed (autocmds, conditional setup).
- Lazy-load with `event` / `keys` / `cmd` when the plugin supports it.
  Colorscheme and snacks load eagerly with `priority = 1000`.
- Type the opts table with lazydev-style annotations when the plugin ships
  types: `---@module 'conform'` + `---@type conform.setupOpts`.
- Pin with `version` ranges only when the plugin recommends it (`blink.cmp`
  uses `version = '1.*'`).

## Keymaps

- Leader is `<space>`. Every mapping gets a `desc`, written kickstart-style
  with bracketed mnemonic letters: `'[F]ind [F]iles'`.
- Leader prefixes are grouped and registered in `lua/plugins/which-key.lua`:
  `<leader>f` find/telescope, `<leader>g` git, `<leader>l` LSP, `<leader>b`
  buffer, `<leader>u` UI toggles, `<leader>x` diagnostics (trouble),
  `<leader>t` tests (neotest). New mappings go under an existing group when
  possible; a new group must be added to the which-key spec.
- Don't shadow Neovim 0.11+ built-in `gr*` LSP maps — extend them (telescope
  rebinds `grr`/`grd`/`gri` to its own pickers on LspAttach).
- Watch for conflicts with built-ins; e.g. mini.ai remaps `an`/`in` to
  `aa`/`ii` to avoid the 0.12 incremental-selection clash.

## Language support

Adding a language touches up to four places — see the `add-language` skill:
1. **LSP**: servers installed via `:Mason` auto-enable with defaults through
   mason-lspconfig. Only add a `vim.lsp.config(...)` override in
   `lua/plugins/lsp.lua` when defaults aren't enough. Servers not managed by
   Mason (e.g. `tofu_ls`) need an explicit `vim.lsp.enable(...)`.
2. **Formatting**: add to `lua/config/formatters.lua`. Format-on-save is an
   explicit filetype whitelist in `lua/plugins/conform.lua` — opt the filetype
   in there too if it should format on save.
3. **Linting**: `linters_by_ft` in `lua/plugins/lint.lua`.
4. **Treesitter**: parsers auto-install on FileType (see `treesitter.lua`,
   which tracks the `main` branch with its new API — `install()`, not
   `ensure_installed`). Only add to the eager `parsers` list for filetypes
   wanted at first launch.

## Verifying changes

Never assume a config edit works — check it headlessly (see the `check-config`
skill):

```sh
nvim --headless "+lua print('ok')" +qa     # startup errors surface on stderr
~/.local/share/nvim/mason/bin/stylua --check lua init.lua
```

For plugin changes also confirm `:Lazy` is clean and the plugin actually loads
(`nvim --headless "+Lazy! load <name>" +qa`).

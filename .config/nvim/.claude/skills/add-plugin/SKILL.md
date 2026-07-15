---
name: add-plugin
description: Add a new plugin to this Neovim config following the one-file-per-plugin lazy.nvim layout and house style. Use when asked to install, add, or try a new nvim plugin.
---

# Add a plugin

## Steps

1. **Create `lua/plugins/<plugin-name>.lua`** returning a single lazy.nvim
   spec table. The file is auto-imported via `{ import = 'plugins' }` in
   `lua/config/lazy.lua` — do not register it anywhere else.

2. **Check the plugin's README for its recommended lazy.nvim spec** before
   writing one from scratch — most modern plugins publish one. Then adapt it
   to house style (below) rather than pasting verbatim.

3. **Shape the spec by house rules:**
   - Prefer `opts = {}` over `config = function()`. Use `config` only when you
     need autocmds, conditional logic, or to call other modules.
   - Lazy-load when the plugin supports it: `event = 'VimEnter'` for UI-level
     plugins, `keys = {}` for keymap-driven ones, `cmd = {}` for command-driven
     ones, `event = { 'BufReadPre', 'BufNewFile' }` for buffer-level ones.
     Eager (`lazy = false, priority = 1000`) is reserved for the colorscheme
     and snacks.
   - Put tightly-coupled dependencies in `dependencies = {}` inside the same
     file (see `telescope.lua`, `neotest.lua` for examples).
   - Add type annotations when the plugin ships them:
     `---@module '<plugin>'` then `---@type <plugin>.Config` above `opts`.

4. **Keymaps** go in this spec file (prefer lazy's `keys = {}` so they also
   lazy-load the plugin). Every map gets a `desc` in the kickstart bracket
   style (`'[R]un nearest test'`), under an existing `<leader>` group from
   `lua/plugins/which-key.lua` (f=find, g=git, l=LSP, b=buffer, u=UI toggles,
   x=diagnostics, t=test). If the plugin needs a new group, add it to the
   which-key spec and pick a letter that doesn't clash.

5. **Format and verify:**
   ```sh
   ~/.local/share/nvim/mason/bin/stylua lua/plugins/<plugin-name>.lua
   nvim --headless "+Lazy! sync" +qa        # installs + updates lazy-lock.json
   nvim --headless "+Lazy! load <plugin-name>" +qa   # errors surface on stderr
   ```
   Commit the `lazy-lock.json` change together with the new spec file.

## Style reminders

- stylua: 2-space indent, 160 cols, single quotes, no call parens
  (`setup { ... }`, `require 'lint'`), simple statements collapsed.
- Comments only for *why* (workarounds, upstream quirks), never *what*.

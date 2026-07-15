return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  ---@module 'which-key'
  ---@type wk.Opts
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    spec = {
      { '<leader>f', group = '[F]ind', mode = { 'n', 'v' } },
      { '<leader>g', group = '[G]it', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]SP' },
      { '<leader>b', group = '[B]uffer' },
      { '<leader>u', group = '[U]I toggle' },
      { '<leader>x', group = 'Diagnostics' },
      { '<leader>t', group = '[T]est' },
      { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
  },
}

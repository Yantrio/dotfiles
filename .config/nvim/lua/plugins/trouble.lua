return {
  'folke/trouble.nvim',
  cmd = 'Trouble',
  ---@module 'trouble'
  ---@type trouble.Config
  opts = {},
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<CR>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xX', '<cmd>Trouble diagnostics toggle filter.buf=0<CR>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<CR>', desc = 'Symbols (Trouble)' },
    { '<leader>xL', '<cmd>Trouble lsp toggle focus=false win.position=right<CR>', desc = 'LSP Definitions / refs (Trouble)' },
    { '<leader>xr', '<cmd>Trouble lsp_references toggle focus=false win.position=right<CR>', desc = 'LSP References (Trouble)' },
    { '<leader>xl', '<cmd>Trouble loclist toggle<CR>', desc = 'Location List (Trouble)' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<CR>', desc = 'Quickfix List (Trouble)' },
  },
}

return {
  'nvim-mini/mini.nvim',
  config = function()
    require('mini.ai').setup {
      -- Avoid conflicts with built-in incremental selection on Neovim>=0.12 (`:help treesitter-incremental-selection`)
      mappings = {
        around_next = 'aa',
        inside_next = 'ii',
      },
      n_lines = 500,
   }

    require('mini.surround').setup()
  end,
}

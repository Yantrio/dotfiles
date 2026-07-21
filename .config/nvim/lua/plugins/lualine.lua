return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  opts = {
    options = {
      theme = 'kanagawa',
      globalstatus = true,
      component_separators = '',
      section_separators = '',
    },
    sections = {
      lualine_a = { { 'mode', icon = '' } },
      lualine_b = { 'branch', 'diff' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'diagnostics' },
      lualine_y = { 'filetype', 'progress' },
      lualine_z = { 'location' },
    },
    extensions = { 'neo-tree', 'lazy', 'mason', 'trouble' },
  },
}

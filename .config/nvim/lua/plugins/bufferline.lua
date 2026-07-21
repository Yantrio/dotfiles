return {
  'akinsho/bufferline.nvim',
  version = '*',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  ---@module 'bufferline'
  ---@type bufferline.UserConfig
  opts = {
    options = {
      mode = 'buffers',
      diagnostics = 'nvim_lsp',
      diagnostics_update_in_insert = false,
      always_show_bufferline = false,
      show_buffer_close_icons = false,
      show_close_icon = false,
      separator_style = 'thin',
      offsets = {
        {
          filetype = 'neo-tree',
          text = 'Files',
          highlight = 'Directory',
          text_align = 'left',
        },
      },
    },
  },
}

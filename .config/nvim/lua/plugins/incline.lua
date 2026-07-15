return {
  'b0o/incline.nvim',
  event = 'BufReadPre',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    local devicons = require 'nvim-web-devicons'
    require('incline').setup {
      window = { padding = 0, margin = { horizontal = 0 } },
      render = function(props)
        local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ':t')
        if filename == '' then filename = '[No Name]' end
        local ft_icon, ft_color = devicons.get_icon_color(filename)
        local modified = vim.bo[props.buf].modified
        return {
          ft_icon and { ' ', ft_icon, ' ', guibg = 'none', guifg = ft_color } or '',
          ' ',
          { filename, gui = modified and 'bold,italic' or 'bold' },
          modified and { ' ●' } or '',
          ' ',
        }
      end,
    }
  end,
}

return {
  'vuki656/package-info.nvim',
  dependencies = 'MunifTanjim/nui.nvim',
  ft = 'json',
  opts = {
    autostart = true,
    hide_up_to_date = false,
    icons = { enable = true },
  },
  keys = {
    { '<leader>ps', function() require('package-info').show { force = true } end, desc = 'Show package versions' },
    { '<leader>pt', function() require('package-info').toggle() end, desc = 'Toggle package versions' },
    { '<leader>pu', function() require('package-info').update() end, desc = 'Update package' },
    { '<leader>pd', function() require('package-info').delete() end, desc = 'Delete package' },
    { '<leader>pi', function() require('package-info').install() end, desc = 'Install new package' },
    { '<leader>pc', function() require('package-info').change_version() end, desc = 'Change package version' },
  },
}

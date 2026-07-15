return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    scroll = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    notifier = { enabled = true },
    dim = { enabled = true },
    dashboard = {
      enabled = true,
      preset = {
        keys = {
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'f', desc = 'Find File', action = ":lua require('telescope.builtin').find_files()" },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua require('telescope.builtin').oldfiles()" },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua require('telescope.builtin').live_grep()" },
          { icon = ' ', key = 'c', desc = 'Config', action = ":lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })" },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'm', desc = 'Mason', action = ':Mason' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
      sections = {
        { section = 'header' },
        { section = 'keys', gap = 1, padding = 1 },
        { section = 'recent_files', cwd = true, limit = 8, padding = 1 },
        { section = 'projects', limit = 5, padding = 1 },
        { section = 'startup' },
      },
    },
  },
}

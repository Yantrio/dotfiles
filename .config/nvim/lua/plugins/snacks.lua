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
      width = 78,
      pane_gap = 4,
      preset = {
        header = [[
      _   __                 _
     / | / /__  ____  _   __(_)_ __ ___
    /  |/ / _ \/ __ \| | / / / // / `__ \
   / /|  /  __/ /_/ /| |/ / / ,< / / / / /
  /_/ |_/\___/\____/|___/_/_/|_/_/ /_/ /
]],
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
        { icon = ' ', title = 'Actions', section = 'keys', gap = 1, padding = 1 },
        { section = 'startup' },
        { icon = ' ', title = 'Recent Files', section = 'recent_files', pane = 2, limit = 8, indent = 2, padding = 1 },
        { icon = ' ', title = 'Projects', section = 'projects', pane = 2, limit = 5, indent = 2, padding = 1 },
        {
          icon = ' ',
          title = 'Git Status',
          section = 'terminal',
          pane = 2,
          enabled = function() return Snacks.git.get_root() ~= nil end,
          cmd = 'git status --short --branch --renames',
          height = 5,
          indent = 2,
          padding = 1,
          ttl = 5 * 60,
        },
      },
    },
  },
}

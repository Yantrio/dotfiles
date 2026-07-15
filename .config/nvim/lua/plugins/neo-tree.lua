return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
    { '<leader>e', ':Neotree position=left filesystem toggle<CR>', desc = 'Toggle explorer', silent = true },
    { '<leader>o', ':Neotree position=bottom document_symbols toggle<CR>', desc = 'Toggle symbols outline', silent = true },
  },
  ---@module 'neo-tree'
  ---@type neotree.Config
  opts = {
    sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
    window = {
      mappings = {
        ['<C-r>'] = 'noop',
      },
    },
    filesystem = {
      follow_current_file = { enabled = true, leave_dirs_open = true },
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
    document_symbols = {
      follow_cursor = true,
      renderers = {
        symbol = {
          { 'indent', with_expanders = true },
          { 'kind_icon', default = '?' },
          { 'name', zindex = 10 },
        },
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = '✚',
          modified  = '●',
          deleted   = '✖',
          renamed   = '➜',
          untracked = '★',
          ignored   = '◌',
          unstaged  = '○',
          staged    = '✓',
          conflict  = '⚠',
        },
      },
    },
  },
}

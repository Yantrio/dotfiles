return {
  'folke/edgy.nvim',
  event = 'VeryLazy',
  init = function()
    vim.opt.laststatus = 3
    vim.opt.splitkeep = 'screen'
  end,
  opts = {
    exit_when_last = true,
    animate = { enabled = false },
    left = {
      {
        title = 'Files',
        ft = 'neo-tree',
        filter = function(buf) return vim.b[buf].neo_tree_source == 'filesystem' end,
        size = { height = 0.6 },
        pinned = true,
        open = 'Neotree position=left filesystem',
      },
      {
        title = 'Symbols',
        ft = 'neo-tree',
        filter = function(buf) return vim.b[buf].neo_tree_source == 'document_symbols' end,
        pinned = true,
        open = 'Neotree position=bottom document_symbols',
      },
    },
  },
}

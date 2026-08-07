return {
  'zion-off/mole.nvim',
  dependencies = { 'MunifTanjim/nui.nvim' },
  cmd = { 'MoleStart', 'MoleStop', 'MoleResume', 'MoleToggle' },
  keys = {
    {
      '<leader>ma',
      function()
        vim.cmd 'normal! V'
        require('mole').annotate()
      end,
      desc = '[M]ole [A]nnotate current line',
    },
    { '<leader>ms', '<cmd>MoleStart<cr>', desc = '[M]ole [S]tart session' },
    { '<leader>mr', '<cmd>MoleResume<cr>', desc = '[M]ole [R]esume session' },
    { '<leader>mq', '<cmd>MoleStop<cr>', desc = '[M]ole [Q]uit session' },
    { '<leader>mw', '<cmd>MoleToggle<cr>', desc = '[M]ole toggle [W]indow' },
  },
  opts = {},
}

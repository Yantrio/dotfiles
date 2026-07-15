return {
  'lewis6991/gitsigns.nvim',
  ---@module 'gitsigns'
  ---@type Gitsigns.Config
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    signs = {
      add = { text = '+' }, ---@diagnostic disable-line: missing-fields
      change = { text = '~' }, ---@diagnostic disable-line: missing-fields
      delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
      topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
      changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    },
    on_attach = function(bufnr)
      local gs = require 'gitsigns'
      local map = function(mode, lhs, rhs, desc) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc }) end

      map('n', ']g', function() gs.nav_hunk 'next' end, 'Next git hunk')
      map('n', '[g', function() gs.nav_hunk 'prev' end, 'Previous git hunk')

      map('n', '<leader>gj', function() gs.nav_hunk 'next' end, 'Next hunk')
      map('n', '<leader>gk', function() gs.nav_hunk 'prev' end, 'Previous hunk')
      map('n', '<leader>gp', gs.preview_hunk, 'Preview hunk')
      map('n', '<leader>gs', gs.stage_hunk, 'Stage hunk')
      map('n', '<leader>gh', gs.reset_hunk, 'Reset hunk')
      map('n', '<leader>gb', function() gs.blame_line { full = true } end, 'Blame line')
      map('n', '<leader>gd', gs.diffthis, 'Diff this')

      map('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Stage hunk')
      map('v', '<leader>gh', function() gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' } end, 'Reset hunk')
    end,
  },
}

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-treesitter/nvim-treesitter',
    {
      'fredrikaverpil/neotest-golang',
      -- gotestsum writes test JSON to a file instead of stdout, which avoids
      -- the corruption/truncation/ANSI issues of `go test -json`. See docs.
      build = function() vim.system({ 'go', 'install', 'gotest.tools/gotestsum@latest' }):wait() end,
    },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-golang' {
          runner = 'gotestsum',
        },
      },
    }
  end,
  keys = {
    { '<leader>tr', function() require('neotest').run.run() end, desc = '[R]un nearest test' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Run [F]ile' },
    { '<leader>tA', function() require('neotest').run.run(vim.uv.cwd()) end, desc = 'Run [A]ll tests' },
    { '<leader>tl', function() require('neotest').run.run_last() end, desc = 'Run [L]ast test' },
    { '<leader>ts', function() require('neotest').run.stop() end, desc = '[S]top' },
    { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = '[O]utput' },
    { '<leader>tO', function() require('neotest').output_panel.toggle() end, desc = 'Output panel' },
    { '<leader>tt', function() require('neotest').summary.toggle() end, desc = '[T]oggle summary' },
    { '<leader>tw', function() require('neotest').watch.toggle(vim.fn.expand '%') end, desc = '[W]atch file' },
    { '<leader>td', function() require('neotest').run.run { suite = false, strategy = 'dap' } end, desc = '[D]ebug nearest (needs dlv)' },
    { ']t', function() require('neotest').jump.next { status = 'failed' } end, desc = 'Next failed test' },
    { '[t', function() require('neotest').jump.prev { status = 'failed' } end, desc = 'Prev failed test' },
  },
}

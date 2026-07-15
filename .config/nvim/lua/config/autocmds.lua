vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

vim.api.nvim_create_autocmd('FileType', {
  desc = 'Force treesitter folding (overrides ftplugin defaults)',
  group = vim.api.nvim_create_augroup('treesitter-folding', { clear = true }),
  callback = function()
    if vim.treesitter.language.get_lang(vim.bo.filetype) then
      vim.opt_local.foldmethod = 'expr'
      vim.opt_local.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    end
  end,
})

-- Auto-open the left sidebar (neo-tree filesystem + document_symbols, slotted by edgy)
-- Skipped when nvim is launched bare so the dashboard can show.
vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Auto-open sidebar on startup',
  group = vim.api.nvim_create_augroup('sidebar-autoopen', { clear = true }),
  callback = function()
    if vim.fn.argc() == 0 then return end
    vim.schedule(function()
      vim.cmd 'Neotree position=left filesystem show'
      vim.cmd 'Neotree position=bottom document_symbols show'
      vim.cmd 'wincmd p'
    end)
  end,
})

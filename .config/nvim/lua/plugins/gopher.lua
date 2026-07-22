return {
  'olexsmir/gopher.nvim',
  ft = 'go',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-treesitter/nvim-treesitter' },
  -- Tools (gomodifytags, impl, iferr, gotests) come from mason-tool-installer
  -- in lsp.lua, so no :GoInstallDeps build step. json2go isn't in the mason
  -- registry — run `:GoInstallDeps` once if you want `:GoJson`/`<leader>Gj`.
  config = function()
    require('gopher').setup {}

    -- Buffer-local Go maps. Set on FileType for every Go buffer, plus the
    -- buffer that triggered lazy-loading (its FileType fired before this
    -- autocmd existed, so it would otherwise be missed).
    local function map_go(buf)
      local m = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { buffer = buf, desc = desc, silent = true }) end
      m('<leader>Ge', '<cmd>GoIfErr<cr>', '[E]rr block (if err)')
      m('<leader>Gc', '<cmd>GoCmt<cr>', 'Doc [C]omment')
      m('<leader>Gg', '<cmd>GoGenerate<cr>', '[G]enerate')
      m('<leader>Gj', '<cmd>GoJson<cr>', '[J]SON to struct')
      -- GoImpl needs an interface arg; leave it on the cmdline (not silent).
      vim.keymap.set('n', '<leader>Gi', ':GoImpl ', { buffer = buf, desc = '[I]mplement interface' })
      m('<leader>Gta', '<cmd>GoTagAdd json<cr>', '[T]ag [A]dd json')
      m('<leader>Gtr', '<cmd>GoTagRm json<cr>', '[T]ag [R]emove json')
      m('<leader>tg', '<cmd>GoTestAdd<cr>', '[G]enerate test for func')
      m('<leader>tG', '<cmd>GoTestsAll<cr>', '[G]enerate all tests in file')
    end

    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'go',
      group = vim.api.nvim_create_augroup('gopher-keys', { clear = true }),
      callback = function(ev) map_go(ev.buf) end,
    })
    if vim.bo.filetype == 'go' then map_go(0) end
  end,
}

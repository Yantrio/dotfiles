return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>lf',
      function() require('conform').format { async = true } end,
      mode = '',
      desc = '[L]SP [F]ormat buffer',
    },
  },
  init = function()
    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        vim.b.disable_autoformat = true -- current buffer only
      else
        vim.g.disable_autoformat = true -- globally
      end
    end, { desc = 'Disable autoformat-on-save', bang = true })
    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, { desc = 'Re-enable autoformat-on-save' })
  end,
  ---@module 'conform'
  ---@type conform.setupOpts
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable with :FormatDisable (global) or :FormatDisable! (buffer)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return nil
      end
      local enabled_filetypes = {
        -- lua = true,
        go = true,
        javascript = true,
        javascriptreact = true,
        typescript = true,
        typescriptreact = true,
        vue = true,
        css = true,
        scss = true,
        less = true,
        html = true,
        json = true,
        jsonc = true,
        yaml = true,
        markdown = true,
        ['markdown.mdx'] = true,
        graphql = true,
        handlebars = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback',
    },
    formatters_by_ft = require 'config.formatters',
  },
}

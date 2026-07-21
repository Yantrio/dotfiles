return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'mason-org/mason.nvim', opts = {} },
    { 'mason-org/mason-lspconfig.nvim', opts = {} },
    {
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      opts = {
        ensure_installed = {
          'lua-language-server',
          'gopls',
          'codebook',
          'tofu-ls',
          'stylua',
          'prettierd',
          'prettier',
          'biome',
          'golangci-lint',
          'gotestsum',
        },
      },
    },
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode) vim.keymap.set(mode or 'n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc }) end

        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        map('<leader>lr', vim.lsp.buf.rename, '[R]ename')
        map('<leader>la', vim.lsp.buf.code_action, 'Code [A]ction', { 'n', 'x' })
        map('<leader>lh', vim.lsp.buf.signature_help, 'Signature [H]elp')

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if not client then return end

        if client:supports_method('textDocument/documentHighlight', event.buf) then
          local hl = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = hl,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = hl,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(e2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = e2.buf }
            end,
          })
        end

        if client:supports_method('textDocument/inlayHint', event.buf) then
          map('<leader>uh', function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }) end, 'Toggle Inlay [H]ints')
        end
      end,
    })

    -- Per-server overrides. Anything NOT in this table still auto-enables via
    -- mason-lspconfig with default settings — install via :Mason and it Just Works.
    -- Only add an entry here when you need to override the defaults.
    vim.lsp.config('lua_ls', {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false

        -- Skip nvim-runtime injection when editing a project that has its own .luarc.json
        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then return end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = { version = 'LuaJIT', path = { 'lua/?.lua', 'lua/?/init.lua' } },
          workspace = {
            checkThirdParty = false,
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      settings = { Lua = { format = { enable = false } } },
    })

    -- codebook: spell checker built for code. Splits camelCase/snake_case,
    -- ignores identifiers, URLs and acronyms. Needs no overrides — it
    -- auto-enables via mason-lspconfig once installed (:Mason). Per-project
    -- custom words go in a `codebook.toml` at the repo root.

    -- tofu-ls is installed by Mason, but keep startup clean if its install
    -- failed or it was deliberately removed.
    local tofu_ls = vim.fn.exepath 'tofu-ls'
    if tofu_ls ~= '' then
      vim.lsp.config('tofu_ls', { cmd = { tofu_ls, 'serve' } })
      vim.lsp.enable 'tofu_ls'
    end
  end,
}

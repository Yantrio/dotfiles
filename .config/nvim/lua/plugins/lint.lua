return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      go = { 'golangcilint' },
    }

    -- Force golangci-lint to lint the buffer's own package directory.
    --
    -- nvim-lint's built-in spec decides file-vs-dir ONCE at load time from
    -- `go env GOMOD` against nvim's cwd. In nested-module monorepos (e.g.
    -- registry-ui, where go.mod lives in backendv2/ and the git root has none)
    -- that resolves to /dev/null and silently degrades to single-file mode,
    -- which can't do whole-package analysis -> staticcheck (ST1005 etc.) never
    -- runs. Pointing at the current file's dir each run avoids that.
    local gcl = lint.linters.golangcilint

    -- Prefer a repo-local custom golangci-lint build (e.g. backend's
    -- ./bin/golangci-lint with the space-lint plugin) over whatever is on
    -- PATH. Mason's stock binary can't load configs that declare plugins
    -- (exit code 3: plugin "spacelint" not found), so walk up from the
    -- buffer's directory looking for bin/golangci-lint first.
    local function find_golangci()
      local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
      while dir do
        local candidate = dir .. '/bin/golangci-lint'
        if vim.fn.executable(candidate) == 1 then
          return candidate
        end
        local parent = vim.fs.dirname(dir)
        if parent == dir then
          break
        end
        dir = parent
      end
      return 'golangci-lint'
    end

    -- Run through a tee shim so stderr lands in /tmp/nvim-golangci-lint.log;
    -- nvim-lint only surfaces the exit code, which makes failures (exit 3/7)
    -- undebuggable otherwise. The shim execs its first argument.
    gcl.cmd = vim.fn.stdpath 'config' .. '/bin/golangci-lint-tee'

    gcl.args = {
      find_golangci,
      'run',
      '--output.json.path=stdout',
      -- A repo .golangci.yml may pin the text format to stdout (backend does);
      -- the json flag ADDS a format rather than replacing it, and mixed
      -- text+json on stdout breaks nvim-lint's json parser -> zero diagnostics.
      '--output.text.path=/dev/null',
      '--show-stats=false',
      '--issues-exit-code=0',
      '--path-mode=abs', -- keep abs paths so nvim-lint's parser matches the buffer
      function()
        return vim.fn.expand '%:p:h'
      end,
    }

    -- Run golangci-lint with cwd = the buffer's own directory, not nvim's
    -- global cwd. When the repo is reached through a symlink (e.g.
    -- spacelift-io/backend -> local.dev/backend) nvim's cwd and the buffer's
    -- absolute path can use different spellings of the same location; go then
    -- considers the target dir "outside main module" and golangci-lint exits
    -- with code 7. Same-spelling cwd + target avoids that entirely.
    local function lint_buffer()
      gcl.cwd = vim.fn.expand '%:p:h'
      lint.try_lint()
    end

    local group = vim.api.nvim_create_augroup('nvim-lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
      group = group,
      callback = function()
        -- Skip unmodifiable/special buffers; only lint real files.
        if vim.bo.buftype == '' then
          lint_buffer()
        end
      end,
    })

    vim.keymap.set('n', '<leader>ll', lint_buffer, { desc = '[L]int buffer' })
  end,
}

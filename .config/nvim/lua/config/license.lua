-- "You forgot the license header" diagnostic.
--
-- Auto-scopes to repos that enforce license headers: the check only runs when
-- one of MARKERS is found walking up from the file (e.g. OpenTofu ships a
-- .licensei.toml). Everywhere else it stays silent, so personal repos that
-- don't use headers never get flagged.
--
-- Pure Lua — no external process — so it feeds the normal vim.diagnostic UI
-- (virtual text, <leader>x, :lua vim.diagnostic.jump, etc).

-- Config files that mean "this project checks license headers".
local MARKERS = { '.licensei.toml', '.copywrite.hcl', '.licenserc.yaml', '.licenserc.json' }

-- Filetypes worth checking. Kept narrow to avoid flagging docs/config/data.
local FILETYPES = {
  go = true,
  rust = true,
  c = true,
  cpp = true,
  python = true,
  sh = true,
  bash = true,
  lua = true,
  javascript = true,
  typescript = true,
  proto = true,
}

local PATTERN = 'SPDX%-License%-Identifier' -- what a present header looks like
local SCAN_LINES = 16 -- headers can sit below build tags / "Code generated" lines

local ns = vim.api.nvim_create_namespace 'license-header'

-- Memoize the upward marker search per directory; repos don't grow markers
-- mid-session, so this keeps BufRead cheap.
local enabled_cache = {}
local function project_enforces_headers(dir)
  if dir == nil or dir == '' then return false end
  local cached = enabled_cache[dir]
  if cached ~= nil then return cached end
  local found = #vim.fs.find(MARKERS, { upward = true, path = dir }) > 0
  enabled_cache[dir] = found
  return found
end

local function check(buf)
  if not vim.api.nvim_buf_is_valid(buf) then return end
  if vim.bo[buf].buftype ~= '' then return end
  if not FILETYPES[vim.bo[buf].filetype] then return end

  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then return end
  if not project_enforces_headers(vim.fs.dirname(name)) then return end

  local lines = vim.api.nvim_buf_get_lines(buf, 0, SCAN_LINES, false)
  for _, line in ipairs(lines) do
    if line:find(PATTERN) then
      vim.diagnostic.set(ns, buf, {}) -- header present: clear any stale diagnostic
      return
    end
  end

  vim.diagnostic.set(ns, buf, {
    {
      lnum = 0,
      col = 0,
      severity = vim.diagnostic.severity.WARN,
      source = 'license',
      message = 'You forgot the license header',
    },
  })
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  group = vim.api.nvim_create_augroup('license-header', { clear = true }),
  callback = function(ev) check(ev.buf) end,
})

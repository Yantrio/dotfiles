-- Single source of truth: filetype -> formatter list, consumed by conform.nvim
-- (`formatters_by_ft`). Tools are installed via `:Mason`.
--
-- For filetypes Biome supports we prefer Biome when the project defines it
-- (a biome.json is found upward from the file); otherwise we fall back to
-- Prettier. Everything else always uses Prettier.
local prettier = { 'prettierd', 'prettier', stop_after_first = true }

-- Use Biome if this buffer lives under a biome.json{,c}, else Prettier.
local function biome_or_prettier(bufnr)
  local dir = vim.fs.dirname(vim.api.nvim_buf_get_name(bufnr))
  if dir and dir ~= '' and #vim.fs.find({ 'biome.json', 'biome.jsonc' }, { upward = true, path = dir }) > 0 then return { 'biome' } end
  return prettier
end

return {
  lua = { 'stylua' },
  go = { 'goimports' },
  javascript = biome_or_prettier,
  javascriptreact = biome_or_prettier,
  typescript = biome_or_prettier,
  typescriptreact = biome_or_prettier,
  json = biome_or_prettier,
  jsonc = biome_or_prettier,
  css = biome_or_prettier,
  vue = prettier,
  scss = prettier,
  less = prettier,
  html = prettier,
  yaml = prettier,
  markdown = prettier,
  ['markdown.mdx'] = prettier,
  graphql = prettier,
  handlebars = prettier,
}

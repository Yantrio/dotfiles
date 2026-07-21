return {
  'rebelot/kanagawa.nvim',
  priority = 1000,
  ---@module 'kanagawa'
  ---@type KanagawaConfig
  opts = {
    commentStyle = { italic = true },
    functionStyle = { italic = true, bold = true },
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    colors = {
      theme = {
        all = {
          ui = {
            bg_gutter = 'none',
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      return {
        NormalFloat = { bg = theme.ui.bg_p1 },
        FloatBorder = { fg = theme.ui.special, bg = theme.ui.bg_p1 },
        WinSeparator = { fg = theme.ui.bg_m3 },
        CursorLine = { bg = theme.ui.bg_p1 },
        Visual = { bg = theme.ui.bg_p2 },
        TelescopeTitle = { fg = theme.ui.special, bold = true },
        TelescopePromptTitle = { fg = theme.ui.bg_m1, bg = theme.ui.special, bold = true },
        TelescopePreviewTitle = { fg = theme.ui.bg_m1, bg = theme.ui.fg_dim, bold = true },
        TelescopeResultsTitle = { fg = theme.ui.bg_m1, bg = theme.ui.fg_dim, bold = true },
        TelescopePromptNormal = { bg = theme.ui.bg_p1 },
        TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
        TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
        TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
        TelescopePreviewNormal = { bg = theme.ui.bg_dim },
        TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1, blend = vim.o.pumblend },
        PmenuSel = { fg = 'NONE', bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
      }
    end,
  },
  config = function(_, opts)
    require('kanagawa').setup(opts)
    vim.cmd.colorscheme 'kanagawa'
  end,
}

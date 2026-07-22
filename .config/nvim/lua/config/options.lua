vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true

-- Disable netrw in favor of neo-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.o.number = true
vim.o.termguicolors = true
vim.o.winblend = 5
vim.o.pumblend = 10
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.tabstop = 2 -- a literal tab renders 2 columns wide
vim.o.shiftwidth = 2 -- >> / << and autoindent shift by 2
vim.o.softtabstop = 2 -- <Tab>/<BS> feel like 2 columns when editing
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true

vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldtext = ''
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.fillchars = 'fold: '

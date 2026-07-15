vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Window focus
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Save / file ops
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>n', '<cmd>enew<CR>', { desc = 'New file' })
vim.keymap.set('n', '<leader>c', '<cmd>bdelete<CR>', { desc = 'Close buffer' })

-- Buffer cycle
vim.keymap.set('n', '<S-l>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<S-h>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })

-- Move lines
vim.keymap.set('n', '<A-j>', '<cmd>m .+1<CR>==', { desc = 'Move line down' })
vim.keymap.set('n', '<A-k>', '<cmd>m .-2<CR>==', { desc = 'Move line up' })
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Stay in visual after indent
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and stay' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and stay' })

-- Buffer ops
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>bD', '<cmd>bdelete!<CR>', { desc = 'Force delete buffer' })

-- UI toggles
vim.keymap.set('n', '<leader>uw', '<cmd>set wrap!<CR>', { desc = 'Toggle wrap' })
vim.keymap.set('n', '<leader>un', '<cmd>set number!<CR>', { desc = 'Toggle line numbers' })
vim.keymap.set('n', '<leader>ur', '<cmd>set relativenumber!<CR>', { desc = 'Toggle relative numbers' })
vim.keymap.set('n', '<leader>us', '<cmd>set spell!<CR>', { desc = 'Toggle spell' })
vim.keymap.set('n', '<leader>ul', '<cmd>set cursorline!<CR>', { desc = 'Toggle cursorline' })


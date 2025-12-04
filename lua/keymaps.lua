-- Enter is mapped to newline + ESC
vim.keymap.set('n', '<CR>', 'o<Esc>', { noremap = true, silent = true })

-- $ is mapped to last non blank char
vim.keymap.set('n', '$', '<Cmd>normal! g_<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '$', '<Cmd>normal! g_<CR>', { noremap = true, silent = true })

-- Clear Highlight
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear Search Highlight' })
vim.keymap.set('n', '<leader>q', ':bd<CR>', { desc = 'Close buffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

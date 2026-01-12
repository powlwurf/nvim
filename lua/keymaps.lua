-- Enter is mapped to newline + ESC
vim.keymap.set('n', '<CR>', 'o<Esc>', { noremap = true, silent = true })

-- $ is mapped to last non blank char
vim.keymap.set('n', '$', '<Cmd>normal! g_<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '$', '<Cmd>normal! g_<CR>', { noremap = true, silent = true })

-- Clear Highlight
vim.keymap.set('n', '<leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear Search Highlight' })
vim.keymap.set('n', '<leader>q', ':q<CR>', { desc = 'Close buffer' })

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Splits
vim.keymap.set('n', '<leader>wj', ':split<CR>', { silent = true })
vim.keymap.set('n', '<leader>wl', ':vsplit<CR>', { silent = true })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Toggle Commands
vim.keymap.set('n', '<leader>xg', function()
  require('gitsigns').toggle_current_line_blame()
end, { desc = 'Toggle Gitsigns Blame' })

vim.keymap.set('n', '<leader>xc', function()
  if vim.o.background == 'dark' then
    vim.o.background = 'light'
    vim.cmd.colorscheme 'tokyonight-day'
  else
    vim.o.background = 'dark'
    vim.cmd.colorscheme 'tokyonight'
  end
end, { desc = 'Toggle dark/light theme' })

vim.keymap.set('n', '<leader>xw', function()
  vim.o.wrap = not vim.o.wrap
end, { desc = 'Toggle wrap' })

vim.keymap.set('n', '<leader>e', function()
  require('neo-tree.command').execute { toggle = true, reveal_current_file = true }
end, { desc = 'Toggle Neo-tree & reveal current file' })

vim.keymap.set('n', '<leader>t', ':terminal<CR>', { silent = true })

-- Workaround to copy to clipboard, as the clipboard in options.lua somehow does not work
-- vim.keymap.set('x', 'Y', ":'<,'>w !clip.exe<CR>", { silent = true })

vim.keymap.set('n', '<leader>cw', function()
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = lnum })
  if diags and diags[1] then
    vim.fn.setreg('+', diags[1].message)
    print('Copied: ' .. diags[1].message)
  else
    print 'No diagnostic on this line'
  end
end, { desc = 'Copy diagnostic message' })

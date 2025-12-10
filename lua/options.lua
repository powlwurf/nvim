vim.g.have_nerd_font = true

vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.o.showmode = false

-- Sync clipboard between OS and Neovim.
-- outcommented: as its somehow not working on fedora 43 wsl
-- vim.schedule(function()
--   vim.o.clipboard = 'unnamedplus'
-- end)

-- Use spaces instead of tabs
vim.o.expandtab = true -- convert tabs to spaces

local function set_indent_and_disable_comment(ft, tabstop, shiftwidth)
  vim.api.nvim_create_autocmd('FileType', {
    pattern = ft,
    callback = function()
      vim.bo.expandtab = true
      vim.bo.tabstop = tabstop
      vim.bo.softtabstop = tabstop
      vim.bo.shiftwidth = shiftwidth
      vim.bo.autoindent = true
      vim.bo.smartindent = false

      vim.bo.comments = '' -- disable auto comment continuation
      vim.opt_local.formatoptions:remove { 'r', 'o', 'c' }
    end,
  })
end

-- Lua: 2 spaces
set_indent_and_disable_comment({ 'lua' }, 2, 2)

-- C/C++: 4 spaces
set_indent_and_disable_comment({ 'c', 'cpp', 'h', 'hpp' }, 4, 4)

-- Enable break indent
vim.o.breakindent = true
vim.opt.equalprg = ''
vim.opt.indentexpr = ''

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.o.signcolumn = 'yes'

-- Prevent comments from continuing on a new line
vim.opt.formatoptions:remove { 'r', 'o' }

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣', extends = '>' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'nosplit'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- instead raise a dialog asking if you wish to save the current file(s)
vim.o.confirm = true

vim.opt.shell = '/usr/sbin/fish'

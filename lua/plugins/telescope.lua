return { -- Fuzzy Finder (files, lsp, etc)
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = 'make',

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  config = function()
    local actions = require 'telescope.actions'

    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-f>'] = actions.to_fuzzy_refine, -- toggle file-only mode
          },
          n = {
            ['<C-f>'] = actions.to_fuzzy_refine,
          },
        },
        layout_strategy = 'vertical',
        layout_config = {
          horizontal = { preview_width = 0.6 },
          vertical = { preview_height = 0.5 },
          width = 0.9,
          height = 0.85,
        },
        sorting_strategy = 'ascending',
        prompt_prefix = '  ',
        pickers = {
          current_buffer_fuzzy_find = {
            layout_strategy = 'vertical', -- tall vertical window
            layout_config = {
              vertical = {
                mirror = false,
                preview_height = 0.6, -- optional preview height
              },
              width = 0.9, -- 90% of terminal width
              height = 0.8, -- 80% of terminal height
            },
            sorting_strategy = 'ascending', -- top matches first
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopePromptNormal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopePromptBorder', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsNormal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopeResultsBorder', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewNormal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'TelescopePreviewBorder', { bg = 'NONE' })

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    -- vim.keymap.set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep with preview on right' })

    vim.keymap.set('v', '<leader>s', function()
      -- Leave visual mode first (VERY important)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)

      -- Now get the finalized visual selection
      local startPos = vim.fn.getpos "'<"
      local endPos = vim.fn.getpos "'>"

      local ls, cs = startPos[2], startPos[3]
      local le, ce = endPos[2], endPos[3]

      local lines = vim.fn.getline(ls, le)
      if #lines == 0 then
        return
      end

      -- Slice selection correctly
      lines[1] = string.sub(lines[1], cs)
      lines[#lines] = string.sub(lines[#lines], 1, ce)

      local selected = table.concat(lines, '\n')
      if selected == '' then
        return
      end

      -- Default folder = folder of current file
      local default_dir = vim.fn.expand '%:p:h' .. '/'

      -- Ask user for folder
      vim.ui.input({
        prompt = 'Folder to grep: ',
        default = default_dir,
      }, function(folder)
        if not folder or folder == '' then
          return
        end

        require('telescope.builtin').live_grep {
          cwd = folder,
          default_text = selected,
          layout_strategy = 'vertical',
          layout_config = {
            vertical = { mirror = true, preview_height = 0.4 },
            width = 0.9,
            height = 0.85,
          },
          sorting_strategy = 'ascending',
        }
      end)
    end, { desc = 'Live grep visual selection in chosen folder' })

    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    vim.keymap.set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
    -- Keymap: choose folder → live_grep inside it
    vim.keymap.set('n', '<leader>ss', function()
      local default_dir = vim.fn.expand '%:p:h' -- current file's folder

      vim.ui.input({
        prompt = 'Folder to grep: ',
        default = default_dir .. '/',
      }, function(folder)
        if folder and folder ~= '' then
          builtin.live_grep { cwd = folder }
        end
      end)
    end, { desc = 'Live grep in chosen folder (default = current file folder)' })

    vim.keymap.set('n', '<leader>/', function()
      builtin.current_buffer_fuzzy_find {
        layout_strategy = 'vertical',
        layout_config = {
          height = 0.8, -- 80% of terminal height
          width = 0.85, -- 85% of terminal width
          preview_cutoff = 0, -- always show results
        },
        sorting_strategy = 'ascending',
      }
    end, { desc = '[/] Fuzzily search in current buffer' })
    -- Slightly advanced example of overriding default behavior and theme
    -- vim.keymap.set('n', '<leader>/', function()
    --   -- You can pass additional configuration to Telescope to change the theme, layout, etc.
    --   builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    --     winblend = 10,
    --     previewer = false,
    --   })
    -- end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    vim.keymap.set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}

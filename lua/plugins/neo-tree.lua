-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },

  lazy = false,
  opts = {
    default_component_configs = {
      git_status = {
        symbols = {
          added = '',
          modified = '',
          deleted = '',
          renamed = '',
          untracked = '',
          ignored = '',
          unstaged = '',
          staged = '',
          conflict = '',
        },
      },
    },
    filesystem = {
      follow_current_file = true,
      filtered_items = {
        visible = true,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id() -- This gives the absolute path
            vim.fn.setreg('+', filepath) -- Copies to system clipboard
            vim.notify('Copied path: ' .. filepath)
          end,
        },
      },
    },
  },
}

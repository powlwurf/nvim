return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    cmake_build_preset = 'release',
    cmake_build_options = {
      '--parallel',
      '8',
    },
    cmake_executor = {
      name = 'terminal',
      opts = {
        direction = 'horizontal',
        size = 20,
      },
    },
  },
  config = function(_, opts)
    require('cmake-tools').setup(opts)
    vim.keymap.set('n', '<leader>cb', '<cmd>CMakeBuild<cr>', { desc = 'CMake Build' })
    vim.keymap.set('n', '<leader>ct', '<cmd>CMakeRunTest<cr>', { desc = 'Run Test selected target' })
  end,
}

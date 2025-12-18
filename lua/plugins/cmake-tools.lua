return {
  'Civitasv/cmake-tools.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    cmake_build_preset = 'release',
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
    -- vim.keymap.set('n', '<leader>cb', '<cmd>CMakeBuild --parallel 8 > build-release/build.output.log 2>&1<cr>', { desc = 'CMake Build' })

    vim.keymap.set('n', '<leader>cb', function()
      local exit_file = '/home/paul/.local/share/nvim/cmake-tools-tmp/exit_code'

      -- Delete old file if it exists
      if vim.fn.filereadable(exit_file) == 1 then
        os.remove(exit_file)
      end

      -- Start the build
      vim.cmd 'CMakeBuild --parallel 8 > build-release/build.output.log 2>&1'

      -- Poll the exit code file until it exists (timeout after 30s)
      local timeout = 30
      local interval = 100 -- ms
      local elapsed = 0

      local timer = vim.loop.new_timer()
      timer:start(
        interval,
        interval,
        vim.schedule_wrap(function()
          elapsed = elapsed + interval / 1000
          if vim.fn.filereadable(exit_file) == 1 then
            local lines = vim.fn.readfile(exit_file)
            local msg = table.concat(lines, ' ')
            local ok = (msg == '0')

            vim.notify(ok and '✔ Build succeeded' or '✘ Build failed', ok and vim.log.levels.INFO or vim.log.levels.ERROR)

            timer:stop()
            timer:close()
          elseif elapsed >= timeout then
            vim.notify('Timeout waiting for build to finish', vim.log.levels.WARN)
            timer:stop()
            timer:close()
          end
        end)
      )
    end, { desc = 'CMakeBuild + wait and show exit code' })
    vim.keymap.set('n', '<leader>ct', '<cmd>CMakeRunTest --verbose<cr>', { desc = 'Run Test selected target' })
    vim.keymap.set('n', '<leader>cl', function()
      local build_dir = 'build-release' -- adjust if your build dir is different
      local log_path = build_dir .. '/Testing/Temporary/LastTest.log'

      -- Check if the file exists
      if vim.fn.filereadable(log_path) == 0 then
        vim.notify('CTest log not found: ' .. log_path, vim.log.levels.WARN)
        return
      end

      -- Open vertical split on the right
      vim.cmd('vsplit ' .. log_path)
    end, { desc = 'Open Last CTest Log' })
    vim.keymap.set('n', '<leader>co', function()
      local build_dir = 'build-release' -- adjust if your build dir is different
      local log_path = build_dir .. '/build.output.log'

      -- Check if the file exists
      if vim.fn.filereadable(log_path) == 0 then
        vim.notify('Build output log not found: ' .. log_path, vim.log.levels.WARN)
        return
      end

      -- Open vertical split on the right
      vim.cmd('vsplit ' .. log_path)
    end, { desc = 'Open Last Build Log' })
  end,
}

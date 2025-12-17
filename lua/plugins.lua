require('lazy').setup {
  'NMAC427/guess-indent.nvim', -- Detect tabstop and shiftwidth automatically

  require 'plugins.telescope',
  require 'plugins.lazydev',
  require 'plugins.lsp',
  require 'plugins.autoformat',
  require 'plugins.autocompletion',
  require 'plugins.colorscheme',
  require 'plugins.comments',
  require 'plugins.comments2',
  require 'plugins.mini',
  require 'plugins.treesitter',
  require 'plugins.neo-tree',
  require 'plugins.gitsigns',
  require 'plugins.guess-indent',
  require 'plugins.markdown',
  require 'plugins.cmake-tools',
  require 'plugins.autosave',
}

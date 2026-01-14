return {
  'folke/tokyonight.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('tokyonight').setup {
      styles = {
        comments = { italic = false }, -- Disable italics in comments
      },
    }

    -- Load the colorscheme here.
    -- Like many other themes, this one has different styles, and you could load
    -- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
    vim.cmd.colorscheme 'tokyonight-night'

    -- 🔥 Transparency fix (Windows Terminal friendly)
    vim.api.nvim_create_autocmd('ColorScheme', {
      callback = function()
        local groups = {
          'Normal',
          'NormalNC',
          'NormalFloat',
          'FloatBorder',

          'TelescopeNormal',
          'TelescopeBorder',
          'TelescopePromptNormal',
          'TelescopePromptBorder',
          'TelescopeResultsNormal',
          'TelescopePreviewNormal',
        }

        for _, group in ipairs(groups) do
          vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
        end
      end,
    })
  end,
}

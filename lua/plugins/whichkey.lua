-- ============================================================================
-- Which-Key: Keybinding Helper
-- ============================================================================
-- Shows available keybindings as you type
-- Essential for learning and discovering features

return {
  'folke/which-key.nvim',
  event = 'VimEnter',
  config = function()
    require('which-key').setup()

    -- Document key groups
    require('which-key').add({
      { '<leader>c', group = 'Code' },
      { '<leader>f', group = 'Find' },
      { '<leader>s', group = 'Search' },
      { '<leader>g', group = 'Git' },
      { '<leader>t', group = 'Toggle' },
    })
  end,
}

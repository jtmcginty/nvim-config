-- ============================================================================
-- Extra Plugins: Quality of Life Improvements
-- ============================================================================

return {
  -- Auto-detect indentation
  { 'tpope/vim-sleuth' },

  -- Surround text objects (ys, cs, ds)
  {
    'kylechui/nvim-surround',
    event = 'VeryLazy',
    config = true,
  },

  -- Auto-close brackets
  {
    'windwp/nvim-autopairs',
    event = 'InsertEnter',
    config = true,
  },

  -- Comment with gc
  {
    'numToStr/Comment.nvim',
    opts = {},
  },

  -- Better statusline
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
    },
  },
}

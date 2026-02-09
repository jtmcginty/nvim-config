-- ============================================================================
-- Extra Plugins: Quality of Life Improvements
-- ============================================================================

return {
  -- Auto-detect indentation
  { 'tpope/vim-sleuth' },

  -- Keep window proportions when opening/closing buffers
  {
    'kwkarlwang/bufresize.nvim',
    config = function()
      require('bufresize').setup()
    end,
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
    dependencies = { 'echasnovski/mini.nvim' },  -- For mini.icons
    opts = {
      options = {
        theme = 'catppuccin',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  -- Command palette for keymaps, commands, autocmds
  {
    'mrjones2014/legendary.nvim',
    lazy = false,
    dependencies = { 'kkharji/sqlite.lua' },
    keys = {
      { '<leader>p', '<cmd>Legendary<cr>', desc = 'Command Palette' },
    },
    config = function()
      require('legendary').setup({
        commands = {
          -- Plugin managers & tools
          { ':Mason', description = 'Open Mason LSP installer' },
          { ':Lazy', description = 'Open Lazy plugin manager' },
          { ':checkhealth', description = 'Run health checks' },
          
          -- LSP & diagnostics
          { ':LspInfo', description = 'Show LSP info' },
          { ':LspRestart', description = 'Restart LSP server' },
          { ':Trouble', description = 'Open diagnostics' },
          
          -- File navigation
          { ':Telescope', description = 'Open Telescope' },
          { ':Neotree', description = 'Toggle file tree' },
          
          -- Git
          { ':Gitsigns', description = 'Git signs commands' },
          
          -- Formatting
          { ':ConformInfo', description = 'Show formatter info' },
          
          -- Database
          { ':DBUI', description = 'Open database UI' },
          { ':DBUIToggle', description = 'Toggle database UI' },
          
          -- Utilities
          { ':UndotreeToggle', description = 'Toggle undo tree' },
          { ':MarkdownPreview', description = 'Preview markdown' },
          { ':Copilot', description = 'Copilot commands' },
          { ':VimBeGood', description = 'Practice Vim motions (basic)' },
        },
        extensions = {
          lazy_nvim = { auto_register = true },
          which_key = { auto_register = true },
        },
        include_builtin = true,
        include_legendary_cmds = true,
      })
    end,
  },

  -- Vim motion practice games
  {
    'ThePrimeagen/vim-be-good',
    cmd = 'VimBeGood',
  },
}

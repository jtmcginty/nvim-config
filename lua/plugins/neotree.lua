-- ============================================================================
-- Neo-tree: File Explorer
-- ============================================================================
-- Sidebar file browser with git integration

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'echasnovski/mini.nvim',  -- For mini.icons
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree toggle<CR>', desc = 'Toggle file Explorer', silent = true },
    { '<leader>o', ':Neotree reveal<CR>', desc = 'Reveal current file in explorer', silent = true },
  },
  opts = {
    close_if_last_window = false,
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = { enabled = true },
      filtered_items = {
        visible = true, -- Show hidden files (dimmed)
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      width = 35,
      mappings = {
        ['\\'] = 'close_window', -- Press \ again to close
      },
    },
  },
}

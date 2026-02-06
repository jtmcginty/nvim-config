-- ============================================================================
-- Mini.nvim: Swiss Army Knife Plugin
-- ============================================================================
-- Collection of small, independent modules for various features

return {
  'echasnovski/mini.nvim',
  version = '*',
  config = function()
    -- Mini.statusline - Clean status bar at bottom
    require('mini.statusline').setup({
      use_icons = vim.g.have_nerd_font or true,
      set_vim_settings = false,
    })

    -- Mini.surround - Add/delete/replace surrounding characters
    -- Usage:
    --   sa"  - Surround with quotes
    --   sd"  - Delete surrounding quotes
    --   sr"' - Replace quotes with single quotes
    require('mini.surround').setup({
      mappings = {
        add = 'sa',            -- Add surrounding in Normal and Visual modes
        delete = 'sd',         -- Delete surrounding
        find = 'sf',           -- Find surrounding (to the right)
        find_left = 'sF',      -- Find surrounding (to the left)
        highlight = 'sh',      -- Highlight surrounding
        replace = 'sr',        -- Replace surrounding
        update_n_lines = 'sn', -- Update `n_lines`
      },
    })
  end,
}

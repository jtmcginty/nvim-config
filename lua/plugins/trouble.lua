-- ============================================================================
-- Trouble: Better Diagnostics UI
-- ============================================================================
-- Pretty list for diagnostics, references, quickfix, and more

return {
  'folke/trouble.nvim',
  enabled = true,
  dependencies = { 'echasnovski/mini.nvim' },  -- For mini.icons
  cmd = 'Trouble',
  event = 'VeryLazy', -- Load after startup is complete
  keys = {
    { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Diagnostics (Trouble)' },
    { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>', desc = 'Buffer Diagnostics (Trouble)' },
    { '<leader>xs', '<cmd>Trouble symbols toggle focus=false<cr>', desc = 'Symbols (Trouble)' },
    { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>', desc = 'LSP Definitions / references / ... (Trouble)' },
    { '<leader>xq', '<cmd>Trouble qflist toggle<cr>', desc = 'Quickfix List (Trouble)' },
  },
  opts = {
    auto_close = true,
    auto_open = false,
    auto_preview = false,
    auto_refresh = false,
  },
}

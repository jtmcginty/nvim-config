-- ============================================================================
-- Todo Comments: Highlight TODO, FIXME, NOTE, etc. in comments
-- ============================================================================
-- Makes special comment keywords stand out with colors

return {
  'folke/todo-comments.nvim',
  event = 'VimEnter',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = { signs = false },
}

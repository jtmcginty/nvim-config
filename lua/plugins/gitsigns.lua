-- ============================================================================
-- Gitsigns: Git Integration
-- ============================================================================
-- Shows git changes in the gutter and provides git operations

return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns

      local function map(mode, l, r, desc)
        vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
      end

      -- Navigation
      map('n', ']h', gs.next_hunk, 'Next git hunk')
      map('n', '[h', gs.prev_hunk, 'Previous git hunk')

      -- Actions
      map('n', '<leader>gs', gs.stage_hunk, 'Git: Stage hunk')
      map('n', '<leader>gr', gs.reset_hunk, 'Git: Reset hunk')
      map('v', '<leader>gs', function()
        gs.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Git: Stage hunk')
      map('v', '<leader>gr', function()
        gs.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') })
      end, 'Git: Reset hunk')

      map('n', '<leader>gS', gs.stage_buffer, 'Git: Stage buffer')
      map('n', '<leader>gu', gs.undo_stage_hunk, 'Git: Undo stage hunk')
      map('n', '<leader>gR', gs.reset_buffer, 'Git: Reset buffer')
      map('n', '<leader>gp', gs.preview_hunk, 'Git: Preview hunk')
      map('n', '<leader>gb', function()
        gs.blame_line({ full = true })
      end, 'Git: Blame line')
      map('n', '<leader>gd', gs.diffthis, 'Git: Diff this')
    end,
  },
}

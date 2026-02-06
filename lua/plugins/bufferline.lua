-- ============================================================================
-- Bufferline: Visual Buffer Tabs
-- ============================================================================
-- Shows open buffers as tabs at the top of the screen

return {
  'akinsho/bufferline.nvim',
  version = '*',
  dependencies = 'nvim-tree/nvim-web-devicons',
  event = 'VeryLazy',
  config = function()
    require('bufferline').setup({
      options = {
        mode = 'buffers',
        themable = true,
        numbers = 'none',
        close_command = 'bdelete! %d',
        right_mouse_command = 'bdelete! %d',
        left_mouse_command = 'buffer %d',
        middle_mouse_command = nil,
        -- Filter out terminal buffers (like Kiro)
        custom_filter = function(buf_number)
          local buftype = vim.bo[buf_number].buftype
          return buftype ~= 'terminal'
        end,
        indicator = {
          style = 'underline',
        },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        diagnostics = 'nvim_lsp',
        diagnostics_indicator = function(count, level)
          local icon = level:match('error') and ' ' or ' '
          return ' ' .. icon .. count
        end,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = 'thin',
        always_show_bufferline = false,
      },
    })

    -- Keymaps for buffer navigation
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
    vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', { desc = 'Close other buffers' })
  end,
}

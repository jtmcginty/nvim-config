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
        numbers = 'ordinal', -- Show buffer numbers for quick jumping
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
          style = 'icon',
          icon = '▎',
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
            text = '󰙅 File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = 'slant', -- Slanted tabs look modern
        always_show_bufferline = true,
        hover = {
          enabled = true,
          delay = 200,
          reveal = {'close'}
        },
      },
    })

    -- Keymaps for buffer navigation
    vim.keymap.set('n', ']b', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    vim.keymap.set('n', '[b', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Previous buffer' })
    vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Close buffer' })
    vim.keymap.set('n', '<leader>bo', '<cmd>BufferLineCloseOthers<CR>', { desc = 'Close other buffers' })
    
    -- Quick jump to buffer by number
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', 
        { desc = 'Go to buffer ' .. i })
    end
  end,
}

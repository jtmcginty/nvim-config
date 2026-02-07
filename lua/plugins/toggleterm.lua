-- ============================================================================
-- Toggleterm: Floating Terminal Management
-- ============================================================================
-- Provides floating terminals and Lazygit integration

return {
  'akinsho/toggleterm.nvim',
  version = '*',
  keys = {
    { '<leader>tt', '<cmd>ToggleTerm direction=float<cr>', desc = 'Toggle terminal', mode = { 'n', 't' } },
    { '<leader>gg', '<cmd>lua _lazygit_toggle()<cr>', desc = 'Lazygit' },
  },
  config = function()
    require('toggleterm').setup({
      size = 20,
      hide_numbers = true,
      shade_terminals = true,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
      },
    })

    -- Make Esc Esc close the terminal
    vim.keymap.set('t', '<Esc><Esc>', '<cmd>ToggleTerm<cr>', { desc = 'Close terminal' })

    -- Lazygit integration
    local Terminal = require('toggleterm.terminal').Terminal
    local lazygit = Terminal:new({
      cmd = 'lazygit',
      direction = 'float',
      hidden = true,
      float_opts = {
        border = 'curved',
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
      },
      on_open = function(term)
        -- Make Esc Esc close lazygit too
        vim.keymap.set('t', '<Esc><Esc>', '<cmd>close<cr>', { buffer = term.bufnr })
      end,
    })

    function _lazygit_toggle()
      lazygit:toggle()
    end
  end,
}

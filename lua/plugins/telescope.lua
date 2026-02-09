-- ============================================================================
-- Telescope: Fuzzy Finder
-- ============================================================================
-- Find files, search text, browse buffers, and more
-- This is your primary navigation tool

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable('make') == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'echasnovski/mini.nvim' },  -- For mini.icons
  },
  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = { 'node_modules', '.git', '.venv', '__pycache__' },
        layout_config = {
          horizontal = { preview_width = 0.55 },
        },
      },
      pickers = {
        find_files = {
          hidden = true, -- Show hidden files
        },
        live_grep = {
          additional_args = function()
            return { '--hidden' }
          end,
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Load extensions
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')

    -- Keymaps
    local builtin = require('telescope.builtin')
    
    -- Files
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find Files' })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = 'Find Recent files' })
    vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Find Buffers' })
    
    -- Search
    vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Search by Grep' })
    vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search Word under cursor' })
    vim.keymap.set('n', '<leader>/', builtin.current_buffer_fuzzy_find, { desc = 'Search in current buffer' })
    
    -- Help
    vim.keymap.set('n', '<leader>sh', builtin.help_tags, { desc = 'Search Help' })
    vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = 'Search Keymaps' })
    
    -- LSP
    vim.keymap.set('n', '<leader>sd', builtin.diagnostics, { desc = 'Search Diagnostics' })
    vim.keymap.set('n', '<leader>ss', builtin.lsp_document_symbols, { desc = 'Search document Symbols' })
    vim.keymap.set('n', '<leader>sS', builtin.lsp_dynamic_workspace_symbols, { desc = 'Search workspace Symbols' })
    
    -- Config
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files({ cwd = vim.fn.stdpath('config') })
    end, { desc = 'Search Neovim config' })
  end,
}

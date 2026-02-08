-- ============================================================================
-- Treesitter: Advanced Syntax Highlighting
-- ============================================================================

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile' },
    config = function()
      local ok, configs = pcall(require, 'nvim-treesitter.configs')
      if not ok then
        return
      end
      configs.setup({
        ensure_installed = { 'lua', 'python', 'javascript', 'typescript', 'rust', 'go', 'bash', 'markdown', 'json', 'yaml' },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- Setup textobjects
      require('nvim-treesitter-textobjects').setup({
        select = {
          lookahead = true,
        },
        move = {
          set_jumps = true,
        },
      })
      
      -- Text object keymaps
      local modes = { 'n', 'x', 'o' }
      vim.keymap.set(modes, 'af', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@function.outer', 'textobjects') 
      end, { desc = 'Select around function' })
      
      vim.keymap.set(modes, 'if', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@function.inner', 'textobjects') 
      end, { desc = 'Select inside function' })
      
      vim.keymap.set(modes, 'ac', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@class.outer', 'textobjects') 
      end, { desc = 'Select around class' })
      
      vim.keymap.set(modes, 'ic', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@class.inner', 'textobjects') 
      end, { desc = 'Select inside class' })
      
      vim.keymap.set(modes, 'aa', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.outer', 'textobjects') 
      end, { desc = 'Select around parameter' })
      
      vim.keymap.set(modes, 'ia', function() 
        require('nvim-treesitter-textobjects.select').select_textobject('@parameter.inner', 'textobjects') 
      end, { desc = 'Select inside parameter' })
      
      -- Navigation keymaps
      vim.keymap.set(modes, ']m', function() 
        require('nvim-treesitter-textobjects.move').goto_next_start('@function.outer', 'textobjects') 
      end, { desc = 'Next function start' })
      
      vim.keymap.set(modes, '[m', function() 
        require('nvim-treesitter-textobjects.move').goto_previous_start('@function.outer', 'textobjects') 
      end, { desc = 'Previous function start' })
      
      vim.keymap.set(modes, ']k', function() 
        require('nvim-treesitter-textobjects.move').goto_next_start('@class.outer', 'textobjects') 
      end, { desc = 'Next class start' })
      
      vim.keymap.set(modes, '[k', function() 
        require('nvim-treesitter-textobjects.move').goto_previous_start('@class.outer', 'textobjects') 
      end, { desc = 'Previous class start' })
    end,
  },
}

-- ============================================================================
-- Leader key
-- ============================================================================
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- ============================================================================
-- System clipboard integration
-- ============================================================================

-- Use system clipboard by default
vim.opt.clipboard = 'unnamedplus'



-- ============================================================================
-- Kiro terminal keybinding
-- ============================================================================

-- Open Kiro in narrow vertical split on far right
vim.keymap.set('n', '<C-\\>', function()
  vim.cmd('botright vsplit')  -- Open on far right
  vim.cmd('vertical resize 50')  -- 80 columns wide
  vim.cmd('terminal kiro-cli chat')
  vim.cmd('startinsert')
end, { desc = 'Open Kiro in terminal split' })

-- Terminal mode window navigation (works while in terminal)
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: Move to left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: Move to right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: Move to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: Move to upper window' })

-- Auto-enter insert mode when entering terminal buffer
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = 'term://*',
  callback = function()
    vim.cmd('startinsert')
  end,
})

-- Jump directly to rightmost window (Kiro terminal)
vim.keymap.set('n', '<leader>k', '<C-w>l', { desc = 'Jump to Kiro terminal' })

-- Window navigation with Ctrl+Arrow keys
vim.keymap.set('n', '<C-Left>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-Right>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-Down>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-Up>', '<C-w>k', { desc = 'Move to upper window' })

-- Also in terminal mode
vim.keymap.set('t', '<C-Left>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: Move to left window' })
vim.keymap.set('t', '<C-Right>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: Move to right window' })
vim.keymap.set('t', '<C-Down>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: Move to lower window' })
vim.keymap.set('t', '<C-Up>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: Move to upper window' })

-- ============================================================================
-- Editor Settings
-- ============================================================================

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Indentation
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- UI
vim.opt.termguicolors = true
vim.opt.signcolumn = 'yes'
vim.opt.cursorline = true
vim.opt.wrap = false

-- Splits
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Backup and undo
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"

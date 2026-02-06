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
  vim.cmd('botright vsplit')    -- Open on far right
  vim.cmd('vertical resize 42') -- 45 columns wide
  vim.cmd('terminal kiro-cli chat')
  vim.cmd('startinsert')
  -- Make window fixed width
  vim.wo.winfixwidth = true
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

-- Window navigation with Ctrl+hjkl (standard vim)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to upper window' })

-- ============================================================================
-- Editor Settings
-- ============================================================================

-- Clear search highlights on <Esc>
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Auto-center screen after jumps
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Jump down half page (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Jump up half page (centered)' })
vim.keymap.set('n', 'G', 'Gzz', { desc = 'Jump to end of file (centered)' })

-- Move selected lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selection down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selection up' })

-- Keep cursor in place when joining lines
vim.keymap.set('n', 'J', 'mzJ`z', { desc = 'Join lines (keep cursor position)' })

-- Disable Q (prevents accidental macro replay)
vim.keymap.set('n', 'Q', '<nop>', { desc = 'Disabled' })

-- Easier terminal exit
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Toggle line wrap
vim.keymap.set('n', '<leader>tw', function()
  vim.opt.wrap = not vim.opt.wrap:get()
  print('Line wrap: ' .. (vim.opt.wrap:get() and 'ON' or 'OFF'))
end, { desc = 'Toggle line wrap' })

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

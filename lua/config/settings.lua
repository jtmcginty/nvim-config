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

-- Helper to check if Kiro terminal exists
local function get_kiro_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("term://.*kiro") then
      return win, buf
    end
  end
  return nil, nil
end

-- Helper to check if Claude terminal exists
local function get_claude_window()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local bufname = vim.api.nvim_buf_get_name(buf)
    if bufname:match("term://.*claude") then
      return win, buf
    end
  end
  return nil, nil
end

-- Helper to kill Kiro process in buffer
local function kill_kiro_process(buf)
  local chan = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
  if chan then
    vim.fn.jobstop(chan)
  end
end

-- Helper to kill Claude process in buffer
local function kill_claude_process(buf)
  local chan = vim.api.nvim_buf_get_var(buf, 'terminal_job_id')
  if chan then
    vim.fn.jobstop(chan)
  end
end

-- Toggle Kiro terminal: open if closed, close if open
vim.keymap.set('n', '<C-\\>', function()
  local kiro_win, kiro_buf = get_kiro_window()

  if kiro_win then
    -- Kiro is open, kill process and close window
    kill_kiro_process(kiro_buf)
    vim.api.nvim_win_close(kiro_win, false)
    vim.api.nvim_buf_delete(kiro_buf, { force = true })
  else
    -- Kiro is closed, open it
    vim.cmd('botright vsplit')
    vim.cmd('vertical resize 42')
    vim.cmd('terminal kiro-cli chat')
    vim.cmd('startinsert')
    vim.wo.winfixwidth = true
  end
end, { desc = 'Toggle Kiro terminal' })

-- Toggle Claude terminal: open if closed, close if open
vim.keymap.set({ 'n', 't' }, '<M-\\>', function()
  local claude_win, claude_buf = get_claude_window()

  if claude_win then
    -- Claude is open, kill process and close window
    kill_claude_process(claude_buf)
    vim.api.nvim_win_close(claude_win, false)
    vim.api.nvim_buf_delete(claude_buf, { force = true })
  else
    -- Claude is closed, open it
    vim.cmd('botright vsplit')
    vim.cmd('vertical resize 42')
    vim.cmd('terminal claude')
    vim.cmd('startinsert')
    vim.wo.winfixwidth = true
  end
end, { desc = 'Toggle Claude terminal' })

-- Also allow closing from terminal mode with Ctrl+\
vim.keymap.set('t', '<C-\\>', function()
  local kiro_win, kiro_buf = get_kiro_window()
  if kiro_win and kiro_buf then
    kill_kiro_process(kiro_buf)
    vim.api.nvim_win_close(kiro_win, false)
    vim.api.nvim_buf_delete(kiro_buf, { force = true })
  end
end, { desc = 'Close Kiro terminal' })

-- Terminal mode window navigation (works while in terminal)
vim.keymap.set('t', '<C-h>', '<C-\\><C-n><C-w>h', { desc = 'Terminal: Move to left window' })
vim.keymap.set('t', '<C-l>', '<C-\\><C-n><C-w>l', { desc = 'Terminal: Move to right window' })
vim.keymap.set('t', '<C-j>', '<C-\\><C-n><C-w>j', { desc = 'Terminal: Move to lower window' })
vim.keymap.set('t', '<C-k>', '<C-\\><C-n><C-w>k', { desc = 'Terminal: Move to upper window' })

-- Load kiro-preview for AI file watching
require("kiro-preview").setup()

-- Cleanup Kiro and Claude processes on Neovim exit
vim.api.nvim_create_autocmd('VimLeavePre', {
  callback = function()
    local _, kiro_buf = get_kiro_window()
    if kiro_buf then
      kill_kiro_process(kiro_buf)
    end
    local _, claude_buf = get_claude_window()
    if claude_buf then
      kill_claude_process(claude_buf)
    end
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
-- Quickfix Navigation
-- ============================================================================

-- Navigate quickfix list (LSP diagnostics, grep results, etc.)
vim.keymap.set('n', ']q', '<cmd>cnext<CR>', { desc = 'Next quickfix item' })
vim.keymap.set('n', '[q', '<cmd>cprev<CR>', { desc = 'Previous quickfix item' })
vim.keymap.set('n', '<leader>qo', '<cmd>copen<CR>', { desc = 'Open quickfix list' })
vim.keymap.set('n', '<leader>qc', '<cmd>cclose<CR>', { desc = 'Close quickfix list' })

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

-- Folding (for nvim-ufo)
vim.opt.foldcolumn = '0'
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

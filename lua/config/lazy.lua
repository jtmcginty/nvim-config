-- ============================================================================
-- Lazy.nvim Plugin Manager Setup
-- ============================================================================
-- Lazy.nvim automatically installs itself and manages all plugins

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'

-- Auto-install lazy.nvim if not present
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

-- Load all plugins from lua/plugins/*.lua
require('lazy').setup('plugins', {
  change_detection = {
    notify = false, -- Don't notify on config changes
  },
})

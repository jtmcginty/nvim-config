-- ============================================================================
-- Performance Optimizations
-- ============================================================================

-- Faster updatetime for better responsiveness
vim.opt.updatetime = 100

-- Reduce redraw frequency
vim.opt.lazyredraw = false -- Keep false for smooth scrolling

-- Faster completion
vim.opt.timeoutlen = 300

-- Better scrolling performance
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8

-- Disable some providers for faster startup
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Optimize LSP for performance
vim.lsp.set_log_level("off") -- Disable LSP logging

-- Debounce diagnostics updates
vim.diagnostic.config({
  update_in_insert = false, -- Don't update diagnostics while typing
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  signs = true,
  underline = true,
  severity_sort = true,
})

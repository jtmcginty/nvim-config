-- ============================================================================
-- Autopairs: Auto-close Brackets and Quotes
-- ============================================================================
-- Automatically closes brackets, quotes, and other pairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    require('nvim-autopairs').setup({
      check_ts = true, -- Use treesitter for better pair detection
      ts_config = {
        lua = { 'string' }, -- Don't add pairs in lua string treesitter nodes
        javascript = { 'template_string' },
      },
      disable_filetype = { 'TelescopePrompt' },
    })
  end,
}

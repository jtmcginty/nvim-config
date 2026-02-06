-- ============================================================================
-- Theme: Catppuccin
-- ============================================================================
-- A soothing pastel theme with great contrast and plugin support

return {
  'catppuccin/nvim',
  name = 'catppuccin',
  priority = 1000, -- Load before other plugins
  config = function()
    require('catppuccin').setup({
      flavour = 'mocha', -- mocha, macchiato, frappe, latte
      transparent_background = false,
      integrations = {
        telescope = true,
        harpoon = true,
        mason = true,
        neotree = true,
        which_key = true,
        gitsigns = true,
        treesitter = true,
      },
    })
    vim.cmd.colorscheme('catppuccin')
  end,
}

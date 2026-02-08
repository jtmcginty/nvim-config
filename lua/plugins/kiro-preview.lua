-- Kiro Live Preview
-- Auto-opens files in main pane when they're written while Kiro is active

return {
  {
    "kiro-preview",
    dir = vim.fn.stdpath("config") .. "/lua/kiro-preview",
    lazy = false,
    priority = 1000,
    config = function()
      require("kiro-preview").setup()
    end,
  },
}

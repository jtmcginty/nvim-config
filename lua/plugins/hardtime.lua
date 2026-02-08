-- hardtime.nvim - Learn better Vim motions through hints
return {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {
    enabled = true,
    max_count = 3, -- Show hint after 3 repeated keys
    disable_mouse = false,
  },
}

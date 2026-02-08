-- undotree - Visualize and navigate undo history
return {
  "mbbill/undotree",
  cmd = "UndotreeToggle",
  keys = {
    { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Toggle Undotree" },
  },
  config = function()
    vim.g.undotree_SetFocusWhenToggle = 1
  end,
}

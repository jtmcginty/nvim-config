-- Markdown preview with mermaid diagram support
return {
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = "cd app && npm install",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown Preview" },
    },
    config = function()
      vim.g.mkdp_port = '8765' -- Fixed port for consistent preview server
      vim.g.mkdp_open_to_the_world = 1 -- Allow external connections
      vim.g.mkdp_echo_preview_url = 1 -- Print URL to messages
    end,
  },
}

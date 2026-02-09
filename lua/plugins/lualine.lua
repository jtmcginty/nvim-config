-- Lualine - statusline with LSP info
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'echasnovski/mini.nvim' },  -- For mini.icons
  opts = {
    sections = {
      lualine_a = {'mode'},
      lualine_b = {'branch', 'diff', 'diagnostics'},
      lualine_c = {'filename'},
      lualine_x = {
        {
          function()
            local clients = vim.lsp.get_clients({bufnr=0})
            if #clients == 0 then return '' end
            local names = {}
            for _, c in ipairs(clients) do
              table.insert(names, c.name)
            end
            return table.concat(names, ',')
          end,
          icon = '',
          color = { fg = '#a6e3a1', gui = 'bold' }, -- Green and bold
        },
        'encoding',
        'fileformat',
        'filetype'
      },
      lualine_y = {'progress'},
      lualine_z = {'location'}
    },
  },
}

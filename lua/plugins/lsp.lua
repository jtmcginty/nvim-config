-- ============================================================================
-- LSP: Language Server Protocol
-- ============================================================================
-- Provides IDE features: autocomplete, go-to-definition, diagnostics, etc.

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason: Auto-install language servers
    { 'williamboman/mason.nvim', config = true },
    { 'williamboman/mason-lspconfig.nvim' },
    
    -- Progress notifications
    { 'j-hui/fidget.nvim', opts = {} },
  },
  config = function()
    -- This function runs when an LSP attaches to a buffer
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Navigation
        map('gd', require('telescope.builtin').lsp_definitions, 'Go to Definition')
        map('gr', require('telescope.builtin').lsp_references, 'Go to References')
        map('gI', require('telescope.builtin').lsp_implementations, 'Go to Implementation')
        map('gy', require('telescope.builtin').lsp_type_definitions, 'Go to Type definition')
        map('gs', require('telescope.builtin').lsp_document_symbols, 'Go to document Symbols')

        -- Actions
        map('<leader>cr', vim.lsp.buf.rename, 'Code Rename')
        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('K', vim.lsp.buf.hover, 'Hover documentation')

        -- Diagnostics
        map('<leader>cd', vim.diagnostic.open_float, 'Show diagnostic')
        map('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next diagnostic')
        
        -- Optimize LSP for performance
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client then
          -- Disable semantic tokens for better performance
          client.server_capabilities.semanticTokensProvider = nil
        end
      end,
    })

    -- LSP servers to install
    local servers = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' }, -- Recognize 'vim' global
            },
          },
        },
      },
      pyright = {},
      rust_analyzer = {},
      ts_ls = {}, -- TypeScript/JavaScript
      gopls = {},
    }

    -- Setup Mason
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_installation = true,
    })

    -- Setup each server using new Neovim 0.11 API
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

    for server_name, config in pairs(servers) do
      config.capabilities = vim.tbl_deep_extend('force', {}, capabilities, config.capabilities or {})
      config.flags = {
        debounce_text_changes = 150, -- Debounce for better performance
      }
      vim.lsp.config(server_name, config)
      vim.lsp.enable(server_name)
    end
  end,
}

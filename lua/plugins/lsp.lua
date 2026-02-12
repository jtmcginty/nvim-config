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
    -- Show LSP clients in statusline
    _G.lsp_clients = function()
      local clients = vim.lsp.get_clients({bufnr=0})
      if #clients == 0 then return '' end
      local names = vim.tbl_map(function(c) return c.name end, clients)
      return ' [' .. table.concat(names, ',') .. ']'
    end

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

        -- Call hierarchy
        map('<leader>ci', vim.lsp.buf.incoming_calls, 'Incoming Calls')
        map('<leader>co', vim.lsp.buf.outgoing_calls, 'Outgoing Calls')

        -- Diagnostics
        map('<leader>cd', vim.diagnostic.open_float, 'Show diagnostic')
        map('[d', vim.diagnostic.goto_prev, 'Previous diagnostic')
        map(']d', vim.diagnostic.goto_next, 'Next diagnostic')

        -- Enable inlay hints if supported
        if client and client.supports_method('textDocument/inlayHint') then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
        end

        -- Highlight symbol under cursor
        if client and client.supports_method('textDocument/documentHighlight') then
          local highlight_group = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_group,
            callback = vim.lsp.buf.clear_references,
          })
        end

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
      pyright = {
        before_init = function(_, config)
          -- Auto-detect virtual environment
          local venv_paths = { '.venv', 'venv', 'env', '.env' }
          for _, venv in ipairs(venv_paths) do
            local venv_python = vim.fn.getcwd() .. '/' .. venv .. '/bin/python'
            if vim.fn.executable(venv_python) == 1 then
              config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
                python = {
                  pythonPath = venv_python,
                },
              })
              break
            end
          end
        end,
      },
      rust_analyzer = {},
      ts_ls = {}, -- TypeScript/JavaScript
      gopls = {},
      ansiblels = {
        filetypes = { 'yaml.ansible' },
      },
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

-- ============================================================================
-- Conform: Auto-formatting
-- ============================================================================
-- Format code on save using external formatters

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format({ async = true, lsp_format = 'fallback' })
      end,
      mode = '',
      desc = 'Format buffer',
    },
  },
  init = function()
    -- Auto-install formatters via Mason
    vim.g.mason_tools = vim.list_extend(vim.g.mason_tools or {}, {
      'prettier',
      'prettierd',
      'black',
      'isort',
      'stylua',
      'shfmt',
      'gofmt',
      'rustfmt',
      'google-java-format',
      'ansible-lint',
    })
  end,
  config = function()
    require('conform').setup({
      formatters_by_ft = {
        -- JavaScript/TypeScript (try prettierd first, fallback to prettier)
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        typescript = { 'prettierd', 'prettier', stop_after_first = true },
        javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
        json = { 'prettierd', 'prettier', stop_after_first = true },
        jsonc = { 'prettierd', 'prettier', stop_after_first = true },
        html = { 'prettierd', 'prettier', stop_after_first = true },
        css = { 'prettierd', 'prettier', stop_after_first = true },
        scss = { 'prettierd', 'prettier', stop_after_first = true },
        markdown = { 'prettierd', 'prettier', stop_after_first = true },
        yaml = { 'prettierd', 'prettier', stop_after_first = true },

        -- Python
        python = { 'isort', 'black' },

        -- Go
        go = { 'gofmt' },

        -- Rust
        rust = { 'rustfmt' },

        -- Java
        java = { 'google-java-format' },

        -- Lua
        lua = { 'stylua' },

        -- Shell
        sh = { 'shfmt' },
        bash = { 'shfmt' },

        -- Ansible
        ['yaml.ansible'] = { 'ansible-lint' },

        -- Trim trailing whitespace for all files
        ['_'] = { 'trim_whitespace' },
      },

      -- Format on save
      format_on_save = {
        timeout_ms = 2000,
        lsp_format = 'fallback',
      },

      -- Formatters configuration
      formatters = {
        shfmt = {
          prepend_args = { '-i', '2' }, -- 2 space indent
        },
      },
    })
  end,
}

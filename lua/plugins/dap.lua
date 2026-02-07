-- ============================================================================
-- DAP: Debug Adapter Protocol
-- ============================================================================
-- Step-through debugging with breakpoints and variable inspection

return {
  -- Core DAP plugin
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- UI for DAP
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      
      -- Mason integration for auto-installing debug adapters
      'jay-babu/mason-nvim-dap.nvim',
      
      -- Virtual text showing variable values
      'theHamsta/nvim-dap-virtual-text',
    },
    keys = {
      { '<leader>db', '<cmd>lua require("dap").toggle_breakpoint()<cr>', desc = 'Toggle Breakpoint' },
      { '<leader>dc', '<cmd>lua require("dap").continue()<cr>', desc = 'Continue' },
      { '<leader>ds', '<cmd>lua require("dap").step_over()<cr>', desc = 'Step Over' },
      { '<leader>di', '<cmd>lua require("dap").step_into()<cr>', desc = 'Step Into' },
      { '<leader>do', '<cmd>lua require("dap").step_out()<cr>', desc = 'Step Out' },
      { '<leader>dr', '<cmd>lua require("dap").repl.open()<cr>', desc = 'Open REPL' },
      { '<leader>dl', '<cmd>lua require("dap").run_last()<cr>', desc = 'Run Last' },
      { '<leader>du', '<cmd>lua require("dapui").toggle()<cr>', desc = 'Toggle Debug UI' },
      { '<leader>dt', '<cmd>lua require("dap").terminate()<cr>', desc = 'Terminate' },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')

      -- Setup Mason DAP
      require('mason-nvim-dap').setup({
        automatic_installation = true,
        ensure_installed = {
          'python',
          'node2',
          'delve', -- Go
        },
      })

      -- Setup DAP UI
      dapui.setup()

      -- Setup virtual text
      require('nvim-dap-virtual-text').setup()

      -- Auto-open/close UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Breakpoint icons
      vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '▶️', texthl = '', linehl = '', numhl = '' })
    end,
  },
}
